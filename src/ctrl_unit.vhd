----------------------------------------------------------------------------------
-- Control FSM and non-architectural registers
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ctrl_unit is
    port(
        clk : in std_logic;
        opp : in std_logic_vector(4 downto 0);
        func : in std_logic_vector(2 downto 0);
        irw : out std_logic;
        pcw : out std_logic;        
        rwe : out std_logic;
        alu_f : out std_logic_vector(2 downto 0);
        alu_a_sel : out std_logic_vector(1 downto 0);
        alu_b_sel : out std_logic;
        pc_src : out std_logic;
        rst : in std_logic
    );
end ctrl_unit;

architecture rtl of ctrl_unit is
    
    component ctrl_fsm 
    port (
        clk : in std_logic;
        rst : in std_logic
    );
    end component;
    
    signal status_reg : std_logic_vector(15 downto 0);

begin

    fsm_entity: ctrl_fsm
    port map(
        clk => clk,
        rst => rst
    );

end rtl;

