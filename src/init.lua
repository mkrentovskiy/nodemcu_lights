-- init Wi-Fi AP
wifi.setmode(wifi.SOFTAP)

wcfg = {}
wcfg.ssid="george-kickscooter"
wcfg.pwd="qwertyasdfgh"
wifi.ap.config(wcfg)

cfg={}
cfg.ip="192.168.252.1";
cfg.netmask="255.255.255.0";
cfg.gateway="192.168.252.1";
wifi.ap.setip(cfg);

wcgf = nil
cfg = nil
collectgarbage();

-- Init led stipe
ws2801.init(4,5)

delay = 10000
n = 10
leds = {}

function set(v, n)
    for i=0, n do
        leds[i] = v
    end 
end

function update(v, n)
  for i=0, n do
    ws2801.write(v[i])
  end
end

-- Starting up
for k=0,255 do
    set(string.char(0, k, k), n)
    update(leds, n)
    tmr.delay(delay)
end
for k=255,0,-1 do
    set(string.char(k, 0, k), n)
    update(leds, n)
    tmr.delay(delay)
end

-- Setup CoAP
cs=coap.Server()
cs:listen(5683)

function lightseq(payload)
  v = encoder.fromBase64(payload)
  update(v, string.len(v))
  tmr.delay(delay)
  collectgarbage();
  respond = "{ 'result': 'ok' }"
  return respond
end
cs:func("lightseq") 
