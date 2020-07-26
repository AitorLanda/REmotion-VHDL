
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity main is
    Port ( clk : in std_logic;
           serial_in : in std_logic;        
           botoia: in std_logic;
           rst : in STD_LOGIC;
           swPause : in STD_LOGIC;
           
           pauseLed: out STD_LOGIC;
           finishLed: out STD_LOGIC;
           an: out STD_LOGIC_VECTOR (3 downto 0);
           seg: out STD_LOGIC_VECTOR (6 downto 0);
           serial_out : out std_logic);--displayean adieraziko dena
end main;

architecture Behavioral of main is
    component main_uart is
    --uarteko kontrola egingo den konponentea.
        Port ( serial_in : in std_logic;            
               clk : in std_logic;
               data_out : out STD_LOGIC_VECTOR(7 downto 0);
               data_in : in STD_LOGIC_VECTOR(7 downto 0);
               data_strobe : out STD_LOGIC;
               en_16_x_baud: in  std_logic;
               serial_out: out std_logic;
               tx_complete: out std_logic;
               send_character : in std_logic);
        end component;
        
        component seven_segment_display_VHDL is
            Port ( clock_100Mhz : in STD_LOGIC;-- 100Mhz clock on Basys 3 FPGA board
                   --reset : in STD_LOGIC; -- reset
                   hasi : in STD_LOGIC;
                   swPause: in STD_LOGIC;
                   balioa : in integer; --timerraren balioa
                   
                   pausa : out STD_LOGIC; --led pausa
                   bukatuta : out STD_LOGIC;
                   Anode_Activate : out STD_LOGIC_VECTOR (3 downto 0);-- 4 Anode signals
                   LED_out : out STD_LOGIC_VECTOR (6 downto 0));-- Cathode patterns of 7-segment display     
        end component;
        
        component decodif is
            Port ( B : out integer;
               seg : in STD_LOGIC_VECTOR (7 downto 0));
        end component;
        
           
        signal jokatzen: std_logic:='0'; 
        signal bukatuta: std_logic;  
        signal rx,tx,rx_jaso: std_logic_vector (7 downto 0);
        signal tx_complete: std_logic ; 
        signal data_strobe: std_logic:='0'; 
        signal bidali_infor: std_logic; 
        signal clk_rx :  STD_LOGIC;
        signal cont: integer:=0;
        signal baud_count: integer range 0 to 65:=0;
        signal en_16_x_baud:  std_logic;signal tinbre_ok,tinbre_aux : std_logic;
        signal BalioaJas,Balioa1,Balioa2,Balioa3,Balioa4: integer;
        signal Balioacons: integer:=1;
        
        type estados is (estado_itxoiten, estado_bidaltzen, estado_jasotzen, estado_kentzen, estado_jasotzen2, estado_jasotzen3, estado_jasotzen4, estado_jasotzen5);
        signal estado_actual : estados:= estado_itxoiten;
        
        signal estado_siguiente : estados;
        
        begin--portmapa
        
        denboragailua: seven_segment_display_VHDL port map (clock_100Mhz=>clk, balioa=>Balioa4, hasi=>jokatzen, swPause=>swPause, pausa=>pauseLed, bukatuta=>bukatuta ,Anode_Activate=>an, LED_out=>seg);
        decodi_FIC: decodif port map (B=>BalioaJas, seg=>rx);
        
        tb_UART: main_uart port map (serial_in=>serial_in,clk=>clk_rx,data_out=>rx,en_16_x_baud=>en_16_x_baud,
        data_in=>tx,data_strobe=>data_strobe,serial_out=>serial_out,send_character=>bidali_infor,tx_complete=>tx_complete);
    
    --prozesu honekin erlojuaren frekuentzia erdira jeisten da
        erloju:process (clk)
            begin
                if clk 'event and clk='1' then
                        if cont=4 then 
                            clk_rx <=not clk_rx;
                            cont <= 0;
                        else 
                            cont <= cont+1;
                    end if;
                end if;
        end process;
    
    -- noiz egin raising triggerra
        baud_timer: process(clk_rx)
            begin 
                if clk_rx'event and clk_rx='1' then
                    if baud_count >= 65 then
                        baud_count <= 0;
                        en_16_x_baud <= '1';
                        
                    else
                        baud_count <= baud_count + 1;
                        en_16_x_baud <= '0';
                    end if;
                end if;
        end process baud_timer; 
    
    --clock ebentu bat dagoenean eta estatu aldaketa bat hau adierazteko
        seq: process (clk_rx,rst)
            begin 
                if rst='1' then
                
                    estado_actual<=estado_itxoiten;
                    elsif clk_rx'event and clk_rx='1' then
                    estado_actual<=estado_siguiente;
                end if;
        end process seq;
    
    -- seinale bakarra bidali dadin
    --tinbre aux batera jartzea helburua. horretarako baldintza botoia sakatzea eta tinbrea 
    --libre izatea
        one_signal: process(clk_rx,rst)
            begin 
                if rst='1' then
                        tinbre_ok <= '0';
                        tinbre_aux <= '0';
                        
                elsif clk_rx'event and clk_rx='1' then
                        if(botoia='1')and tinbre_ok='0' then
                            tinbre_aux<='1';
                            tinbre_ok<='1';
                        elsif tinbre_aux='1'  then
                            tinbre_aux<='0';
                        elsif  botoia = '0' then
                            tinbre_ok <= '0';
                    end if;
                end if;
        end process one_signal;
    --Proceso principal, aqui estan todas los estados
        comb: process (estado_actual,data_strobe,tx_complete,rx,tinbre_aux,rx_jaso)
            begin
            
                case estado_actual is
                   
                 when estado_itxoiten => 
                         bidali_infor<='0';--hau zerora jartzen da bidaltzeari lagatzeko
                         jokatzen<='0';
                        if data_strobe ='1' then--Recibe una señal
                            estado_siguiente<=estado_jasotzen;
                        else
                            estado_siguiente<=estado_actual;
                        end if;
                                                   
                when estado_jasotzen =>
                      jokatzen<='0';
                      rx_jaso<=rx;
                      if(data_strobe ='1') then        
                           estado_siguiente<=estado_jasotzen2;
                       else
                           estado_siguiente<=estado_jasotzen;
                      end if;

                 when estado_jasotzen2 =>
                        jokatzen<='0';
                        rx_jaso<=rx;
                        if(data_strobe ='1') then        
                             estado_siguiente<=estado_jasotzen3;
                         else
                             estado_siguiente<=estado_jasotzen2;
                        end if;                                        
                                                                         
                when estado_jasotzen3 =>
                      jokatzen<='0';
                       rx_jaso<=rx;
                      if data_strobe ='1' then        
                            estado_siguiente<=estado_jasotzen4;
                        else
                            estado_siguiente<=estado_jasotzen3;
                       end if;  

                when estado_jasotzen4 =>
                        jokatzen<='0';
                        rx_jaso<=rx;
                      if data_strobe ='1' then
                          estado_siguiente<=estado_jasotzen5;
                       else
                          estado_siguiente<=estado_jasotzen4;
                       end if;                                                          
                      
                when estado_jasotzen5 =>
                        jokatzen<='0';
                        rx_jaso<=rx;--Recibe
                        if (rx_jaso(7)='1' and rx_jaso(6)='1' and rx_jaso(3)='1' and rx_jaso(0)='1' ) then
                            estado_siguiente<=estado_kentzen;
                        else   
                            estado_siguiente<=estado_jasotzen5;
                        end if;
                              
                when estado_kentzen =>
                        jokatzen<='1';--Mientras que jokatzen sea igual a uno, el componente rehabilitacion restará
                        if (bukatuta='1') then
                            estado_siguiente<=estado_bidaltzen;    
                        else
                            estado_siguiente<=estado_actual;
                        end if;                
                                   
                when estado_bidaltzen => 
                        jokatzen<='0';
                        tx<="00110011";--Seinale bat bueltatzen du, kasu honetan 3 bat.
                        bidali_infor<='1';-- bidaltzeko baimena
                        if tx_complete ='1' then
                            estado_siguiente<=estado_itxoiten;
                        else
                            estado_siguiente<=estado_bidaltzen;
                        end if;   
                
                end case;
        end process comb;   
    --Avisa Cuando se acaba el tiempo, encendiendo una Led
        bukatuLed:process (bukatuta)
            begin            
                if clk 'event and clk='1' then
                    if bukatuta='1' then 
                        finishLed<='1';
                    else 
                        finishLed<='0';
                    end if;
                end if;       
        end process bukatuLed;
         --Combierte las cifraz sueltas en una unica(en segundos)   
        segundu_kontadorea: process(estado_actual, clk)
            begin
                if clk 'event and clk='1' then
                    if estado_actual=estado_jasotzen then
                        if(Balioacons=1) then
                              Balioa1<=BalioaJas;                            
                              Balioacons<=2;
                        else
                            Balioa1<=Balioa1;
                        end if;
                  end if;  
                    if(estado_actual=estado_jasotzen2) then
                        if(Balioacons=2) then
                            Balioa2<=Balioa1*10+BalioaJas;
                            Balioacons<=3;
                         else
                            Balioa2<=Balioa2;
                         end if;
                  end if;  
                    if(estado_actual=estado_jasotzen3) then
                        if(Balioacons=3) then
                            Balioa3<=Balioa2*10+BalioaJas;
                            Balioacons<=4;
                        else
                            Balioa3<=Balioa3;
                     end if;
                    end if;
                    if(estado_actual=estado_jasotzen4) then
                        if(Balioacons=4) then
                            Balioa4<=Balioa3*10+BalioaJas;
                            Balioacons<=5;
                        else
                            Balioa4<=Balioa4;
                 end if;
                    end if;                                                                                                                                                    
                    if(estado_actual=estado_bidaltzen) then
                                Balioacons<=1;
                            end if;
              end if;
        end process segundu_kontadorea;

end Behavioral;

