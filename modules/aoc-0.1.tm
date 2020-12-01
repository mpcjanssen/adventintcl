set scriptdir [file dirname [info script]]
package require http
package require twapi
package require tdom
http::register https 443 twapi::tls_socket

namespace eval aoc {
        proc get-puzzle {year day part} {
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
    proc get-input {year day} {
    incr part -1
    set cookie session=$::env(SESSION)

    set tok [http::geturl https://adventofcode.com/$year/day/$day/input -headers [list Cookie $cookie ]]
    set data [http::data $tok]
    http::cleanup $tok
    return $data
    }

}