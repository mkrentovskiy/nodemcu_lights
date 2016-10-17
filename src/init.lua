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
ws2801.init(5,4)

s_delay = 500
l_delay = 10000
k = 0
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
print "Initial blink."
for k=0,255 do
    set(string.char(0, 0, k), n)
    update(leds, n)
    tmr.delay(s_delay)
end
tmr.delay(l_delay)

for k=255,0,-5 do
    set(string.char(k, 0, 0), n)
    update(leds, n)
    tmr.delay(s_delay)
end

-- Setup CoAP
print "Starting CoAP server."
function lightseq(payload)
  print "1"
  v = encoder.fromBase64(payload)
  print "2"
  update(v, string.len(v))
  print "3"
  tmr.delay(delay)
  print "4"
  collectgarbage();
  print "5"
  respond = "{ 'result': 'ok' }"
  print "6"
  return respond
end

cs=coap.Server()
cs:listen(5683)
cs:func("lightseq") 
