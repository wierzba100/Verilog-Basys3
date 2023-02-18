1.
switche[5:4]
sw[5:4] == 2'b00 -> monInstr
sw[5:4] == 2'b01 -> monPC
sw[5:4] == 2'b01 or sw[5:4] == 2'b11 -> monRFData

monRFData ->  switche[3:0]

2.
T18(BTNU) -> PCenable
W19(BTNL) -> extCtl
U18(BTNC) -> reset

3.
switch[6] == 1'b0 -> krokowe za pomoca przycisku PCenable(BTNU)
switch[6] == 1'b1 -> ciagłe wykonywanie programu