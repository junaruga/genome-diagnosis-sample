.PHONY: dummy carton test testv tidy critic

dummy:
	@echo dummy

carton:
	. ./env.sh; \
	script/build/update_carton_modules.sh

tidy:
	. ./env.sh; \
	script/dev/tidy.sh

critic:
	. ./env.sh; \
	prove -cfrmv --timer --trap --state=adrian t t/99-perlcritic.t

test:
	. ./env.sh; \
	prove -cfrm --timer --trap --state=adrian t

# make testv FILE=t/xxx/yyy.t
testv:
	. ./env.sh; \
	prove -cfrmv --timer --trap --state=adrian t $(FILE)

generate_genome:
	. ./env.sh; \
	perl script/generate_genome.pl

