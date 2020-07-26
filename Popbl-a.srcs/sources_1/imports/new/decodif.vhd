----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.01.2019 14:47:16
-- Design Name: 
-- Module Name: decodif - Behavioral
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

entity decodif is
    Port ( B : out integer;
       seg : in STD_LOGIC_VECTOR (7 downto 0));
end decodif;
--Decodifica, los 8 bits los trasforma en un numero
architecture Behavioral of decodif is
begin
with seg select
    B<=  1 when "00110001",
         2 when "00110010",
         3 when "00110011",
         4 when "00110100",
         5 when "00110101",
         6 when "00110110",
         7 when "00110111",
         8 when "00111000",
         9 when "00111001",
         0 when others;
end Behavioral;

