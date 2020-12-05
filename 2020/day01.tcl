source setup.tcl

aoc::get-puzzle 2020 1 1

set input [aoc::get-input 2020 1];
puts [string range $input 0 100]...

set data [split [string trim $input] \n];

aoc::get-puzzle 2020 1 2

proc parts data {
    set data [lsort -integer $data]
    set l [llength $data]
    set d1 false
    set d2 false
    for {set x 0} {$x < $l} {incr x} {
        if {$d1 && $d2} return
            for {set y [expr {$x+1}]} {$y < $l} {incr y} {
                set a [lindex $data $x]
                set b [lindex $data $y]
                if {$a + $b > 2020} break
                 if {!$d1 && $a+$b == 2020} {
                    puts  Part1:\t[ * $a $b ]
                    set d1 true
                }
                for {set z [expr {$y+1}]} {$z < $l} {incr z} {
                    set c [lindex $data $z]  
                    if {!$d2 && $a+$b+$c == 2020} {
                    puts  Part2:\t[* $a $b $c]
                    set d2 true
                   
                }           
            }
        }
    }
}
time {parts $data}

set sdata [lsort -unique $data]

set sdata [lsort -unique $data]


proc spart {data} {
    set d1 false
    set d2 false
    set l [llength $data]
    for {set i 0} {$i < $l} {incr i} {
        if {$d1 && $d2} {return}
        set x [lindex $data $i]
        set rest [expr {2020 - $x}] 
        if {!$d1 && ($rest in $data) } {puts spart1:\t[expr {$x * $rest}] ; set d1 true}
         for {set j $i} {$j < $l} {incr j} {
            set y [lindex $data $j]
            set z [expr {$rest - [lindex $data $j]}]
            if {!$d2 && ($z in $data) } {puts spart2\t[expr {$x * $y * $z}]; set d2 true  }
        }
        
    }
    
}

time {spart $sdata}


