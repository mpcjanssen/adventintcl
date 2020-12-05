set scriptdir [file dirname [info script]]
package require http

package require tdom
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
        proc results {} {
             if {[info exists ::intests]} {
                return [parts $::input]
             } else {
               set dt [time {lassign [parts $::input] result1 result2}]
               puts "Day1\t$result1"
               puts "Day2\t$result2"
               puts $dt
             }
        }
        proc get-puzzle {year day part} {
            set fname [file join puzzles $day-$part.html]
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
    set cookie session=$::env(SESSION)

    set tok [http::geturl https://adventofcode.com/$year/day/$day -headers [list Cookie $cookie ]]
    set html [http::data $tok]
    if {[http::status $tok] != 200} {
        http::cleanup $tok
        return -code error $html
    }
    set doc [dom parse -html $html]
    set html [[lindex [$doc selectNodes //article] $part] asHTML]
    rename $doc {}
    jupyter::html $html
        set f [open $fname w]
    fconfigure $f -encoding utf-8
    puts -nonewline $f $html
    close $f
    http::cleanup $tok
    }
    
    proc answer {year day part answer} {
        set cookie session=$::env(SESSION)
        set tok [http::geturl https://adventofcode.com/$year/day/$day/answer -headers [list Cookie $cookie ] -query [list level $part answer $answer]]
        set html [http::data $tok]
        parray $tok
        http::cleanup $tok
        jupyter::html $html
    }
    proc get-input {year day} {
    set fname [file join input $day.txt]
    if {[file exists $fname]} {
        jupyter::display text/plain (cached)
        set f [open $fname]
        fconfigure $f -encoding utf-8
        set data [read $f]
        close $f
        return $data
    } 
    set cookie session=$::env(SESSION)

    set tok [http::geturl https://adventofcode.com/$year/day/$day/input -headers [list Cookie $cookie ]]
    set data [http::data $tok]
        if {[http::status $tok] != 200} {
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

}