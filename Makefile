all:
	luarocks install --local luacheck
	luarocks install --local vusted

test:
	vusted

.PHONY: all test
