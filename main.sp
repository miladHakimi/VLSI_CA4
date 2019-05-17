.prot
.lib 'crn90g_2d5_lk_v1d2p1.l' tt
.unprot
.param	Lmin=100n
.temp	25
*********************Source Voltages**************
Vds		Vdd	0  	dc	5
Vin 	in 	0 	dc PULSE(0V 5V 5us 0.5us 0.5us 4.5us 10us)
Vin1 	in1	0 	dc PULSE(0V 5V 3us 0.5us 0.5us 5us 10us)
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

******************Transistor Level Implementation****************
******* drain 	gate 	source 		body 		mname 
	
*************************************************

******************* Gate Level Implementation ***********************
* Xinv1 in Vdd Gnd out Inverter
XXOR in in1 Vdd Gnd out XOR
**********************************************************************
.OP
* .TF V(output,0) VIN
.probe
* .dc  Vout	0	out	0.01
.option post
.TRAN 5us 20us
.END