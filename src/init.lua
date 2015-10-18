majorVer, minorVer, devVer, chipid, flashid, flashsize, flashmode, flashspeed = node.info();
print("NodeMCU "..majorVer.."."..minorVer.."."..devVer)
print("ChipID "..chipid)
print("FlashID "..flashid)

heap_size = node.heap();
print("Remaining heap size is: "..heap_size)

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

ws2801.init(4,5)
n = 10
delay = 10000
leds = {}

-- (B, G, R)
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

function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function isset(set, key)
    return set[key] ~= nil
end

set(string.char(0, 0, 0), n)
tmr.delay(delay)

for k=0,255 do
    set(string.char(0, k, k), n)
    update(n)
    tmr.delay(delay)
end
for k=255,0,-1 do
    set(string.char(k, 0, k), n)
    update(n)
    tmr.delay(delay)
end

