--------------------------------------
-- Numeric Controlled Oscillator (NCO)
-- Autor: Abraham R.
--------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity NCO is
  port (
    c_i         : in std_logic; -- Clock signal
    en_i        : in std_logic; -- Enable signal
    freq_word_i : in std_logic_vector(31 downto 0); -- Frequency tuning word
    wave_type_i : in std_logic_vector(1 downto 0); -- Wave type selector
    wave_o      : out std_logic_vector(15 downto 0) -- Output sine wave
  );
end NCO;

architecture NCO_arq of NCO is
  signal phase_acc     : unsigned(31 downto 0) := (others => '0'); -- Phase accumulator
  signal addr          : std_logic_vector(9 downto 0); -- Sine LUT address
  signal sine_wave     : std_logic_vector(15 downto 0); -- Sine wave output from LUT
  signal square_wave   : std_logic_vector(15 downto 0); -- Square wave
  signal triangle_wave : std_logic_vector(15 downto 0); -- Triangle wave
  signal sawtooth_wave : std_logic_vector(15 downto 0); -- Sawtooth wave
begin

  u_SineLUT : entity work.sineLUT
    port map
    (
      c_i    => c_i,
      en_i   => en_i,
      addr_i => addr,
      wave_o => sine_wave
    );

  process (c_i)
  begin
    if rising_edge(c_i) then
      if en_i = '1' then
        -- Phase accumulator update
        phase_acc <= phase_acc + unsigned(freq_word_i);

        -- Extract upper bits of the phase accumulator for the SineLUT
        addr <= std_logic_vector(phase_acc(31 downto 22));

        -- Generate square wave (based on MSB of phase accumulator)
        if phase_acc(31) = '1' then
          square_wave <= std_logic_vector(to_signed(32767, 16)); -- High output
        else
          square_wave <= std_logic_vector(to_signed(-32767, 16)); -- Low output
        end if;

        -- Generate triangle wave (linear ramp)
        -- Generate triangle wave (linear ramp)
        if phase_acc(31) = '1' then
          -- Descending part of the triangle wave (negative half)
          triangle_wave <= std_logic_vector(to_signed(32767 - to_integer(unsigned(phase_acc(30 downto 16))), 16));
        else
          -- Ascending part of the triangle wave (positive half)
          triangle_wave <= std_logic_vector(to_signed(to_integer(unsigned(phase_acc(30 downto 16))), 16));
        end if;

        -- Generate sawtooth wave (directly from phase accumulator)
        sawtooth_wave <= std_logic_vector(phase_acc(31 downto 16));

        -- Select the output waveform based on wave_type_i
        case wave_type_i is
          when "00" =>
            wave_o <= sine_wave; -- Output sine wave
          when "01" =>
            wave_o <= square_wave; -- Output square wave
          when "10" =>
            wave_o <= triangle_wave; -- Output triangle wave
          when "11" =>
            wave_o <= sawtooth_wave; -- Output sawtooth wave
          when others =>
            wave_o <= sine_wave; -- Default to sine wave
        end case;
      end if;
    end if;
  end process;

end NCO_arq;