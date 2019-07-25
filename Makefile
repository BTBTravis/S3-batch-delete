CREATE_FILE_RAW = ./create_files.m4
DEL_FILE_RAW = ./del_files.m4
KILL_FILE_RAW = ./kill.sh

CREATE_FILE = ./build/create_files.sh
DEL_FILE = ./build/del_files.sh
KILL_FILE = ./build/kill.sh

build: $(CREATE_FILE) $(DEL_FILE) $(KILL_FILE)
	ls -l ./build

.PHONY: clean
clean:
	rm -f ./build/*

build_dir:
	mkdir -p ./build

$(KILL_FILE): build_dir
	cp $(KILL_FILE_RAW) $(KILL_FILE)

$(DEL_FILE): build_dir
	argbash $(DEL_FILE_RAW) -o $(DEL_FILE)

$(CREATE_FILE): build_dir
	argbash $(CREATE_FILE_RAW) -o $(CREATE_FILE)
