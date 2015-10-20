-- show chip info
majorVer, minorVer, devVer, chipid, flashid, flashsize, flashmode, flashspeed = node.info();
print("NodeMCU "..majorVer.."."..minorVer.."."..devVer)
print("ChipID "..chipid)
print("FlashID "..flashid)

heap_size = node.heap();
print("Remaining heap size is: "..heap_size)

-- init Wi-Fi AP
cfg = {}
cfg.ssid="george-kickscooter"
cfg.pwd="qwerty123456"
wifi.ap.config(cfg)

cfg={}
cfg.ip="192.168.1.1";
cfg.netmask="255.255.255.0";
cfg.gateway="192.168.1.1";
wifi.ap.setip(cfg);
wifi.setmode(wifi.SOFTAP)
collectgarbage();

-- Compile souce code
local compileAndRemoveIfNeeded = function(f)
   if file.open(f) then
      file.close()
      print('Compiling:', f)
      node.compile(f)
      file.remove(f)
      collectgarbage()
   end
end

local serverFiles = {'server.lua', 'request.lua', 'static.lua', 'header.lua', 'error.lua'}
for i, f in ipairs(serverFiles) do compileAndRemoveIfNeeded(f) end

compileAndRemoveIfNeeded = nil
serverFiles = nil
collectgarbage()

-- Init led stipe
ws2801.init(4,5)
n = 10
delay = 10000
leds = {}

function set(v, n)
    for i=0, n do
        leds[i] = v
    end 
end
function update(n)
    for i=0, n do
        ws2801.write(leds[i])
    end
end

set(string.char(0, 0, 0), n)
tmr.delay(delay)

for k=0,255 do
    set(string.char(0, k, k), n)
    update(n)
    tmr.delay(delay)
end

dofile("server.lc")(80)

for k=255,0,-1 do
    set(string.char(k, 0, k), n)
    update(n)
    tmr.delay(delay)
end

