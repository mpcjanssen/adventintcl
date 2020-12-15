lappend auto_path [file dirname [info script]]/lib
lappend auto_path /usr/lib/tcltk/x86_64-linux-gnu/
tcl::tm::path add [file dirname [info script]]/modules
tcl::tm::path add [file dirname [info script]]/../modules
package forget aoc
package require aoc
namespace import tcl::mathop::*
