# Main Make Targets
# ======================================================================

# Common targets
.PHONY: default all clean dist

# Development
.PHONY: assets2019		# Download UiT assets
.PHONY: example_art		# Download example art to include in PDFs
.PHONY:	dev_preview		# Build PDFs to test theme

# Distribution
.PHONY: examples		# Update PDFs and screenshots in examples/ dir

default: dev_preview
all: assets2019 dev_preview examples
dist: clean examples clean

clean:
	git clean -fXd ./

# Download UiT Template Assets
# ======================================================================

assets2019: | \
    assets-download/profil2019/UiT_PowerPoint_engelsk.potx \
    assets/uit-profil2019/UiT_Logo_Eng_Hvit.pdf \
    assets/uit-profil2019/UiT_Logo_Eng_Sort.pdf \
    assets/uit-profil2019/UiT_Logo_Eng_Bla_CMYK.pdf \
    assets/uit-profil2019/UiT_Logo_Eng_Bla_RGB.pdf

assets-download/profil2019/UiT_PowerPoint_engelsk.potx:
	mkdir -p $(@D) && cd $(@D) && wget https://uit.no/ressurs/uit/profil2019/maler/UiT_PowerPoint_engelsk.potx

assets-download/profil2019/logo/engelsk.zip:
	mkdir -p $(@D) && cd $(@D) && wget https://uit.no/ressurs/uit/profil2019/logo/engelsk.zip

assets/uit-profil2019/UiT_Logo_Eng_%.pdf: | assets-download/profil2019/logo/engelsk.zip
	mkdir -p $(@D) \
		&& unzip -j -d $(@D) \
			assets-download/profil2019/logo/engelsk.zip \
			"engelsk/Logo\ for\ trykk/UiT_Logo_Eng_$*.pdf" \
		&& chmod a-x $@

# Downloading Example Art to Include in Test PDFs
# ======================================================================

example_art: \
    example-art/csiro-five-antennas.jpg \
    example-art/csiro-five-antennas-bg.jpg

# Photo of antenna array
# Image by John Masterson, CSIRO
# Licensed under Creative Commons Attribution 3.0 (CC BY 3.0) license
# https://commons.wikimedia.org/wiki/File:CSIRO_ScienceImage_3881_Five_Antennas_at_Narrabri.jpg
# https://www.scienceimage.csiro.au/pages/about/
# https://creativecommons.org/licenses/by/3.0/
example-art/csiro-five-antennas.jpg:
	mkdir -p $(@D) && cd $(@D) && wget -O $(@F) https://upload.wikimedia.org/wikipedia/commons/e/e8/CSIRO_ScienceImage_3881_Five_Antennas_at_Narrabri.jpg

%-bg.jpg: %.jpg
	convert $< -resize "x900" $@

# Test Documents
# ======================================================================

dev_preview: \
	uitbeamertest.pdf \
	uitbeamerarticletest.pdf \
	README.html

LATEXENGINE := pdflatex
LATEXFLAGS += -halt-on-error

uitbeamertest.pdf: uitbeamercontent.tex | assets2019 example_art
uitbeamerarticletest.pdf: uitbeamercontent.tex | assets2019 example_art

%.pdf: %.tex $(wildcard *.sty)
	$(LATEXENGINE) $(LATEXFLAGS) $<
	$(LATEXENGINE) $(LATEXFLAGS) $<

%.html: %.md
	pandoc --from gfm $< -o $@

# Rendered Examples to be Distributed with Code
# ======================================================================

examples: \
    examples/uitbeamertest.pdf \
    examples/uitbeamerarticletest.pdf \
    examples/beamer-title.png \
    examples/beamer-title-graphic.png \
    examples/beamer-colors.png

# Example PDF: copy development PDF
examples/%.pdf: %.pdf
	mkdir -p $(@D) && cp $< $@

# Screenshots: Capture a given page of a PDF as a PNG
#
# Note that this use of 'convert' is not allowed by default on many Linux
# distros, including Ubuntu. This is because ImageMagick uses the GhostScript
# library to work with PDFs and the GhostScript library has known
# vulerabilities.
#
# See: https://askubuntu.com/a/1081907/652922
examples/uitbeamertest-%.png: examples/uitbeamertest.pdf
	mkdir -p $(@D) && convert $< -density 300 -resize x200 $(<:.pdf=.png)

examples/beamer-title.png: examples/uitbeamertest-0.png
	cp $< $@

examples/beamer-title-graphic.png: examples/uitbeamertest-1.png
	cp $< $@

examples/beamer-colors.png: examples/uitbeamertest-4.png
	cp $< $@
