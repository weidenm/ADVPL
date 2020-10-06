#INCLUDE "RWMAKE.CH"
#include "topconn.ch"
#include "tbiconn.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "Protheus.CH"
#include "TBICODE.CH"
#INCLUDE "ap5mail.ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMP       ºAutor  ³Weiden M. Mendes   º Data ³  20/09/10    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ IMPORTA DADOS ENTRE OS BANCOS - FINANCEIRO                 º±±
±±ºPROGRAMA  ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Considera todos os registros,mesmo os já atualizados e     º±±
±±º versão   ³ com LOG                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/**************************************************************************************
*
*
*****/         
                        

User Function ImpFinV2()

	Public Ponto := .f.
	
/*
//Local lAuto := .F.  
cTimeIni := TIME()                 

// MsgBox ("Serão gerados "+ALLTRIM(STR(numped))+" pedidos de venda. Itens: "+STR(rec),"Informação","INFO")
                    

@  000,000 To 230,500 Dialog oDlg1 Title "Comunicação TOTVS X Environment"       
@  010,050 Say "EXPORTAÇÕES"
@  010,160 Say "IMPORTAÇÕES"
@  025,030 Button "Exportar Clientes" size 80,12 Action(Processa({||AtualizaForn()},"Exportando Fornecedores..."))
//@  025,030 Button "Exportar Clientes" size 80,12 Action(SchedCliente())
@  045,030 Button "Exportar Entrada" size 80,12 Action(Processa({||AtualizaNFEnt()},"Exportando Notas Entrada..."))
@  065,030 Button "Exportar bancarios" size 80,12 Action(Processa({||MovBancarios()},"Exportando mov. bancarios..."))
@  085,030 Button "Exportar Titulos a pagar" size 80,12 Action(Processa({||AtualizaFinEnt()},"Exportando títulos..."))
@  025,140 Button "Importar Cheques" size 80,12 Action(Processa({||AtualizaCheqTotvs()},"Importando cheque..."))
//@  045,140 Button "Importar Notas de Remessa" size 80,12 Action(Processa({||SchedDocs()},"Importando Notas de Remessa..."))     
//@  065,140 Button "Reimportar Remessas" size 80,12 Action(Processa({||Reimport()},"Reimportando Notas de Remessa..."))     
//@  065,140 Button "Reimportar Remessas" size 80,12 Action(Reimport())     
@  095,195 button "Fechar"           size 50,12 action{Close(oDlg1)}	
//@  100,200 BMPBUTTON TYPE 01 ACTION Close(oDlg1)
Activate Dialog oDlg1 Center
*/	

	FuncoesParam()

Return


Static Function FuncoesParam()

	//u_zAtuPerg("IMPFIN", "MV_PAR01", ddatabase-10) //Data De
	//u_zAtuPerg("IMPFIN", "MV_PAR02", ddatabase) //Data Até

	cPerg  :="IMPFIN"
		
	If !Pergunte (cPerg,.T.)
		Return
	EndIf

	cDataIni := dtos(MV_PAR01)
	cDataFim := dtos(MV_PAR02)
	Public PedIni := MV_PAR04
	Public PedFim := MV_PAR05
	Public RomIni := MV_PAR06
	Public RomFim := MV_PAR07


	cData := Dtoc(date())	
	cHora := time()

	Public DataHora := cData + " " + cHora
  
	conout(Dtoc(date())+" "+ time()+"iniciando ImpFin")
//Abrindo Arquivos do Ambiente (Origem)
	TCCONTYPE("TCPIP")
	
	//Apaga movimentos importados e excluídos do OFICIAL
	Processa({||ExcluiMov()},"Aguarde...","Excluindo movimentos...")
	//Importa baixas de titulos por Liquidação (Cheques)
	Processa({||MovBancarios()},"Aguarde...","Importando baixa de NF com Cheque...")
	//Processa({||ImportaCheque()},"Aguarde...","Importando titulo e registro de cheque...")
	//Processa({||ImpBaixaLiq()},"Aguarde...","Importando exclusão e baixas de cheque...")
	Processa({||AtualizaTitulos()},"Aguarde...","Atualizando títulos...")

	//If MV_PAR05 = 1
	
//	EndIf
	//Processa({||AtualizTitBol()},"Aguarde...","Atualizando historico de titulos...")
	//Processa({||AtualizaRoman()},"Aguarde...","Atualizando historico de titulos...")
	

Return
	

Static Function MovBancarios()

	cNum := ""
	cPref:= ""
	cParc:= ""
	nSaldoTit :=0
	nValCheq := 0
	nValMov  := 0
	cErroGeral := ""
	cErroSem := ""
	cErroIg  := ""

	//1) Movimento de baixa de titulo com cheque
	
	//fecha o alias temporário 
	If Select("MOVNFIG") > 0
		dbSelectArea("MOVNFIG")
		dbCloseArea()
	EndIf

/*
	cQuery := "SELECT TITNF.E1_PEDIDO AS PEDIDO, TITNF.E1_PARCELA,  E5_PREFIXO, E5_NUMERO, E5_PARCELA,E5_DATA, E5_TIPO,E5_TIPODOC,E5_MOTBX, E5_RECPAG, E5_DOCUMEN,  E5_BENEF,E5_HISTOR,"
	cQuery += " E5_MOEDA,E5_NATUREZ, E5_CLIENTE, E5_VALOR,  E5_CLIFOR, E5_LOJA, E5_DTDIGIT,  E5_SEQ, E5_DTDISPO, E5_FILORIG, E5_BANCO, E5_AGENCIA, E5_CONTA , B.R_E_C_N_O_ AS ID"
	cQuery += " FROM  SRVPP01.DADOS12.dbo.SE5010 B INNER JOIN SRVPP01.DADOS12.dbo.SE1010 TITNF ON B.E5_PREFIXO = TITNF.E1_PREFIXO AND B.E5_NUMERO = TITNF.E1_NUM AND B.E5_PARCELA = TITNF.E1_PARCELA"
	cQuery += " INNER JOIN SRVPP03.DADOSTOTVS11.dbo.SE1010 C ON TITNF.E1_PEDIDO=C.E1_PEDIDO AND RTRIM(TITNF.E1_PARCELA)=RTRIM(C.E1_PARCELA)"
	cQuery += " WHERE B.D_E_L_E_T_='' AND TITNF.D_E_L_E_T_='' AND C.D_E_L_E_T_='' AND E5_SITUACA='' AND E5_NUMERO<>'' "
	cQuery += " AND TITNF.E1_PEDIDO<> '' AND E5_DATA>'"+cDataIni +"' AND E5_DATA <='"+ cDataFim +"' "   
	cQuery += " AND E5_MOTBX IN ('LIQ')  AND E5_BANCO NOT IN ('CX1')   "
	//cQuery += " AND E5_MOTBX IN ('NOR','LIQ')   AND (  TITNF.E1_HIST='BOLETO BB GERADO' OR E5_MOTBX='LIQ' ) AND E5_BANCO NOT IN ('CX1')"  
	cQuery += " AND C.E1_SALDO > 0  AND E5_VALOR <= C.E1_VALOR*1.1"
	cQuery += " AND B.R_E_C_N_O_ NOT IN (SELECT  CAST(E5_IDMOVI AS INT) FROM SRVPP03.DADOSTOTVS11.dbo.SE5010 WHERE E5_IDMOVI<>'' )"
  */


	cQuery := " SELECT TITNF.E1_PEDIDO AS PEDIDO, TITNF.E1_PARCELA,  E5_PREFIXO, E5_NUMERO, E5_PARCELA,E5_DATA, E5_TIPO,E5_TIPODOC,E5_MOTBX, E5_RECPAG, E5_DOCUMEN,  E5_BENEF,E5_HISTOR,"
	cQuery += "  E5_MOEDA,E5_NATUREZ, E5_CLIENTE, E5_VALOR,  E5_CLIFOR, E5_LOJA, E5_DTDIGIT,  E5_SEQ, E5_DTDISPO, E5_FILORIG, E5_BANCO, E5_AGENCIA, E5_CONTA , B.R_E_C_N_O_ AS ID"
	cQuery += "  FROM  SRVPP01.DADOS12.dbo.SE5010 B INNER JOIN SRVPP01.DADOS12.dbo.SE1010 TITNF ON B.E5_PREFIXO = TITNF.E1_PREFIXO AND B.E5_NUMERO = TITNF.E1_NUM AND B.E5_PARCELA = TITNF.E1_PARCELA"
	cQuery += " INNER JOIN SRVPP03.DADOSTOTVS11.dbo.SE1010 C ON TITNF.E1_PEDIDO=C.E1_PEDIDO AND RTRIM(TITNF.E1_PARCELA)=RTRIM(C.E1_PARCELA)"
	cQuery += "  WHERE B.D_E_L_E_T_='' AND TITNF.D_E_L_E_T_='' AND E5_NUMERO<>'' AND E5_SITUACA='' "
	cQuery += "  AND TITNF.E1_PEDIDO<> ''  AND E5_MOTBX IN ('LIQ') AND E5_TIPODOC NOT IN ('JUR')   AND E5_BANCO NOT IN ('CX1')   "
	cQuery += "  AND E5_DATA>'"+cDataIni +"' AND E5_DATA <='"+ cDataFim +"' " 
	cQuery += " 	AND C.E1_SALDO > 0  AND E5_VALOR <= C.E1_VALOR*1.1"
	cQuery += "  AND B.R_E_C_N_O_ NOT IN (SELECT  CAST(E5_IDMOVI AS INT) FROM SRVPP03.DADOSTOTVS11.dbo.SE5010 WHERE E5_IDMOVI<>'' )"
	cQuery += "  AND TITNF.E1_PEDIDO IN ( SELECT  C5_NUM FROM SRVPP03.DADOSTOTVS11.dbo.SC5010 "
	cQuery += "  WHERE C5_NUM >='"+PedIni +"' AND C5_NUM <='"+PedIni +"' AND C5_ROMANEI >='"+RomIni +"' AND C5_ROMANEI <='"+RomFim +"' )"

	TCQuery cQuery Alias MOVNFIG New



	dbSelectArea("MOVNFIG")

	Do While (! MOVNFIG->(Eof()))

		nValCheq := MOVNFIG->E5_VALOR
		lparcig := .f. //Parcela igual importada
		limp := .f.  //registro foi importado
	
		//Verificar se existe saldo em algum título do pedido	
		dbSelectArea("SE1")
		DbSetOrder(32)
		dbseek(xfilial("SE1")+MOVNFIG->PEDIDO)  //VER SE SERÁ NECESSÁRIO INCLUIR MAIS CAMPOS NESSE INDICE

		conout("Tit.posicionado:"+SE1->E1_PEDIDO+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA)
		
		Do While SE1->E1_PEDIDO = MOVNFIG->PEDIDO
		//If limp := .f.
			If Alltrim(SE1->E1_PARCELA) == Alltrim(MOVNFIG->E5_PARCELA)
				//conout("Parcelas iguais:<"+SE1->E1_PARCELA+"> e <"+MOVNFIG->E5_PARCELA+">")
				lparcig := .t.
				//if SE1->E1_SALDO*1.10 >= MOVNFIG->E5_VALOR //Para quando importava todas as movimentações não baixar titulo parcial
				if SE1->E1_SALDO >= MOVNFIG->E5_VALOR // .or. MOVNFIG = "JUR"
					nSaldoTit := SE1->E1_SALDO
					cNum  := SE1->E1_NUM
					cParc := SE1->E1_PARCELA
					cPref:= SE1->E1_PREFIXO
							
					dbSelectArea("SE5")
					DbSetOrder(2)
					dbseek(xfilial("SE5")+MOVNFIG->E5_TIPODOC+cPref+cNum+cParc+MOVNFIG->E5_DATA+MOVNFIG->E5_CLIFOR)
	
	//Verifica se registro já existe. 
					if ! SE5->(found())
						conout("Gravando SE5 "+E5_TIPODOC+cPref+cNum+cParc+MOVNFIG->E5_DATA+MOVNFIG->E5_CLIFOR)
						RecLock("SE5",.T.)
						SE5->E5_FILIAL:=  xfilial("SE5")
						SE5->E5_TIPO:=  MOVNFIG->E5_TIPO
						SE5->E5_PREFIXO:= cPref
						SE5->E5_NUMERO := cNum
						SE5->E5_PARCELA:= cParc
						SE5->E5_DATA:=  STOD(MOVNFIG->E5_DATA)
						SE5->E5_TIPO:=  MOVNFIG->E5_TIPO
						SE5->E5_MOEDA:=  MOVNFIG->E5_MOEDA
						SE5->E5_BANCO:=  MOVNFIG->E5_BANCO
						SE5->E5_AGENCIA:=  MOVNFIG->E5_AGENCIA
						SE5->E5_CONTA:=  MOVNFIG->E5_CONTA
						SE5->E5_NATUREZ:=  MOVNFIG-> E5_NATUREZ
						IF MOVNFIG->E5_MOTBX ='LIQ'  //Se for baixa por Liquidação,muda o código pra não gerar conflito com número E1_NUMLIQ do TOTVS.
							SE5->E5_DOCUMEN:=  "T"+SUBSTR(MOVNFIG->E5_DOCUMEN,2,5)
		//		ELSE
			//		SE5->E5_DOCUMEN:=  MOVNFIG->E5_DOCUMEN
						ENDIF
						SE5->E5_RECPAG:=  MOVNFIG->E5_RECPAG
						SE5->E5_BENEF:=  MOVNFIG->E5_BENEF
				//SE5->E5_HISTOR:= 'IMP.PED. '+MOVNFIG->E5_BENEF+'TITULO '+MOVNFIG->E5_PREFIXO+MOVNFIG->E5_NUMERO+MOVNFIG->E5_PARCELA //MUDAR APOS TESTES
						SE5->E5_HISTOR:= Alltrim(strzero(MOVNFIG->ID,10))+"-"+MOVNFIG->E5_HISTOR+'-NF'+MOVNFIG->E5_PREFIXO+MOVNFIG->E5_NUMERO+MOVNFIG->E5_PARCELA
						SE5->E5_TIPODOC:=  MOVNFIG->E5_TIPODOC
						SE5->E5_VALOR:=  MOVNFIG->E5_VALOR //nValMov
						SE5->E5_CLIENTE:=  MOVNFIG->E5_CLIENTE
						SE5->E5_CLIFOR:=  MOVNFIG->E5_CLIFOR
						SE5->E5_LOJA:=  MOVNFIG->E5_LOJA
						SE5->E5_DTDIGIT:=  STOD(MOVNFIG->E5_DTDIGIT)
						SE5->E5_MOTBX:=  MOVNFIG->E5_MOTBX
						SE5->E5_SEQ:=  MOVNFIG->E5_SEQ
						SE5->E5_DTDISPO:=  STOD(MOVNFIG->E5_DTDISPO)
						SE5->E5_FILORIG:=  MOVNFIG->E5_FILORIG
						SE5->E5_HORIMP :=Dtoc(date())+" "+ time()
						SE5->E5_IDMOVI := Alltrim(strzero(MOVNFIG->ID,10))
						conout("Importado parcela igual "+E5_TIPODOC+"-"+cPref+cNum+cParc+MOVNFIG->E5_DATA+MOVNFIG->E5_CLIFOR+"-Valor="+str(MOVNFIG->E5_VALOR))
						SE5->(MsUnlock())
			
						limp := .t.
						
					EndIf
		
				//	dbSelectArea("SE1")
				//	DbSetOrder(1)
				//	dbseek(xfilial("SE1")+cPref+cNum+cParc)
		
					conout("Atualizando titulo origem "+cPref+"-"+cNum+"-"+cParc)
		 
	//Atualiza status do título Origem
	 
					//IF SE1->E1_SALDO*1.10  >= MOVNFIG->E5_VALOR .AND. Alltrim(SE1->E1_NUM)=Alltrim(cNum)
					IF SE1->E1_SALDO  >= MOVNFIG->E5_VALOR .AND. Alltrim(SE1->E1_NUM)=Alltrim(cNum)
						RecLock("SE1",.f.)
						SE1->E1_BASCOM5 := SE1->E1_SALDO
						conout("Valor Saldo Anterior ="+str(SE1->E1_SALDO)+" Valliq="+str(E1_VALLIQ))
						IF SE1->E1_SALDO >= MOVNFIG->E5_VALOR
							SE1->E1_SALDO := SE1->E1_SALDO - MOVNFIG->E5_VALOR
						Else
							SE1->E1_SALDO := 0
						EndIf
						SE1->E1_VALLIQ:= SE1->E1_VALLIQ + MOVNFIG->E5_VALOR
						conout("Valor Saldo Novo ="+str(SE1->E1_SALDO)+" Valliq="+str(E1_VALLIQ))
						SE1->E1_BAIXA := ddatabase
						SE1->E1_HORIMP:="At."+ Dtoc(date())+"-"+time()
						SE1->(MsUnlock())
					Else
						conout("Titulo sem saldo ou incorreto: "+SE1->E1_NUM+"-"+SE1->E1_PARCELA )
					EndIf
				Else
					conout("Titulo sem saldo: "+SE1->E1_NUM+"-"+SE1->E1_PARCELA )
					if SE1->E1_VALOR > MOVNFIG->E5_VALOR  //Verificar se valor da parcela é maior que valor da baixa.
						conout("Parcela igual não tem saldo suficiente.: "+SE1->E1_NUM+"-"+SE1->E1_PARCELA )
						cErroIg += "Ped. "+ SE1->E1_PEDIDO+"-Parc."+SE1->E1_PARCELA+": Parcela igual não tem saldo suficiente para baixa ("+Alltrim(STR(MOVNFIG->E5_VALOR))+"). Verificar baixas no titulo TOTVS."+ENTER
					EndIf
				EndIf  //Fecha Saldo > Valor Movimento
		
			Else //Senão for parcela igual
				//conout("Parcela diferente.")
			
			EndIf
		//EndIF
			SE1->(dbskip())
		EndDo
		MOVNFIG->(dbskip())
	EndDo
	
	dbCloseArea("MOVNFIG")
	
//*****************************************
//***  Caso não encontre parcela igual  *** -- INCLUIR MOVNFSEM AQUI
//*****************************************
	//fecha o alias temporário 
	If Select("MOVNFSEM") > 0
		dbSelectArea("MOVNFSEM")
		dbCloseArea()
	EndIf
/*
	cQuery := "SELECT SUM(C.E1_SALDO) AS SALDO_TOTVS, COUNT(C.E1_SALDO) QTPARC_TOT, SUM(C.E1_VALOR)/COUNT(C.E1_SALDO) AS VALPARC_TOT,"
	cQuery += " TITNF.E1_PEDIDO AS PEDIDO, TITNF.E1_PARCELA,  E5_PREFIXO, E5_NUMERO, E5_PARCELA,E5_DATA, E5_TIPO,E5_TIPODOC,E5_MOTBX, E5_RECPAG, E5_DOCUMEN,  E5_BENEF,E5_HISTOR,"
	cQuery += " E5_MOEDA,E5_NATUREZ, E5_CLIENTE, E5_VALOR,  E5_CLIFOR, E5_LOJA, E5_DTDIGIT,  E5_SEQ, E5_DTDISPO, E5_FILORIG, E5_BANCO, E5_AGENCIA, E5_CONTA , B.R_E_C_N_O_ AS ID"
	cQuery += " FROM  SRVPP01.DADOS12.dbo.SE5010 B INNER JOIN SRVPP01.DADOS12.dbo.SE1010 TITNF ON B.E5_PREFIXO = TITNF.E1_PREFIXO AND B.E5_NUMERO = TITNF.E1_NUM AND B.E5_PARCELA = TITNF.E1_PARCELA"
	cQuery += " INNER JOIN SRVPP03.DADOSTOTVS11.dbo.SE1010 C ON TITNF.E1_PEDIDO=C.E1_PEDIDO "
	cQuery += " WHERE B.D_E_L_E_T_=''AND TITNF.D_E_L_E_T_='' AND E5_SITUACA='' AND E5_NUMERO<>'' AND TITNF.E1_PEDIDO<> '' AND C.D_E_L_E_T_=''"
	//cQuery += " AND E5_MOTBX IN ('NOR','LIQ')   AND (  TITNF.E1_HIST='BOLETO BB GERADO' OR E5_MOTBX='LIQ' ) AND E5_BANCO NOT IN ('CX1') "
	cQuery += "	AND E5_MOTBX IN ('LIQ')  AND E5_BANCO NOT IN ('CX1')  "
	cQuery += " AND E5_DATA>='"+cDataIni +"' AND E5_DATA <='"+ cDataFim +"' "  
	cQuery += " AND B.R_E_C_N_O_ NOT IN (SELECT  CAST(E5_IDMOVI AS INT) FROM SRVPP03.DADOSTOTVS11.dbo.SE5010 WHERE E5_IDMOVI<>'' ) "
	cQuery += " AND TITNF.E1_PEDIDO+TITNF.E1_PARCELA NOT IN (SELECT E1_PEDIDO+E1_PARCELA FROM SRVPP03.DADOSTOTVS11.dbo.SE1010 WHERE D_E_L_E_T_='') "
	cQuery += " GROUP BY TITNF.E1_PEDIDO, TITNF.E1_PARCELA,  E5_PREFIXO, E5_NUMERO, E5_PARCELA,E5_DATA, E5_TIPO,E5_TIPODOC,E5_MOTBX, E5_RECPAG, E5_DOCUMEN,  E5_BENEF,E5_HISTOR,"
	cQuery += " E5_MOEDA,E5_NATUREZ, E5_CLIENTE, E5_VALOR,  E5_CLIFOR, E5_LOJA, E5_DTDIGIT,  E5_SEQ, E5_DTDISPO, E5_FILORIG, E5_BANCO, E5_AGENCIA, E5_CONTA , B.R_E_C_N_O_ "
	cQuery += " HAVING  SUM(C.E1_SALDO)>0 " 
	*/
	

cQuery := "	SELECT TITNF.E1_PEDIDO AS PEDIDO, TITNF.E1_PARCELA, TITNF.E1_VALOR, TITNF.E1_SALDO, "
cQuery += " C.E1_PARCELA, SUM(C.E1_VALOR) AS VALOR, SUM(C.E1_SALDO) AS SALDO_TOTVS, COUNT(C.E1_SALDO) QTPARC_TOT, SUM(C.E1_VALOR)/COUNT(C.E1_SALDO) AS VALPARC_TOT, "
cQuery += " E5_PREFIXO, E5_NUMERO, E5_PARCELA,E5_DATA, E5_TIPO,E5_TIPODOC,E5_MOTBX, E5_RECPAG, E5_DOCUMEN,  E5_BENEF,E5_HISTOR,"
cQuery += " E5_MOEDA,E5_NATUREZ, E5_CLIENTE, E5_VALOR,  E5_CLIFOR, E5_LOJA, E5_DTDIGIT,  E5_SEQ, E5_DTDISPO, E5_FILORIG, E5_BANCO, E5_AGENCIA, E5_CONTA , B.R_E_C_N_O_ AS ID"
cQuery += " FROM  SRVPP01.DADOS12.dbo.SE5010 B INNER JOIN SRVPP01.DADOS12.dbo.SE1010 TITNF ON B.E5_PREFIXO = TITNF.E1_PREFIXO AND B.E5_NUMERO = TITNF.E1_NUM AND B.E5_PARCELA = TITNF.E1_PARCELA"
cQuery += " INNER JOIN SRVPP03.DADOSTOTVS11.dbo.SE1010 C ON TITNF.E1_PEDIDO=C.E1_PEDIDO "
cQuery += " WHERE B.D_E_L_E_T_=''AND TITNF.D_E_L_E_T_='' AND C.D_E_L_E_T_=''  AND E5_SITUACA='' AND E5_NUMERO<>'' AND TITNF.E1_PEDIDO<> '' AND E5_MOTBX IN ('LIQ') AND E5_TIPODOC NOT IN ('JUR') AND E5_BANCO NOT IN ('CX1') AND C.E1_SALDO>0"
cQuery += "  AND E5_DATA>'"+cDataIni +"' AND E5_DATA <='"+ cDataFim +"' " 
cQuery += " AND B.R_E_C_N_O_ NOT IN (SELECT  CAST(E5_IDMOVI AS INT) FROM SRVPP03.DADOSTOTVS11.dbo.SE5010 WHERE E5_IDMOVI<>'' ) "
cQuery += " AND TITNF.E1_PEDIDO+TITNF.E1_PARCELA NOT IN (SELECT E1_PEDIDO+E1_PARCELA FROM SRVPP03.DADOSTOTVS11.dbo.SE1010 WHERE D_E_L_E_T_='' AND E1_SALDO>0 AND LEN(E1_PEDIDO)=6) "
cQuery += " AND TITNF.E1_PEDIDO IN ( SELECT  C5_NUM FROM SRVPP03.DADOSTOTVS11.dbo.SC5010 WHERE C5_NUM >='"+PedIni +"' AND C5_NUM <='"+PedIni +"' AND C5_ROMANEI >='"+RomIni +"' AND C5_ROMANEI <='"+RomFim +"' )"
cQuery += " GROUP BY TITNF.E1_PEDIDO, TITNF.E1_PARCELA,TITNF.E1_VALOR, TITNF.E1_SALDO, C.E1_PARCELA,  E5_PREFIXO, E5_NUMERO, E5_PARCELA,E5_DATA, E5_TIPO,E5_TIPODOC,E5_MOTBX, E5_RECPAG, E5_DOCUMEN,  E5_BENEF,E5_HISTOR,"
cQuery += " E5_MOEDA,E5_NATUREZ, E5_CLIENTE, E5_VALOR,  E5_CLIFOR, E5_LOJA, E5_DTDIGIT,  E5_SEQ, E5_DTDISPO, E5_FILORIG, E5_BANCO, E5_AGENCIA, E5_CONTA , B.R_E_C_N_O_ "


	TCQuery cQuery Alias MOVNFSEM New

	dbSelectArea("MOVNFSEM")

	Do While (! MOVNFSEM->(Eof()))
	
		//Verificar se existe saldo em algum título do pedido	
		dbSelectArea("SE1")
		dbGoTop("SE1")
		DbSetOrder(32)
		dbseek(xfilial("SE1")+MOVNFSEM->PEDIDO)  //VER SE SERÁ NECESSÁRIO INCLUIR MAIS CAMPOS NESSE INDICE

		conout("Tit.parc.diferente:"+SE1->E1_PEDIDO+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA)
		
		Do While SE1->E1_PEDIDO = MOVNFSEM->PEDIDO
		//	If limp := .f.
		//	if SE1->E1_SALDO*1.10 >= MOVNFSEM->E5_VALOR
			if SE1->E1_SALDO >= MOVNFSEM->E5_VALOR
				conout("Baixado parc.dif:<"+SE1->E1_PARCELA+"> e <"+MOVNFSEM->E5_PARCELA+">")
				nSaldoTit := SE1->E1_SALDO
				cNum  := SE1->E1_NUM
				cParc := SE1->E1_PARCELA
				cPref:= SE1->E1_PREFIXO
				cCli := SE1->E1_CLIENTE
				
				dbSelectArea("SE5")
				DbSetOrder(2)
				dbseek(xfilial("SE5")+MOVNFSEM->E5_TIPODOC+cPref+cNum+cParc+MOVNFSEM->E5_DATA+MOVNFSEM->E5_CLIFOR)
	
	//Verifica se registro já existe. 
				if ! SE5->(found())
					conout("Gravando SE5 sem parcela "+E5_TIPODOC+cPref+cNum+cParc+MOVNFSEM->E5_DATA+MOVNFSEM->E5_CLIFOR)
					RecLock("SE5",.T.)
					SE5->E5_FILIAL:=  xfilial("SE5")
					SE5->E5_TIPO:=  MOVNFSEM->E5_TIPO
					SE5->E5_PREFIXO:= cPref
					SE5->E5_NUMERO := cNum
					SE5->E5_PARCELA:= cParc
					SE5->E5_DATA:=  STOD(MOVNFSEM->E5_DATA)
					SE5->E5_TIPO:=  MOVNFSEM->E5_TIPO
					SE5->E5_MOEDA:=  MOVNFSEM->E5_MOEDA
					SE5->E5_BANCO:=  MOVNFSEM->E5_BANCO
					SE5->E5_AGENCIA:=  MOVNFSEM->E5_AGENCIA
					SE5->E5_CONTA:=  MOVNFSEM->E5_CONTA
					SE5->E5_NATUREZ:=  MOVNFSEM-> E5_NATUREZ
					IF MOVNFSEM->E5_MOTBX ='LIQ'  //Se for baixa por Liquidação,muda o código pra não gerar conflito com número E1_NUMLIQ do TOTVS.
						SE5->E5_DOCUMEN:=  "T"+SUBSTR(MOVNFSEM->E5_DOCUMEN,2,5)
			//		ELSE
			//			SE5->E5_DOCUMEN:=  MOVNFSEM->E5_DOCUMEN
					ENDIF
					SE5->E5_RECPAG:=  MOVNFSEM->E5_RECPAG
					SE5->E5_BENEF:=  MOVNFSEM->E5_BENEF
					SE5->E5_HISTOR:= Alltrim(strzero(MOVNFSEM->ID,10))+"-"+MOVNFSEM->E5_HISTOR+'-NF'+MOVNFSEM->E5_PREFIXO+MOVNFSEM->E5_NUMERO+MOVNFSEM->E5_PARCELA
					SE5->E5_TIPODOC:=  MOVNFSEM->E5_TIPODOC
					SE5->E5_VALOR:=  MOVNFSEM->E5_VALOR //nValMov
					SE5->E5_CLIENTE:=  MOVNFSEM->E5_CLIENTE
					SE5->E5_CLIFOR:=  MOVNFSEM->E5_CLIFOR
					SE5->E5_LOJA:=  MOVNFSEM->E5_LOJA
					SE5->E5_DTDIGIT:=  STOD(MOVNFSEM->E5_DTDIGIT)
					SE5->E5_MOTBX:=  MOVNFSEM->E5_MOTBX
					SE5->E5_SEQ:=  MOVNFSEM->E5_SEQ
					SE5->E5_DTDISPO:=  STOD(MOVNFSEM->E5_DTDISPO)
					SE5->E5_FILORIG:=  MOVNFSEM->E5_FILORIG
					SE5->E5_HORIMP :=Dtoc(date())+" "+ time()
					SE5->E5_IDMOVI := Alltrim(strzero(MOVNFSEM->ID,10))
					conout("Importado Mov. sem parcela "+E5_TIPODOC+"-"+cPref+cNum+cParc+MOVNFSEM->E5_DATA+MOVNFSEM->E5_CLIFOR+"-Valor="+str(MOVNFSEM->E5_VALOR))
					SE5->(MsUnlock())
			
					limp := .t.
				EndIf
		
				dbSelectArea("SE1")
				DbSetOrder(1)
				dbseek(xfilial("SE1")+cPref+cNum+cParc)
		
				conout("Atualizando titulo origem "+cPref+"-"+cNum+"-"+cParc)
		 
	//Atualiza status do título Origem
				IF Alltrim(SE1->E1_NUM)=Alltrim(cNum) .and. SE1->E1_CLIENTE = MOVNFSEM->E5_CLIENTE
				//	IF SE1->E1_SALDO*1.10 >= MOVNFSEM->E5_VALOR
					IF SE1->E1_SALDO >= MOVNFSEM->E5_VALOR
				
						RecLock("SE1",.f.)
						SE1->E1_BASCOM5 := SE1->E1_SALDO
						conout("Valor Saldo Anterior ="+str(SE1->E1_SALDO)+" Valliq="+str(E1_VALLIQ))
						SE1->E1_SALDO := SE1->E1_SALDO - MOVNFSEM->E5_VALOR
						SE1->E1_BASCOM4 := SE1->E1_VALLIQ
						SE1->E1_VALLIQ:= SE1->E1_VALLIQ + MOVNFSEM->E5_VALOR

						conout("Valor Saldo Novo ="+str(SE1->E1_SALDO)+" Valliq="+str(E1_VALLIQ))
						SE1->E1_BAIXA := ddatabase
						SE1->E1_HORIMP:="At."+ Dtoc(date())+"-"+time()
						SE1->(MsUnlock())
						conout("Atualizado titulo "+cPref+"-"+cNum+"-"+cParc+" com sucesso.")
					ELSE
						conout("1-Titulo sem saldo: "+SE1->E1_NUM+"-"+SE1->E1_PARCELA )
						cErroSem += "Ped. "+SE1->E1_PEDIDO+"-Parc."+SE1->E1_PARCELA+": sem saldo disponível para atualizar titulo."+ENTER
					ENDIF
				Else
					conout("Titulo incorreto: "+SE1->E1_NUM+"-"+SE1->E1_PARCELA )
				EndIf
			Else
				if SE1->E1_VALOR > MOVNFSEM->E5_VALOR
					conout("2-Titulo sem saldo: "+SE1->E1_NUM+"-"+SE1->E1_PARCELA )
					cErroSem += SE1->E1_NUM+"-"+SE1->E1_PARCELA+": Titulo com parcela diferente e sem saldo disponível."+ENTER
				EndIf
			EndIf  //Fecha Saldo > Valor Movimento
			//EndIF
			SE1->(dbskip())
				
		EndDo
	
		MOVNFSEM->(dbskip())
	EndDo
	dbCloseArea("MOVNFSEM")
	conout(Dtoc(date())+" "+ time()+"-Fim fase 1-Importa Movto")

Return


Static Function ImportaCheque()	
///******************************************* 
//***  3) INCLUI TITULO DO CHEQUE - SE1   ***
//*******************************************	
	//fecha o alias temporário 
	If Select("TITCH") > 0
		dbSelectArea("TITCH")
		dbCloseArea()
	EndIf

	// Titulo do Cheque 
/*	cQuery := "SELECT SUBSTRING(E1_PARCELA,2,1) AS E1_PARCELA, E1_NUM, E1_PREFIXO , E1_TIPO,E1_NATUREZ ,E1_CLIENTE, E1_LOJA ,  E1_NOMCLI, E1_EMISSAO, E1_VENCTO, E1_VENCREA, E1_VALOR, E1_BAIXA, E1_EMIS1, E1_HIST,
	cQuery += " E1_MOVIMEN, E1_SALDO, E1_VEND1, E1_VALLIQ,E1_VENCORI,E1_OK,E1_OCORREN, E1_VLCRUZ,E1_STATUS, E1_ORIGEM, E1_FLUXO, E1_NUMLIQ, E1_EMITCHQ, E1_CTACHQ, E1_AGECHQ, E1_BCOCHQ, A.R_E_C_N_O_ AS ID"
	cQuery += " FROM SRVPP01.DADOS12.dbo.SE1010 A INNER JOIN SRVPP03.DADOSTOTVS11.dbo.SE5010 B ON 'T'+SUBSTRING(A.E1_NUMLIQ,2,5) = B.E5_DOCUMEN"
	cQuery += " WHERE A.D_E_L_E_T_='' AND B.D_E_L_E_T_='' AND E1_NUMLIQ<>'' AND E1_TIPO IN ('CH','NF') AND E1_EMISSAO >='"+cDataIni +"' AND E1_EMISSAO<='"+cDataFim +"'" //dtos(ddatabase-10)
	cQuery += " AND E1_NUM+SUBSTRING(E1_PARCELA,2,1)+E1_CLIENTE+E1_TIPO NOT IN (SELECT E1_NUM+E1_PARCELA+E1_CLIENTE+E1_TIPO FROM SRVPP03.DADOSTOTVS11.dbo.SE1010 WHERE E1_EMISSAO>='"+ cDataIni+"' AND E1_EMISSAO <='"+ cDataFim +"' )"
	cQuery += " GROUP BY SUBSTRING(E1_PARCELA,2,1) , E1_NUM, E1_PREFIXO , E1_TIPO,E1_NATUREZ ,E1_CLIENTE, E1_LOJA ,  E1_NOMCLI, E1_EMISSAO, E1_VENCTO, E1_VENCREA, E1_VALOR, E1_BAIXA, E1_EMIS1, E1_HIST,"
	cQuery += " E1_MOVIMEN, E1_SALDO, E1_VEND1, E1_VALLIQ,E1_VENCORI,E1_OK,E1_OCORREN, E1_VLCRUZ,E1_STATUS, E1_ORIGEM, E1_FLUXO, E1_NUMLIQ, E1_EMITCHQ, E1_CTACHQ, E1_AGECHQ, E1_BCOCHQ, A.R_E_C_N_O_"
*/

	cQuery := "SELECT SUBSTRING(E1_PARCELA,2,1) AS E1_PARCELA, E1_NUM, E1_PREFIXO , E1_TIPO,E1_NATUREZ ,E1_CLIENTE, E1_LOJA ,  E1_NOMCLI, E1_EMISSAO, E1_VENCTO, E1_VENCREA, E1_VALOR, E1_BAIXA, E1_EMIS1, E1_HIST, "
	cQuery += " E1_MOVIMEN, E1_SALDO, E1_VEND1, E1_VALLIQ,E1_VENCORI,E1_OK,E1_OCORREN, E1_VLCRUZ,E1_STATUS, E1_ORIGEM, E1_FLUXO, E1_NUMLIQ, E1_EMITCHQ, E1_CTACHQ, E1_AGECHQ, E1_BCOCHQ, A.R_E_C_N_O_ AS ID"
	cQuery += " FROM SRVPP01.DADOS12.dbo.SE1010 A INNER JOIN SRVPP03.DADOSTOTVS11.dbo.SE5010 B ON 'T'+SUBSTRING(A.E1_NUMLIQ,2,5) = B.E5_DOCUMEN"
	cQuery += " WHERE A.D_E_L_E_T_='' AND B.D_E_L_E_T_='' AND E1_NUMLIQ<>'' AND E1_TIPO IN ('CH','NF') " //AND E1_EMISSAO >='"+cDataIni +"' AND E1_EMISSAO<='"+cDataFim +"'" //dtos(ddatabase-10)
	cQuery += " AND A.E1_PEDIDO IN ( SELECT  C5_NUM FROM SRVPP03.DADOSTOTVS11.dbo.SC5010 WHERE C5_NUM >='"+PedIni +"' AND C5_NUM <='"+PedIni +"' AND C5_ROMANEI >='"+RomIni +"' AND C5_ROMANEI <='"+RomFim +"' )"
//	cQuery += " AND E1_NUM+SUBSTRING(E1_PARCELA,2,1)+E1_CLIENTE+E1_TIPO NOT IN (SELECT E1_NUM+E1_PARCELA+E1_CLIENTE+E1_TIPO FROM SRVPP03.DADOSTOTVS11.dbo.SE1010 WHERE E1_EMISSAO>='"+ cDataIni+"' AND E1_EMISSAO <='"+ cDataFim +"' )"
	cQuery += " GROUP BY SUBSTRING(E1_PARCELA,2,1) , E1_NUM, E1_PREFIXO , E1_TIPO,E1_NATUREZ ,E1_CLIENTE, E1_LOJA ,  E1_NOMCLI, E1_EMISSAO, E1_VENCTO, E1_VENCREA, E1_VALOR, E1_BAIXA, E1_EMIS1, E1_HIST,"
	cQuery += " E1_MOVIMEN, E1_SALDO, E1_VEND1, E1_VALLIQ,E1_VENCORI,E1_OK,E1_OCORREN, E1_VLCRUZ,E1_STATUS, E1_ORIGEM, E1_FLUXO, E1_NUMLIQ, E1_EMITCHQ, E1_CTACHQ, E1_AGECHQ, E1_BCOCHQ, A.R_E_C_N_O_"

	TCQuery cQuery Alias TITCH New

	conout(cQuery)	
		
	dbSelectArea("TITCH")
	TITCH->(dbGotop())
	
	While ! TITCH->(Eof())
	
		IF TITCH->E1_TIPO = 'CH'
			cPrefTit :='T'+SUBSTRING(TITCH->E1_CLIENTE,5,2)    //+Alltrim(TITCH->E1_PREFIXO)
		Else
			cPrefTit := 'TLI'  //'T'+SUBSTRING(Alltrim(TITCH->E1_PREFIXO),1,2)
		EndIf
	
		dbSelectArea("SE1")
		DbSetOrder(1)
		//dbseek(xfilial("SE1")+'T'+SUBSTRING(TITCH->E1_CLIENTE,5,2)+TITCH->E1_NUM+TITCH->E1_PARCELA+TITCH->E1_TIPO)
		dbseek(xfilial("SE1")+cPrefTit+TITCH->E1_NUM+TITCH->E1_PARCELA+TITCH->E1_TIPO)
		
		If ! SE1->(found()) 
		
			RecLock("SE1",.t.)
			SE1->E1_FILIAL:=  xfilial("SE1")
			IF TITCH->E1_TIPO = 'CH'
				SE1->E1_PREFIXO :='T'+SUBSTRING(TITCH->E1_CLIENTE,5,2)    //+Alltrim(TITCH->E1_PREFIXO)
			Else
				SE1->E1_PREFIXO := 'TLI'  //'T'+SUBSTRING(Alltrim(TITCH->E1_PREFIXO),1,2)
			EndIf
			SE1->E1_NUM :=TITCH->E1_NUM
			SE1->E1_PARCELA :=TITCH->E1_PARCELA
			SE1->E1_TIPO :=TITCH->E1_TIPO
			SE1->E1_NATUREZ :=TITCH->E1_NATUREZ
			SE1->E1_CLIENTE :=TITCH->E1_CLIENTE
			SE1->E1_LOJA :=TITCH->E1_LOJA
			SE1->E1_NOMCLI :=TITCH->E1_NOMCLI
			SE1->E1_HIST  := TITCH->E1_HIST //Alltrim(strzero(TITCH->ID,8))+"-"+TITCH->E1_HIST
			SE1->E1_NUMRA := Alltrim(strzero(TITCH->ID,8))
			SE1->E1_EMISSAO :=STOD(TITCH->E1_EMISSAO)
			SE1->E1_VENCTO :=STOD(TITCH->E1_VENCTO)
			SE1->E1_VENCREA :=STOD(TITCH->E1_VENCREA)
			SE1->E1_VALOR := TITCH->E1_VALOR //nValMov
			SE1->E1_BAIXA :=STOD(TITCH->E1_BAIXA)
			SE1->E1_EMIS1 :=STOD(TITCH->E1_EMIS1)
			SE1->E1_MOVIMEN :=STOD(TITCH->E1_MOVIMEN)
			SE1->E1_VEND1:= TITCH->E1_VEND1
				//if SE1->E1_SALDO > nValMov
					//SE1->E1_SALDO := nValMov
				//ELSE
			SE1->E1_SALDO := TITCH->E1_SALDO
				//EndIf
				//if SE1->E1_VALLIQ  > nValMov
					//SE1->E1_VALLIQ:= nValMov
				//Else
			SE1->E1_VALLIQ:= TITCH->E1_VALLIQ
				//EndIf
			SE1->E1_VENCORI:=STOD(TITCH->E1_VENCORI)
			SE1->E1_OK:=TITCH->E1_OK
			SE1->E1_OCORREN:=TITCH->E1_OCORREN
			SE1->E1_VLCRUZ:=TITCH->E1_VLCRUZ
			SE1->E1_STATUS:=TITCH->E1_STATUS
			SE1->E1_ORIGEM:=TITCH->E1_ORIGEM
			SE1->E1_FLUXO:=TITCH->E1_FLUXO
			SE1->E1_NUMLIQ:="T"+SUBSTR(TITCH->E1_NUMLIQ,2,5)
			SE1->E1_EMITCHQ:=TITCH->E1_EMITCHQ
			SE1->E1_CTACHQ:=TITCH->E1_CTACHQ
			SE1->E1_AGECHQ:=TITCH->E1_AGECHQ
			SE1->E1_BCOCHQ:= TITCH->E1_BCOCHQ
			SE1->E1_HORIMP:=Dtoc(date())+" "+ time()
			SE1->(MsUnlock())
				
			conout("Incluído titulo "+TITCH->E1_NUM+" no valor de "+STR(TITCH->E1_VALOR))
		
		Else
			if SE1->E1_TIPO='CH'
				cErroGeral +="Nº de Cheque já existente: "+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA  + ENTER
				conout("Cheque já existente:"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+" - "+TITCH->E1_NUM)
			ELSE
				cErroGeral +="Titulo já existente: "+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO + ENTER
				conout("Titulo já existente:"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+" - "+SE1->E1_TIPO)
			EndIf
		EndIf   //End do Titulo do cheque
					
		TITCH->(dbskip())
	EndDo
		
	dbCloseArea("TITCH")
	conout(Dtoc(date())+" "+ time()+"-Fim fase 2-Importa titulo CH")
							
//******************************************* 
//***     4) INCLUI SEF DO CHEQUE - SEF   ***
//*******************************************		
	If Select("CHEQ") > 0
		dbSelectArea("CHEQ")
		dbCloseArea()
	EndIf
	
	cQuery := "SELECT EF_NUM,EF_TITULO,EF_TIPO,EF_PREFIXO,EF_PARCELA, EF_BANCO, EF_AGENCIA, EF_CONTA, EF_VALOR, EF_VALORBX, EF_DATA, EF_VENCTO, EF_BENEF, "
	cQuery += " EF_FORNECE, EF_CLIENTE, EF_LOJA, EF_LOJACLI, EF_CPFCNPJ, EF_EMITENT, EF_HIST, EF_ALINEA1, EF_DTALIN1, EF_ALINEA2, EF_DTALIN2, EF_DTREPRE, EF_CART,"
	cQuery += " EF_CHDEVOL, EF_ORIGEM,EF_TERCEIR, EF_USADOBX, EF_TEL, EF_SEQUENC, EF_DEPOSIT, EF_COMP, EF_GARANT, EF_IMPRESS, EF_LIBER, EF_OK, EF_PORTADO, EF_RG, R_E_C_N_O_  AS ID"
	cQuery += " FROM SRVPP01.DADOS12.dbo.SEF010 WHERE D_E_L_E_T_='' AND EF_TIPO ='CH'  AND EF_CART='R' " //AND EF_DATA >='"+ cDataIni +"' AND EF_DATA <='"+ cDataFim +"' "  //dtos(ddatabase-10)
	cQuery += " AND EF_TITULO IN ( SELECT  C5_NOTA FROM SRVPP03.DADOSTOTVS11.dbo.SC5010 WHERE C5_NUM >='"+PedIni +"' AND C5_NUM <='"+PedIni +"' AND C5_ROMANEI >='"+RomIni +"' AND C5_ROMANEI <='"+RomFim +"' )"
	cQuery += " AND EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM+EF_CLIENTE NOT IN (SELECT EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM+EF_CLIENTE FROM SRVPP03.DADOSTOTVS11.dbo.SEF010)"

	TCQuery cQuery Alias CHEQ New
	conout(cQuery)
	dbSelectArea("CHEQ")
	CHEQ->(dbgotop())
				
	Do While (! CHEQ->(Eof()))
	
				//dbSelectArea("SEF")
				//DbSetOrder(3)
				//dbseek(xfilial("SEF")+CHEQ->EF_PREFIXO+CHEQ->EF_TITULO+CHEQ->EF_PARCELA+CHEQ->EF_TIPO+CHEQ->EF_NUM+CHEQ->EF_SEQUENC)
				//if SEF->(found())

		RecLock("SEF",.T.)
		SEF->EF_FILIAL:=  xfilial("SEF")
		if EF_TIPO='CH'
			SEF->EF_PREFIXO:=  "T"+SUBSTRING(CHEQ->EF_CLIENTE,5,2)   //Alltrim(CHEQ->EF_PREFIXO)
		Else
			SEF->EF_PREFIXO:= 'T'+SUBSTRING(Alltrim(CHEQ->EF_PREFIXO),1,2)
		EndIf
		SEF->EF_TITULO:=  CHEQ->EF_TITULO
		SEF->EF_PARCELA:=  SUBSTRING(CHEQ->EF_PARCELA,2,1)
		SEF->EF_TIPO:=  CHEQ->EF_TIPO
		SEF->EF_NUM:=  CHEQ->EF_NUM
		SEF->EF_SEQUENC:=  CHEQ->EF_SEQUENC
		SEF->EF_BANCO:=  CHEQ->EF_BANCO
		SEF->EF_AGENCIA:=  CHEQ->EF_AGENCIA
		SEF->EF_CONTA:=  CHEQ->EF_CONTA
		SEF->EF_VALOR:=   CHEQ->EF_VALOR //nValMov //
				//if EF_VALORBX > nValMov
//					SEF->EF_VALORBX:= nValMov
	//			else
		SEF->EF_VALORBX:= CHEQ->EF_VALORBX
		//		EndIf
		SEF->EF_DATA:=  STOD(CHEQ->EF_DATA)
		SEF->EF_VENCTO:=  STOD(CHEQ->EF_VENCTO)
		SEF->EF_BENEF:=  CHEQ->EF_BENEF
		SEF->EF_FORNECE:=  CHEQ->EF_FORNECE
		SEF->EF_LOJA:=  CHEQ->EF_LOJA
		SEF->EF_CLIENTE:=  CHEQ->EF_CLIENTE
		SEF->EF_LOJACLI:=  CHEQ->EF_LOJACLI
		SEF->EF_CPFCNPJ:=  CHEQ->EF_CPFCNPJ
		SEF->EF_EMITENT:=  CHEQ->EF_EMITENT
		SEF->EF_HIST:=  Alltrim(strzero(CHEQ->ID,10))+"-"+CHEQ->EF_HIST
		SEF->EF_ALINEA1:=  CHEQ->EF_ALINEA1
		SEF->EF_DTALIN1:=  STOD(CHEQ->EF_DTALIN1)
		SEF->EF_ALINEA2:=  CHEQ->EF_ALINEA2
		SEF->EF_DTALIN2:=  STOD(CHEQ->EF_DTALIN2)
		SEF->EF_DTREPRE:=  STOD(CHEQ->EF_DTREPRE)
		SEF->EF_CART:=  CHEQ->EF_CART
		SEF->EF_CHDEVOL:=  CHEQ->EF_CHDEVOL
		SEF->EF_COMP:=  CHEQ->EF_COMP
		SEF->EF_DEPOSIT:=  CHEQ->EF_DEPOSIT
		SEF->EF_GARANT:=  CHEQ->EF_GARANT
		SEF->EF_IMPRESS:=  CHEQ->EF_IMPRESS
		SEF->EF_LIBER:=  CHEQ->EF_LIBER
		SEF->EF_ORIGEM:=  CHEQ->EF_ORIGEM
		SEF->EF_PORTADO:=  CHEQ->EF_PORTADO
		SEF->EF_RG:=  CHEQ->EF_RG
		SEF->EF_USADOBX:=  CHEQ->EF_USADOBX
		SEF->EF_HORIMP := Dtoc(date())+" "+ time()
			//	SEF->EF_TERCEIR:=  CHEQ->EF_TERCEIR
			//SEF->EF_TEL:=  CHEQ->EF_TEL
			//SEF->EF_DTCOMP:= STOD( CHEQ->EF_DTCOMP)
		SEF->(MsUnlock())
		conout("Incluído Cheque "+CHEQ->EF_BANCO+CHEQ->EF_AGENCIA+CHEQ->EF_CONTA+CHEQ->EF_NUM)
			//Else
				//conout("Já existe Cheque "+CHEQ->EF_BANCO+CHEQ->EF_AGENCIA+CHEQ->EF_CONTA+CHEQ->EF_NUM)
			//EndIf
				
		CHEQ->(dbskip())
	EndDo
	dbCloseArea("CHEQ")
	conout(Dtoc(date())+" "+ time()+"-Fim fase 3-Importa Cheque-SEF")
	
	//Caso não seja importado movimento, inclui na mensagem para enviar por email
	/*
	if cErroGeral = ""
		cErroGeral :=" -------------------  MOVIMENTOS NÃO IMPORTADOS ----------------------------" +ENTER
		cErroGeral +="Verificar os motivos da não importação, analisando as baixas do TOTVS."+ENTER
		cErroGeral +="A CONFERÊNCIA É DE TOTAL RESPONSABILIDADE DO SETOR DE MALOTES."+ENTER
		cErroGeral += Replicate("=",80)+ENTER
	EndIf

	cErroGeral += cErroIg
	cErroGeral += Replicate("=",80)+ENTER
	cErroGeral += cErroSem
	*/			
	//Envio de e-mail
/*	if Alltrim(cErroGeral)<> ""
		U_EnvMailimp('malotes@produtosplinc.com.br','IMPFIN - Movimentos não importados - '+ time() ,cErroGeral)
		U_EnvMailimp('sistemas@produtosplinc.com.br','IMPFIN - Movimentos não importados - '+ time() ,cErroGeral)
	EndIf 
	 */
	
Return


//**********************************************************************
//  Importa baixas de títulos gerados por Liquidação  e importados  ****
//**********************************************************************
Static Function ImpBaixaLiq()

	cNum := ""
	cPref:= ""
	cParc:= ""
	nValMov  := 0
	
	nSaldoTit :=0
	nValCheq := 0
	cErroGeral := ""
	
	//**************************************************
	//***	EXCLUI BAIXAS NO TOTVS JA CANCELADAS	**** RETIRADO TRECHO TEMPORARIAMENTE. VERIFICAR SE CÓDIO É NECESSÁRIO
	//***************************************************
/*
	If Select("EXCBX") > 0
		dbSelectArea("EXCBX")
		dbCloseArea()
	EndIf
		
	cQuery := "SELECT A.E5_NUMERO, A.E5_PREFIXO, A.E5_PARCELA,A.E5_VALOR, A.E5_IDMOVI , B.D_E_L_E_T_ "
	cQuery += " FROM  SRVPP03.DADOSTOTVS11.dbo.SE5010 A INNER JOIN SRVPP01.DADOS12.dbo.SE5010 B ON CAST(A.E5_IDMOVI AS INT) = B.R_E_C_N_O_  WHERE A.D_E_L_E_T_='' AND (B.D_E_L_E_T_='*' or B.E5_SITUACA='C') AND A.E5_IDMOVI<>''"

	TCQuery cQuery Alias EXCBX New
			
	dbSelectArea("EXCBX")
		
	Do While (! EXCBX->(Eof()))
		cNum := ""
		cPref:= ""
		cParc:= ""
		nValMov  := 0
					
		dbSelectArea("SE5")
		DbSetOrder(18)
		dbseek(xfilial("SE5")+EXCBX->E5_IDMOVI)
		
		if SE5->(found())
			cNum := EXCBX->E5_NUMERO
			cPref:= EXCBX->E5_PREFIXO
			cParc:= SUBSTRING(EXCBX->E5_PARCELA,2,1)
			nValMov := EXCBX->E5_VALOR
			
			RecLock("SE5",.F.,.T.)
			dbDelete()
			SE5->(MsUnlock())
			conout("Movimento excluído do titulo "+cPref+"-"+cNum+"-"+cParc)
			
			if nValMov > 0
				dbSelectArea("SE1")
				DbSetOrder(1)
				dbseek(xfilial("SE1")+EXCBX->E5_PREFIXO+EXCBX->E5_NUMERO+EXCBX->E5_PARCELA)
		
				conout("Atualizando titulo com exclusão "+cPref+"-"+cNum+"-"+cParc)
		 
	//Atualiza status do título Origem
				IF  Alltrim(SE1->E1_NUM)=Alltrim(cNum) .and. Alltrim(SE1->E1_PREFIXO)=Alltrim(cPref) .and. Alltrim(SE1->E1_PARCELA)=Alltrim(cParc)
					RecLock("SE1",.f.)
					SE1->E1_BASCOM5 := SE1->E1_SALDO
					conout("Valor Saldo Anterior ="+str(SE1->E1_SALDO)+" Valliq="+str(E1_VALLIQ))
					IF SE1->E1_VALLIQ >= nValMov
						SE1->E1_VALLIQ:= SE1->E1_VALLIQ - nValMov
					ELSE
						SE1->E1_VALLIQ:= 0
						SE1->E1_BAIXA := CTOD("  /  /  ") 
					ENDIF
			
					IF SE1->E1_SALDO+nValMov <= SE1->E1_VALOR
						SE1->E1_SALDO := SE1->E1_SALDO + nValMov
					Else
						SE1->E1_SALDO := SE1->E1_VALOR
					EndIf
					conout("Valor Saldo Novo ="+str(SE1->E1_SALDO)+" Valliq="+str(E1_VALLIQ))
			
					SE1->E1_HORIMP:="At."+ Dtoc(date())+"-"+time()
					SE1->(MsUnlock())
				Else
					conout("Titulo não encontrado:"+EXCBX->E5_PREFIXO+"-"+EXCBX->E5_NUMERO+"-"+EXCBX->E5_PARCELA)
				EndIf
			EndIf
		endif
		EXCBX->(dbskip())
	EndDo
	dbCloseArea("EXCBX")
	
	conout(Dtoc(date())+" "+ time()+"-Fim fase 4-Excluindo movimentos")
*/
//*******************************************************
//*** BAIXAS DE TÍTULOS DE LIQUIDAÇÃO IMPORTADOS  *******
//*******************************************************
	If Select("BXCH") > 0
		dbSelectArea("BXCH")
		dbCloseArea()
	EndIf
		
	cQuery := " SELECT TITNF.E1_PEDIDO AS PEDIDO, E5_PREFIXO, E5_NUMERO, E5_PARCELA,E5_DATA, E5_TIPO,E5_TIPODOC,E5_MOTBX, E5_RECPAG, E5_DOCUMEN,  E5_BENEF,E5_HISTOR, E5_MOEDA,E5_NATUREZ,"
	cQUery += " E5_CLIENTE, E5_VALOR,  E5_CLIFOR, E5_LOJA, E5_DTDIGIT,  E5_SEQ, E5_DTDISPO, E5_FILORIG, E5_BANCO, E5_AGENCIA, E5_CONTA , B.R_E_C_N_O_ AS ID "
	cQuery += " FROM  SRVPP01.DADOS12.dbo.SE5010 B INNER JOIN SRVPP01.DADOS12.dbo.SE1010 TITNF ON B.E5_PREFIXO = TITNF.E1_PREFIXO AND B.E5_NUMERO = TITNF.E1_NUM AND B.E5_PARCELA = TITNF.E1_PARCELA"
	cQuery += " WHERE B.D_E_L_E_T_='' AND TITNF.D_E_L_E_T_='' AND E5_SITUACA='' AND E5_NUMERO<>'' "
	cQuery += " AND E5_DATA>='"+ cDataIni +"' AND E5_DATA <='"+ cDataFim +"' "  
	cQuery += " AND TITNF.E1_PEDIDO IN ( SELECT  C5_NUM FROM SRVPP03.DADOSTOTVS11.dbo.SC5010 WHERE C5_NUM >='"+PedIni +"' AND C5_NUM <='"+PedIni +"' AND C5_ROMANEI >='"+RomIni +"' AND C5_ROMANEI <='"+RomFim +"' )"
	cQuery += " AND B.R_E_C_N_O_ NOT IN (SELECT  CAST(E5_IDMOVI AS INT) FROM SRVPP03.DADOSTOTVS11.dbo.SE5010 WHERE E5_IDMOVI<>'' AND D_E_L_E_T_='')"
	cQuery += " AND ((LEN(LTRIM(E1_PARCELA))='2' AND TITNF.E1_NUM+TITNF.E1_CLIENTE+SUBSTRING(E1_PARCELA,2,1) IN (SELECT E1_NUM+E1_CLIENTE+E1_PARCELA FROM SRVPP03.DADOSTOTVS11.dbo.SE1010 WHERE D_E_L_E_T_='' ) ) "   
	cQuery += " OR(LEN(LTRIM(TITNF.E1_PARCELA))<='1' AND TITNF.E1_NUM+TITNF.E1_CLIENTE+TITNF.E1_PARCELA	IN (SELECT E1_NUM+E1_CLIENTE+E1_PARCELA FROM SRVPP03.DADOSTOTVS11.dbo.SE1010 WHERE D_E_L_E_T_='' )))"  		// AND E1_SALDO>0
	  
	TCQuery cQuery Alias BXCH New
		
	Do While (! BXCH->(Eof()))

		nValCheq := BXCH->E5_VALOR
		lparcig := .f. //Parcela igual importada
		limp := .f.  //registro foi importado
	
		//Verificar se existe saldo em algum título do pedido	
		dbSelectArea("SE1")
		DbSetOrder(31)
		dbseek(xfilial("SE1")+BXCH->E5_NUMERO+SUBSTRING(BXCH->E5_PARCELA,2,1)) //+"T"+substring(BXCH->E5_DOCUMEN,2,5))  //Titulo+Parcela+Numliq

		Do While SE1->E1_NUM = BXCH->E5_NUMERO .and. SE1->E1_PARCELA = SUBSTRING(BXCH->E5_PARCELA,2,1) //verificar diferença de parcelas
			If SE1->E1_CLIENTE = BXCH->E5_CLIENTE //  limp := .f.
				conout("Tit.posicionado:"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA)
					
				nSaldoTit := SE1->E1_SALDO
				cNum  := SE1->E1_NUM
				cParc := SE1->E1_PARCELA
				cPref:= SE1->E1_PREFIXO
							
				dbSelectArea("SE5")
				DbSetOrder(2)
				dbseek(xfilial("SE5")+BXCH->E5_TIPODOC+cPref+cNum+cParc+BXCH->E5_DATA+BXCH->E5_CLIFOR)
	
	//Verifica se registro já existe. 
				if ! SE5->(found())
					conout("Gravando baixa CHeque SE5 "+BXCH->E5_TIPODOC+cPref+cNum+cParc+BXCH->E5_DATA+BXCH->E5_CLIFOR)
					RecLock("SE5",.T.)
					SE5->E5_FILIAL:=  xfilial("SE5")
					SE5->E5_TIPO:=  BXCH->E5_TIPO
					SE5->E5_PREFIXO:= cPref
					SE5->E5_NUMERO := cNum
					SE5->E5_PARCELA:= cParc
					SE5->E5_DATA:=  STOD(BXCH->E5_DATA)
					SE5->E5_TIPO:=  BXCH->E5_TIPO
					SE5->E5_MOEDA:=  BXCH->E5_MOEDA
					SE5->E5_BANCO:=  BXCH->E5_BANCO
					SE5->E5_AGENCIA:=  BXCH->E5_AGENCIA
					SE5->E5_CONTA:=  BXCH->E5_CONTA
					SE5->E5_NATUREZ:=  BXCH-> E5_NATUREZ
					IF BXCH->E5_MOTBX ='LIQ'  //Se for baixa por Liquidação,muda o código pra não gerar conflito com número E1_NUMLIQ do TOTVS.
						SE5->E5_DOCUMEN:=  "T"+SUBSTR(BXCH->E5_DOCUMEN,2,5)
					ENDIF
					SE5->E5_RECPAG:=  BXCH->E5_RECPAG
					SE5->E5_BENEF:=  BXCH->E5_BENEF
				//		SE5->E5_HISTOR:= Alltrim(strzero(BXCH->ID,10))+"-"+BXCH->E5_HISTOR+'-NF'+MOVNF->E5_PREFIXO+MOVNF->E5_NUMERO+MOVNF->E5_PARCELA
					SE5->E5_TIPODOC:=  BXCH->E5_TIPODOC
					SE5->E5_VALOR:=  BXCH->E5_VALOR //nValMov
					SE5->E5_CLIENTE:=  BXCH->E5_CLIENTE
					SE5->E5_CLIFOR:=  BXCH->E5_CLIFOR
					SE5->E5_LOJA:=  BXCH->E5_LOJA
					SE5->E5_DTDIGIT:=  STOD(BXCH->E5_DTDIGIT)
					SE5->E5_MOTBX:=  BXCH->E5_MOTBX
						//SE5->E5_SEQ:=  BXCH->E5_SEQ
					SE5->E5_DTDISPO:=  STOD(BXCH->E5_DTDISPO)
					SE5->E5_FILORIG:=  BXCH->E5_FILORIG
					SE5->E5_HORIMP :=Dtoc(date())+" "+ time()
					SE5->E5_IDMOVI := Alltrim(strzero(BXCH->ID,10))
					conout("Sucesso SE5 "+BXCH->E5_TIPODOC+"-"+cPref+cNum+cParc+BXCH->E5_DATA+BXCH->E5_CLIFOR+"-Valor="+str(BXCH->E5_VALOR))
					SE5->(MsUnlock())
			
					limp := .t.
						
				EndIf
		
	//Atualiza status do título Origem
				/*		conout("Atualizando titulo origem "+cPref+"-"+cNum+"-"+cParc)
						IF SE1->E1_SALDO*1.10 >= BXCH->E5_VALOR .AND. Alltrim(SE1->E1_NUM)=Alltrim(cNum)
							RecLock("SE1",.f.)
							SE1->E1_BASCOM5 := SE1->E1_SALDO
							conout("Valor Saldo Anterior ="+str(SE1->E1_SALDO)+" Valliq="+str(E1_VALLIQ))
							IF SE1->E1_SALDO >= BXCH->E5_VALOR
								SE1->E1_SALDO := SE1->E1_SALDO - BXCH->E5_VALOR
							Else
								SE1->E1_SALDO := 0
							EndIf
							SE1->E1_VALLIQ:= SE1->E1_VALLIQ + BXCH->E5_VALOR
							conout("Valor Saldo Novo ="+str(SE1->E1_SALDO)+" Valliq="+str(E1_VALLIQ))
							SE1->E1_BAIXA := ddatabase
							SE1->E1_HORIMP:="At."+ Dtoc(date())+"-"+time()
							SE1->(MsUnlock())
						Else
							conout("Titulo sem saldo ou incorreto: "+SE1->E1_NUM+"-"+SE1->E1_PARCELA )
						EndIf
			*/
			EndIF
			SE1->(dbskip())
		EndDo
		
		BXCH->(dbskip())
	EndDo
	dbCloseArea("BXCH")
	conout(Dtoc(date())+" "+ time()+"-Fim fase 5-Importando baixas de cheques")
Return

/*
//**************************************************
//     ATUALIZA ALTERAÇOES EM TÍTULOS
//**************************************************
*/
Static Function AtualizaTitulos()

//Atualizações no Título do Cheque e Fatura - Finalizado
/*	cQuery := "UPDATE SRVPP03.DADOSTOTVS11.dbo.SE1010 SET E1_BAIXA = A.E1_BAIXA, E1_MOVIMEN= A.E1_MOVIMEN, E1_SALDO = A.E1_SALDO, E1_VALLIQ = A.E1_VALLIQ, E1_STATUS = A.E1_STATUS, E1_JURFAT='Atualizado '+CAST(GETDATE() AS varchar(19)) "
	cQuery += " FROM SRVPP01.DADOS12.dbo.SE1010 A  INNER JOIN SRVPP03.DADOSTOTVS11.dbo.SE1010 B ON  A.E1_NUM=B.E1_NUM AND  A.E1_CLIENTE=B.E1_CLIENTE "
	cQuery += " AND SUBSTRING(A.E1_NUMLIQ,2,5) = SUBSTRING(B.E1_NUMLIQ,2,5) AND SUBSTRING(A.E1_PARCELA, 2,1)=B.E1_PARCELA WHERE E1_HORIMP<>''"  //AND A.E1_NUMLIQ<>''      
	cQuery += " AND ( A.E1_BAIXA <> B.E1_BAIXA  OR A.E1_SALDO <> B.E1_SALDO OR A.E1_VALLIQ <> B.E1_VALLIQ OR A.E1_BAIXA <> B.E1_BAIXA OR A.E1_STATUS <> B.E1_STATUS) "
	//cQuery += "A.E1_EMISSAO >='"+ cDataIni +"' AND E5_DATA <='"+ cDataFim +"' "    //AND A.E1_BAIXA >="+ dtos(ddatabase-10)  
	cQuery += " AND A.E1_PEDIDO IN ( SELECT  C5_NUM FROM SRVPP03.DADOSTOTVS11.dbo.SC5010 WHERE C5_NUM >='"+PedIni +"' AND C5_NUM <='"+PedIni +"' AND C5_ROMANEI >='"+RomIni +"' AND C5_ROMANEI <='"+RomFim +"' )"
	TCSQLexec(cQuery)
	conout(Dtoc(date())+" "+ time()+"Atualizados campos dos títulos SE1")


//Atualização de cheque
	cQueryc := "UPDATE SRVPP03.DADOSTOTVS11.dbo.SEF010 SET EF_ALINEA1=B.EF_ALINEA1, EF_DTALIN1=B.EF_DTALIN1, EF_ALINEA2=B.EF_ALINEA2, EF_DTALIN2=B.EF_DTALIN2, EF_DTREPRE=B.EF_DTREPRE, EF_CHDEVOL=B.EF_CHDEVOL, D_E_L_E_T_=B.D_E_L_E_T_ "
	cQueryc += " FROM SRVPP03.DADOSTOTVS11.dbo.SEF010 A inner join SRVPP01.DADOS12.dbo.SEF010 B ON A.EF_BANCO+A.EF_AGENCIA+A.EF_CONTA+A.EF_NUM+A.EF_TITULO+A.EF_CLIENTE =B.EF_BANCO+B.EF_AGENCIA+B.EF_CONTA+B.EF_NUM+B.EF_TITULO+B.EF_CLIENTE"
	cQueryc += " WHERE A.EF_TIPO IN ('CH ','FAT')  AND A.EF_HORIMP<>'' AND (A.EF_ALINEA1<>B.EF_ALINEA1 OR A.EF_DTALIN1 <> B.EF_DTALIN1 OR A.EF_ALINEA2 <> B.EF_ALINEA2 OR  A.EF_DTALIN2<>B.EF_DTALIN2 OR  A.EF_DTREPRE<>B.EF_DTREPRE OR A.EF_CHDEVOL<>B.EF_CHDEVOL OR A.D_E_L_E_T_<>B.D_E_L_E_T_)"
	//cQueryc += " AND a.EF_TITULO IN ( SELECT  C5_SERIE+C5_NUM FROM SRVPP03.DADOSTOTVS11.dbo.SC5010 WHERE C5_NUM >='"+PedIni +"' AND C5_NUM <='"+PedIni +"' AND C5_ROMANEI >='"+RomIni +"' AND C5_ROMANEI <='"+RomFim +"' )"
	//Queryc +=" AND A.EF_DATA >='"+ cDataIni+"' AND A.EF_DATA <='"+ cDataFim +"'"  
	cQueryc += " AND A.EF_DATA >= '" + dtos(ddatabase-180) +"'" 
 
	TCSQLexec(cQueryc)
	conout(Dtoc(date())+" "+ time()+"Atualizados campos dos cheques SEF")
*/	
	
//Atualiza condição de pagamento do TOTVS, caso for alterado no OFICIAL após importação.	
	cQuery := "UPDATE SRVPP03.DADOSTOTVS11.dbo.SC5010 SET C5_CONDPAG=B.C5_CONDPAG FROM  SRVPP03.DADOSTOTVS11.dbo.SC5010 A INNER JOIN SRVPP01.DADOS12.dbo.SC5010 B ON A.C5_NUM=B.C5_NUM "
	cQuery += " WHERE A.C5_NUM <'900000' AND B.C5_NUM <'900000' AND A.C5_NOTA='' AND B.C5_NOTA<>'' AND   A.C5_CONDPAG<>B.C5_CONDPAG AND A.D_E_L_E_T_='' AND B.D_E_L_E_T_='' "
	cQuery += " AND C5_NUM >='"+PedIni +"' AND C5_NUM <='"+PedIni +"' AND C5_ROMANEI >='"+RomIni +"' AND C5_ROMANEI <='"+RomFim +"'"
	//cQuery += " AND (A.C5_EMISSAO >='"+ cDataIni +"' AND A.C5_EMISSAO <='"+ cDataFim +"') "
	//cQuery += " OR (A.C5_EMISSAO >='"+ dtos(ddatabase-180)+"' )) "
		//conout(cQuery)
	TCSQLexec(cQuery)
	conout(Dtoc(date())+" "+ time()+"- Atualizadas condições de pagto dos pedidos.")
Return


Static Function ExcluiMov()

//Exclusão de titulos já excluidos no OFICIAL.	- 
/*	cQuery := 	"UPDATE SRVPP03.DADOSTOTVS11.dbo.SE1010 SET D_E_L_E_T_=A.D_E_L_E_T_ , E1_FILIAL='' "
	cQuery +=    "FROM SRVPP01.DADOS12.dbo.SE1010 A  INNER JOIN SRVPP03.DADOSTOTVS11.dbo.SE1010 B ON  A.E1_NUM=B.E1_NUM AND  A.E1_CLIENTE=B.E1_CLIENTE "
	cQuery += 	"AND SUBSTRING(A.E1_NUMLIQ,2,5) = SUBSTRING(B.E1_NUMLIQ,2,5) AND SUBSTRING(A.E1_PARCELA, 2,1)=B.E1_PARCELA "
	cQuery += 	"WHERE E1_HORIMP<>'' AND  A.D_E_L_E_T_ <> B.D_E_L_E_T_ "  // A.E1_NUMLIQ<>'' AND
	cQuery +=  " AND A.E1_EMISSAO >="+ dtos(ddatabase-180)
	//cQuery += " AND A.E1_EMISSAO >='"+ cDataIni+"' AND E5_DATA <='"+ cDataFim +"' "  
	TCSQLexec(cQuery)
	conout(Dtoc(date())+" "+ time()+" Excluídos titulos já excluídos no OFICIAL.")

	cQuery := "DELETE FROM SRVPP03.DADOSTOTVS11.dbo.SE1010 WHERE D_E_L_E_T_='*' AND E1_NUMRA<>'' AND E1_SALDO=E1_VALOR"
	TCSQLexec(cQuery)
	conout(Dtoc(date())+" "+ time()+" Apagados títulos excluídos que foram importados.")
*/

	//cQuery := "DELETE FROM SRVPP03.DADOSTOTVS11.dbo.SE5010 WHERE E5_HORIMP<>''  AND CAST(E5_IDMOVI AS INT) IN "
	//cQuery += " (SELECT R_E_C_N_O_  FROM SRVPP01.DADOS12.dbo.SE5010 WHERE E5_MOTBX='LIQ' AND ( D_E_L_E_T_='*' OR E5_SITUACA<>'') AND E5_DATA >='20190101') " 
	
cQuery := "UPDATE SRVPP03.DADOSTOTVS11.dbo.SE5010 SET D_E_L_E_T_ = '*'   FROM SRVPP03.DADOSTOTVS11.dbo.SE5010 A INNER JOIN SRVPP03.DADOSTOTVS11.dbo.SC5010 B " 
cQuery += " ON A.E5_NUMERO = B.C5_NOTA WHERE E5_HORIMP<>'' AND C5_NUM >='"+PedIni +"' AND C5_NUM <='"+PedIni +"' AND C5_ROMANEI >='"+RomIni +"' AND C5_ROMANEI <='"+RomFim +"'"
cQuery += " AND CAST(E5_IDMOVI AS INT) IN  (SELECT R_E_C_N_O_  FROM SRVPP01.DADOS12.dbo.SE5010 WHERE E5_MOTBX='LIQ' AND ( D_E_L_E_T_='*' OR E5_SITUACA<>'') AND E5_DATA >='20190101') "
TCSQLexec(cQuery)


cQuery := "UPDATE SRVPP03.DADOSTOTVS11.dbo.SE1010 SET E1_BASCOM3 = E1_SALDO FROM SE1010 A LEFT OUTER JOIN TIT_SALDO B "
cQuery += " ON A.E1_NUM=B.E5_NUMERO AND A.E1_PREFIXO=B.E5_PREFIXO AND A.E1_PARCELA=B.E5_PARCELA"
cQuery += " WHERE D_E_L_E_T_='' AND E1_TIPO IN ('NF','NP') "
cQuery += " AND ROUND(E1_VALOR+ISNULL(ROUND(ACRESC,2),0)-ISNULL(ROUND(BAIXAS,2),0),2)-E1_SALDO <> 0"
cQuery += " AND E1_PEDIDO IN ( SELECT  C5_NUM FROM SRVPP03.DADOSTOTVS11.dbo.SC5010 WHERE C5_NUM >='"+PedIni +"' AND C5_NUM <='"+PedIni +"' AND C5_ROMANEI >='"+RomIni +"' AND C5_ROMANEI <='"+RomFim +"' )"
TCSQLexec(cQuery)

cQuery := "UPDATE SRVPP03.DADOSTOTVS11.dbo.SE1010 SET  E1_SALDO= ROUND(E1_VALOR+ISNULL(ROUND(ACRESC,2),0)-ISNULL(ROUND(BAIXAS,2),0),2), E1_VALLIQ=ISNULL(ROUND(BAIXAS,2),0),2) FROM SE1010 A LEFT OUTER JOIN "
cQuery += " TIT_SALDO B ON A.E1_NUM=B.E5_NUMERO AND A.E1_PREFIXO=B.E5_PREFIXO AND A.E1_PARCELA=B.E5_PARCELA"
cQuery += " WHERE D_E_L_E_T_='' AND E1_TIPO IN ('NF','NP')"
cQuery += " AND ROUND(E1_VALOR+ISNULL(ROUND(ACRESC,2),0)-ISNULL(ROUND(BAIXAS,2),0),2)-E1_SALDO <> 0 "
cQuery += " AND E1_PEDIDO IN ( SELECT  C5_NUM FROM SRVPP03.DADOSTOTVS11.dbo.SC5010 WHERE C5_NUM >='"+PedIni +"' AND C5_NUM <='"+PedIni +"' AND C5_ROMANEI >='"+RomIni +"' AND C5_ROMANEI <='"+RomFim +"' )"
TCSQLexec(cQuery)

conout(Dtoc(date())+" "+ time()+"- Apagados movimentos importados e excluídos no OFICIAL.")

Return

/*
Static Function AtualizTitBol()

cQuery := "UPDATE SRVPP03.DADOSTOTVS11.dbo.SE1010 SET E1_HIST='BOLETO BB GERADO'"
cQuery += " FROM SRVPP03.DADOSTOTVS11.dbo.SE1010 A  INNER JOIN SRVPP01.DADOS12.dbo.SE1010 B ON  A.E1_PEDIDO=B.E1_PEDIDO AND  A.E1_CLIENTE=B.E1_CLIENTE AND A.E1_PARCELA = B.E1_PARCELA --SUBSTRING(A.E1_PARCELA, 2,1)=B.E1_PARCELA 
cQuery += " WHERE  B.D_E_L_E_T_='' AND  A.E1_SALDO > 0 AND B.E1_HIST ='BOLETO BB GERADO' AND B.E1_TIPO ='NF' AND A.E1_HIST='' AND A.E1_PEDIDO <>'' AND A.E1_EMISSAO >='20190701' "
TCSQLexec(cQuery)
	conout(Dtoc(date())+" "+ time()+"- Atualizado histórico de titulos de Boleto.")

Return
*/

/*
Static Function AtualizaRoman()

cQuery := " UPDATE SRVPP01.DADOS12.dbo.SC5010 SET C5_ROMANEI=B.C5_ROMANEI, C5_ROMIT=B.C5_ROMIT "
cQuery += " FROM SRVPP01.DADOS12.dbo.SC5010 A INNER JOIN SRVPP03.DADOSTOTVS11.dbo.SC5010 B "
cQuery += " ON A.C5_NUM = B.C5_NUM WHERE A.C5_EMISSAO >= '20190701' AND B.C5_ROMANEI<>''  and A.C5_ROMANEI='' "
cQuery += " AND B.C5_ROMANEI IN (SELECT Z1_NUM  FROM SRVPP01.DADOS12.dbo.SZ1010 WHERE Z1_ITEM='01' AND Z1_DTFECH='' AND D_E_L_E_T_='')"
TCSQLexec(cQuery)

Return
*/

/*
//************************************************************
//    EXCLUI MOVIMENTOS NO TOTVS APOS ESTORNO NO OFICIAL  ****
//************************************************************
*/
User Function EnvMailimp( cTo, cAssunto, cMensagem )
 
	Local cQuery    := ""
	Local cData
	Local cServer   := AllTrim(GetNewPar("MV_RELSERV"," "))
	Local cAccount := AllTrim(GetNewPar("MV_RELACNT"," "))
	Local cPassword := AllTrim(GetNewPar("MV_RELPSW" ," "))
	Local lSmtpAuth := GetMv("MV_RELAUTH",,.F.)
	Local cFrom     := cAccount
	Local cCC     := ""
	Local lOk       := .T.
	Local lAutOk    := .F.
             
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lOk
	If !lAutOk
		If ( lSmtpAuth )
			lAutOk := MailAuth(cAccount,cPassword)
		Else
			lAutOk := .T.
		EndIf
	EndIf
                          
	If lOk .and. lAutOk
		SEND MAIL FROM cFrom TO cTo CC cCC SUBJECT cAssunto BODY cMensagem RESULT lOk //lEnviado
	
		If lOk
			ConOut("Email enviado com sucesso")
		Else
			GET MAIL ERROR cErro
			ConOut("Não foi possível enviar o Email." +Chr(13)+Chr(10)+ cErro)
			Return .f.
		EndIf
	Else
		GET MAIL ERROR cErro
		Conout("Erro na conexão com o SMTP Server." +Chr(13)+Chr(10)+ cErro)
		Return .f.
	EndIf
	DISCONNECT SMTP SERVER

Return

 	