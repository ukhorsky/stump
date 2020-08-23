----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity memory is
    port(
        clk : in std_logic;
        pc_en : in std_logic;
        pc_in : in std_logic_vector(7 downto 0);
        pc_out : out std_logic_vector(7 downto 0);
        ra1 : in std_logic_vector(3 downto 0);
        ra2 : in std_logic_vector(3 downto 0);
        rwa : in std_logic_vector(3 downto 0);
        rwd : in std_logic_vector(15 downto 0);
        rd1 : out std_logic_vector(15 downto 0);
        rd2 : out std_logic_vector(15 downto 0);
        rst : in std_logic
    );
end memory;

architecture rtl of memory is

    type registers is array (0 to 15) of std_logic_vector(15 downto 0); 
    type rom is array (0 to 255) of std_logic_vector(15 downto 0);

    signal rf : registers;
    signal imem : rom;
    signal pc : std_logic_vector(7 downto 0);

begin

    pc_entity: process(rst, clk)
    begin
        if (rst = '1') then
            pc <= x"08"; -- 8 addresses are reserved for interruots vectors
        elsif (rising_edge(clk)) then
            if (pc_en = '1') then
                pc <= pc_in;
            end if;
        end if;
    end process;
    
    pc_out <= pc;
    
    process (clk)
    begin
        if (rising_edge(clk))
            if (rwd = '1') then
                rf(CONV_INTEGER(rwa)) <= rwd;
            end if;
        end if;
    end process;
    
    rd1 <= rf(CONV_INTEGER(ra1));
    rd2 <= rf(CONV_INTEGER(ra2));

end rtl;

