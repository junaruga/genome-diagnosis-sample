.PHONY: dummy carton test testv

dummy:
	@echo dummy

carton:
	. ./env.sh; \
	script/build/update_carton_modules.sh

test:
	. ./env.sh; \
	prove -cfrm --timer --trap --state=adrian t

# make testv FILE=t/xxx/yyy.t
testv:
	. ./env.sh; \
	prove -cfrmv --timer --trap --state=adrian t $(FILE)
