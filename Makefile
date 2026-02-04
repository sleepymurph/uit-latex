# Main Make Targets
# ======================================================================

# Common targets
.PHONY: default all clean distclean

# Development
.PHONY: assets2019		# Download UiT assets
.PHONY: example_art		# Download example art to include in PDFs
.PHONY:	dev_preview		# Build PDFs to test theme

# Distribution
.PHONY: examples		# Update PDFs and screenshots in examples/ dir

default: dev_preview examples
all: assets2019 dev_preview examples

clean:
	$(RM) *.aux *.log *.nav *.out *.snm *.toc	# LaTeX files

distclean:
	git clean -fXd ./

# Download UiT Template Assets
# ======================================================================

assets2019: | \
    download/profil2019/UiT_PowerPoint_engelsk.potx \
    assets/uit-profil2019/UiT_Logo_Eng_Hvit.pdf \
    assets/uit-profil2019/UiT_Logo_Eng_Sort.pdf \
    assets/uit-profil2019/UiT_Logo_Eng_Bla_CMYK.pdf \
    assets/uit-profil2019/UiT_Logo_Eng_Bla_RGB.pdf

download/profil2019/UiT_PowerPoint_engelsk.potx:
	mkdir -p $(@D) && cd $(@D) && wget https://uit.no/ressurs/uit/profil2019/maler/UiT_PowerPoint_engelsk.potx

download/profil2019/logo/engelsk.zip:
	mkdir -p $(@D) && cd $(@D) && wget https://uit.no/ressurs/uit/profil2019/logo/engelsk.zip

assets/uit-profil2019/UiT_Logo_Eng_%.pdf: | download/profil2019/logo/engelsk.zip
	mkdir -p $(@D) \
		&& unzip -j -d $(@D) \
			download/profil2019/logo/engelsk.zip \
			"engelsk/Logo\ for\ trykk/UiT_Logo_Eng_$*.pdf" \
		&& chmod a-x $@

# Downloading Example Art to Include in Test PDFs
# ======================================================================

example_art: \
    download/csiro-five-antennas.jpg \
    download/csiro-five-antennas-bg.jpg

# Photo of antenna array
# Image by John Masterson, CSIRO
# Licensed under Creative Commons Attribution 3.0 (CC BY 3.0) license
# https://commons.wikimedia.org/wiki/File:CSIRO_ScienceImage_3881_Five_Antennas_at_Narrabri.jpg
# https://www.scienceimage.csiro.au/pages/about/
# https://creativecommons.org/licenses/by/3.0/
download/csiro-five-antennas.jpg:
	mkdir -p $(@D) && cd $(@D) && wget -O $(@F) https://upload.wikimedia.org/wikipedia/commons/e/e8/CSIRO_ScienceImage_3881_Five_Antennas_at_Narrabri.jpg

%-bg.jpg: %.jpg
	convert $< -resize "x900" $@

# Test Documents
# ======================================================================

test_pdfs := \
	uitbeamertest.pdf \
	uitbeamertest-shadeblocks.pdf \
	uitbeamertest-coatedpaper.pdf \
	uitbeamerarticletest.pdf \

dev_preview: $(test_pdfs) README.html examples

LATEXENGINE := pdflatex
LATEXFLAGS += -halt-on-error

$(test_pdfs): uitbeamercontent.tex | assets2019 example_art

# The article extracts frames from the presentation PDF.
uitbeamerarticletest.pdf: uitbeamertest.pdf

%.pdf: %.tex $(wildcard *.sty)
	$(LATEXENGINE) $(LATEXFLAGS) $<
	$(LATEXENGINE) $(LATEXFLAGS) $<

%.html: %.md
	pandoc -s --from gfm $< -o $@

# Rendered Examples to be Distributed with Code
# ======================================================================
# Screenshots: Capture a given page of a PDF as a PNG
#
# Note that this use of 'convert' is not allowed by default on many Linux
# distros, including Ubuntu. This is because ImageMagick uses the GhostScript
# library to work with PDFs and the GhostScript library has known
# vulerabilities.
#
# See: https://askubuntu.com/a/1081907/652922

example_pdfs = $(addprefix examples/,$(test_pdfs))
examples/%.pdf: %.pdf
	mkdir -p $(@D) && cp $< $@

example_pngs := \
    examples/beamer-title.png \
    examples/beamer-title-graphic.png \
    examples/beamer-colors.png \
    examples/beamer-colors-shadeblocks.png \
    examples/beamer-slide-with-element.png

convertflags = -density 300 -resize x300 -strip

$(example_pngs): uitbeamertest.pdf uitbeamertest-shadeblocks.pdf
	mkdir -p $(@D)
	convert $(convertflags) uitbeamertest.pdf examples/uitbeamertest.png
	convert $(convertflags) uitbeamertest-shadeblocks.pdf \
		examples/uitbeamertest-shadeblocks.png
	cp examples/uitbeamertest-0.png examples/beamer-title.png
	cp examples/uitbeamertest-1.png examples/beamer-title-graphic.png
	cp examples/uitbeamertest-4.png examples/beamer-colors.png
	cp examples/uitbeamertest-shadeblocks-4.png \
		examples/beamer-colors-shadeblocks.png
	cp examples/uitbeamertest-shadeblocks-8.png \
		examples/beamer-slide-with-element.png

examples: $(example_pdfs) $(example_pngs)
