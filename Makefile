SUDO = $(if $USER=="root",sudo)

FW = bin/nodemcu-master-10-modules-2016-10-07-19-11-33-integer.bin

ESPTOOL = utils/esptool.py
LUATOOL = utils/luatool.py

UPLOAD = $(SUDO) $(LUATOOL) -f

write: 
	$(SUDO) $(LUATOOL) -w 
	$(UPLOAD) src/init.lua -r 

update:
	$(UPLOAD) src/init.lua -r 
	
flash: $(FW)
	$(SUDO) $(ESPTOOL) write_flash 0x00000 $(FW)

console:
	$(SUDO) minicom

tests-prepare:
	virtualenv tests/.env
	. tests/.env/bin/activate
	pip install requests

