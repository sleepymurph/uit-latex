.PHONY: default assets2019

default: assets2019 uitbeamertest.pdf

%.pdf: %.tex $(wildcard *.sty)
	pdflatex -halt-on-error $<
	pdflatex -halt-on-error $<


# Assets

assets2019: \
    assets-original/2019 \
    assets-original/2019/UiT_PowerPoint_engelsk.potx

assets-original/2019:
	mkdir -p $@

assets-original/2019/UiT_PowerPoint_engelsk.potx:
	cd $(@D) && wget https://uit.no/ressurs/uit/profil2019/maler/UiT_PowerPoint_engelsk.potx
