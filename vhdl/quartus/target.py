import  collections

Target = collections.namedtuple('Target', \
    ['name','system_name', 'device_family', 'device', 'base_qsys_file', \
     'base_proj_tcl_file', 'files_list', 'original_system', 'base_address', \
     'axi_master_name', 'audio_in', 'audio_out', 'clock_name', 'top_level_vhdl_file'])

DE10 = Target(name='de10', system_name='de10_system', device_family='Cyclone V', \
    device='5CSEBA6U23I7', base_qsys_file='soc_base_system.qsys', base_proj_tcl_file = 'de10_proj.tcl', \
    files_list=['DE10Nano_System.vhd', 'de10_system/synthesis/de10_system.qip'], \
    top_level_vhdl_file='DE10Nano_System.vhd', original_system='soc_system', base_address='20', axi_master_name='hps.h2f_lw_axi_master', \
    audio_in='FE_Qsys_AD1939_Audio_Mini_v1_0.Line_In', audio_out='FE_Qsys_AD1939_Audio_Mini_v1_0.Headphone_Out', \
    clock_name='clk_hps'    
    )
Arria10 = Target(name='arria10', system_name='arria10_system', device_family='Arria 10', \
    device='10AS066H2F34I1HG', base_qsys_file='som_system.qsys', base_proj_tcl_file='arria10_proj.tcl', \
    files_list=['A10SoM_System.vhd', 'arria10_system/arria10_system.qip', 'pll.qsys'], \
    top_level_vhdl_file= 'A10SoM_System.vhd', original_system='som_system', base_address='20', \
    axi_master_name='arria10_hps_0.h2f_lw_axi_master', audio_in='FE_Qsys_AD1939_Audio_Research_v1_0.Line_In', \
    audio_out='FE_Qsys_AD1939_Audio_Research_v1_0.Headphone_Out', clock_name='clk_1'
    )    