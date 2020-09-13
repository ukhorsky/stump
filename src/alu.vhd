----------------------------------------------------------------------------------
-- ALU
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity alu is
    port(
        src_a : in std_logic_vector(15 downto 0);
        src_b : in std_logic_vector(15 downto 0);
        f : in std_logic_vector(2 downto 0);
        result : out std_logic_vector(15 downto 0);
        carry_out : out std_logic;
        zero : out std_logic
    );
end alu;

architecture rtl of alu is
    
    signal a : std_logic_vector(16 downto 0);
    signal b : std_logic_vector(16 downto 0);
    signal r : std_logic_vector(16 downto 0);

begin
    
    a <= '0' & src_a;
    b <= '0' & not src_b when(f(2) = '1') else '0' & src_b;

    process(a, b, f)
    begin
        case f(1 downto 0) is
            when "00" =>
                r <=  a and b;
            when "01" =>
                r <= a or b;
            when "10" =>
                  r <= a + b + f(2);
            when others =>
                r <= b;
        end case;
    end process;

    result <= r(15 downto 0);
    carry_out <= r(16);
    zero <= '1' when(r(15 downto 0) = x"0000") else '0';

end rtl;

