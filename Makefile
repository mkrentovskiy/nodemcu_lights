SUDO = $(if $USER=="root",sudo)

DEVICE = /dev/ttyUSB0

FIXFW = bin/esp_init_data_default.bin
FW = bin/nodemcu-master-11-modules-2016-10-18-09-44-21-integer.bin

ESPTOOL = utils/esptool.py
LUATOOL = utils/luatool.py -p $(DEVICE) -b 115200

UPLOAD = $(SUDO) $(LUATOOL) -f

write: 
	$(SUDO) $(LUATOOL) -w 
	$(UPLOAD) src/init.lua -r 

rgb: 
	$(SUDO) $(LUATOOL) -w 
	$(UPLOAD) tests/rgb/init.lua -r 

flash: $(FW) $(FIXFW)
	$(SUDO) $(ESPTOOL) erase_flash
	$(SUDO) $(ESPTOOL) --port $(DEVICE) -b 115200 write_flash -fm dio -fs 32m -ff 40m  0x00000 $(FW) 0x3fc000 $(FIXFW)

console:
	$(SUDO) cu -l $(DEVICE)

