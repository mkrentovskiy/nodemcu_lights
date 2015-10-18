ESPTOOL = utils/esptool.py
LUATOOL = utils/luatool.py

write:
	sudo $(LUATOOL) -w 
	sudo $(LUATOOL) -r -f src/init.lua 

flash:
	sudo $(ESPTOOL) write_flash 0x00000 bin/nodemcu-master-10-modules-2015-09-29-17-58-26-integer.bin

console:
	sudo minicom
