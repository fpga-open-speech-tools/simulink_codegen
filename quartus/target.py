"""This module provides tuples to describe target configurations of quartus_workflow.

* Target      tuple to define information needed about a target
* Audiomini   instance of Target tuple to describe the target configuration for a DE-10 Nano with an Audiomini
* Audioblade  instance of Target tuple to describe the configuration for an Audioblade
"""
import collections

Target = collections.namedtuple('Target',
                                ['name', 'system_name', 'device_family', 'device', 'base_qsys_file',
                                 'base_proj_tcl_file', 'files_list', 'original_system', 'base_address',
                                 'axi_master_name', 'audio_in', 'audio_out', 'clock_name', 'top_level_vhdl_file'])

Audiomini = Target(name='audiomini', system_name='audiomini_system', device_family='Cyclone V',
                   device='5CSEBA6U23I7', base_qsys_file='soc_base_system.qsys', base_proj_tcl_file='audiomini_proj.tcl',
                   files_list=['Audiomini.vhd',
                               'audiomini_system/synthesis/audiomini_system.qip'],
                   top_level_vhdl_file='Audiomini.vhd', original_system='soc_system', base_address='40', axi_master_name='hps.h2f_lw_axi_master',
                   audio_in='FE_Qsys_AD1939_Audio_Mini_0.Line_In', audio_out='FE_Qsys_AD1939_Audio_Mini_0.Headphone_Out',
                   clock_name='clk_hps'
                   )

Audioblade = Target(name='audioblade', system_name='audioblade_system', device_family='Arria 10',
                    device='10AS066H2F34I1HG', base_qsys_file='audioblade_system.qsys', base_proj_tcl_file='audioblade_proj.tcl',
                    files_list=['audioblade.vhd', 'audioblade.sdc',
                                'audioblade_system/audioblade_system.qip', 'pll.qsys'],
                    top_level_vhdl_file='audioblade.vhd', original_system='som_system', base_address='40',
                    axi_master_name='arria10_hps_0.h2f_lw_axi_master', audio_in='FE_Qsys_AD1939_Audio_Blade_v1_0.Line_In',
                    audio_out='FE_Qsys_AD1939_Audio_Blade_v1_0.Line_Out', clock_name='clk_1'
                    )

Reflex = Target(name='reflex', system_name='reflex_system', device_family='Arria 10',
                    device='10AS066H2F34I1HG', base_qsys_file='reflex_system.qsys', base_proj_tcl_file='reflex_proj.tcl',
                    files_list=['reflex_som.vhd',
                                'reflex_system/reflex_system.qip', 'pll_sys.qsys', 'common/delayed_rst.vhd', 'common/sync_rst.vhd', 'common/tick_gen.vhd'],
                    top_level_vhdl_file='reflex_som.vhd', original_system='soc_system', base_address='40',
                    axi_master_name='hps.h2f_lw_axi_master', audio_in='FE_Qsys_AD1939_Audio_Research_v1_0.Line_In',
                    audio_out='FE_Qsys_AD1939_Audio_Research_v1_0.Line_Out', clock_name='clk_hps'
                    )
