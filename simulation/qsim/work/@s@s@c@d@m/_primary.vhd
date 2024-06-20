library verilog;
use verilog.vl_types.all;
entity SSCDM is
    port(
        clk             : in     vl_logic;
        number          : in     vl_logic_vector(4 downto 0);
        display1        : out    vl_logic_vector(6 downto 0);
        display0        : out    vl_logic_vector(6 downto 0)
    );
end SSCDM;
