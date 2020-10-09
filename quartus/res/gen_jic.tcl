set OS [lindex $tcl_platform(os) 0]
if { $OS == "Windows" } {
    set bin_dir "bin64\\"
} else {
    set bin_dir "bin/"
}
set sof_files [glob output_files/*.sof]

foreach sof_file $sof_files {
    set jic_file [lindex [split $sof_file "."] 0].jic
    puts "Converting $sof_file to jic file"
    puts "$quartus(quartus_rootpath)${bin_dir}quartus_cpf -c -s 10AS066H2 -d EPCQ-512 ${sof_file} ${jic_file}"
    exec $quartus(quartus_rootpath)${bin_dir}quartus_cpf -c  ${sof_file} ${jic_file}
}
