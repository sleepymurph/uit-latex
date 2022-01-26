.PHONY: default assets2019

default: assets2019 uitbeamertest.pdf

%.pdf: %.tex $(wildcard *.sty)
	pdflatex -halt-on-error $<
	pdflatex -halt-on-error $<


# Assets

assets2019: \
    assets-original/2019/UiT_PowerPoint_engelsk.potx \
    assets/UiT_Logo_Eng_Hvit.pdf

assets-original/2019/UiT_PowerPoint_engelsk.potx:
	mkdir -p $(@D) && cd $(@D) && wget https://uit.no/ressurs/uit/profil2019/maler/UiT_PowerPoint_engelsk.potx

assets-original/2019/logo/engelsk.zip:
	mkdir -p $(@D) && cd $(@D) && wget https://uit.no/ressurs/uit/profil2019/logo/engelsk.zip

assets/UiT_Logo_Eng_Hvit.pdf: | assets-original/2019/logo/engelsk.zip
	mkdir -p $(@D) && unzip -j -d $(@D) assets-original/2019/logo/engelsk.zip "engelsk/Logo\ for\ trykk/UiT_Logo_Eng_Hvit.pdf"
