# Build directory
BUILDDIR=out

# LaTeX file name to build
TARGET=document

all: $(TARGET).pdf

$(TARGET).pdf: $(TARGET).tex
	if [ ! -d $(BUILDDIR) ]; then mkdir $(BUILDDIR); fi
	latexmk -output-directory=$(BUILDDIR) -pdf -pdflatex="pdflatex" $<
	cp $(BUILDDIR)/$@ $@

.PHONY: download-mga
download-mga:
	wget http://www2.math.uni-wuppertal.de/~fritzsch/latex/mga24.zip
	sha256sum mga24.zip | \
	  grep dac6910b2889b6f51d0626ee0855a05fa125e04d4f4e8dc49199676b42c2bdc9
	unzip mga24.zip
	rm mga24.zip

.PHONY: remove-mga
remove-mga:
	for file in epic.sty eepic.sty mga_ncol.sty mga_col.sty mg24i_pd.sty \
	  mg24_cor.sty mga_turt.sty mg24i_ep.sty mg24_pre.sty mg24i_ps.sty \
	  mg24_3d.sty mg24_var.sty mgtex_24.sty mg24_ari.sty mga24.zip; \
	do \
	  rm "$$file" 2> /dev/null || true; \
	done

.PHONY: clean
clean:
	if [ -d $(BUILDDIR) ]; then rm --recursive ./$(BUILDDIR); fi

.PHONY: distclean
distclean: clean
	if [ -f $(TARGET).pdf ]; then rm $(TARGET).pdf; fi

.PHONY: info
info:
	@echo 'Build directory: $(BUILDDIR)'
	@echo 'LaTeX file to build: $(TARGET).tex'
	@echo 'Generated PDF name: $(TARGET).pdf'

.PHONY: help
help:
	@echo 'Building targets:'
	@echo '  all            - Build the script'
	@echo 'Auxiliary targets:'
	@echo '  info           - Show the current configuration of the makefile'
	@echo '  help           - Show this help'
	@echo '  download-mga   - Download (and extract) MGA-TeX'
	@echo '  remove-mga     - Remove MGA-TeX'
	@echo 'Cleaning targets:'
	@echo '  clean          - Remove the $(BUILDDIR)-Directory'
	@echo '  distclean      - Remove the $(BUILDDIR)-Directory and $(TARGET).pdf (i.e. everything)'
