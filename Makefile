TARGET   := main
BUILD    := xelatex -interaction=nonstopmode -halt-on-error -shell-escape

# Two passes: the first writes the .toc/.aux, the second resolves the
# table of contents and all cross-references.
PASSES   := 2

SOURCES := $(TARGET).tex \
           style/course.sty \
           style/tikz-styles.tex \
           $(wildcard chapters/*.tex) \
           $(wildcard appendix/*.tex)

.PHONY: all clean distclean

all: $(TARGET).pdf

LOG := build.log

$(TARGET).pdf: $(SOURCES)
	@rm -f $(TARGET).pdf
	@for i in $$(seq 1 $(PASSES)); do \
		echo "-- pass $$i"; \
		$(BUILD) $(TARGET).tex >$(LOG) 2>&1 || { \
			echo "xelatex failed; last lines of $(LOG):"; \
			tail -n 40 $(LOG); \
			exit 1; \
		}; \
	done
	@echo "Done: $(TARGET).pdf (logs: $(LOG), $(TARGET).log)"

clean:
	rm -f *.aux *.toc *.lof *.lot *.out *.log $(LOG)
	rm -rf _minted-*
	rm -f $(TARGET).pdf
	@echo "Cleaned."

distclean: clean
