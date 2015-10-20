SUDO = $(if $USER=="root",sudo)

ESPTOOL = utils/esptool.py
LUATOOL = utils/luatool.py

UPLOAD = $(SUDO) $(LUATOOL) -f

HTTP_FILES = $(wildcard src/www/*)
LUA_FILES  = $(wildcard src/modules/*.lua)

write: $(HTTP_FILES) $(LUA_FILES)
	$(SUDO) $(LUATOOL) -w 
	$(foreach F, $(HTTP_FILES), $(UPLOAD) $(F);) 
	$(foreach F, $(LUA_FILES),  $(UPLOAD) $(F) -c;) 
	$(UPLOAD) src/server.lua -c 
	$(UPLOAD) src/init.lua -r 
	
flash:
	$(SUDO) $(ESPTOOL) write_flash 0x00000 bin/nodemcu-master-10-modules-2015-09-29-17-58-26-integer.bin

console:
	$(SUDO) minicom
