
all: beamer-test.pdf

# Generic LaTeX build process, with biblatex
%.pdf: %.tex
	pdflatex $(PDFLATEXFLAGS) $<
	biber $(basename $<)
	pdflatex $(PDFLATEXFLAGS) $<
	pdflatex $(PDFLATEXFLAGS) $<
