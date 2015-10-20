-- httpserver-header.lua
-- Part of nodemcu-httpserver, knows how to send an HTTP header.
-- Author: Marcos Kirsch

return function (connection, code, extension, gzip)

   local function getHTTPStatusString(code)
      local codez = {[200]="OK", [400]="Bad Request", [404]="Not Found",}
      local myResult = codez[code]
      -- enforce returning valid http codes all the way throughout?
      if myResult then return myResult else return "Not Implemented" end
   end

   local function getMimeType(ext)
      -- A few MIME types. Keep list short. If you need something that is missing, let's add it.
      local mt = {html = "text/html", ico = "image/x-icon", js = "application/javascript", json = "application/json"}
      if mt[ext] then contentType = mt[ext] else contentType = "text/plain" end
      return {contentType = contentType}
   end

   local mimeType = getMimeType(extension)

   connection:send("HTTP/1.0 " .. code .. " " .. getHTTPStatusString(code) .. "\r\nServer: nodemcu-httpserver\r\nContent-Type: " .. mimeType["contentType"] .. "\r\n")
   connection:send("Connection: close\r\n\r\n")
end

