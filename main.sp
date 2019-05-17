.prot
.lib 'crn90g_2d5_lk_v1d2p1.l' tt
.unprot
.param	Lmin=100n
.temp	25
*********************Source Voltages**************
Vds		Vdd	0  	dc	1
Vin 	in 	0 	dc PULSE(0V 1V 5us 0.5us 0.5us 5us 20us)
Vin1 	in1	0 	dc PULSE(0V 1V 4us 0.5us 0.5us 4us 30us)
Vin2 	in2	0 	dc PULSE(0V 1V 4us 0.5us 0.5us 4us 15us)

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

******************* Gate Level Implementation ***********************

XFA in in1 Vdd 0 sum cout  HA
**********************************************************************
.OP
* .TF V(output,0) VIN
.probe
* .dc  Vout	0	out	0.01
.option post
.TRAN 1ns 100us
.END