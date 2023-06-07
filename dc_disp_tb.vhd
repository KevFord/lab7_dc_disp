library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;
library std;
    use std.textio.all;
library work;

entity tb is
end entity tb;

architecture behave of tb is

    type t_7seg_number is array(0 to 10) of std_logic_vector(6 downto 0);
    constant c_7seg_number      : t_7seg_number := (
        "1000000", -- 0
        "1111001", -- 1
        "0100100", -- 2
        "0110000", -- 3
        "0011001", -- 4
        "0010010", -- 5
        "0000010", -- 6
        "1111000", -- 7
        "0000000", -- 8
        "0011000", -- 9
        "1111111"  -- Blank
    );

    signal hex0_check           : std_logic_vector(6 downto 0) := (others => '0');
    signal hex1_check           : std_logic_vector(6 downto 0) := (others => '0');
    signal hex2_check           : std_logic_vector(6 downto 0) := (others => '0');

    signal current_dc           : std_logic_vector(7 downto 0) := (others => '0');
    signal current_dc_update    : std_logic := '0';

    signal hex0                 : std_logic_vector(6 downto 0) := (others => '0');
    signal hex1                 : std_logic_vector(6 downto 0) := (others => '0');
    signal hex2                 : std_logic_vector(6 downto 0) := (others => '0');

    signal transmit_data        : std_logic_vector(7 downto 0) := (others => '0');
    signal transmit_valid       : std_logic := '0';
    signal transmit_ready       : std_logic := '0';

    signal reset                : std_logic := '0';
    signal clk_50               : std_logic := '0';
    signal kill_clock           : std_logic := '0';

    signal tx                   : std_logic := '1';
    signal update_done_flag     : std_logic;
    signal update_flag          : std_logic;

begin
    i_dc_disp   : entity work.dc_disp
    port map (
    -- In
        clk_50              => clK_50,
        reset               => reset,
        current_dc          => current_dc,
        current_dc_update   => current_dc_update,
        transmit_ready      => transmit_ready,
    -- Out
        transmit_data       => transmit_data,
        transmit_valid      => transmit_valid,

        hex0                => hex0,
        hex1                => hex1,
        hex2                => hex2
    );

    i_uart      : entity work.serial_uart
    generic map (
        g_reset_active_state    => '1',
        g_serial_speed_bps      => 115200,
        g_clk_period_ns         => 20,      -- 50 MHz testbench clock
        g_parity                => 0
    )
    port map (
        clk                     => clk_50,
        reset                   => reset, -- active low reset
        rx                      => '1',
        tx                      => tx,
  
        received_data           => open,
        received_valid          => open,
        received_error          => open,
        received_parity_error   => open,
  
        transmit_ready          => transmit_ready,
        transmit_valid          => transmit_valid,
        transmit_data           => transmit_data
    );

    p_clock_gen : process
    begin
        while ( kill_clock = '0' ) loop
            clk_50 <= not clk_50;
            wait for 10 ns;
         end loop;
         -- wait forever;
         wait;
    end process p_clock_gen;

    p_reset_gen : process
    begin
        report("Reset process waiting on clock..");
        wait for 1 us;
        reset <= '1';
        report("Reset set.");
        wait for 1 us;
        reset <= '0';
        report("Reset released.");
        wait;
    end process p_reset_gen;

    p_main_test : process
    begin
        wait for 1.1 ms;
        wait on reset for 1 us;
        if reset = '0' then
            report("Main test begins.");            
        end if;
        wait for 10 ms;

        report("current_dc set to 23");
        hex0_check <= c_7seg_number(3);
        hex1_check <= c_7seg_number(2);
        hex2_check <= c_7seg_number(0);

        wait on clK_50 for 1 us;
        current_dc <= std_logic_vector(to_unsigned(23, current_dc'length));
        wait on clk_50 for 1 us;
        report("current_dc_update toggled.");
        current_dc_update <= '1';
        wait on clk_50 for 1 us;
        current_dc_update <= '0';
        report("Running for 100 us. Another 5 bytes should be sent instantly after the first.");
        wait for 100 us;

        report("current_dc set to 15");
        hex0_check <= c_7seg_number(5);
        hex1_check <= c_7seg_number(1);
        hex2_check <= c_7seg_number(0);

        wait on clK_50 for 1 us;
        current_dc <= std_logic_vector(to_unsigned(15, current_dc'length));
        wait on clk_50 for 1 us;
        report("current_dc_update toggled.");
        current_dc_update <= '1';
        wait on clk_50 for 1 us;
        current_dc_update <= '0';
        report("Running for 100 ms.");
        wait for 10 ms;

        report("current_dc set to 50");
        hex0_check <= c_7seg_number(0);
        hex1_check <= c_7seg_number(5);
        hex2_check <= c_7seg_number(0);

        wait on clK_50 for 1 us;
        current_dc <= std_logic_vector(to_unsigned(50, current_dc'length));
        wait on clk_50 for 1 us;
        report("current_dc_update toggled.");
        current_dc_update <= '1';
        wait on clk_50 for 1 us;
        current_dc_update <= '0';
        report("Running for 100 ms.");
        wait for 10 ms;

        report("current_dc set to 20");
        hex0_check <= c_7seg_number(0);
        hex1_check <= c_7seg_number(2);
        hex2_check <= c_7seg_number(0);

        wait on clK_50 for 1 us;
        current_dc <= std_logic_vector(to_unsigned(20, current_dc'length));
        wait on clk_50 for 1 us;
        report("current_dc_update toggled.");
        current_dc_update <= '1';
        wait on clk_50 for 1 us;
        current_dc_update <= '0';
        report("Running for 100 ms.");
        wait for 10 ms;

        report("current_dc set to 90");
        hex0_check <= c_7seg_number(0);
        hex1_check <= c_7seg_number(9);
        hex2_check <= c_7seg_number(0);

        wait on clK_50 for 1 us;
        current_dc <= std_logic_vector(to_unsigned(90, current_dc'length));
        wait on clk_50 for 1 us;
        report("current_dc_update toggled.");
        current_dc_update <= '1';
        wait on clk_50 for 1 us;
        current_dc_update <= '0';
        report("Running for 100 ms.");
        wait for 10 ms;

        report("current_dc set to 100");
        hex0_check <= c_7seg_number(0);
        hex1_check <= c_7seg_number(0);
        hex2_check <= c_7seg_number(1);

        wait on clK_50 for 1 us;
        current_dc <= std_logic_vector(to_unsigned(100, current_dc'length));
        wait on clk_50 for 1 us;
        report("current_dc_update toggled.");
        current_dc_update <= '1';
        wait on clk_50 for 1 us;
        current_dc_update <= '0';
        report("Running for 100 ms.");
        wait for 10 ms;

        wait for 10 ms;
        kill_clock <= '1';
        report("Main test over. Check waves.");
        wait;
    end process p_main_test;
end architecture behave;