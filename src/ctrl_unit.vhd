----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ctrl_unit is
    port(
        clk : in std_logic;
        instr : in std_logic_vector(15 downto 0);
        pc_en : out std_logic;
        ra1 : out std_logic_vector(3 downto 0);
        ra2 : out std_logic_vector(3 downto 0);
        rwa : out std_logic_vector(3 downto 0);
        rwe : out std_logic
    );
end ctrl_unit;

architecture rtl of ctrl_unit is

begin


end rtl;

