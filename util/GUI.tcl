#!/usr/bin/wish
# Tcl script which acts as a frontend (I'm too lazy to learn Swing)
package require Tk

cd build

# Callback for the file opener
proc cb_filedialog {ent_name type} {
    if {![string compare $type open]} {
        set fname [tk_getOpenFile -title "Please Choose A File To Open..."]
    } elseif {![string compare $type save]} {
        set fname [tk_getSaveFile -title "Please Choose A File To.save..."]
    } else {
        return
    }

    if {[string length $fname] > 0} {
        $ent_name delete 0 end
        $ent_name insert 0 $fname
    }
}

# Creates a file dialog widget
proc make_filedialog {fr_name ent_name type} {
    pack [frame $fr_name] -fill x -expand 1
    pack [entry $fr_name.$ent_name] -fill x -expand 1 -side left
    pack [button $fr_name.activate -text "Open..." -command "cb_filedialog $fr_name.$ent_name $type"] -side right
}

# Bundle an entry and a label describing it
proc entry_label {ent_name labtext} {
    pack [label ${ent_name}label -text $labtext] -fill x -expand 1
    pack [entry $ent_name] -fill x -expand 1
}

proc send_file {} {
    set ip [.s.ip get]
    set port [.s.port get]
    set fname [.s.sel.fname get]
    puts -nonewline "Sending File... "
    exec java CLI send $ip $port $fname
    puts Done
}

proc recv_file {} {
    set port [.r.port get]
    set fname [.r.sel.fname get]
    puts -nonewline "Recieving File... "
    exec java CLI read $port $fname
    puts Done
}

pack [frame .s] -fill both -expand 1
pack [frame .r] -fill both -expand 1

entry_label .s.ip "IP Address"
entry_label .s.port "Port"
make_filedialog .s.sel fname open
pack [button .s.go -text "Send File" -command send_file] -fill x -expand 1

entry_label .r.port "Local Port"
make_filedialog .r.sel fname save
pack [button .r.go -text "Recieve File" -command recv_file] -fill x -expand 1

wm title . "FileCat"