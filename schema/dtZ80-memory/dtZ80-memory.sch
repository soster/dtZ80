EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L dk_Rectangular-Connectors-Headers-Male-Pins:PRPC040SAAN-RC J1
U 1 1 5FDACB91
P 4100 6000
F 0 "J1" H 4108 6215 50  0000 C CNN
F 1 "PRPC040SAAN-RC" H 4108 6124 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x40_P2.54mm_Vertical" H 4300 6200 50  0001 L CNN
F 3 "https://media.digikey.com/PDF/Data%20Sheets/Sullins%20PDFs/xRxCzzzSxxN-RC_ST_11635-B.pdf" V 4300 6300 50  0001 L CNN
F 4 "S1011EC-40-ND" H 4300 6400 60  0001 L CNN "Digi-Key_PN"
F 5 "PRPC040SAAN-RC" H 4300 6500 60  0001 L CNN "MPN"
F 6 "Connectors, Interconnects" H 4300 6600 60  0001 L CNN "Category"
F 7 "Rectangular Connectors - Headers, Male Pins" H 4300 6700 60  0001 L CNN "Family"
F 8 "https://media.digikey.com/PDF/Data%20Sheets/Sullins%20PDFs/xRxCzzzSxxN-RC_ST_11635-B.pdf" H 4300 6800 60  0001 L CNN "DK_Datasheet_Link"
F 9 "/product-detail/en/sullins-connector-solutions/PRPC040SAAN-RC/S1011EC-40-ND/2775214" H 4300 6900 60  0001 L CNN "DK_Detail_Page"
F 10 "CONN HEADER VERT 40POS 2.54MM" H 4300 7000 60  0001 L CNN "Description"
F 11 "Sullins Connector Solutions" H 4300 7100 60  0001 L CNN "Manufacturer"
F 12 "Active" H 4300 7200 60  0001 L CNN "Status"
	1    4100 6000
	0    -1   -1   0   
$EndComp
Wire Wire Line
	6100 5900 6100 5550
Text Label 6100 5700 3    50   ~ 0
CLK
Wire Wire Line
	6600 5900 6600 5550
Wire Wire Line
	6700 5900 6700 5550
Wire Wire Line
	4200 5900 4200 5650
Wire Wire Line
	4300 5900 4300 5650
Wire Wire Line
	4400 5900 4400 5650
Wire Wire Line
	4500 5900 4500 5650
Wire Wire Line
	4600 5900 4600 5650
Wire Wire Line
	4700 5900 4700 5650
Wire Wire Line
	4800 5900 4800 5650
Wire Wire Line
	4900 5900 4900 5650
Wire Wire Line
	5000 5900 5000 5650
Wire Wire Line
	5100 5900 5100 5650
Wire Wire Line
	5200 5900 5200 5650
Wire Wire Line
	5300 5900 5300 5650
Wire Wire Line
	5400 5900 5400 5650
Wire Wire Line
	5500 5900 5500 5650
Wire Wire Line
	5600 5900 5600 5650
Text Label 4100 5750 3    50   ~ 0
A15
Text Label 4200 5750 3    50   ~ 0
A14
Text Label 4300 5750 3    50   ~ 0
A13
Text Label 4400 5750 3    50   ~ 0
A12
Text Label 4500 5750 3    50   ~ 0
A11
Text Label 4600 5750 3    50   ~ 0
A10
Text Label 4700 5750 3    50   ~ 0
A9
Text Label 4800 5750 3    50   ~ 0
A8
Text Label 4900 5750 3    50   ~ 0
A7
Text Label 5000 5750 3    50   ~ 0
A6
Text Label 5100 5750 3    50   ~ 0
A5
Text Label 5200 5750 3    50   ~ 0
A4
Text Label 5300 5750 3    50   ~ 0
A3
Text Label 5400 5750 3    50   ~ 0
A2
Text Label 5500 5750 3    50   ~ 0
A1
Text Label 5600 5750 3    50   ~ 0
A0
Text Label 6600 5700 3    50   ~ 0
IORQ
Wire Wire Line
	6000 5900 6000 5550
Wire Wire Line
	5900 5900 5900 5550
Wire Wire Line
	6200 5900 6200 5550
Text Label 6000 5650 3    50   ~ 0
RESET
Text Label 6200 5700 3    50   ~ 0
INT
Text Label 6300 5700 3    50   ~ 0
MREQ
Text Label 6400 5700 3    50   ~ 0
WR
Text Label 6500 5700 3    50   ~ 0
RD
Wire Wire Line
	6800 5900 6800 5650
Wire Wire Line
	6900 5900 6900 5650
Wire Wire Line
	7000 5900 7000 5650
Wire Wire Line
	7100 5900 7100 5650
Wire Wire Line
	7200 5900 7200 5650
Wire Wire Line
	7300 5900 7300 5650
Wire Wire Line
	7400 5900 7400 5650
Wire Wire Line
	7500 5900 7500 5650
Wire Wire Line
	7600 5900 7600 5650
Wire Wire Line
	7700 5900 7700 5650
Wire Wire Line
	7800 5900 7800 5650
Wire Wire Line
	7900 5900 7900 5650
Wire Wire Line
	8000 5900 8000 5650
Text Label 6700 5700 3    50   ~ 0
D0
Text Label 6800 5700 3    50   ~ 0
D1
Text Label 6900 5700 3    50   ~ 0
D2
Text Label 7000 5700 3    50   ~ 0
D3
Text Label 7100 5700 3    50   ~ 0
D4
Text Label 7200 5700 3    50   ~ 0
D5
Text Label 7300 5700 3    50   ~ 0
D6
Text Label 7400 5700 3    50   ~ 0
D7
$Comp
L Device:C C1
U 1 1 5FDACBEB
P 5800 5100
F 0 "C1" V 5548 5100 50  0000 C CNN
F 1 "100nF" V 5639 5100 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D3.0mm_W2.0mm_P2.50mm" H 5838 4950 50  0001 C CNN
F 3 "~" H 5800 5100 50  0001 C CNN
	1    5800 5100
	0    1    1    0   
$EndComp
Wire Wire Line
	5800 5300 5950 5300
Wire Wire Line
	5950 5300 5950 5100
Wire Wire Line
	5650 5100 5650 5450
Wire Wire Line
	5650 5650 5700 5650
Wire Wire Line
	5700 5650 5700 5900
Text Label 5700 5700 3    50   ~ 0
GND
Text Label 5800 5700 3    50   ~ 0
VCC
Text Label 5900 5750 3    50   ~ 0
M1
NoConn ~ 7500 5650
NoConn ~ 7600 5650
NoConn ~ 7700 5650
NoConn ~ 7800 5650
NoConn ~ 7900 5650
NoConn ~ 8000 5650
$Comp
L Memory_RAM:HM62256BLP U2
U 1 1 5FDAEFE3
P 5800 3250
F 0 "U2" H 5800 4331 50  0000 C CNN
F 1 "HM62256" H 5800 4240 50  0000 C CNN
F 2 "Package_DIP:DIP-28_W15.24mm_Socket" H 5800 3150 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 5800 3150 50  0001 C CNN
	1    5800 3250
	1    0    0    -1  
$EndComp
$Comp
L Device:C C2
U 1 1 5FDB1C59
P 4500 2750
F 0 "C2" V 4248 2750 50  0000 C CNN
F 1 "100nF" V 4339 2750 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D3.0mm_W2.0mm_P2.50mm" H 4538 2600 50  0001 C CNN
F 3 "~" H 4500 2750 50  0001 C CNN
	1    4500 2750
	1    0    0    -1  
$EndComp
Wire Wire Line
	5800 2350 5800 2100
Wire Wire Line
	4500 2900 4500 3900
$Comp
L power:+5V #PWR0104
U 1 1 5FDBD7A6
P 5800 2100
F 0 "#PWR0104" H 5800 1950 50  0001 C CNN
F 1 "+5V" H 5815 2273 50  0000 C CNN
F 2 "" H 5800 2100 50  0001 C CNN
F 3 "" H 5800 2100 50  0001 C CNN
	1    5800 2100
	1    0    0    -1  
$EndComp
Wire Wire Line
	6300 2550 6500 2550
Wire Wire Line
	6300 2650 6500 2650
Wire Wire Line
	6300 2750 6500 2750
Wire Wire Line
	6300 2850 6500 2850
Wire Wire Line
	6300 2950 6500 2950
Wire Wire Line
	6300 3050 6500 3050
Wire Wire Line
	6300 3150 6500 3150
Wire Wire Line
	6300 3250 6500 3250
Wire Wire Line
	5300 2550 5100 2550
Wire Wire Line
	5300 2650 5100 2650
Wire Wire Line
	5300 2750 5100 2750
Wire Wire Line
	5300 2850 5100 2850
Wire Wire Line
	5300 2950 5100 2950
Wire Wire Line
	5300 3050 5100 3050
Wire Wire Line
	5300 3150 5100 3150
Wire Wire Line
	5300 3250 5100 3250
Wire Wire Line
	5300 3350 5100 3350
Wire Wire Line
	5300 3450 5100 3450
Wire Wire Line
	5300 3550 5100 3550
Wire Wire Line
	5300 3650 5100 3650
Wire Wire Line
	5300 3750 5100 3750
Wire Wire Line
	5300 3850 5100 3850
Wire Wire Line
	5300 3950 5100 3950
Text Label 5150 2550 0    50   ~ 0
A0
Text Label 5150 2650 0    50   ~ 0
A1
Text Label 5150 2750 0    50   ~ 0
A2
Text Label 5150 2850 0    50   ~ 0
A3
Text Label 5150 2950 0    50   ~ 0
A4
Text Label 5150 3050 0    50   ~ 0
A5
Text Label 5150 3150 0    50   ~ 0
A6
Text Label 5150 3250 0    50   ~ 0
A7
Text Label 5150 3350 0    50   ~ 0
A8
Text Label 5150 3450 0    50   ~ 0
A9
Text Label 5150 3550 0    50   ~ 0
A10
Text Label 5150 3650 0    50   ~ 0
A11
Text Label 5150 3750 0    50   ~ 0
A12
Text Label 5150 3850 0    50   ~ 0
A13
Text Label 5150 3950 0    50   ~ 0
A14
Text Label 6350 2550 0    50   ~ 0
D0
Text Label 6350 2650 0    50   ~ 0
D1
Text Label 6350 2750 0    50   ~ 0
D2
Text Label 6350 2850 0    50   ~ 0
D3
Text Label 6350 2950 0    50   ~ 0
D4
Text Label 6350 3050 0    50   ~ 0
D5
Text Label 6350 3150 0    50   ~ 0
D6
Text Label 6350 3250 0    50   ~ 0
D7
NoConn ~ 6600 5550
NoConn ~ 6200 5550
NoConn ~ 6100 5550
NoConn ~ 6000 5550
NoConn ~ 5900 5550
Wire Wire Line
	5950 5100 5950 4800
Connection ~ 5950 5100
Wire Wire Line
	5650 5100 5650 4800
Connection ~ 5650 5100
Wire Wire Line
	5800 5300 5800 5550
$Comp
L power:+5V #PWR0101
U 1 1 5FE81D91
P 5950 4800
F 0 "#PWR0101" H 5950 4650 50  0001 C CNN
F 1 "+5V" H 5965 4973 50  0000 C CNN
F 2 "" H 5950 4800 50  0001 C CNN
F 3 "" H 5950 4800 50  0001 C CNN
	1    5950 4800
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 4800 5250 4800
Wire Wire Line
	5250 4800 5250 5100
$Comp
L power:GND #PWR0102
U 1 1 5FE85CB0
P 5250 5100
F 0 "#PWR0102" H 5250 4850 50  0001 C CNN
F 1 "GND" H 5255 4927 50  0000 C CNN
F 2 "" H 5250 5100 50  0001 C CNN
F 3 "" H 5250 5100 50  0001 C CNN
	1    5250 5100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0103
U 1 1 5FEBBF56
P 5800 4350
F 0 "#PWR0103" H 5800 4100 50  0001 C CNN
F 1 "GND" H 5805 4177 50  0000 C CNN
F 2 "" H 5800 4350 50  0001 C CNN
F 3 "" H 5800 4350 50  0001 C CNN
	1    5800 4350
	1    0    0    -1  
$EndComp
Wire Wire Line
	5800 4350 5800 4150
Wire Wire Line
	5800 4150 4950 4150
Wire Wire Line
	4950 4150 4950 3900
Wire Wire Line
	4950 3900 4500 3900
Connection ~ 5800 4150
Wire Wire Line
	5800 2350 4500 2350
Wire Wire Line
	4500 2350 4500 2600
Connection ~ 5800 2350
$Comp
L power:GND #PWR04
U 1 1 5FF252A8
P 8750 4600
F 0 "#PWR04" H 8750 4350 50  0001 C CNN
F 1 "GND" H 8755 4427 50  0000 C CNN
F 2 "" H 8750 4600 50  0001 C CNN
F 3 "" H 8750 4600 50  0001 C CNN
	1    8750 4600
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR03
U 1 1 5FF2590B
P 8700 3950
F 0 "#PWR03" H 8700 3800 50  0001 C CNN
F 1 "+5V" H 8715 4123 50  0000 C CNN
F 2 "" H 8700 3950 50  0001 C CNN
F 3 "" H 8700 3950 50  0001 C CNN
	1    8700 3950
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG01
U 1 1 5FF265E6
P 9000 3950
F 0 "#FLG01" H 9000 4025 50  0001 C CNN
F 1 "PWR_FLAG" H 9000 4123 50  0000 C CNN
F 2 "" H 9000 3950 50  0001 C CNN
F 3 "~" H 9000 3950 50  0001 C CNN
	1    9000 3950
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG02
U 1 1 5FF26A37
P 9050 4600
F 0 "#FLG02" H 9050 4675 50  0001 C CNN
F 1 "PWR_FLAG" H 9050 4773 50  0000 C CNN
F 2 "" H 9050 4600 50  0001 C CNN
F 3 "~" H 9050 4600 50  0001 C CNN
	1    9050 4600
	1    0    0    -1  
$EndComp
Wire Wire Line
	9000 3950 8700 3950
Wire Wire Line
	9050 4600 8750 4600
$Comp
L 74xx:74LS00 U1
U 1 1 5FF2F1D4
P 7150 4100
F 0 "U1" H 7150 4425 50  0000 C CNN
F 1 "74LS00" H 7150 4334 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 7150 4100 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74ls00" H 7150 4100 50  0001 C CNN
	1    7150 4100
	1    0    0    -1  
$EndComp
Wire Wire Line
	6500 5550 6500 5900
Wire Wire Line
	4100 5650 4100 5900
Wire Wire Line
	6450 4100 6850 4100
Wire Wire Line
	6850 4100 6850 4000
Wire Wire Line
	6850 4100 6850 4200
Connection ~ 6850 4100
Text Label 6550 4100 0    50   ~ 0
A15
Wire Wire Line
	7450 4100 7450 3450
Wire Wire Line
	7450 3450 6300 3450
Wire Wire Line
	6300 5550 6300 5900
Wire Wire Line
	6400 5550 6400 5900
$Comp
L 74xx:74LS32 U3
U 1 1 5FF8DC1F
P 7150 4700
F 0 "U3" H 7150 5025 50  0000 C CNN
F 1 "74LS32" H 7150 4934 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 7150 4700 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 7150 4700 50  0001 C CNN
	1    7150 4700
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS32 U3
U 2 1 5FF8EDAC
P 7150 5200
F 0 "U3" H 7150 5525 50  0000 C CNN
F 1 "74LS32" H 7150 5434 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 7150 5200 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 7150 5200 50  0001 C CNN
	2    7150 5200
	1    0    0    -1  
$EndComp
Wire Wire Line
	6850 5100 6850 4950
Wire Wire Line
	6850 4950 6500 4950
Connection ~ 6850 4950
Wire Wire Line
	6850 4950 6850 4800
Text Label 6550 4950 0    50   ~ 0
MREQ
Wire Wire Line
	6850 4600 6500 4600
Wire Wire Line
	6850 5300 6500 5300
Text Label 6600 4600 0    50   ~ 0
RD
Text Label 6600 5300 0    50   ~ 0
WR
Wire Wire Line
	7450 4700 7650 4700
Wire Wire Line
	7650 4700 7650 3650
Wire Wire Line
	7650 3650 6300 3650
Wire Wire Line
	7450 5200 7850 5200
Wire Wire Line
	7850 5200 7850 3750
Wire Wire Line
	7850 3750 6300 3750
$Comp
L 74xx:74LS32 U3
U 5 1 5FFA15D6
P 8300 3000
F 0 "U3" H 8530 3046 50  0000 L CNN
F 1 "74LS32" H 8530 2955 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 8300 3000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 8300 3000 50  0001 C CNN
	5    8300 3000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR02
U 1 1 5FFA57E7
P 8300 3500
F 0 "#PWR02" H 8300 3250 50  0001 C CNN
F 1 "GND" H 8305 3327 50  0000 C CNN
F 2 "" H 8300 3500 50  0001 C CNN
F 3 "" H 8300 3500 50  0001 C CNN
	1    8300 3500
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR01
U 1 1 5FFA7936
P 8300 2500
F 0 "#PWR01" H 8300 2350 50  0001 C CNN
F 1 "+5V" H 8315 2673 50  0000 C CNN
F 2 "" H 8300 2500 50  0001 C CNN
F 3 "" H 8300 2500 50  0001 C CNN
	1    8300 2500
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS00 U1
U 5 1 5FFA8FAF
P 9200 3050
F 0 "U1" H 9430 3096 50  0000 L CNN
F 1 "74LS00" H 9430 3005 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 9200 3050 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74ls00" H 9200 3050 50  0001 C CNN
	5    9200 3050
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR05
U 1 1 5FFAC179
P 9200 2550
F 0 "#PWR05" H 9200 2400 50  0001 C CNN
F 1 "+5V" H 9215 2723 50  0000 C CNN
F 2 "" H 9200 2550 50  0001 C CNN
F 3 "" H 9200 2550 50  0001 C CNN
	1    9200 2550
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR06
U 1 1 5FFADC33
P 9200 3550
F 0 "#PWR06" H 9200 3300 50  0001 C CNN
F 1 "GND" H 9205 3377 50  0000 C CNN
F 2 "" H 9200 3550 50  0001 C CNN
F 3 "" H 9200 3550 50  0001 C CNN
	1    9200 3550
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG?
U 1 1 5FFE325E
P 5650 5450
F 0 "#FLG?" H 5650 5525 50  0001 C CNN
F 1 "PWR_FLAG" H 5650 5623 50  0000 C CNN
F 2 "" H 5650 5450 50  0001 C CNN
F 3 "~" H 5650 5450 50  0001 C CNN
	1    5650 5450
	1    0    0    -1  
$EndComp
Connection ~ 5650 5450
Wire Wire Line
	5650 5450 5650 5650
$Comp
L power:PWR_FLAG #FLG?
U 1 1 5FFE3927
P 5800 5550
F 0 "#FLG?" H 5800 5625 50  0001 C CNN
F 1 "PWR_FLAG" H 5800 5723 50  0000 C CNN
F 2 "" H 5800 5550 50  0001 C CNN
F 3 "~" H 5800 5550 50  0001 C CNN
	1    5800 5550
	1    0    0    -1  
$EndComp
Connection ~ 5800 5550
Wire Wire Line
	5800 5550 5800 5900
$EndSCHEMATC