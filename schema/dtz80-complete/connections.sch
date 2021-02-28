EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 2 2
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
L Connector_Generic:Conn_02x07_Top_Bottom J3
U 1 1 60E82957
P 1400 1500
F 0 "J3" H 1450 2017 50  0000 C CNN
F 1 "8 Bit Port" H 1450 1926 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x07_P2.54mm_Vertical" H 1400 1500 50  0001 C CNN
F 3 "~" H 1400 1500 50  0001 C CNN
	1    1400 1500
	1    0    0    -1  
$EndComp
Wire Wire Line
	1200 1200 1050 1200
Wire Wire Line
	1200 1300 1050 1300
Wire Wire Line
	1200 1400 1050 1400
Wire Wire Line
	1200 1500 1050 1500
Wire Wire Line
	1200 1600 1050 1600
Wire Wire Line
	1200 1700 1050 1700
Wire Wire Line
	1200 1800 1050 1800
Wire Wire Line
	1700 1200 1850 1200
Wire Wire Line
	1700 1300 1850 1300
Wire Wire Line
	1700 1400 1850 1400
Wire Wire Line
	1700 1600 1850 1600
Wire Wire Line
	1700 1700 1850 1700
Text Label 1700 1600 0    50   ~ 0
A0
Text Label 1700 1400 0    50   ~ 0
IO7
Text Label 1700 1300 0    50   ~ 0
IO6
Text Label 1700 1200 0    50   ~ 0
IO5
Text Label 1100 1800 0    50   ~ 0
IO4
Text Label 1100 1700 0    50   ~ 0
IO3
Text Label 1100 1600 0    50   ~ 0
IO2
Text Label 1100 1500 0    50   ~ 0
IO1
Text Label 1100 1400 0    50   ~ 0
IO0
Text Label 1100 1300 0    50   ~ 0
Vcc
Text Label 1100 1200 0    50   ~ 0
GND
Text Label 1700 1500 0    50   ~ 0
RD
Text Label 1700 1700 0    50   ~ 0
A1
Text Label 1700 1800 0    50   ~ 0
Y1
Text Label 2850 1500 2    50   ~ 0
~RD~
Wire Wire Line
	2700 1500 2950 1500
$Comp
L 74xx:74LS04 U5
U 5 1 60E82979
P 2400 1500
F 0 "U5" H 2400 1817 50  0000 C CNN
F 1 "74LS04" H 2400 1726 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 2400 1500 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74AHC_AHCT04.pdf" H 2400 1500 50  0001 C CNN
	5    2400 1500
	-1   0    0    -1  
$EndComp
Wire Wire Line
	1700 1500 2100 1500
$Comp
L 74xx:74LS04 U5
U 6 1 60E82980
P 2400 2050
F 0 "U5" H 2400 2367 50  0000 C CNN
F 1 "74LS04" H 2400 2276 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 2400 2050 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74AHC_AHCT04.pdf" H 2400 2050 50  0001 C CNN
	6    2400 2050
	-1   0    0    -1  
$EndComp
Wire Wire Line
	2100 2050 2050 2050
Wire Wire Line
	2050 2050 2050 1800
Wire Wire Line
	1700 1800 2050 1800
Wire Wire Line
	2950 2050 2700 2050
Text Label 2750 2050 0    50   ~ 0
~Y1~
Wire Wire Line
	4250 6900 4250 6650
$Comp
L power:GND #PWR?
U 1 1 60F76959
P 4050 6250
AR Path="/60F76959" Ref="#PWR?"  Part="1" 
AR Path="/60E4F668/60F76959" Ref="#PWR058"  Part="1" 
F 0 "#PWR058" H 4050 6000 50  0001 C CNN
F 1 "GND" H 4055 6077 50  0000 C CNN
F 2 "" H 4050 6250 50  0001 C CNN
F 3 "" H 4050 6250 50  0001 C CNN
	1    4050 6250
	1    0    0    -1  
$EndComp
Wire Wire Line
	4050 6250 4150 6250
$Comp
L power:+5V #PWR?
U 1 1 60F76960
P 4250 6650
AR Path="/60F76960" Ref="#PWR?"  Part="1" 
AR Path="/60E4F668/60F76960" Ref="#PWR059"  Part="1" 
F 0 "#PWR059" H 4250 6500 50  0001 C CNN
F 1 "+5V" H 4265 6823 50  0000 C CNN
F 2 "" H 4250 6650 50  0001 C CNN
F 3 "" H 4250 6650 50  0001 C CNN
	1    4250 6650
	1    0    0    -1  
$EndComp
Wire Wire Line
	4550 6900 4550 6550
Text Label 4550 6700 3    50   ~ 0
CLK
Wire Wire Line
	5050 6900 5050 6550
Wire Wire Line
	5150 6900 5150 6550
Wire Wire Line
	2550 6900 2550 6650
Wire Wire Line
	2650 6900 2650 6650
Wire Wire Line
	2750 6900 2750 6650
Wire Wire Line
	2850 6900 2850 6650
Wire Wire Line
	2950 6900 2950 6650
Wire Wire Line
	3050 6900 3050 6650
Wire Wire Line
	3150 6900 3150 6650
Wire Wire Line
	3250 6900 3250 6650
Wire Wire Line
	3350 6900 3350 6650
Wire Wire Line
	3450 6900 3450 6650
Wire Wire Line
	3550 6900 3550 6650
Wire Wire Line
	3650 6900 3650 6650
Wire Wire Line
	3750 6900 3750 6650
Wire Wire Line
	3850 6900 3850 6650
Wire Wire Line
	3950 6900 3950 6650
Wire Wire Line
	4150 6250 4150 6650
Wire Wire Line
	4050 6900 4050 6650
Text Label 2550 6750 3    50   ~ 0
A15
Text Label 2650 6750 3    50   ~ 0
A14
Text Label 2750 6750 3    50   ~ 0
A13
Text Label 2850 6750 3    50   ~ 0
A12
Text Label 2950 6750 3    50   ~ 0
A11
Text Label 3050 6750 3    50   ~ 0
A10
Text Label 3150 6750 3    50   ~ 0
A9
Text Label 3250 6750 3    50   ~ 0
A8
Text Label 3350 6750 3    50   ~ 0
A7
Text Label 3450 6750 3    50   ~ 0
A6
Text Label 3550 6750 3    50   ~ 0
A5
Text Label 3650 6750 3    50   ~ 0
A4
Text Label 3750 6750 3    50   ~ 0
A3
Text Label 3850 6750 3    50   ~ 0
A2
Text Label 3950 6750 3    50   ~ 0
A1
Text Label 4050 6750 3    50   ~ 0
A0
Text Label 5050 6700 3    50   ~ 0
~IORQ~
Wire Wire Line
	4450 6900 4450 6550
Wire Wire Line
	4350 6900 4350 6550
Wire Wire Line
	4650 6900 4650 6550
Wire Wire Line
	4750 6900 4750 6550
Wire Wire Line
	4850 6900 4850 6550
Wire Wire Line
	4950 6900 4950 6550
Text Label 4450 6650 3    50   ~ 0
~RESET~
Text Label 4650 6700 3    50   ~ 0
~INT~
Text Label 4750 6700 3    50   ~ 0
~MREQ~
Text Label 4850 6700 3    50   ~ 0
~WR~
Text Label 4950 6700 3    50   ~ 0
~RD~
Wire Wire Line
	5250 6900 5250 6650
Wire Wire Line
	5350 6900 5350 6650
Wire Wire Line
	5450 6900 5450 6650
Wire Wire Line
	5550 6900 5550 6650
Wire Wire Line
	5650 6900 5650 6650
Wire Wire Line
	5750 6900 5750 6650
Wire Wire Line
	5850 6900 5850 6650
Wire Wire Line
	5950 6900 5950 6650
Wire Wire Line
	6050 6900 6050 6650
Wire Wire Line
	6150 6900 6150 6650
Wire Wire Line
	6250 6900 6250 6650
Wire Wire Line
	6350 6900 6350 6650
Wire Wire Line
	6450 6900 6450 6650
Text Label 5150 6700 3    50   ~ 0
D0
Text Label 5250 6700 3    50   ~ 0
D1
Text Label 5350 6700 3    50   ~ 0
D2
Text Label 5450 6700 3    50   ~ 0
D3
Text Label 5550 6700 3    50   ~ 0
D4
Text Label 5650 6700 3    50   ~ 0
D5
Text Label 5750 6700 3    50   ~ 0
D6
Text Label 5850 6700 3    50   ~ 0
D7
$Comp
L Device:C C?
U 1 1 60F769AC
P 4250 6100
AR Path="/60F769AC" Ref="C?"  Part="1" 
AR Path="/60E4F668/60F769AC" Ref="C7"  Part="1" 
F 0 "C7" V 3998 6100 50  0000 C CNN
F 1 "100nF" V 4089 6100 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D3.0mm_W2.0mm_P2.50mm" H 4288 5950 50  0001 C CNN
F 3 "~" H 4250 6100 50  0001 C CNN
	1    4250 6100
	0    1    1    0   
$EndComp
Wire Wire Line
	4250 6650 4250 6300
Wire Wire Line
	4250 6300 4400 6300
Wire Wire Line
	4400 6300 4400 6100
Connection ~ 4250 6650
Wire Wire Line
	4100 6100 4100 6650
Wire Wire Line
	4100 6650 4150 6650
Connection ~ 4150 6650
Wire Wire Line
	4150 6650 4150 6900
Text Label 4150 6700 3    50   ~ 0
GND
Text Label 4250 6700 3    50   ~ 0
VCC
Text Label 4350 6750 3    50   ~ 0
~M1~
NoConn ~ 5950 6650
NoConn ~ 6050 6650
NoConn ~ 6150 6650
NoConn ~ 6250 6650
NoConn ~ 6350 6650
NoConn ~ 6450 6650
$Comp
L rc2014bus:RC2014Bus J?
U 1 1 60F769C3
P 4450 7100
AR Path="/60F769C3" Ref="J?"  Part="1" 
AR Path="/60E4F668/60F769C3" Ref="J5"  Part="1" 
F 0 "J5" V 4813 7055 50  0000 C CNN
F 1 "RC2014Bus" V 4904 7055 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x40_P2.54mm_Vertical" H 4450 7100 50  0001 C CNN
F 3 "~" H 4450 7100 50  0001 C CNN
	1    4450 7100
	0    -1   1    0   
$EndComp
$Comp
L Connector:Mini-DIN-6 J?
U 1 1 60FA91CA
P 1700 5450
AR Path="/60FA91CA" Ref="J?"  Part="1" 
AR Path="/60E4F668/60FA91CA" Ref="J4"  Part="1" 
F 0 "J4" H 1700 5817 50  0000 C CNN
F 1 "PS/2 Keyboard" H 1700 5726 50  0000 C CNN
F 2 "package_connectors:Mini_DIN_6_TE_Connectivity" H 1700 5450 50  0001 C CNN
F 3 "http://service.powerdynamics.com/ec/Catalog17/Section%2011.pdf" H 1700 5450 50  0001 C CNN
	1    1700 5450
	1    0    0    -1  
$EndComp
Wire Wire Line
	1400 5450 1250 5450
Wire Wire Line
	2000 5450 2200 5450
$Comp
L power:GND #PWR?
U 1 1 60FA91D2
P 2200 5450
AR Path="/60FA91D2" Ref="#PWR?"  Part="1" 
AR Path="/60E4F668/60FA91D2" Ref="#PWR057"  Part="1" 
F 0 "#PWR057" H 2200 5200 50  0001 C CNN
F 1 "GND" H 2205 5277 50  0000 C CNN
F 2 "" H 2200 5450 50  0001 C CNN
F 3 "" H 2200 5450 50  0001 C CNN
	1    2200 5450
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 60FA91D8
P 1250 5450
AR Path="/60FA91D8" Ref="#PWR?"  Part="1" 
AR Path="/60E4F668/60FA91D8" Ref="#PWR056"  Part="1" 
F 0 "#PWR056" H 1250 5300 50  0001 C CNN
F 1 "+5V" H 1265 5623 50  0000 C CNN
F 2 "" H 1250 5450 50  0001 C CNN
F 3 "" H 1250 5450 50  0001 C CNN
	1    1250 5450
	1    0    0    -1  
$EndComp
Wire Wire Line
	2000 5350 2200 5350
Wire Wire Line
	2000 5550 2000 5800
Wire Wire Line
	2000 5800 2200 5800
Text Label 2000 5350 0    50   ~ 0
KEY_CLK
Text Label 2050 5800 0    50   ~ 0
KEY_DATA
NoConn ~ 1400 5550
NoConn ~ 1400 5350
$EndSCHEMATC
