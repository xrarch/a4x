INCLUDES := $(subst :, ,$(INCDIR))
INCLUDEFILES := $(foreach incdir,$(INCLUDES),$(shell find $(incdir) -type f -name "*.hjk"))

SFILES := $(foreach component,$(COMPONENTS),$(wildcard $(component)/$(ARCHITECTURE)/*.s))

DFILES := $(foreach component,$(COMPONENTS),$(wildcard $(component)/*.jkl)) \
			$(foreach component,$(COMPONENTS),$(wildcard $(component)/$(ARCHITECTURE)/*.jkl))

OBJ    := $(DFILES:.jkl=.$(ARCHITECTURE).$(CHKFRE).o)
SOBJ   := $(SFILES:.s=.$(ARCHITECTURE).$(CHKFRE).o)

FULLOUTPUTFILE = $(BUILDROOT)/$(OUTPUTFILE).$(ARCHITECTURE).$(CHKFRE)

all: $(FULLOUTPUTFILE)

$(FULLOUTPUTFILE): $(OBJ) $(SOBJ)
	$(LNK) link $(LINKOPT) $(FULLOUTPUTFILE) $(PRELIBS) $(SOBJ) $(OBJ) $(LIBS) -d $(DYLIBS)

ifdef MOVEEXPR
	$(LNK) move $(FULLOUTPUTFILE) $(MOVEEXPR)
else
	$(LNK) move $(FULLOUTPUTFILE) mintia
endif

ifdef MKBINARY
	cp $(FULLOUTPUTFILE) $(FULLOUTPUTFILE).XLOFF
	$(LNK) binary -nobss $(FULLOUTPUTFILE)
else
	$(LNK) istrip $(FULLOUTPUTFILE)
endif

define COMPONENT_TEMPLATE

$(1)/%.$$(ARCHITECTURE).$$(CHKFRE).o: $(1)/%.jkl $$(INCLUDEFILES) $$(wildcard $(1)/*.hjk)
	$$(JC) $$< $$@ incdir=$$(INCDIR) libdir=$$(LIBDIR)

endef

$(foreach component,$(COMPONENTS), \
	$(eval $(call COMPONENT_TEMPLATE,$(component))) \
)

%.$(ARCHITECTURE).$(CHKFRE).o: %.s
	$(ASM) $< $@

cleanup:
	rm -f ${OBJ} ${SOBJ} $(FULLOUTPUTFILE)