-- Copyright (C) 2023  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 22.1std.2 Build 922 07/20/2023 SC Lite Edition"

-- DATE "05/12/2025 16:32:21"

-- 
-- Device: Altera 5CGXFC7C7F23C8 Package FBGA484
-- 

-- 
-- This VHDL file should be used for ModelSim (VHDL) only
-- 

LIBRARY ALTERA_LNSIM;
LIBRARY CYCLONEV;
LIBRARY IEEE;
USE ALTERA_LNSIM.ALTERA_LNSIM_COMPONENTS.ALL;
USE CYCLONEV.CYCLONEV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	PiplinedProcessor IS
    PORT (
	clk : IN std_logic;
	rst : IN std_logic;
	in_port : IN std_logic_vector(31 DOWNTO 0);
	out_port : BUFFER std_logic_vector(31 DOWNTO 0)
	);
END PiplinedProcessor;

-- Design Ports Information
-- out_port[0]	=>  Location: PIN_G15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[1]	=>  Location: PIN_A13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[2]	=>  Location: PIN_N6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[3]	=>  Location: PIN_P18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[4]	=>  Location: PIN_L7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[5]	=>  Location: PIN_J11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[6]	=>  Location: PIN_A8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[7]	=>  Location: PIN_K16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[8]	=>  Location: PIN_C16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[9]	=>  Location: PIN_J21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[10]	=>  Location: PIN_J18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[11]	=>  Location: PIN_T13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[12]	=>  Location: PIN_Y17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[13]	=>  Location: PIN_C6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[14]	=>  Location: PIN_V9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[15]	=>  Location: PIN_H16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[16]	=>  Location: PIN_P14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[17]	=>  Location: PIN_H11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[18]	=>  Location: PIN_B13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[19]	=>  Location: PIN_AA12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[20]	=>  Location: PIN_D17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[21]	=>  Location: PIN_M8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[22]	=>  Location: PIN_G12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[23]	=>  Location: PIN_R9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[24]	=>  Location: PIN_D21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[25]	=>  Location: PIN_G16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[26]	=>  Location: PIN_M22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[27]	=>  Location: PIN_F9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[28]	=>  Location: PIN_AA9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[29]	=>  Location: PIN_J9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[30]	=>  Location: PIN_F10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[31]	=>  Location: PIN_A22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[0]	=>  Location: PIN_M16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[31]	=>  Location: PIN_W16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[30]	=>  Location: PIN_AA20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[29]	=>  Location: PIN_B11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[28]	=>  Location: PIN_F15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[27]	=>  Location: PIN_N16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[26]	=>  Location: PIN_R15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[25]	=>  Location: PIN_AB11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[24]	=>  Location: PIN_R6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[23]	=>  Location: PIN_R22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[22]	=>  Location: PIN_B5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[21]	=>  Location: PIN_G18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[20]	=>  Location: PIN_D13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[19]	=>  Location: PIN_T22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[18]	=>  Location: PIN_W9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[17]	=>  Location: PIN_AA17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[16]	=>  Location: PIN_F7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[15]	=>  Location: PIN_W8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[14]	=>  Location: PIN_A10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[13]	=>  Location: PIN_B20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[12]	=>  Location: PIN_AA14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[11]	=>  Location: PIN_C11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[10]	=>  Location: PIN_D22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[9]	=>  Location: PIN_B16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[8]	=>  Location: PIN_F19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[7]	=>  Location: PIN_C18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[6]	=>  Location: PIN_U15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[5]	=>  Location: PIN_P16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[4]	=>  Location: PIN_A5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[3]	=>  Location: PIN_D9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[2]	=>  Location: PIN_E19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[1]	=>  Location: PIN_G22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- rst	=>  Location: PIN_K20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clk	=>  Location: PIN_T12,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF PiplinedProcessor IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_clk : std_logic;
SIGNAL ww_rst : std_logic;
SIGNAL ww_in_port : std_logic_vector(31 DOWNTO 0);
SIGNAL ww_out_port : std_logic_vector(31 DOWNTO 0);
SIGNAL \in_port[0]~input_o\ : std_logic;
SIGNAL \in_port[31]~input_o\ : std_logic;
SIGNAL \in_port[30]~input_o\ : std_logic;
SIGNAL \in_port[29]~input_o\ : std_logic;
SIGNAL \in_port[28]~input_o\ : std_logic;
SIGNAL \in_port[27]~input_o\ : std_logic;
SIGNAL \in_port[26]~input_o\ : std_logic;
SIGNAL \in_port[25]~input_o\ : std_logic;
SIGNAL \in_port[24]~input_o\ : std_logic;
SIGNAL \in_port[23]~input_o\ : std_logic;
SIGNAL \in_port[22]~input_o\ : std_logic;
SIGNAL \in_port[21]~input_o\ : std_logic;
SIGNAL \in_port[20]~input_o\ : std_logic;
SIGNAL \in_port[19]~input_o\ : std_logic;
SIGNAL \in_port[18]~input_o\ : std_logic;
SIGNAL \in_port[17]~input_o\ : std_logic;
SIGNAL \in_port[16]~input_o\ : std_logic;
SIGNAL \in_port[15]~input_o\ : std_logic;
SIGNAL \in_port[14]~input_o\ : std_logic;
SIGNAL \in_port[13]~input_o\ : std_logic;
SIGNAL \in_port[12]~input_o\ : std_logic;
SIGNAL \in_port[11]~input_o\ : std_logic;
SIGNAL \in_port[10]~input_o\ : std_logic;
SIGNAL \in_port[9]~input_o\ : std_logic;
SIGNAL \in_port[8]~input_o\ : std_logic;
SIGNAL \in_port[7]~input_o\ : std_logic;
SIGNAL \in_port[6]~input_o\ : std_logic;
SIGNAL \in_port[5]~input_o\ : std_logic;
SIGNAL \in_port[4]~input_o\ : std_logic;
SIGNAL \in_port[3]~input_o\ : std_logic;
SIGNAL \in_port[2]~input_o\ : std_logic;
SIGNAL \in_port[1]~input_o\ : std_logic;
SIGNAL \rst~input_o\ : std_logic;
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \~QUARTUS_CREATED_GND~I_combout\ : std_logic;

BEGIN

ww_clk <= clk;
ww_rst <= rst;
ww_in_port <= in_port;
out_port <= ww_out_port;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

-- Location: IOOBUF_X62_Y81_N36
\out_port[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(0));

-- Location: IOOBUF_X60_Y81_N53
\out_port[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(1));

-- Location: IOOBUF_X4_Y0_N2
\out_port[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(2));

-- Location: IOOBUF_X89_Y9_N56
\out_port[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(3));

-- Location: IOOBUF_X40_Y81_N36
\out_port[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(4));

-- Location: IOOBUF_X58_Y81_N76
\out_port[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(5));

-- Location: IOOBUF_X30_Y81_N2
\out_port[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(6));

-- Location: IOOBUF_X64_Y81_N53
\out_port[7]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(7));

-- Location: IOOBUF_X72_Y81_N53
\out_port[8]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(8));

-- Location: IOOBUF_X84_Y81_N2
\out_port[9]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(9));

-- Location: IOOBUF_X68_Y81_N53
\out_port[10]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(10));

-- Location: IOOBUF_X52_Y0_N2
\out_port[11]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(11));

-- Location: IOOBUF_X58_Y0_N42
\out_port[12]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(12));

-- Location: IOOBUF_X30_Y81_N36
\out_port[13]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(13));

-- Location: IOOBUF_X26_Y0_N59
\out_port[14]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(14));

-- Location: IOOBUF_X64_Y81_N2
\out_port[15]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(15));

-- Location: IOOBUF_X68_Y0_N19
\out_port[16]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(16));

-- Location: IOOBUF_X52_Y81_N2
\out_port[17]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(17));

-- Location: IOOBUF_X60_Y81_N36
\out_port[18]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(18));

-- Location: IOOBUF_X40_Y0_N36
\out_port[19]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(19));

-- Location: IOOBUF_X70_Y81_N2
\out_port[20]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(20));

-- Location: IOOBUF_X32_Y0_N19
\out_port[21]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(21));

-- Location: IOOBUF_X52_Y81_N19
\out_port[22]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(22));

-- Location: IOOBUF_X34_Y0_N42
\out_port[23]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(23));

-- Location: IOOBUF_X88_Y81_N54
\out_port[24]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(24));

-- Location: IOOBUF_X70_Y81_N53
\out_port[25]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(25));

-- Location: IOOBUF_X89_Y36_N39
\out_port[26]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(26));

-- Location: IOOBUF_X32_Y81_N19
\out_port[27]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(27));

-- Location: IOOBUF_X32_Y0_N36
\out_port[28]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(28));

-- Location: IOOBUF_X36_Y81_N2
\out_port[29]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(29));

-- Location: IOOBUF_X40_Y81_N19
\out_port[30]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(30));

-- Location: IOOBUF_X78_Y81_N53
\out_port[31]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(31));

-- Location: IOIBUF_X89_Y35_N61
\in_port[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(0),
	o => \in_port[0]~input_o\);

-- Location: IOIBUF_X64_Y0_N1
\in_port[31]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(31),
	o => \in_port[31]~input_o\);

-- Location: IOIBUF_X62_Y0_N35
\in_port[30]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(30),
	o => \in_port[30]~input_o\);

-- Location: IOIBUF_X50_Y81_N92
\in_port[29]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(29),
	o => \in_port[29]~input_o\);

-- Location: IOIBUF_X66_Y81_N58
\in_port[28]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(28),
	o => \in_port[28]~input_o\);

-- Location: IOIBUF_X89_Y35_N44
\in_port[27]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(27),
	o => \in_port[27]~input_o\);

-- Location: IOIBUF_X89_Y6_N21
\in_port[26]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(26),
	o => \in_port[26]~input_o\);

-- Location: IOIBUF_X38_Y0_N35
\in_port[25]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(25),
	o => \in_port[25]~input_o\);

-- Location: IOIBUF_X2_Y0_N58
\in_port[24]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(24),
	o => \in_port[24]~input_o\);

-- Location: IOIBUF_X89_Y6_N55
\in_port[23]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(23),
	o => \in_port[23]~input_o\);

-- Location: IOIBUF_X34_Y81_N92
\in_port[22]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(22),
	o => \in_port[22]~input_o\);

-- Location: IOIBUF_X68_Y81_N1
\in_port[21]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(21),
	o => \in_port[21]~input_o\);

-- Location: IOIBUF_X54_Y81_N1
\in_port[20]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(20),
	o => \in_port[20]~input_o\);

-- Location: IOIBUF_X89_Y6_N38
\in_port[19]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(19),
	o => \in_port[19]~input_o\);

-- Location: IOIBUF_X4_Y0_N35
\in_port[18]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(18),
	o => \in_port[18]~input_o\);

-- Location: IOIBUF_X60_Y0_N52
\in_port[17]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(17),
	o => \in_port[17]~input_o\);

-- Location: IOIBUF_X26_Y81_N75
\in_port[16]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(16),
	o => \in_port[16]~input_o\);

-- Location: IOIBUF_X4_Y0_N52
\in_port[15]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(15),
	o => \in_port[15]~input_o\);

-- Location: IOIBUF_X36_Y81_N35
\in_port[14]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(14),
	o => \in_port[14]~input_o\);

-- Location: IOIBUF_X86_Y81_N52
\in_port[13]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(13),
	o => \in_port[13]~input_o\);

-- Location: IOIBUF_X52_Y0_N52
\in_port[12]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(12),
	o => \in_port[12]~input_o\);

-- Location: IOIBUF_X50_Y81_N75
\in_port[11]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(11),
	o => \in_port[11]~input_o\);

-- Location: IOIBUF_X80_Y81_N52
\in_port[10]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(10),
	o => \in_port[10]~input_o\);

-- Location: IOIBUF_X72_Y81_N35
\in_port[9]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(9),
	o => \in_port[9]~input_o\);

-- Location: IOIBUF_X76_Y81_N1
\in_port[8]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(8),
	o => \in_port[8]~input_o\);

-- Location: IOIBUF_X78_Y81_N18
\in_port[7]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(7),
	o => \in_port[7]~input_o\);

-- Location: IOIBUF_X60_Y0_N1
\in_port[6]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(6),
	o => \in_port[6]~input_o\);

-- Location: IOIBUF_X89_Y9_N4
\in_port[5]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(5),
	o => \in_port[5]~input_o\);

-- Location: IOIBUF_X34_Y81_N75
\in_port[4]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(4),
	o => \in_port[4]~input_o\);

-- Location: IOIBUF_X28_Y81_N18
\in_port[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(3),
	o => \in_port[3]~input_o\);

-- Location: IOIBUF_X86_Y81_N1
\in_port[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(2),
	o => \in_port[2]~input_o\);

-- Location: IOIBUF_X82_Y81_N75
\in_port[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(1),
	o => \in_port[1]~input_o\);

-- Location: IOIBUF_X72_Y81_N1
\rst~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_rst,
	o => \rst~input_o\);

-- Location: IOIBUF_X52_Y0_N18
\clk~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clk,
	o => \clk~input_o\);

-- Location: LABCELL_X9_Y47_N3
\~QUARTUS_CREATED_GND~I\ : cyclonev_lcell_comb
-- Equation(s):

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
;
END structure;


