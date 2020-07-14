TEMP_DIR = temp
RESULT_DIR = result
LATEX = pdflatex
BIBTEX = biber
MAKEINDEX = makeindex

INCLUDES = kapitel/abkuerzungen.tex docinfo.tex preambel.tex titelblatt.tex literatur.bib bilder/*.png

CHAPTERS = kapitel/kapitel*.tex kapitel/anhang*.tex

define latex-it
$(eval FILE = $(firstword $^))
@echo "Building $(FILE)"
@echo $(FILE)
@$(LATEX) -draftmode -output-directory=$(TEMP_DIR) $(FILE)
@cd $(TEMP_DIR) ; $(BIBTEX) $(basename $(FILE))
@cd $(TEMP_DIR) ; $(MAKEINDEX) $(basename $(FILE)).idx
@$(LATEX) -draftmode -output-directory=$(TEMP_DIR) $(FILE) > /dev/null
@$(LATEX) -draftmode -output-directory=$(TEMP_DIR) $(FILE) > /dev/null
@$(LATEX) -output-directory=$(TEMP_DIR) $(FILE)
endef


all: $(TEMP_DIR) $(RESULT_DIR) \
	$(RESULT_DIR)/ddos.pdf

clean:
	rm -rf $(TEMP_DIR)
	rm -rf $(RESULT_DIR)

$(TEMP_DIR)/ddos.pdf: ddos.tex $(INCLUDES) $(CHAPTERS)
	cp literatur.bib $(TEMP_DIR)
	$(latex-it)

$(RESULT_DIR)/ddos.pdf: $(TEMP_DIR)/ddos.pdf
	@cat $< > $@

$(TEMP_DIR):
	mkdir $(TEMP_DIR)

$(RESULT_DIR):
	mkdir $(RESULT_DIR)

.PHONY: clean all
