all:
	luarocks install --local busted

test:
	busted

.PHONY: all test
