library verilog;
use verilog.vl_types.all;
entity SSCDM_vlg_check_tst is
    port(
        display0        : in     vl_logic_vector(6 downto 0);
        display1        : in     vl_logic_vector(6 downto 0);
        sampler_rx      : in     vl_logic
    );
end SSCDM_vlg_check_tst;
