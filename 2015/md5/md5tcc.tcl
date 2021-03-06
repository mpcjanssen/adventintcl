package require tcc4tcl;                 # needs tcc4tcl
package provide md5tcc 0.0.1;              # 

namespace eval ::md5 {
  set handle [tcc4tcl::new]
 
  set source_dir [file dirname [info script]] 
  $handle add_include_path $source_dir
  $handle ccode {#include "md5.c"}


  $handle ccommand md5tcc {dummy ip objc objv} {
      MD5_CTX *mp;
      unsigned char *data;
      unsigned char buf[16];
      int size;
      Tcl_Obj *obj;

      if (objc < 2 || objc > 3) {
        Tcl_WrongNumArgs(ip, 1, objv, "data");
        return TCL_ERROR;
      }
      obj = Tcl_NewByteArrayObj(NULL, sizeof *mp);
      mp = (MD5_CTX *) Tcl_GetByteArrayFromObj(obj,NULL);
      MD5Init(mp);
      data = Tcl_GetByteArrayFromObj(objv[1], &size);
      MD5Update(mp, data, size);
      MD5Final(buf, mp);
      size = sizeof buf;
      Tcl_SetObjResult(ip, Tcl_NewByteArrayObj(buf,size));
      return TCL_OK;
    }

  $handle go
}