----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ctrl_fsm is
    port(
        clk : in std_logic;
        rst : in std_logic
    );
end ctrl_fsm;

architecture rtl of ctrl_fsm is

    type fsm_state is (S0, S1, S2);
    
    signal c_state : fsm_state;
    signal n_state : fsm_state;

begin

    fsm_reg: process (rst, clk)
    begin
        if (rst = '1') then
            c_state <= S0;
        elsif (rising_edge(clk)) then
            c_state <= n_state;
        end if;
    end process;

    next_state_logic: process (c_state)
    begin
        case c_state is
            when S0 =>
            when others =>
                null;
        end case;
    end process;
    
    output_logic: process(rst, clk)
    begin
        if (rst = '1') then
        elsif (rising_edge(clk)) then
            case c_state is
                when S0 =>
                when others =>
                    null;
            end case;
        end if;
    end process;

end rtl;

