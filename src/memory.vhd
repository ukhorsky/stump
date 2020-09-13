----------------------------------------------------------------------------------
-- Harvard architecture memory setup
-- RAM is planned to be placed on external chip
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity memory is
    port(
        clk : in std_logic;
        pcw: in std_logic;
        pc_in : in std_logic_vector(7 downto 0);
        pc_out : out std_logic_vector(7 downto 0);
        rwe : in std_logic;
        rwd : in std_logic_vector(15 downto 0);
        rd1 : out std_logic_vector(15 downto 0);
        rd2 : out std_logic_vector(15 downto 0);
        irw : in std_logic;
        opp : out std_logic_vector(4 downto 0);
        func : out std_logic_vector(2 downto 0);
        imm : out std_logic_vector(7 downto 0);
        rst : in std_logic
    );
end memory;

architecture rtl of memory is

    -- block memory 16x256 rom ip core
    component imem
    port (
        clka : in std_logic;
        addra : in std_logic_vector(7 downto 0);
        ena : in std_logic;
        douta : out std_logic_vector(15 downto 0)
    );    
    end component;

    type registers is array (0 to 15) of std_logic_vector(15 downto 0); 

    signal rf : registers;
    signal pc : std_logic_vector(7 downto 0);
    signal instr_bus : std_logic_vector(15 downto 0);
    signal ra2 : std_logic_vector(3 downto 0);
    signal rwa : std_logic_vector(3 downto 0);

begin

    -- program counter 
    pc_entity: process(rst, clk)
    begin
        if (rst = '1') then
            pc <= x"08"; -- 8 addresses are reserved for interrupts vectors
        elsif (rising_edge(clk)) then
            if (pcw = '1') then
                pc <= pc_in;
            end if;
        end if;
    end process;
    
    pc_out <= pc;
    
    -- register file   
    reg_file_entity: process (clk)
    begin
        if (rising_edge(clk)) then
            if (rwe = '1') then
                rf(CONV_INTEGER(rwa)) <= rwd;
            end if;
        end if;
    end process;
    
    ra2 <= (instr_bus(15) and instr_bus(14) and instr_bus(3)) & instr_bus(2 downto 0);    
    rwa <= ra2;
    
    rf_out_reg: process(clk)
    begin
        if (rising_edge(clk)) then
            rd1 <= rf(CONV_INTEGER(instr_bus(7 downto 4)));
            rd2 <= rf(CONV_INTEGER(ra2));
        end if;    
    end process;
    
    
    -- instructions rom  
    instructions_rom: imem 
    port map(
        clka => clk,
        addra => pc,
        ena => irw,
        douta => instr_bus
    );
    
    opp <= instr_bus(15 downto 11);
    func <= instr_bus(10 downto 8);
    imm <= instr_bus(10 downto 3);

end rtl;

