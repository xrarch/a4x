export REPO := $(shell pwd)
export BUILDROOT := $(REPO)/build

ifndef SDK
	SDK := $(REPO)/../sdk
endif

export SDK

export JC := $(SDK)/jcd.sh
export ASM := $(SDK)/asm.sh target=xr17032
export LNK := $(SDK)/link.sh

export ARCHITECTURE := xr17032
export PLATFORM := xrstation

ifeq ($(CHK),1)
	JC += CHK=1
	CHKFRE := chk
else
	JC += CHK=0
	CHKFRE := fre
endif

export CHKFRE

PROJECTS := a4x

ifndef PROJECT
	PROJECT := $(PROJECTS)
endif

all: $(PROJECT)

$(PROJECTS): FORCE | $(BUILDROOT)
	make -C $@

FORCE: ;

$(BUILDROOT):
	mkdir -p $(BUILDROOT)

cleanupall:
	for platform in $(PLATFORMS); do \
		make cleanup PLATFORM=$$platform; \
		make cleanup PLATFORM=$$platform DEBUGCHECKS=1; \
	done

cleanup:
	for dir in $(PROJECTS); do \
		make -C $$dir cleanup; \
	done