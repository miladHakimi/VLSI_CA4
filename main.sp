.prot
.lib 'crn90g_2d5_lk_v1d2p1.l' tt
.unprot
.param	Lmin=100n
.temp	25
*********************Source Voltages**************
Vds		Vdd	0  	dc	5
Vin 	in 	0 	dc PULSE(0V 5V 5us 0.5us 0.5us 4.5us 10us)
**************************** sub circuits **********************
**** Inverter *****

.subckt Inverter in Vdd Gnd out 
* Subcircuit Body
	M1   	out   	in     	Vdd     	Vdd     	pch 	w='5*lmin'  l='lmin'
	M2   	out   	in 		Gnd     	Gnd     	nch 	w='5*lmin'  l='lmin'
.ends Inverter

******************Transistor Level Implementation****************
******* drain 	gate 	source 		body 		mname 
	
*************************************************

******************* Gate Level Implementation ***********************
Xinv1 in Vdd Gnd out Inverter

**********************************************************************
.OP
* .TF V(output,0) VIN
.probe
* .dc  Vout	0	out	0.01
.option post
.TRAN 5us 20us
.END