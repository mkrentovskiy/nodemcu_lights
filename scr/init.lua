-- init wi-fi AP
cfg = {}
cfg.ssid="george-kickscooter"
cfg.pwd="qwerty123456"
wifi.ap.config(cfg)

-- init networking
cfg={}
cfg.ip="192.168.1.1";
cfg.netmask="255.255.255.0";
cfg.gateway="192.168.1.1";
wifi.ap.setip(cfg);
wifi.setmode(wifi.SOFTAP)
collectgarbage();

-- init RGB stripe
ws2801.init(4,5)

n = 10
leds = {}
set_color(string.char(0, 0, 0), n)

tmr.alarm(0, 100, 1, function() 
    for i=0, table.getn(leds) do
        ws2801.write(leds[i])
        tmr.delay(500)
        end
    end)

function set_color(v, n)
    for i=0, n do
        leds[i] = v
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
