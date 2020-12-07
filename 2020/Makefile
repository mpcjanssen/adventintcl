.PHONY: all

test: day03.tcl day04.tcl day05.tcl day06.tcl day07.tcl all.tcl
	tclsh all.tcl


%.tcl: %.ipynb
	jupyter nbconvert --to script $<
