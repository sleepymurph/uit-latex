
default: uitbeamertest.pdf

%.pdf: %.tex uit.sty
	pdflatex -halt-on-error $<
