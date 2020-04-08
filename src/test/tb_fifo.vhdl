library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;


entity fifo_tb is
    generic (runner_cfg : string);
end fifo_tb;

architecture Behavioral of fifo_tb is

    component fifo is
        generic (ELEM_NUM : positive;  -- number of elements
                 ELEM_BITS : positive); -- number of bits per element
        port    (wr, rd, clk : in std_logic;
                 elem_in : in std_logic_vector (ELEM_BITS-1 downto 0);
                 elem_out : out std_logic_vector (ELEM_BITS-1 downto 0));
    end component;

    constant ELEM_BITS : positive :=3;
    signal clk : std_logic;
    signal rd : std_logic := '0';
    signal wr : std_logic := '0';
    signal elem_in : std_logic_vector (ELEM_BITS-1 downto 0);
    signal elem_out : std_logic_vector (ELEM_BITS-1 downto 0);
    constant T : time := 20 ns;

begin

    clock_generation : process
    begin
        clk <= '0';
        wait for T/2;
        clk <= '1';
        wait for T/2;
    end process;

    uut: fifo
        generic map (
            ELEM_NUM => 4,
            ELEM_BITS => ELEM_BITS)
        port map (
            rd => rd,
            clk => clk,
            wr => wr,
            elem_in => elem_in,
            elem_out => elem_out);

    tb: process
    begin
        test_runner_setup(runner, runner_cfg);

        wait until falling_edge(clk);
        wr <= '1';
        rd <= '0';
        elem_in <= "001";

        wait until falling_edge(clk);
        elem_in <= "010";

        wait until falling_edge(clk);
        wr <= '0';
        rd <= '1';

        wait until falling_edge(clk);
        assert elem_out = "001" report "fail first read";

        wait until falling_edge(clk);
        assert elem_out = "010" report "fail second read";

        test_runner_cleanup(runner); -- Simulation ends here
    end process;

end Behavioral;
