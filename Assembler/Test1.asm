MOV R0,R1
ADD R1,R1,R2
AND R3,R3,R1
NOT R1
INC R2
PUSH R1
POP R1
LDM R5,#102
.ORG 200
	MOV R6,#3

LDD R7,200(R6)
STD R5,300(R1)
