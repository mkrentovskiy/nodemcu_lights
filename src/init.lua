-- init Wi-Fi AP
-- wifi.setmode(wifi.SOFTAP)

-- wcfg = {}
-- wcfg.ssid="george-kickscooter"
-- wcfg.pwd="qwertyasdfgh"
-- wifi.ap.config(wcfg)

-- cfg={}
-- cfg.ip="192.168.252.1"
-- cfg.netmask="255.255.255.0"
-- cfg.gateway="192.168.252.1"
-- wifi.ap.setip(cfg);

-- wcgf = nil
-- cfg = nil
-- collectgarbage();

-- init Wi-Fi client

wifi.setmode(wifi.STATION)

wifi.sta.config("wlan", "...")
wifi.sta.connect()

-- Init led stipe

s_delay = 100
l_delay = 10000
k = 0
n = 160
leds = {}

function set(v, n)
    for i=0, n do
        leds[i] = v
    end 
end

function update(v, n)
  for i=0, n do
    if v[i] ~= nil then
      ws2801.write(v[i])
    end
  end
  tmr.delay(s_delay)
end

-- Starting up

print("Initial blink.")

ws2801.init(5,4)
 
for k=0,127 do
  set(string.char(0, k, k), n)
  update(leds, n)
end

tmr.delay(l_delay)

for k=250,0,-10 do
  set(string.char(k, k, 0), n)
  update(leds, n)
end

-- Networking
print("Starting network service on port 5000.")
srv = net.createServer(net.UDP)
srv:listen(5000)
srv:on("receive", function(s, payload)
  local plen = payload:len()
  j = 0
  for i=1,plen+1,3 do
    r = string.byte(payload, i+2)
    g = string.byte(payload, i+1)
    b = string.byte(payload, i)
    if r ~= nil and g ~= nil and b ~= nil then
      leds[j] = string.char(r, g, b)
      j = j + 1
    end
  end
  update(leds, j)
end)

print("My IP is "..wifi.sta.getip())
