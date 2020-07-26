----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2018 19:57:52
-- Design Name: 
-- Module Name: segundutikDisplayera - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity segundutikDisplayera is
    Port ( seg : in integer;
           display : out STD_LOGIC_VECTOR (15 downto 0));
end segundutikDisplayera;

-- segunduak hartzen ditu eta displayean erakusteko balioak itzultzen ditu.
-- Adibidez: 70 segundu pasata 0110 itzuliko du. 70 segundu -> minutu 1 eta 10 segundu.

architecture Behavioral of segundutikDisplayera is
    signal minkop : integer;
    signal minutuak, segunduak: integer;
    signal m1, m2, s1, s2: integer;
begin

    sek1: process
    begin
    minutuak <= seg/60;
    minkop <= seg/60;
    end process sek1;
    
    sek2: process
        begin
        segunduak <= seg - (minkop*60);
        end process sek2;

   process(minutuak,segunduak)
   begin 
        m1 <= minutuak/10;
        m2 <= minutuak mod 10;
        s1 <= segunduak/10;
        s2 <= segunduak mod 10;
    end process;
    
    
    with m1 select
    display(15 downto 12) <= "0001" when 1,
                             "0010" when 2,
                             "0011" when 3,
                             "0100" when 4,
                             "0101" when 5,
                             "0110" when 6,
                             "0111" when 7,
                             "1000" when 8,
                             "1001" when 9,
                             "0000" when others;
                         
    with m2 select
    display(11 downto 8) <= "0001" when 1,
                            "0010" when 2,
                            "0011" when 3,
                            "0100" when 4,
                            "0101" when 5,
                            "0110" when 6,
                            "0111" when 7,
                            "1000" when 8,
                            "1001" when 9,
                            "0000" when others;
    
    
     with s1 select
     display(7 downto 4) <= "0001" when 1,
                            "0010" when 2,
                            "0011" when 3,
                            "0100" when 4,
                            "0101" when 5,
                            "0110" when 6,
                            "0111" when 7,
                            "1000" when 8,
                            "1001" when 9,
                            "0000" when others;
                                                 
     with s2 select
     display(3 downto 0) <= "0001" when 1,
                            "0010" when 2,
                            "0011" when 3,
                            "0100" when 4,
                            "0101" when 5,
                            "0110" when 6,
                            "0111" when 7,
                            "1000" when 8,
                            "1001" when 9,
                            "0000" when others;    
end Behavioral;
