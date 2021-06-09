load [file normalize ./bld/libmd5c.so] Md5c
puts [time {
set seed ngcjuoqr
array unset cands
array unset hashes
set keys {}

set index 0
for {set index 0} {$index < 50000 } {incr index} {
    set hashes($index) [binary encode hex [md5c $seed$index]]
    if {[regexp {(.)\1{2}} $hashes($index) -> d]} {
        if {[regexp {(.)\1{4}} $hashes($index) -> d]} {
#         puts $index
#         puts [llength $cands($d)]
            if {[info exists cands($d)]} {
                foreach idx $cands($d) {
                    if {$index - $idx <= 1000} {
                        lappend keys $idx
    #                     puts "$index: digit $d in $hashes($index) and hashes($idx) = $hashes($idx)"  
                    }
                }
            }
            set cands($d) $index
        } else {
            lappend cands($d) $index
        }
    }

}
puts [lindex [lsort -integer $keys] 63]}]
proc stretch {s} {
    time {set s [binary encode hex [md5c $s]]} 2017
    return $s
}

array unset cands
array unset hashes
set keys {}
array unset stretched

set index 0
for {set index 0} {$index < 50000 } {incr index} {
   if {$index % 100 == 0} {puts $index}
    set hashes($index) [stretch $seed$index]
    if {[regexp {(.)\1{2}} $hashes($index) -> d]} {
        if {[regexp {(.)\1{4}} $hashes($index) -> d]} {
#         puts $index
#         puts [llength $cands($d)]
            if {[info exists cands($d)]} {
                foreach idx $cands($d) {
                    if {$index - $idx <= 1000} {
                        lappend keys $idx
                        puts "$index: digit $d in $hashes($index) and hashes($idx) = $hashes($idx)"
                    }
                }
            }
            set cands($d) $index
        } else {
            lappend cands($d) $index
        }
    }
}
puts [lindex [lsort -integer $keys] 63]
# parray stretched
