library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

-- Top-level entity for testing the NCO with ILA
entity NCO_Testbench is
  port (
    clk        : in std_logic;
    reset      : in std_logic;
    wave_o_ila : out std_logic_vector(15 downto 0) -- Output wave for ILA observation
  );
end NCO_Testbench;

architecture Behavioral of NCO_Testbench is

  -- Signals for inputs and outputs
  signal en_i_vio        : std_logic; -- Enable signal
  signal freq_word_i_vio : std_logic_vector(31 downto 0); -- Frequency tuning word
  signal wave_type_i_vio : std_logic_vector(1 downto 0); -- Wave type selector

  -- NCO Output signal
  signal wave_o : std_logic_vector(15 downto 0); -- Output wave from NCO

begin
  -- Instance of the NCO
  u_NCO : entity work.NCO
    port map
    (
      c_i         => clk,
      en_i        => en_i_vio,
      freq_word_i => freq_word_i_vio,
      wave_type_i => wave_type_i_vio,
      wave_o      => wave_o
    );

  -- Assign output to ILA for observation
  wave_o_ila <= wave_o;

  -- ILA component instantiation
  ila_inst : ila
  generic map(
    C_PROBE0_WIDTH => 16 -- Width of the output wave (wave_o)
  )
  port map
  (
    clk    => clk,
    probe0 => wave_o -- Monitor the output waveform
  );

end Behavioral;
