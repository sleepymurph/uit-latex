.PHONY: default assets2019 example_art

default: assets2019 example_art uitbeamertest.pdf

uitbeamertest.pdf: assets/UiT_Logo_Eng_Hvit.pdf example-art/cmb-timeline-bg.jpg

%.pdf: %.tex $(wildcard *.sty)
	pdflatex -halt-on-error $<
	pdflatex -halt-on-error $<


# Assets

assets2019: \
    assets-download/2019/UiT_PowerPoint_engelsk.potx \
    assets/UiT_Logo_Eng_Hvit.pdf

assets-download/2019/UiT_PowerPoint_engelsk.potx:
	mkdir -p $(@D) && cd $(@D) && wget https://uit.no/ressurs/uit/profil2019/maler/UiT_PowerPoint_engelsk.potx

assets-download/2019/logo/engelsk.zip:
	mkdir -p $(@D) && cd $(@D) && wget https://uit.no/ressurs/uit/profil2019/logo/engelsk.zip

assets/UiT_Logo_Eng_Hvit.pdf: | assets-download/2019/logo/engelsk.zip
	mkdir -p $(@D) && unzip -j -d $(@D) assets-download/2019/logo/engelsk.zip "engelsk/Logo\ for\ trykk/UiT_Logo_Eng_Hvit.pdf"

# Example art

example_art: \
    example-art/cmb-timeline.jpg \
    example-art/cmb-timeline-bg.jpg

# Timeline of the cosmic background radiation
# Downloaded from Wikimedia Commons. Image is in public domain.
# https://commons.wikimedia.org/wiki/File:CMB_Timeline300_no_WMAP.jpg
example-art/cmb-timeline.jpg:
	mkdir -p $(@D) && cd $(@D) && wget -O $(@F) https://upload.wikimedia.org/wikipedia/commons/6/6f/CMB_Timeline300_no_WMAP.jpg

%-bg.jpg: %.jpg
	convert $< -resize "x900" $@
