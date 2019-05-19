.prot
.lib 'crn90g_2d5_lk_v1d2p1.l' tt
.unprot
.param	Lmin=100n
.temp	25
*********************Source Voltages**************
Vds		Vdd	0  	dc	1
Vclk 	clk	0 	dc PULSE(0V 1V 55ns 0 0 55ns 110ns)
Vin 	in 	0 	dc PULSE(0V 1V 80ns 0 0 80ns 200ns)
Vin1 	in1	0 	dc PULSE(0V 1V 4us 0.5us 0.5us 4us 50us)
Vin2 	in2	0 	dc PULSE(0V 1V 4us 0.5us 0.5us 4us 15us)

********************* Vectors **********************
.vec "cp.txt"
**************************** sub circuits **********************
**** Inverter *****
.subckt Inverter in Vdd Gnd out 
* Subcircuit Body
*********** drain 	gate 	source 		body 		mname 

	M1   	out   	in     	Vdd     	Vdd     	pch 	w='10*lmin'  l='lmin'
	M2   	out   	in 		Gnd     	Gnd     	nch 	w='5*lmin'  l='lmin'
.ends Inverter

*************************************** NAND **************************************
.subckt NAND in1 in2 Vdd Gnd out 
* Subcircuit Body
*********** drain 	gate 	source 		body 		mname 

	M1   	out   	in1    	Vdd     	Vdd     	pch 	w='10*lmin'  l='lmin'
	M2   	out   	in2    	Vdd     	Vdd     	pch 	w='10*lmin'  l='lmin'

	M3   	out   	in1		x     		x 	     	nch 	w='10*lmin'  l='lmin'
	M4   	x   	in2		Gnd    		Gnd	     	nch 	w='10*lmin'  l='lmin'

.ends NAND

************************************** XOR **************************************
.subckt XOR in1 in2 Vdd Gnd out 
* Subcircuit Body
	
	Xinv1 in1 Vdd Gnd not_in1 Inverter
	Xinv2 in2 Vdd Gnd not_in2 Inverter

*********** drain 	gate 	source 		body 		mname 

	M1   	x1   	not_in1	Vdd     	Vdd     	pch 	w='20*lmin'  l='lmin'
	M2   	out   	in2    	x1     		x1 	     	pch 	w='20*lmin'  l='lmin'

	M3   	x2    	not_in2	Vdd     	Vdd     	pch 	w='20*lmin'  l='lmin'
	M4   	out   	in1    	x2     		x2 	     	pch 	w='20*lmin'  l='lmin'

	M5   	out   	in1		x3     		x3 	     	nch 	w='10*lmin'  l='lmin'
	M6   	x3   	in2		Gnd    		Gnd	     	nch 	w='10*lmin'  l='lmin'

	M7   	out   	not_in1	x4     		x4 	     	nch 	w='10*lmin'  l='lmin'
	M8   	x4   	not_in2	Gnd    		Gnd	     	nch 	w='10*lmin'  l='lmin'

.ends XOR


************************************** DFF **************************************
.subckt DFF clk D_in Vdd Gnd Qs
* Subcircuit Body
	
	Xinv1 clk Vdd Gnd not_clk Inverter
*********** drain 	gate 	source 		body 		mname 
	M1   	x1 		not_clk	Qm     		Qm     		pch 	w='5*lmin'  l='lmin'
	M2   	x1   	clk    	Qm     		Qm 	     	nch 	w='5*lmin'  l='lmin'

	M3   	x1   	clk		D_in     	D_in   		pch 	w='5*lmin'  l='lmin'
	M4   	x1   	not_clk D_in     	D_in     	nch 	w='5*lmin'  l='lmin'

	Xinv2 	x1 		Vdd Gnd not_Qm 	Inverter
	Xinv3 	not_Qm 	Vdd Gnd Qm 		Inverter

	M5   	x2   	clk		Qm     		Qm 	     	nch 	w='5*lmin'  l='lmin'
	M6   	x2   	not_clk	Qm    		Qm	     	pch 	w='5*lmin'  l='lmin'

	M7   	x2   	not_clk	Qs     		Qs 	     	nch 	w='5*lmin'  l='lmin'
	M8   	x2   	clk 	Qs    		Qs	     	pch 	w='5*lmin'  l='lmin'

	Xinv4 	x2 		Vdd Gnd not_Qs 	Inverter
	Xinv5 	not_Qs 	Vdd Gnd Qs 		Inverter

.ends DFF

************************************** FA **************************************
.subckt FA A B C Vdd Gnd sum cout
* Subcircuit Body
	
	XXOR1 A 	B Vdd 0 out1 	XOR
	XXOR2 out1 	C Vdd 0 sum 	XOR

	XNAND1 A 	B vdd 0 out2 NAND
	XNAND2 out1 C Vdd 0 out3 NAND

	XNAND3 out2 out3 Vdd 0 cout NAND

.ends FA

************************************** HA **************************************
.subckt HA A B Vdd Gnd sum cout
* Subcircuit Body
	
	XXOR1 A B Vdd 0 sum XOR

	XNAND1 A B Vdd 0 out1 NAND

	Xinv1 out1 Vdd 0 cout Inverter

.ends HA

************************************** 8 bit Adder **************************************
XDFF0 clk X0 Vdd 0 X0_out DFF 
XDFF1 clk X1 Vdd 0 X1_out DFF
XDFF2 clk X2 Vdd 0 X2_out DFF
XDFF3 clk X3 Vdd 0 X3_out DFF
XDFF4 clk X4 Vdd 0 X4_out DFF
XDFF5 clk X5 Vdd 0 X5_out DFF
XDFF6 clk X6 Vdd 0 X6_out DFF
XDFF7 clk X7 Vdd 0 X7_out DFF

XDFF8  clk Y0 Vdd 0 Y0_out DFF
XDFF9  clk Y1 Vdd 0 Y1_out DFF
XDFF10 clk Y2 Vdd 0 Y2_out DFF
XDFF11 clk Y3 Vdd 0 Y3_out DFF
XDFF12 clk Y4 Vdd 0 Y4_out DFF
XDFF13 clk Y5 Vdd 0 Y5_out DFF
XDFF14 clk Y6 Vdd 0 Y6_out DFF
XDFF15 clk Y7 Vdd 0 Y7_out DFF

XHA X0_out Y0_out Vdd 0 out0 C1 HA
XDFF16 clk out0 Vdd 0 S0 DFF

XFA1 X1_out Y1_out C1 Vdd 0 out1 C2 FA
XDFF17 clk out1 Vdd 0 S1 DFF

XFA2 X2_out Y2_out C2 Vdd 0 out2 C3 FA
XDFF18 clk out2 Vdd 0 S2 DFF

XFA3 X3_out Y3_out C3 Vdd 0 out3 C4 FA
XDFF19 clk out3 Vdd 0 S3 DFF

XFA4 X4_out Y4_out C4 Vdd 0 out4 C5 FA
XDFF20 clk out4 Vdd 0 S4 DFF

XFA5 X5_out Y5_out C5 Vdd 0 out5 C6 FA
XDFF21 clk out5 Vdd 0 S5 DFF

XFA6 X6_out Y6_out C6 Vdd 0 out6 C7 FA
XDFF22 clk out6 Vdd 0 S6 DFF

XFA7 X7_out Y7_out C7 Vdd 0 out7 C8 FA
XDFF23 clk out7 Vdd 0 S7 DFF

XDFF24 clk c8 Vdd 0 cout DFF



**********************************************************************
.OP

******* setup time measure *************
.MEASURE Tran SetupTime	
+ Trig v(X0)  Val = 'v(Vdd)/2.0' Rise = 1
+ Targ v(clk) Val = 'v(Vdd)/2.0' Fall = 1

******************* Adder Delay ***************
.MEASURE TRAN delay_cout 
+	TRIG V(Y0_out) 	VAL='v(Vdd)/2.0' 	Rise=1
+   TARG V(C8) 	VAL='v(Vdd)/2.0'    CROSS=1

.MEASURE TRAN delay_sum 
+	TRIG V(X0_out) 	VAL='v(Vdd)/2.0' 	Rise=1
+   TARG V(S7) 	VAL='v(Vdd)/2.0'    Rise=1


.probe
* .dc  Vout	0	out	0.01
.option post
.TRAN 1ns 1000ns


.END