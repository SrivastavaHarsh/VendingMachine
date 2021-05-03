library ieee;
use IEEE.std_logic_1164.all;

entity FSM is
port (CLK : in std_logic; --Clock, active high
	RSTn : in std_logic; --Async. Reset, active low
	item : in std_logic_vector (3 downto 0); --Which item is selected
	CoinIn : in std_logic_vector (1 downto 0); --Which coin was inserted
	CoinOut : out std_logic_vector (1 downto 0); --Number of "5-valued" coin returned
	dflag : out std_logic --Is the item dispensed
 );
end entity;

architecture behavior of FSM is
type state_type is (start_s,
	select_item,
	insert_coins,
	in_5,in_10,in_20,in_15,in_25,in_30, --states corresponding to total value of coins inserted
	ret_0,ret_5,ret_10,ret_15, --states corresponding to total value of coins returned 
	dispense --state corresponding to dispensing of product
); 
signal current_s,next_s: state_type; --current and next state declaration.
signal cost : std_logic_vector(1 downto 0); --cost = first two MSBs of 'item'

begin
cost(1 downto 0) <= item(3 downto 2);

process(CLK,RSTn) 
begin
	if(RSTn = '0') then
		current_s <= start_s; --defualt state is on RESET
	elsif(clk'event and clk = '1') then
		current_s <= next_s;
	end if;
end process;

--FSM process:
process(current_s,item,CoinIn)
begin
case current_s is
when start_s => 
	CoinOut <= "00";
	dflag <= '0';
	next_s <= select_item;
---------------------------------------------
when select_item =>
	if (item = "0000" or item = "0001" or item = "0010" or item = "0011" or item = "1111")then
		next_s <= select_item;
	else
		next_s <= insert_coins;
	end if;
---------------------------------------------
when insert_coins => 
	if(CoinIn = "00")then
		dflag <= '0';
		CoinOut <= "00";
		next_s <= insert_coins;		
	elsif(CoinIn = "01")then 
		dflag <= '0';
		CoinOut <= "00";
		if(cost = "01")then
			next_s <= ret_0;			
		else 
			next_s <= in_5;
		end if;		
	elsif(CoinIn = "10")then 
		dflag <= '0';
		CoinOut <= "00";
		if(cost = "01")then
			next_s <= ret_5;			
		else 
			next_s <= in_10;
		end if;		
	elsif(CoinIn = "11")then 
		dflag <= '0';
		CoinOut <= "00";
		if(cost = "01")then
			next_s <= ret_15;			
		elsif(cost = "10")then
			next_s <= ret_0;
		else
			next_s <= in_20;
		end if;
		next_s <= in_20;
	end if;
----------------------------------------------	
when in_5 => 
	if(CoinIn = "00")then
		dflag <= '0';
		CoinOut <= "00";
		next_s <= in_5;
	elsif(CoinIn = "01")then 
		dflag <= '0';
		CoinOut <= "00";
		next_s <= in_10;			
	elsif(CoinIn = "10")then 
		dflag <= '0';
		CoinOut <= "00";
		next_s <= in_15;
	elsif(CoinIn = "11")then 
		dflag <= '0';
		CoinOut <= "00";
		if(cost = "10")then
			next_s <= ret_5;			
		else 
			next_s <= in_25;
		end if;
	end if;
-----------------------------------------------
when in_10 => 
	if(CoinIn = "00")then
		dflag <= '0';
		CoinOut <= "00";
		next_s <= in_10;
	elsif(CoinIn = "01")then 
		dflag <= '0';
		CoinOut <= "00";
		next_s <= in_15;			
	elsif(CoinIn = "10")then 
		dflag <= '0';
		CoinOut <= "00";
		if(cost = "10")then
			next_s <= ret_0;			
		else 
			next_s <= in_20;
		end if;
	elsif(CoinIn = "11")then 
		dflag <= '0';
		CoinOut <= "00";
		if(cost = "10")then
			next_s <= ret_10;			
		else 
			next_s <= in_30;
		end if;
	end if;
------------------------------------------------
when in_15 => 
	if(CoinIn = "00")then
		dflag <= '0';
		CoinOut <= "00";
		next_s <= in_15;
	elsif(CoinIn = "01")then 
		dflag <= '0';
		CoinOut <= "00";
		if(cost = "10")then
			next_s <= ret_0;			
		else 
			next_s <= in_20;
		end if;
	elsif(CoinIn = "10")then 
		dflag <= '0';
		CoinOut <= "00";
		if(cost = "10")then
			next_s <= ret_5;			
		else 
			next_s <= in_25;
		end if;
	elsif(CoinIn = "11")then 
		dflag <= '0';
		CoinOut <= "00";
		if(cost = "10")then
			next_s <= ret_15;
		else
			next_s <= ret_0;
		end if;
	end if;
-------------------------------------------------
when in_20 => 
	if(CoinIn = "00")then
		dflag <= '0';
		CoinOut <= "00";
		next_s <= in_20;
	elsif(CoinIn = "01")then 
		dflag <= '0';
		CoinOut <= "00";
		next_s <= in_25;
	elsif(CoinIn = "10")then 
		dflag <= '0';
		CoinOut <= "00";
		next_s <= in_30;
	elsif(CoinIn = "11")then 
		dflag <= '0';
		CoinOut <= "00";
		next_s <= ret_5;
	end if;
--------------------------------------------------
when in_25 => 
	if(CoinIn = "00")then
		dflag <= '0';
		CoinOut <= "00";
		next_s <= in_25;
	elsif(CoinIn = "01")then 
		dflag <= '0';
		CoinOut <= "00";
		next_s <= in_30;
	elsif(CoinIn = "10")then 
		dflag <= '0';
		CoinOut <= "00";
		next_s <= ret_0;
	elsif(CoinIn = "11")then 
		dflag <= '0';
		CoinOut <= "00";
		next_s <= ret_10;
	end if;
---------------------------------------------------	
when in_30 => 
	if(CoinIn = "00")then
		dflag <= '0';
		CoinOut <= "00";
		next_s <= in_30;
	elsif(CoinIn = "01")then 
		dflag <= '0';
		CoinOut <= "00";
		next_s <= ret_0;
	elsif(CoinIn = "10")then 
		dflag <= '0';
		CoinOut <= "00";
		next_s <= ret_5;
	elsif(CoinIn = "11")then 
		dflag <= '0';
		CoinOut <= "00";
		next_s <= ret_15;
	end if;
---------------------------------------------------
when ret_0 => 
	dflag <= '0';
	CoinOut <= "00";
	next_s <= dispense;
-------------------------------
when ret_5 => 
	dflag <= '0';
	CoinOut <= "01";
	next_s <= dispense;
-------------------------------	
when ret_10 => 
	dflag <= '0';
	CoinOut <= "10";
	next_s <= dispense;
-------------------------------
when ret_15 => 
	dflag <= '0';
	CoinOut <= "11";
	next_s <= dispense;
-------------------------------	
when dispense => 
	dflag <= '1';
	CoinOut <= "00";
	next_s <= select_item;
-------------------------------	

end case;
end process;

end behavior;