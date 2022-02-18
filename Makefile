.PHONY: default clean assets2019 logos2019 example_art

default: assets2019 example_art uitbeamertest.pdf

clean:
	git clean -fXd ./

uitbeamertest.pdf: logos2019 example_art

%.pdf: %.tex $(wildcard *.sty)
	pdflatex -halt-on-error $<
	pdflatex -halt-on-error $<


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
# Image by CSIRO
# https://commons.wikimedia.org/wiki/File:CSIRO_ScienceImage_3881_Five_Antennas_at_Narrabri.jpg
example-art/csiro-five-antennas.jpg:
	mkdir -p $(@D) && cd $(@D) && wget -O $(@F) https://upload.wikimedia.org/wikipedia/commons/e/e8/CSIRO_ScienceImage_3881_Five_Antennas_at_Narrabri.jpg

%-bg.jpg: %.jpg
	convert $< -resize "x900" $@
