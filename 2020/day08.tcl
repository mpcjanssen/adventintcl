source setup.tcl

aoc::get-puzzle 2020 8 1
aoc::get-puzzle 2020 8 2
set input [aoc::get-input 2020 8]
jupyter::html "<h2>Input</h2>"
jupyter::display "text/plain" [string range $input 0 100]...;

    proc handheld {program} {
        set hh {}
        set pos 0
        foreach {opc arg} $program {
            dict set hh mem $pos op $opc
            dict set hh mem $pos arg $arg
            incr pos
        }
        dict set hh mem $pos op done 
        dict set hh mem $pos arg 0
        dict set hh pc 0
        dict set hh executed {} 
        set acc 0
        while {1} {
            dict with hh {
                dict with mem $pc {
                    # puts $executed
                    #puts "$pc\t$op $arg\t$count"
                    if {[lsearch $executed $pc] != -1} {
                        return [list inf $acc $hh]
                    }
                    lappend executed $pc
                    
                    # puts $op
                    # puts $arg
                    switch $op {
                       acc {incr acc $arg; incr pc}
                       jmp {incr pc $arg}
                       nop {incr pc}
                       done {return [list done $acc]}
                       default {error "Invallid op $op"}
                    }
                    
                }
            }
        }
    }

    proc parts input {
        set data  [string trim $input]
        lassign [handheld $data] _ result1 hh
        set result2 {}
        # only ops executed in the looping program are candidates for
        # replacement
        while {$result2 eq {}} {
            foreach candidate [lreverse [dict get $hh executed]] {
                set prog_idx [expr {2*$candidate}]
                set modprogram $data
                switch [lindex $modprogram $prog_idx] {
                    jmp {lset modprogram  $prog_idx nop}
                    nop {lset modprogram  $prog_idx jmp}
                    default {continue}
                }
                
                # puts $modprogram
                lassign [handheld $modprogram] res acc
                if {$res eq "done"} {set result2 $acc ; break}
            }
        }
        return [list $result1 $result2]
    }
    aoc::results


