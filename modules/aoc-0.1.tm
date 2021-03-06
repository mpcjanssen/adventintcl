set scriptdir [file dirname [info script]]
package require http

package require tdom

set cookiefile [file join [file dirname [info script]] cookie.txt]
set f [open $cookiefile]
set cookie [read $f]
close $f

catch {
    package require twapi
    http::register https 443 twapi::tls_socket
}

catch {
    package require tls
    http::register https 443 tls::socket
}

if {[info procs ::jupyter::html] eq {}} {
   # Not running in jupyter
   # define dummy jupyter commands
   namespace eval jupyter {}
   proc ::jupyter::display args {}
   proc ::jupyter::html args {}
   set intests 1
   
}

namespace eval aoc {
        proc testresults {} {
               set t1 [time {lassign [part1 $::input] result1}]
               set t2 [time {lassign [part2 $::input] result2}]
               
               puts "Day1\t$result1 ($t1)"
               puts "Day2\t$result2 ($t2)"
               puts ===\n$t1\n$t2\n===
               return [list $result1 $result2]
        }
        proc results {} {
             if {[info exists ::intests]} {
                return
             } else {
               set t1 [lindex [time {lassign [part1 $::input] result1}] 0]
               puts "Part1\t$result1 ($t1 ms)"
               set t2 [lindex [time {lassign [part2 $::input] result2}] 0]
               puts "Part2\t$result2 ($t2 ms)"
        
             }
             return [list $result1 $result2]
        }
        
        proc parts {body} {
            coroutine ::aoc::part1 apply [list {} $body]          
            interp alias {} ::aoc::part2 {} ::aoc::part1
        }
        proc get-puzzle {year day part} {
            set fname [file join .. $year puzzles $day-$part.html]
            file mkdir [file dirname $fname]
    if {[file exists $fname]} {
        set f [open $fname]
        fconfigure $f -encoding utf-8
        set data [read $f]
        close $f
        jupyter::display text/plain (cached)
        jupyter::html $data
        return
    } 
    incr part -1
 

    set tok [http::geturl https://adventofcode.com/$year/day/$day -headers [list Cookie $::cookie ]]
    set html [http::data $tok]
    if {[http::ncode $tok] ne 200} {
        http::cleanup $tok
        puts stderr $html
        return
    }
    # puts $html
    dom parse -html $html doc
    set parthtml [lindex [$doc selectNodes //article] $part]
    if {$parthtml eq {}} {
        incr part
        puts stderr "Part $part not available"
        return
    }
    set html [$parthtml asHTML]

    jupyter::html $html
        set f [open $fname w]
    fconfigure $f -encoding utf-8
    puts -nonewline $f $html
    close $f
    http::cleanup $tok
    }
    

    proc get-input {year day} {
    set fname [file join .. $year input $day.txt]
    file mkdir [file dirname $fname]
    if {[file exists $fname]} {
        jupyter::display text/plain (cached)
        set f [open $fname]
        fconfigure $f -encoding utf-8
        set data [read $f]
        close $f
        return $data
    } 

    set tok [http::geturl https://adventofcode.com/$year/day/$day/input -headers [list Cookie $::cookie ]]
    set data [http::data $tok]
        if {[http::ncode $tok] ne 200} {
        http::cleanup $tok
        return -code error $data
    }
    http::cleanup $tok
    set f [open $fname w]
    fconfigure $f -encoding utf-8
    puts -nonewline $f $data
    close $f
    return $data
    }
    
     proc permutations {list} {
    set res [list [lrange $list 0 0]]
    set posL {0 1}
    foreach item [lreplace $list 0 0] {
       set nres {}
       foreach pos $posL {
          foreach perm $res {
             lappend nres [linsert $perm $pos $item]
          }
       }
       set res $nres
       lappend posL [llength $posL]
    }
    return $res
 }
 proc neighbours8 {x y} {
      subst { {[- $x 1] [- $y 1]}
              {[- $x 1] $y}
              {[- $x 1] [+ $y 1]}
              {$x [- $y 1]}
              {$x [+ $y 1]}
              {[+ $x 1] [- $y 1]}
              {[+ $x 1] $y}
              {[+ $x 1] [+ $y 1]}}
}

proc neighbours4 {x y} {
      subst {{[- $x 1] $y} {$x [- $y 1]} {$x [+ $y 1]} {[+ $x 1] $y}}
}

 proc combinations { list size } {
     if { $size == 0 } {
         return [list [list]]
     }
     set retval {}
     for { set i 0 } { ($i + $size) <= [llength $list] } { incr i } {
         set firstElement [lindex $list $i]
         set remainingElements [lrange $list [expr { $i + 1 }] end]
         foreach subset [combinations $remainingElements [expr { $size - 1 }]] {
             lappend retval [linsert $subset 0 $firstElement]
         }
     }
     return $retval
 }

}