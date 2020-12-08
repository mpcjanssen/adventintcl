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
        dict set hh mem $pos count 0
        incr pos
    }
    dict set hh mem $pos op done 
    dict set hh mem $pos arg 0
    dict set hh mem $pos count 0
    
    dict set hh pc 0
    set acc 0
    while {1} {
        dict with hh {
            dict with mem $pc {
                #puts "$pc\t$op $arg\t$count"
                if {$count == 1} {
                    return [list inf $acc]
                }
                # puts $op
                # puts $arg
                switch $op {
                   acc {incr acc $arg; incr pc}
                   jmp {incr pc $arg}
                   nop {incr pc}
                   done {return [list done $acc]}
                   default {error "Invallid op $op"}
                }
                incr count
            }
        }

    }
}

proc parts input {
    set data  [string trim $input]
    lassign [handheld $data] _ result1
    set result2 {}
    while {$result2 eq {}} {
    foreach jmppos [lsearch -all $data jmp] {
        set modprogram $input
        lset modprogram  $jmppos nop
        # puts $modprogram
        lassign [handheld $modprogram] res acc
        if {$res eq "done"} {set result2 $acc ; break}
    }
   
}
    return [list $result1 $result2]
}
aoc::results
