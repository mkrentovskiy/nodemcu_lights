SUDO = $(if $USER=="root",sudo)

FIXFW = bin/esp_init_data_default.bin
FW = bin/nodemcu-master-12-modules-2016-10-13-08-08-42-integer.bin

ESPTOOL = utils/esptool.py
LUATOOL = utils/luatool.py -p /dev/ttyUSB0 -b 115200

UPLOAD = $(SUDO) $(LUATOOL) -f

write: 
	$(SUDO) $(LUATOOL) -w 
	$(UPLOAD) src/init.lua -r 

rgb: 
	$(SUDO) $(LUATOOL) -w 
	$(UPLOAD) tests/rgb/init.lua -r 

flash: $(FW) $(FIXFW)
	$(SUDO) $(ESPTOOL) erase_flash
	$(SUDO) $(ESPTOOL) --port /dev/ttyUSB0 -b 115200 write_flash -fm dio -fs 32m -ff 40m  0x00000 $(FW) 0x3fc000 $(FIXFW)

console:
	$(SUDO) minicom

tests-prepare:
	virtualenv tests/.env
	. tests/.env/bin/activate
	pip install requests

