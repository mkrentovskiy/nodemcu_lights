-- httpserver
-- Author: Marcos Kirsch

-- Starts web server in the specified port.
return function (port)

   local s = net.createServer(net.TCP, 10) -- 10 seconds client timeout
   s:listen(
      port,
      function (connection)

         -- This variable holds the thread used for sending data back to the user.
         -- We do it in a separate thread because we need to yield when sending lots
         -- of data in order to avoid overflowing the mcu's buffer.
         local connectionThread
         
         local allowStatic = {GET=true, HEAD=true, POST=false, PUT=false, DELETE=false, TRACE=false, OPTIONS=false, CONNECT=false, PATCH=false}

         local function onRequest(connection, req)
            collectgarbage()
            local method = req.method
            local uri = req.uri
            local fileServeFunction = nil
            
            print("Method: " .. method);
            
            if #(uri.file) > 32 then
               -- nodemcu-firmware cannot handle long filenames.
               uri.args = {code = 400, errorString = "Bad Request"}
               fileServeFunction = dofile("error.lc")
            else
               local fileExists = file.open(uri.file, "r")
               file.close()
            
               if not fileExists then
                  uri.args = {code = 404, errorString = "Not Found"}
                  fileServeFunction = dofile("error.lc")
               elseif uri.isScript then
                  fileServeFunction = dofile(uri.file)
               else
                  if allowStatic[method] then
                    uri.args = {file = uri.file, ext = uri.ext, gzipped = uri.isGzipped}
                    fileServeFunction = dofile("static.lc")
                  else
                    uri.args = {code = 405, errorString = "Method not supported"}
                    fileServeFunction = dofile("error.lc")
                  end
               end
            end
            connectionThread = coroutine.create(fileServeFunction)
            coroutine.resume(connectionThread, connection, req, uri.args)
         end

         local function onReceive(connection, payload)
            collectgarbage()
            
            -- parse payload and decide what to serve.
            local req = dofile("request.lc")(payload)
            print("Requested URI: " .. req.request)

            if req.methodIsValid and (req.method == "GET" or req.method == "POST" or req.method == "PUT") then
               onRequest(connection, req)
            else
               local args = {}
               local fileServeFunction = dofile("error.lc")
               if req.methodIsValid then
                  args = {code = 501, errorString = "Not Implemented"}
               else
                  args = {code = 400, errorString = "Bad Request"}
               end
               connectionThread = coroutine.create(fileServeFunction)
               coroutine.resume(connectionThread, connection, req, args)
            end
         end

         local function onSent(connection, payload)
            collectgarbage()
            if connectionThread then
               local connectionThreadStatus = coroutine.status(connectionThread)
               if connectionThreadStatus == "suspended" then
                  -- Not finished sending file, resume.
                  coroutine.resume(connectionThread)
               elseif connectionThreadStatus == "dead" then
                  -- We're done sending file.
                  connection:close()
                  connectionThread = nil
               end
            end
         end

         connection:on("receive", onReceive)
         connection:on("sent", onSent)

      end
   )
   
   ip = wifi.ap.getip()
   print("Server running at http://" .. ip .. ":" ..  port)
   return s

end
