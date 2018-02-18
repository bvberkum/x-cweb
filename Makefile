#
#   CWEB Makefile extracted from MMIXware
#

#   Be sure that CWEB version 3.0 or greater is installed before proceeding!
#   In fact, CWEB 3.61 is recommended for making hardcopy or PDF documentation.

#   If you prefer optimization to debugging, change -g to something like -O:
CFLAGS = -g

#   Uncomment the second line if you use pdftex to bypass .dvi files:
#PDFTEX = dvipdfm
PDFTEX = pdftex

.SUFFIXES: .dvi .tex .w .ps .pdf

.tex.dvi:
	tex $*.tex

.dvi.ps:
	dvips $* -o $*.ps

.w.c:
	if test -r $*.ch; then ctangle $*.w $*.ch; else ctangle $*.w; fi

.w.tex:
	if test -r $*.ch; then cweave $*.w $*.ch; else cweave $*.w; fi

.w.o:
	make $*.c
	make $*.o

.w:
	make $*.c
	make $*

.w.dvi:
	make $*.tex
	make $*.dvi

.w.ps:
	make $*.dvi
	make $*.ps

.w.pdf:
	make $*.tex
	case "$(PDFTEX)" in \
	 dvipdfm ) tex "\let\pdf+ \input $*"; dvipdfm $* ;; \
	 pdftex ) pdftex $* ;; \
	esac

WEBFILES = $(wildcard *.w)
BIN = $(WEBFILES:%.w=%)
DOCS = $(WEBFILES:%.w=%.pdf)
ALL = $(WEBFILES)

default:

build: $(BIN)
doc: $(DOCS)

all: build $(DOCS)

clean:
	rm -f $(CLN)

test:
	for bin in $(BIN); do $$bin ; done
