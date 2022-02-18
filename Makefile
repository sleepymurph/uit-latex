.PHONY: default dist clean assets2019 logos2019 example_art examples

default: assets2019 example_art uitbeamertest.pdf README.html

dist: default examples clean

clean:
	git clean -fXd ./

uitbeamertest.pdf: | logos2019 example_art

%.pdf: %.tex $(wildcard *.sty)
	pdflatex -halt-on-error $<
	pdflatex -halt-on-error $<

%.html: %.md
	pandoc --from gfm $< -o $@

# Assets

logos2019: \
    assets/UiT_Logo_Eng_Hvit.pdf

assets2019: logos2019 \
    assets-download/2019/UiT_PowerPoint_engelsk.potx

assets-download/2019/UiT_PowerPoint_engelsk.potx:
	mkdir -p $(@D) && cd $(@D) && wget https://uit.no/ressurs/uit/profil2019/maler/UiT_PowerPoint_engelsk.potx

assets-download/2019/logo/engelsk.zip:
	mkdir -p $(@D) && cd $(@D) && wget https://uit.no/ressurs/uit/profil2019/logo/engelsk.zip

assets/UiT_Logo_Eng_Hvit.pdf: | assets-download/2019/logo/engelsk.zip
	mkdir -p $(@D) && unzip -j -d $(@D) assets-download/2019/logo/engelsk.zip "engelsk/Logo\ for\ trykk/UiT_Logo_Eng_Hvit.pdf"

# Example art

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

# Rendered examples

examples: \
    examples/uitbeamertest.pdf \
    examples/beamer-title.png \
    examples/beamer-title-graphic.png \
    examples/beamer-colors.png

examples/%.pdf: %.pdf
	mkdir -p $(@D) && cp $< $@

examples/uitbeamertest-0.png\
examples/uitbeamertest-1.png\
examples/uitbeamertest-3.png\
: examples/uitbeamertest.pdf
	mkdir -p $(@D) && convert $< -density 300 -resize x200 $(<:.pdf=.png)

examples/beamer-title.png: examples/uitbeamertest-0.png
	cp $< $@

examples/beamer-title-graphic.png: examples/uitbeamertest-1.png
	cp $< $@

examples/beamer-colors.png: examples/uitbeamertest-4.png
	cp $< $@
