set libdir [file dirname [info script]]
switch -glob $tcl_platform(os) {
   Linux {load [file join $libdir bld libmd5.so ]}
   default {error "No binary"}
}
