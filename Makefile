
default: uitbeamertest.pdf

%.pdf: %.tex uit.sty
	pdflatex $<
