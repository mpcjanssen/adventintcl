set scriptdir [file dirname [info script]]
package require twapi
package require tdom
http::register https 443 twapi::tls_socket

namespace eval aoc {
    proc display-day {year day part} {
    incr part -1
    set cookie session=$::env(SESSION)

    set tok [http::geturl https://adventofcode.com/$year/day/$day -headers [list Cookie $cookie ]]
    set html [http::data $tok]
    set doc [dom parse -html $html]
    set html [[lindex [$doc selectNodes //article] $part] asHTML]
    rename $doc {}
    jupyter::html $html

    http::cleanup $tok
    }
    proc input-day {year day} {
    incr part -1
    set cookie session=$::env(SESSION)

    set tok [http::geturl https://adventofcode.com/$year/day/$day/input -headers [list Cookie $cookie ]]
    set data [http::data $tok]
    http::cleanup $tok
    return $data
    }

   proc read-input {year day} {
       set fname $::scriptdir/../$year/input/$day.txt
       if {[file exists $fname]} {
            set f [open $fname]
            set d [read $f]
            close $f
            return $d
        } else {
            set f [open $fname w]
            set data [input-day $year $day]
            puts -nonewline $f $data
            close $f
            return $data
        }
   }
}