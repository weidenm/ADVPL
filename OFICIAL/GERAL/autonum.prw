
#Include "PROTHEUS.CH"    
#Include "RWMAKE.CH"
#Include "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AUTONUM   บ Autor ณ Weiden Mendes  บ Data ณ  16/08/17      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Autonumera็ใo para cadastros com registros irregulares.     ฑฑ
ฑฑบ                                                                 	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ 12.1.25  ณ Numero do c๓digo que o arquivo irแ utilizar.               บฑฑ
ฑฑบ          ณ                                                      	  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function SB1NUM()

	cUlt := ""
	
	//dbSelectArea("SB1")
	//dbSetOrder(1)
//	dbseek(xfilial("SB1")+ddatabase+"01001")
    //DESCEND() //VERIFICAR COMO FUNCIONA ESSA FUNวรO
	//MsSeek("200000", .T.)
	
	cQuery:= "SELECT MAX(B1_COD) MAXCOD FROM SB1010"
	cQuery+= " WHERE B1_COD < '100000' AND LEN(B1_COD)=6 AND D_E_L_E_T_=''"
			
	TCQuery cQuery Alias ULTPROD New

	cUlt := strzero(val(ULTPROD->MAXCOD)+1,6)
	  
	//If select("ULTPROD") > 0
	    ULTPROD->(DbCloseArea())
	//Endif 
	
return(cUlt)  


User Function SA1NUM()

	cUlt := ""
	
	cQuery:= "SELECT MAX(A1_COD) MAXCOD FROM SA1010"
	cQuery+= " WHERE A1_COD < '900000' AND LEN(A1_COD)=6 AND D_E_L_E_T_=''"
			
	TCQuery cQuery Alias ULTCLI New

	cUlt := strzero(val(ULTCLI->MAXCOD)+1,6)
  
		//If select("ULTCLI") > 0
	    ULTCLI->(DbCloseArea())
	//Endif 

return(cUlt) 



User Function SA2NUM()

	cUlt := ""
	
	cQuery:= "SELECT MAX(A2_COD) MAXCOD FROM SA2010"
	cQuery+= " WHERE A2_COD < '900000' AND LEN(A2_COD)=6 AND D_E_L_E_T_=''"
			
	TCQuery cQuery Alias ULTFOR New

	cUlt := strzero(val(ULTFOR->MAXCOD)+1,6)
  
	//If select("ULTFOR") > 0
	    ULTFOR->(DbCloseArea())
	//Endif 

return(cUlt) 
	

User Function SC5NUM()

	cUlt := ""
	
	cQuery:= "SELECT MAX(C5_NUM) MAXCOD FROM SC5010"
	cQuery+= " WHERE  D_E_L_E_T_='' "
	//cQuery+= AND C5_NUM < '200000' " 
			
	TCQuery cQuery Alias ULTPED New

	cUlt := strzero(val(ULTPED->MAXCOD)+1,6)
  
	//If select("ULTFOR") > 0
	    ULTPED->(DbCloseArea())
	//Endif 

return(cUlt) 
                 
                      