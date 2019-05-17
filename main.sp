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
	M1   	out   	in     	Vdd     	Vdd     	pch 	w='5*lmin'  l='lmin'
	M2   	out   	in 		Gnd     	Gnd     	nch 	w='5*lmin'  l='lmin'
.ends Inverter

**** NAND *****

.subckt NAND in1 in2 Vdd Gnd out 
* Subcircuit Body
	M1   	out   	in1    	Vdd     	Vdd     	pch 	w='5*lmin'  l='lmin'
	M2   	out   	in2    	Vdd     	Vdd     	pch 	w='5*lmin'  l='lmin'

	M3   	out   	in1		x     		x 	     	nch 	w='5*lmin'  l='lmin'
	M4   	x   	in2		Gnd    		Gnd	     	nch 	w='5*lmin'  l='lmin'

.ends NAND

******************Transistor Level Implementation****************
******* drain 	gate 	source 		body 		mname 
	
*************************************************

******************* Gate Level Implementation ***********************
* Xinv1 in Vdd Gnd out Inverter
XNAND1 in in1 Vdd Gnd out NAND
**********************************************************************
.OP
* .TF V(output,0) VIN
.probe
* .dc  Vout	0	out	0.01
.option post
.TRAN 5us 20us
.END