.PHONY: all

test: day04.tcl day05.tcl all.tcl
	tclsh all.tcl


%.tcl: %.ipynb
	jupyter nbconvert --to script $<
