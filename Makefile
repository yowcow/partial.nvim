all:
	luarocks install --local vusted

test:
	vusted

.PHONY: all test
