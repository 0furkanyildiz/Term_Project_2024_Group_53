library verilog;
use verilog.vl_types.all;
entity SSCDM_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        number          : in     vl_logic_vector(4 downto 0);
        sampler_tx      : out    vl_logic
    );
end SSCDM_vlg_sample_tst;
