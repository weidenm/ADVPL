#include "topconn.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#include "TBICONN.CH"
#include "TBICODE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTELAPROD1 ver. 6.0 บAutor  ณ  Weiden Mendes Data ณ 27/07/15 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para realizar impressใo de etiquetas e            บฑฑ
ฑฑบ          ณ  apontamento de produ็ใo.                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบVersใo    ณ  3.14 - Alterada posi็๕es dos textos devido restaura็ใo	  บฑฑ
ฑฑ 12.1.25		de fแbrica da impressora t้rmica.						  บฑฑ
				5.0 - Inclusใo de etiqueta de devolu็ใo                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//User Function FormAponta()
User Function SIGATEC()
 	//DECLARAR COMO STATIC TODAS VARIAVEIS DE PARยMETRO DE FUNวรO.
	Static NumOP
	Static _NumOP
	Static oDlg
	Static BmpLogo
	Static oBtnAponta
	Static oBtnImprimir
	Static oFont1 := TFont():New("MS Sans Serif",,024,,.T.,,,,,.F.,.F.)
	Static oFont2 := TFont():New("MS Sans Serif",,020,,.T.,,,,,.F.,.F.)
	Static oFont3 := TFont():New("MS Sans Serif",,020,,.F.,,,,,.F.,.F.)
	Static oFont4 := TFont():New("MS Sans Serif",,026,,.T.,,,,,.F.,.F.)
	Static oSay1
	Static oSay2
	Static oSay3
	Static oSay4
	Static oSayNmApont
	Static oSayDescTurma
	Static oSay7
	Static oSayLinha
	Static oSayResp
	Static oSayTurma
	Static _nTipoEtq
	Public _nImpress
	Public _nPorta
	Public _nPadraoBar
	Static cTurma

//CRIA PARAMETROS PARA IMPRIMIR ETIQUETAS
	aPerg := {}
	cPerg := "IMPETQ"

	Pergunte(cPerg,.F.)

	_nImpress := 	Mv_Par01
	_nPorta   := 	Mv_Par02
	_nPadraoBar:= 	Mv_Par03

// sintaxe para o acionar uma fun็ใo a partir de uma tecla de atalho... Fun็ใo utilizada: SetKey

	//SetKey(115 ,{|| u_PrintEtq() })  // Habilita com F4
	//SetKey(116 ,{|| u_reimp() })  // Habilita com F5
	//SetKey(119 ,{|| u_ApontaCodBarras() })  // Habilita com F8

//Os outros c๓digos das outras teclas sใo: F5=116, 117=F6, 118=F7 e assim vai...
//  Para desabilitar a tecla: Set Key 115 To

//FILTRA O NฺMERO DA ORDEM DE PRODUวรO DO DIA (A MAIS RECENTE)
	cQry := "SELECT MAX(C2_NUM) C2_NUM "
	cQry += " FROM SC2010"
	cQry += " WHERE D_E_L_E_T_='' AND C2_DATPRI <= '" + dtos(ddatabase) + "' and C2_DATPRF >= '" + dtos(ddatabase) + "' AND C2_ITEM = '01'"
	cQry += " ORDER BY C2_NUM DESC"

	cQry := ChangeQuery(cQry)
	TCQUERY cQry NEW ALIAS "OP"

	NumOP := OP->C2_NUM
	cTurma := pswret(1)[1][12]

	DEFINE MSDIALOG oDlg TITLE "Etiquetamento e apontamento de Produ็ใo  6.0 - PLINC " FROM 000, 000  TO 500, 800 COLORS 0, 16777215 PIXEL

	@ 000, 004 BITMAP BmpLogo SIZE 143, 045 OF oDlg1 FILENAME "\\srvpp02\Microsiga\protheus_data\system\logoRel.bmp" NOBORDER PIXEL
	@ 008, 090 SAY oSay1 PROMPT "OP:" SIZE 022, 017 OF oDlg FONT oFont4 COLORS 0, 16777215 PIXEL
	@ 008, 110 SAY oSay2 PROMPT NumOP SIZE 049, 010 OF oDlg FONT oFont4 COLORS 0, 16777215 PIXEL
	@ 025, 090 SAY oSayResp PROMPT "Encarregado:" SIZE 060, 011 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 025, 150 SAY oSay4 PROMPT pswret(1)[1][2] SIZE 060, 011 OF oDlg FONT oFont3 COLORS 0, 16777215 PIXEL
	@ 040, 200 SAY oSayTurma PROMPT "Turma:" SIZE 032, 011 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 040, 230 SAY oSayDescTurma PROMPT cTurma SIZE 021, 011 OF oDlg FONT oFont3 COLORS 0, 16777215 PIXEL
	@ 040, 090 SAY oSayLinha PROMPT "Apontador:" SIZE 049, 012 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 040, 135 SAY oSayNmApont PROMPT pswret(1)[1][4] SIZE 060, 011 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	u_Grid()
	//@ 010, 220 BUTTON oBtnCancel2 PROMPT "Cancela outro Lote" SIZE 051, 013 OF oDlg ACTION (u_ExcFardoBarras()) PIXEL
	//@ 010, 220 BUTTON oBtnReimp PROMPT "Etiq. Devolvidos" SIZE 051, 013 OF oDlg ACTION (ImpSub(2))  PIXEL
	@ 010, 280 BUTTON oBtnReimp PROMPT "Etiq. Substitui็ใo" SIZE 051, 013 OF oDlg ACTION (ImpSub(1)) PIXEL
	@ 010, 341 BUTTON oBtnCancel PROMPT "Cancelamento" SIZE 051, 013 OF oDlg ACTION (u_ExcFardoBarras()) PIXEL
	@ 025, 280 BUTTON oBtnParam PROMPT "Parametros" SIZE 051, 013 OF oDlg ACTION Pergunte(cPerg,.T.,"Configura็ใo de Impressora") PIXEL
	@ 025, 341 BUTTON oBtnImprimir PROMPT "Impressใo" SIZE 051, 013 OF oDlg ACTION (u_PrintEtq()) PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	OP->(DbCloseArea())

Return

//***********************************************
//  Grid da tela inicial - Ordem de Produ็ใo
//***********************************************

User Function Grid()

	nX := 0
	aHeaderEx := {}
	aColsEx := {}
	aFieldFill := {}
	aFields := {}
	aAlterFields := {}
	cQry := ""
	aDados := {}

	Public oMSNewGe1

	AADD(aFields,{"Ordem Producao" ,"OP"    ,"" ,15 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Item OP" ,"ITEM"    ,"" ,3 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Cod. Produto" ,"CODIGO"    ,"" ,7 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Descricao" ,"DESCRI"    ,"" ,40 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Quantidade"  ,"QUANT"   ,"" ,09 ,2, ,"๛","N","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Produzido"  ,"PRODUZIDO"   ,"" ,09 ,2, ,"๛","N","" ,"V",  ,  ,".F."} )

	
//CONSULTA DE DADOS PARA O GRID
	cQry := "SELECT C2_NUM,C2_ITEM,C2_PRODUTO,B1_DESC, SALDO"
	if cTurma = "A" .or. cTurma = "B"
		cQry += "  ,PRODTURMA"+Alltrim(cTurma)+" AS QTDAPONT"
	else	
		cQry += "  , PRODTURMAA+PRODTURMAB AS QTDAPONT"
	EndIf
	cQry += " FROM EST_APONTADO WHERE C2_NUM = '" + Alltrim(NumOP) + "'  ORDER BY B1_GRUPO, B1_DESC "

	cQry := ChangeQuery(cQry)
	TCQUERY cQry NEW ALIAS "TR"

	While !TR->(Eof())
		Aadd(aDados,{ TR->C2_NUM,;
			TR->C2_ITEM,;
			TR->C2_PRODUTO,;
			TR->B1_DESC,;
			TR->SALDO,;
			TR->QTDAPONT})
	
		TR->(DbSkip())
	
	End

	TR->(DbCloseArea())

	For I:= 1 To Len(aDados)
		AADD(aColsEx,Array(Len(aFields)+1))
		nLin := Len(aColsEx)
	
		aColsEx[nLin,01] := aDados[i][1]
		aColsEx[nLin,02] := aDados[i][2]
		aColsEx[nLin,03] := aDados[i][3]
		aColsEx[nLin,04] := aDados[i][4]
		aColsEx[nLin,05] := Transform(aDados[i][5],"@E 999,999,999")
		aColsEx[nLin,06] := Transform(aDados[i][6],"@E 999,999,999")
	
		aColsEx[nLin,Len(aFields)+1] := .F.
	Next

	oMSNewGe1 := MsNewGetDados():New( 057, 005, 250, 396,, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2",,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aFields, aColsEx)
	oMSNewGe1:oBrowse:refresh()
	oMSNewGe1:oBrowse:setfocus()
Return( Nil )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPRINTETQ บAutor  ณMicrosiga           บ Data ณ  10/13/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime as etiquetas dos c๓digos de barras.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PrintEtq()

	Static oDlg1
	Static oBtnOK
	Static oFont1 := TFont():New("MS Sans Serif",,018,,.F.,,,,,.F.,.F.)
	Static oGetQuant
	Static nGetQuant := 0
	Static oSay1
	Static oSayDescProd
	Static oSayQuant
	pos := oMSNewGe1:nAt
	cOPetq := oMSNewGe1:aCols[pos][1]+oMSNewGe1:aCols[pos][2]

	

	DEFINE MSDIALOG oDlg1 TITLE "Impressใo de etiquetas" FROM 000, 000  TO 130, 450 COLORS 0, 16777215 PIXEL
	@ 007, 003 SAY oSay1 PROMPT "Produto:" SIZE 032, 017 OF oDlg1 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 007, 038 SAY oSayDescProd PROMPT trim(oMSNewGe1:aCols[pos][3]) + " - " + trim(oMSNewGe1:aCols[pos][4])  SIZE 237, 010 OF oDlg1 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 028, 004 SAY oSayQuant PROMPT "Quantidade:" SIZE 036, 007 OF oDlg1 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 025, 058 MSGET oGetQuant VAR nGetQuant SIZE 089, 012 OF oDlg1 COLORS 0, 16777215 FONT oFont1 PIXEL PICTURE "@E 999,999" VALID nGetQuant > 0.00
	DEFINE SBUTTON oBtnOK FROM 047, 192 TYPE 01 OF oDlg1 ENABLE ACTION (EtiqOP(nGetQuant,cOPetq,Alltrim(pswret(1)[1][12])),oDlg1:End())

	ACTIVATE MSDIALOG oDlg1 CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTELAPROD1 บAutor  ณMicrosiga           บ Data ณ  10/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Fun็ใo que imprime as etiquetas.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EtiqOP(_nQuant,_cOP,_cTurma )

	Local cPorta
	Local cPrinter

	Public cNumFardo	:= ""
	Public Numerac	   := 0
	//Public NumIni		:= 0
	
	cOP		   := ""
	cFardo		:= ""
	nQuant     := _nQuant
	cOP		   := _cOP
	Turma	   := _cTurma
	nTurma	   := ""
	_cDoc := ""
	nApontSucess := 0
	nApontErro := 0
	nQtdEstorno := 0
	nImprEtiq := 0
	nQtdTotal := 0
	aProd := {}
	cLoteEtq:= DataLoteEtq()
	
//Valida็ใo de quantidade permitida a imprimir por vez.
	IF SUBSTR(SB1->B1_GRUPO,1,2)<>'13'
		if nQuant > 50
			MSGSTOP("Digitar quantidade menor que 50 para impressใo desse produto.")
			u_printetq()
			Return
		EndIf
	ELSE
		if nQuant > 200 //PRODUTOS DO GRUPO DE TERCEIROS
			MSGSTOP("Digitar quantidade menor que 200 para impressใo desse produto.")
			u_printetq()
			Return
		EndIf
	ENDIF


//VERIFICAวีES PARA CONFIRMAR REIMPRESSรO.
//Caso campo da etiqueta nใo tenha sido preenchido.
	if Alltrim(cOP)+ Alltrim(cFardo) = ""
		Return
	else
	//TELA PARA CONFIRMAR IMPRESSรO
		if  ! MSGYESNO("Deseja realmente imprimir?", "Confirma็ใo")
			Return
		endif
	endif
		
	dbSelectArea("SC2")
	dbseek(xfilial("SC2")+cOP+"001")
	
	If  SC2->(found())
		nQtdTotal := SC2->C2_QUANT
		
		dbSelectArea("SB1")
		DbSetOrder(1)
		dbseek(xfilial("SB1")+SC2->C2_PRODUTO)
	
		cCodBarProd := Alltrim(SB1->B1_CODBAR)
		cCodProd := SB1->B1_COD
		cDescProd := SB1->B1_DESC
		cUM := SB1->B1_UM
		cGrupo := SB1->B1_GRUPO
			
		cQry := "SELECT Z3_NUMOP,Z3_ITEMOP,MAX(Z3_NUMERAC) NUM FROM SZ3010"
		cQry += " WHERE Z3_NUMOP = '" + Substr(cOP,1,6) + "' AND Z3_ITEMOP='" + Substr(cOP,7,2)+"'"
		cQry += " GROUP BY Z3_NUMOP,Z3_ITEMOP"
		
		cQry := ChangeQuery(cQry)
		TCQUERY cQry NEW ALIAS "ULFAR"
	
		Numerac :=  val(ULFAR->NUM)
	
		ULFAR->(DbCloseArea())
	
	//BUSCA ฺLTIMO NฺMERO DE DOCUMENTO (D3_DOC) NO ARQUIVO DE MOVIMENTAวีES - 13/09/16
		cQry := "select ISNULL(MAX(D3_DOC),'0') AS DOC "
		cQry += " from SD3010"
		cQry += " Where D3_DOC >'P' AND D3_DOC <='P9999999'"
		
		cQry := ChangeQuery(cQry)
		TCQUERY cQry NEW ALIAS "ULDOC"
		if ULDOC->DOC <> '0'
			_cDoc := 'P'+ strzero(val(SUBSTR(ULDOC->DOC,2,7))+1,7) //calcula o pr๓ximo numero de documento
		ELSE
			_cDoc := 'P0000001'
		EndIf
		
		ULDOC->(DbCloseArea())
		
		if _nImpress = 1
			cPrinter := "DATAMAX"
		else
			cPrinter := "ELTRON"
		endif
	
		if _nPorta   = 1
			cPorta   := "LPT1"
		elseif  _nPorta = 2
			cPorta   := "LPT2" //USB mapeada pelo NET USE
		elseif  _nPorta = 3
			cPorta := "LPT3"
		endif

//***** CONFIGURAวีES PARA TESTE EM ZEBRA *************	
//	_nImpress:=2 			//APENAS PARA TESTES. RETIRAR ANTES DE POR EM PRODUวรO.
//	cPrinter:="ELTRON"  //APENAS PARA TESTES. RETIRAR ANTES DE POR EM PRODUวรO.
//*********************************************************************************
	
		if _nPadraoBar  = 1 //CODE 128
			cPadraoBar   := "MB07"
		elseif  _nPadraoBar = 2 //EAN 13
			cPadraoBar   := "MB04"
		elseif  _nPadraoBar = 3 //Interleaved
			cPadraoBar := "MB01"
		elseif _nPadraoBar = 4 //Code 39
			cPadraoBar := "MB02"
		endif
	
		MSCBPRINTER(cPrinter,cPorta, , , .F., , , , ,,.f. , )
	
		IncProc("Imprimindo "+Alltrim(SC2->C2_NUM)+" "+Alltrim(SC2->C2_ITEM)+" "+cPorta)
	
	//co1 := Alltrim(SB1->B1_COD)+" - "+Alltrim(SB1->B1_DESC) //Descri็ใo
	
	//	cDataFab := dtoc(date())
		cDataFab :=Dtoc(dDataBase)
		
		IF  Alltrim(cGrupo) =="1209" //Suco
			//cDataVal := dtoc(date()+120) //Validade 4 meses
			cDataVal := dtoc(dDataBase+180) //Validade 4 meses
		Else
			//cDataVal := dtoc(date()+180) //Validade 6 meses
			cDataVal := dtoc(dDataBase+180) //Validade 6 meses
		EndIf
		
		//_cDoc := time() //PENSAR EM INFORMAวรO MELHOR PARA NUMERO DE DOCUMENTO.

//*******************************************************
//**** APONTAMENTO DA PRODUวรO DE  ETIQUETA IMPRESSAS ***
//*******************************************************
		lMsErroAuto := .F.
		cModulo = "PCP"
		nModulo = 10
		nOpc := 3
	
		_aInf:={{"D3_TM" ,"001"                   ,Nil},;
			{"D3_OP"           ,cOP+"001"       ,Nil},;
			{"D3_COD"         ,cCodProd                ,Nil},;
			{"D3_UM"           ,cUM     ,Nil},;
			{"D3_QUANT"     , nQuant             ,Nil},;
			{"D3_LOCAL"      ,"01" ,Nil},;
			{"D3_DOC"         ,_cDoc            ,Nil},;
			{"D3_EMISSAO" ,dDataBase          ,Nil},;
			{"D3_HORA" ,time()          ,Nil},;
			{"D3_CHAVE" ,"R0"          ,Nil},;
			{"D3_CF" ,"PR0"          ,Nil}}
	
		MSExecAuto({|x,y| Mata250(x,y)},_aInf,3)
		
//*******************************************************
//**** IMPRESSรO DE ETIQUETAS COM CำDIGO DE BARRAS    ***
//*******************************************************	
		If !lMsErroAuto
			cont		:= 0
			MSCBCHKStatus(.f.)
			
			While  cont < nQuant
			
				if Numerac >= nQtdTotal
					MSGSTOP("Excedeu a quantidade da OP. Solicitar inclusใo de novo item.")
					Exit
				EndIf
				
				Numerac := Numerac + 1
				cNumFardo := strzero(Numerac,4)
				lote:= Alltrim(SC2->C2_NUM)+ Alltrim(SC2->C2_ITEM)
				cb1 := left(lote+cNumFardo,13)
				//cCodBarProd := Alltrim(SB1->B1_CODBAR)
								
				if _nImpress = 1 //ALLEGRO
					MSCBBEGIN(1,6)
						MSCBSAYBAR ( 05, 05 , cb1 , 'N',"MB04",08,,.T.,,,3,2.5) // LOTE (OP) + FARDO
							
					if Alltrim(cGrupo) $ "1207" //.or. Alltrim(cCodProd) == "PA8215"
						//MSCBSAYBAR ( 05, 20 , cCodBarProd , 'N',"MB01",06,,.T.,,,2,2) //EAN14 OFICIAL												
						MSCBSAYBAR ( 05, 17 , cCodBarProd , 'N',"MB04",08,,.T.,,,2,2) // BARRAS DO PRODUTO
					EndIf
					
					//Imprime data de fabrica็ใo, validade e lote no grupo 1204, 1205,1203
					if ((Alltrim(cGrupo) =="1204" .OR. Alltrim(cGrupo) =="1205" .OR. Alltrim(cGrupo) =="1203"  .OR. Alltrim(cGrupo) =="1209") .and. Alltrim(cUM)== "CX")
						MSCBSAY(01,30,Alltrim(cCodProd)+ "-"+Alltrim(cDescProd),"N","3","1,0")
						MSCBSAY(50,22,"Turma: "+ Turma,"N","1","2,2")
						MSCBSAY(50,18,"F: ","N","1","2,2")
						MSCBSAY(55,18,cDataFab,"N","1","2,2")
						MSCBSAY(50,13,"V: ","N","1","2,2")
						MSCBSAY(55,13,cDataVal,"N","1","2,2")
						MSCBSAY(50,8,"Lote: ","N","1","2,2")
						
				
						IF Alltrim(cGrupo) =="1203"  .OR. Alltrim(cGrupo) =="1209"
							MSCBSAY(61,8,lote,"N","1","2,2")  //Formato DDMMAA+IT
						Else
							MSCBSAY(61,8,cLoteEtq,"N","1","2,2") //Formato dia do ano DDD (3 digitos)
						EndIf
						MSCBEND()
					EndIf
									
					MSCBSAY(01,30,Alltrim(cCodProd)+ "-"+Alltrim(cDescProd),"N","3","1,0")
					MSCBSAY(50,22,"Turma: "+ Turma,"N","1","2,2")
					MSCBSAY(50,15,"Fabricacao: ","N","1","2,2")
					MSCBSAY(50,10,cDataFab,"N","1","2,2")
					MSCBSAY(50,06, _cDoc,"N","1","2,2")
					MSCBEND()
					nImprEtiq := nImprEtiq + 1
					
					if Alltrim(cGrupo) == "1208"
						nPcte := 1
						while nPcte <= 5
							MSCBBEGIN(1,6) //01/01/16 - Diminuido 2 pontos na posi็ใo da linha.
							MSCBSAYBAR ( 05, 15 , cCodBarProd , 'N',"MB04",08,,.T.,,,2,2) // original
							MSCBSAY(07,08,"Lote: "+lote,"N","2","0.8,0")
							MSCBSAY(03,28,Alltrim(cCodProd)+ "-"+Alltrim(cDescProd),"N","2","1,0")
							MSCBSAY(50,22,"Validade: ","N","1","2,2")
							MSCBSAY(50,17,cDataVal,"N","1","2,2")
							MSCBSAY(50,09,"Fabricacao: ","N","1","2,2")
							MSCBSAY(50,06,cDataFab,"N","1","2,2")
							MSCBSAY(50,03, _cDoc,"N","1","2,2")
							MSCBEND()
							nPcte += 1
						EndDo
					EndIf
					
		/*		else
					if _nImpress = 2 //Eltron TLP2844
						MSCBBEGIN(1,6)
						MSCBSAY(19,05,cCodProd,"N","2","2")
						MSCBSAY(30,05,cDescProd,"N","2","2")
						MSCBSAY(63,13,"Fabrica็ใo: ","N","2","2")
						MSCBSAY(63,18,cDataFab + " "+ _cDoc ,"N","2","2")
					
						if Alltrim(SB1->B1_GRUPO) == "1207"
							MSCBSAYBAR(05,10,cCodBarProd,'N','MB07',06,.f.,.t.,,,2,2)
						EndIf
						
						MSCBSAY(65,30,"Turma: "+ Turma ,"N","1","2,2")
						MSCBSAYBAR ( 17, 20 , cb1 , 'N',cPadraoBar,10,,,,,3,2)
						MSCBEND()
						nImprEtiq := nImprEtiq + 1
					endif
					*/
				endif
				
//*******************************************************
//****    APONTAMENTO DE FARDOS DE ETIQUETA IMPRESSAS ***
//*******************************************************
		 //Verifica se existe numera็ใo do fardo no SZ3
				dbSelectArea("SZ3")
				dbGotop()
				dbseek(xfilial("SZ3")+Alltrim(SC2->C2_NUM)+Alltrim(SC2->C2_ITEM)+cNumFardo)
	
				if ! SZ3->(found())
	//Incluir apontamentos de fardos no SZ3
					RecLock("SZ3",.t.)
					SZ3->Z3_PRODUTO := cCodProd
					SZ3->Z3_NUMOP :=  SUBSTR(cb1,1,6)  // Alltrim(SC2->C2_NUM)
					SZ3->Z3_ITEMOP := substr(cb1,7,2) //  Alltrim(SC2->C2_ITEM)
					SZ3->Z3_NUMERAC	:= cNumFardo
					SZ3->Z3_DOCSD3 :=  _cDoc
					SZ3->Z3_DATA   := dDatabase
					SZ3->Z3_LETRA  := Turma
					SZ3->(MsUnlock())
					nApontSucess := nApontSucess + 1
				//Else
					//MSGINFO("Fardo"+SZ3->Z3_NUMERAC+" jแ existe com documento "+SZ3->Z3_DOCSD3+". Favor informar responsavel pelo sistema.")
				EndIf
				cont := cont + 1
			EndDo
			MSCBCLOSEPRINTER()
//*******************************************************
//**** VERIFICACAO DE CONCLUSรO DE IMPRESSAO          ***
//*******************************************************
			
			if  ! MSGYESNO("Impressใo de "+str(nImprEtiq)+" fardos solicitados realizado corretamente?", "Confirma็ใo")
				MSGINFO("Favor cancelar etiquetas nใo impressas e imprimir novamente.")
				FormExcFardo()
			EndIf
		

		ELSE //CASO MSEXEC Dส ERRO
			nApontErro := nApontErro + 1
			cFileLog := ""
			cPath := ""
		
			AutoGrLog("INICIANDO O LOG")
			AutoGrLog("---------------")
			AutoGrLog("DATABASE...........: "+Dtoc(dDataBase))
			AutoGrLog("DATA...............: "+Dtoc(MsDate()))
			AutoGrLog("HORA...............: "+Time())
			AutoGrLog("ENVIRONMENT........: "+GetEnvServer())
			AutoGrLog("PATCH..............: "+GetSrvProfString("Startpath",""))
			AutoGrLog("ROOT...............: "+GetSrvProfString("SourcePath",""))
			AutoGrLog("VERSรO.............: "+GetVersao())
			AutoGrLog("MำDULO.............: "+"SIGA"+cModulo)
			AutoGrLog("EMPRESA / FILIAL...: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)
			AutoGrLog("NOME EMPRESA.......: "+Capital(Trim(SM0->M0_NOME)))
			AutoGrLog("NOME FILIAL........: "+Capital(Trim(SM0->M0_FILIAL)))
			AutoGrLog("USUมRIO............: "+cUserName)
		
			cFileLog := NomeAutoLog()
		
			If cFileLog <> ""
				MostraErro(cPath,cFileLog)
			Endif

		EndIf //end do Log de Erro do MSEXECAUTO
	//GRAVA ฺLTIMO FARDO IMPRESSO
//		RecLock("SC2",.f.)
//		SC2->C2_ULTNUM := STRZERO(Numerac,4)
//		SC2->(msunlock())
		u_Grid()
	Else
		MSGALERT("Item de Ordem de Produ็ใo nใo encontrada.")
	EndIf

Return

//**********************************************
//*** IMPRESSรO DE SUBSTITUIวรO DE ETIQUETA  *** 
//**********************************************
Static Function ImpSub(cTipoEtq)
//CRIA PARAMETROS PARA IMPRIMIR ETIQUETAS
	aPerg2 := {}
	cPerg2 := "IMPSUB"
	cOP :=""
	cEtqCod := ""
	cMot := ""
	cProduto :=""
	cTurma := Alltrim(pswret(1)[1][12])
	
	Pergunte(cPerg2,.T.,"Substitui็ใo de Etiqueta")

	_Motivo := MV_PAR01
	cEtqSub := MV_PAR02 //nบ da etiqueta antiga - gravar em outro campo para registro
	cLoteSub := MV_PAR03 //Preencher com nบ do lote no pacotinho caso etiqueta antiga nใo existir ou for ilegํvel
	cCodProd := MV_PAR04
	//cQuant	 := MV_PAR05 //CRIAR
	
	Numerac := "0001"
	
	if Alltrim(cLoteSub) <> ""
		dbSelectArea("SB1")
		DbSetOrder(1)
		dbseek(xfilial("SB1")+cCodProd) //ALTERAR PARA PARยMETRO DE PRODUTO
		
		cCodBarProd := SB1->B1_CODBAR
		cProduto := SB1->B1_COD
	EndIF
	
	
	if  MSGYESNO("Deseja realmente imprimir etiqueta para o produto "+SB1->B1_DESC+"?", "Confirma็ใo")

		if _Motivo = 1
			cMot := "R" //Rasgada/Reenfardamento
		ElseIf _Motivo = 2
			cMot := "S" //Substitui็ใo
		//ElseIf _Motivo = 3  //Retirada op็ใo.Fardos sem etiqueta devem ser etiquetados como produto novo.
		EndIf
		
		
		//nTurma := "9"
	
		if Alltrim(cLoteSub) <> ""
			IF Alltrim(cCodProd) <> ""
				if cMot = "S"
					cOP := "55"+ strzero(val(cLoteSub),4) +"55" //alterado 16/07/18
				Else
					cOP := "99"+ strzero(val(cLoteSub),4) +"99" //alterado 11/04/16
				EndIf
			Else
				MSGINFO("Preencha o cod. produto.")
			EndIf
		Else
			MSGINFO("Preencha o nบ do lote no pacote e o cod. produto.")
			Return
		EndIf
	
		cQry := "SELECT Z3_NUMOP,Z3_ITEMOP,MAX(Z3_NUMERAC) NUM FROM SZ3010"
		cQry += " WHERE Z3_NUMOP = '" + Substr(cOP,1,6) + "' AND Z3_ITEMOP='" + Substr(cOP,7,2)+"'"
		cQry += " GROUP BY Z3_NUMOP,Z3_ITEMOP"
	
		cQry := ChangeQuery(cQry)
		TCQUERY cQry NEW ALIAS "ULFAR"
	
		Numerac :=  val(ULFAR->NUM)

		ULFAR->(DbCloseArea())
	
	//SOLICITA IMPRESSรO DE NOVAS ETIQUETAS
		if _nImpress = 1
			cPrinter := "DATAMAX"
		else
			cPrinter := "ELTRON"
		endif
	
		if _nPorta   = 1
			cPorta   := "LPT1"
		elseif  _nPorta = 2
			cPorta   := "LPT2" //USB mapeada pelo NET USE
		elseif  _nPorta = 3
			cPorta := "LPT3"
		endif

//***** CONFIGURAวีES PARA TESTE EM ZEBRA *************	
//	_nImpress:=2 			//APENAS PARA TESTES. RETIRAR ANTES DE POR EM PRODUวรO.
//	cPrinter:="ELTRON"  //APENAS PARA TESTES. RETIRAR ANTES DE POR EM PRODUวรO.
//*********************************************************************************
	
		if _nPadraoBar  = 1 //CODE 128
			cPadraoBar   := "MB07"
		elseif  _nPadraoBar = 2 //EAN 13
			cPadraoBar   := "MB04"
		elseif  _nPadraoBar = 3 //Interleaved
			cPadraoBar := "MB01"
		elseif _nPadraoBar = 4 //Code 39
			cPadraoBar := "MB02"
		endif
	
		MSCBPRINTER(cPrinter,cPorta, , , .F., , , , ,,.f. , )
	
		IncProc("Imprimindo "+Alltrim(cOP)+" "+cPorta)
	
		
		cDataFab := dtoc(date())
		_cDoc := cMot + time() //PENSAR EM INFORMAวรO MELHOR PARA NUMERO DE DOCUMENTO.

//*******************************************************
//**** IMPRESSรO DE ETIQUETAS COM CำDIGO DE BARRAS    ***
//*******************************************************		
		MSCBCHKStatus(.f.)
			
		Numerac := Numerac + 1
		cNumFardo := strzero(Numerac,4)
		cb1 := left(Alltrim(cOP)+cNumFardo,12)

								
		if _nImpress = 1
			MSCBBEGIN(1,6)
			MSCBSAYBAR ( 05, 05 , cb1 , 'N',"MB04",08,,.T.,,,3,2.5) // LOTE (OP) + FARDO
					
			if Alltrim(SB1->B1_GRUPO) $ "1207"
						//MSCBSAYBAR ( 05, 20 , cCodBarProd , 'N',"MB04",06,,.T.,,,2,2) //EAN14 OFICIAL
				MSCBSAYBAR ( 03, 25 , cCodBarProd , 'N',"MB04",08,,.T.,,,2,2) // BARRAS DO PRODUTO
			EndIf
			MSCBSAY(01,30,Alltrim(cProduto)+ "-"+Alltrim(SB1->B1_DESC),"N","3","1,0")
			MSCBSAY(50,20,"Impresso em: ","N","1","2,2")
			MSCBSAY(50,15,cDataFab,"N","1","2,2")
			MSCBSAY(50,11, _cDoc,"N","1","2,2")
			MSCBSAY(50,06,"Origem: "+ cMot,"N","1","2,2")
			//MSCBSAY(50,15,"Impresso em: ","N","1","2,2")
			//MSCBSAY(50,10,cDataFab + " " + _cDoc,"N","1","2,2")
			//MSCBSAY(50,06,"Origem: "+ cMot,"N","1","2,2")
			MSCBEND()
				
		endif
				
//*******************************************************
//****    INCLUSรO DE FARDOS DE ETIQUETA IMPRESSAS ***
//*******************************************************
		 //Verifica se existe numera็ใo do fardo no SZ3
		dbSelectArea("SZ3")
		dbGotop()
		dbseek(xfilial("SZ3")+Alltrim(cOP)+cNumFardo)
	
		if !SZ3->(found())
	//Incluir apontamentos de fardos no SZ3
			RecLock("SZ3",.t.)
			SZ3->Z3_PRODUTO := SB1->B1_COD
			SZ3->Z3_NUMOP :=  SUBSTR(cb1,1,6)  // Alltrim(SC2->C2_NUM)
			SZ3->Z3_ITEMOP := substr(cb1,7,2) //  Alltrim(SC2->C2_ITEM)
			SZ3->Z3_NUMERAC	:= cNumFardo
			SZ3->Z3_DOCSD3 :=  _cDoc
			SZ3->Z3_DATA   := dDatabase  //DATA DE APONTAMENTO DO FARDO - INCLUIR CAMPO
			SZ3->Z3_LETRA  := cTurma
		//	if cMot = "D"  //Registrar que fardo jแ foi carregado e tem etiqueta substituta de devolu็ใo.
		//		SZ3->Z3_REG ='D'
		//	EndIf
			SZ3->(MsUnlock())
		//Else
//			MSGINFO("Fardo"+SZ3->Z3_NUMERAC+" jแ existe com documento "+SZ3->Z3_DOCSD3+". Favor informar responsavel pelo sistema.")

		EndIf
 		MSCBCLOSEPRINTER()

//*******************************************************
//**** EXCLUSรO DE FARDO SUBSTITUIDO POR ETIQUETA NOVA***
//*******************************************************
	/*	dbGotop()
		dbseek(xfilial("SZ3")+SUBSTR(cEtqSub,1,12))
		if  SZ3->(found())  //CASO FARDO FOR ENCONTRADO
			reclock("SZ3",.f.)
			dbdelete()
			msunlock()
		endif */
	EndIf
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณREIMP    บAutor  ณMicrosiga           บ Data ณ  10/13/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Reimpressao de etiquetas.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FormExcFardo()

	Static oDlg4
	Static oBtnOK
	Static oFont1 := TFont():New("MS Sans Serif",,018,,.F.,,,,,.F.,.F.)
	Static oGetEtq1
	Static cGetEtq1 := space(4)
	Static oGetEtq2
	Static cGetEtq2 := space(4)
	Static oSay1


	pos := oMSNewGe1:nAt

	DEFINE MSDIALOG oDlg4 TITLE "Estorno de Fardos" FROM 000, 000  TO 130, 450 COLORS 0, 16777215 PIXEL
	@ 012, 010 SAY oSay1 PROMPT "Etiqueta Inicio:" SIZE 060, 017 OF oDlg4 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 010, 070 MSGET oGetEtq1 VAR cGetEtq1 SIZE 089, 012 OF oDlg4 COLORS 0, 16777215 FONT oFont1 PIXEL PICTURE "@!"
	@ 030, 010 SAY oSay1 PROMPT "Etiqueta Fim:" SIZE 060, 017 OF oDlg4 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 030, 070 MSGET oGetEtq2 VAR cGetEtq2 SIZE 089, 012 OF oDlg4 COLORS 0, 16777215 FONT oFont1 PIXEL PICTURE "@!"
	//DEFINE SBUTTON oBtnOK FROM 047, 192 TYPE 01 OF oDlg4 ENABLE ACTION (ExcFardo(substr(cGetEtq1,1,8),substr(cGetEtq1,9,3),substr(cGetEtq2,9,3)),oDlg4:End())
	//DEFINE SBUTTON oBtnOK FROM 047, 192 TYPE 01 OF oDlg4 ENABLE ACTION (ExcFardo(oMSNewGe1:aCols[pos][1]+oMSNewGe1:aCols[pos][2],substr(cGetEtq1,1,3),substr(cGetEtq2,1,3)),oDlg4:End())
	DEFINE SBUTTON oBtnOK FROM 047, 192 TYPE 01 OF oDlg4 ENABLE ACTION (ExcFardo(oMSNewGe1:aCols[pos][1]+oMSNewGe1:aCols[pos][2],substr(cGetEtq1,1,4),substr(cGetEtq2,1,4)),oDlg4:End())
	
	ACTIVATE MSDIALOG oDlg4 CENTERED
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEXCLFARDO บAutor  ณMicrosiga           บ Data ณ  10/25/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ ESTORNA FARDOS Jม INCLUIDOS NO SISTEMA    			   บฑฑ
ฑฑบ          ณ com erros e acertos.                             	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExcFardo(_nOPexc,_nFardoIni2,_nFardoFim2, _turma)

	Local aVetor := {}
	Local cOP := _nOPexc
	Local cProd := ""
	Local _cDoc :=""
	Local _cDocNew :=""
	Local nFardoIni := Val(_nFardoIni2)
	Local nFardoFim := val(_nFardoFim2)
	Local contCanc := 0
	Local contErro := 0
	Local nQtdEntreg := 0
	//Local Quant := nFardoFim-nFardoIni
	Local QtdSZ3 := 0
	Local QtdSD3 := 0
	Local QtdDif := 0
	//Local aProd :={}
	Local _aVetor := {}
	Local cont := 0
	Local nFardo := 0
	Local nFdocIni
	Local nFdocFim
	
	PRIVATE lMsErroAuto := .F.
//*************************************************************
//** CONTA FARDOS POR DOCUMENTO E ESTORNA O SD3 DOS MESMOS ****
//*************************************************************
	nFardo := nFardoIni
	cont := 0
	nFdocIni := nFardoIni //define o primeiro fardo
	
	_cDoc := ""
	
	For nFardo := nFardoIni To nFardoFim
	
		dbSelectArea("SZ3")
		dbGotop()
		dbseek(xfilial("SZ3")+ cOP + strzero(nFardo,4))
		conout("EXCFARDO: "+ cOP + strzero(nFardo,4))
	
		//Estorna SD3 ap๓s somar quantidade do documento e reaponta diferen็a.
		IF _cDoc <> SZ3->Z3_DOCSD3
		
			cProd := SZ3->Z3_PRODUTO
			_cDoc := SZ3->Z3_DOCSD3
			conout("entrou no IF - cDoc="+_cDoc+" - DOCSD3="+SZ3->Z3_DOCSD3+" cProd="+cProd+" nFardo="+str(nFardo))
			
			//CRIAR FUNวรO QUE RETORNA QUANTIDADE DO DOCUMENTO SZ3.
			QtdSZ3 := quantDocSZ3(_cDoc,cOP, nFardoIni,nFardoFim)

	//BUSCA ฺLTIMO NฺMERO DE DOCUMENTO (D3_DOC) NO ARQUIVO DE MOVIMENTAวีES - 13/09/16
			cQry := "select D3_DOC DOC, D3_QUANT, D3_UM "
			cQry += " from SD3010"
			cQry += " Where SUBSTRING(D3_DOC,1,8) = '"+ _cDoc+"'"
			cQry += " and D3_ESTORNO='' AND D_E_L_E_T_=''"
			cQry += " AND D3_CF='PR0' and D3_COD = '"+cProd+"'"
		
			cQry := ChangeQuery(cQry)
			TCQUERY cQry NEW ALIAS "DOCEST"
			
			cDocEst := DOCEST->DOC
			QtdSD3 := DOCEST->D3_QUANT
			cUM	   := DOCEST->D3_UM
			
			//QtdSD3 := SD3->D3_QUANT
			//cUM	   := SD3->D3_UM
			//SD3->(DbCloseArea())
			DOCEST->(DbCloseArea())
			conout("EXCFARDO: Encontrado apontamento com quant = "+ str(QtdSD3) +" no doc "+ _cDoc + "- cProd="+cProd)
//********************************************************
//** GERA MOVTO DE ESTORNO DE QUANT. SZ3 ENCONTRADA  ****
//********************************************************	
				
			_aVetor:={ {"D3_DOC" ,cDocEst+cProd ,NIL},;
				{"INDEX" ,2 ,NIL}}
	
			MSExecAuto({|x,y| MATA250(x,y)},_aVetor,5) //Estorno
					
			If lMsErroAuto
				MSGALERT("ExcFardo: Nใo foi possํvel estornar o estoque do DOC."+_cDoc)
				conout("ExcFardo: Nใo foi possํvel estornar fardos - DOC="+_cDoc)
				Return
			Else
				conout("ExcFardo: SD3 ESTORNADO - DOC="+_cDoc)
				
				//ATUALIZA CAMPO DE QUANTIDADE Jม ENTREGUE
				dbSelectArea("SC2")
				dbgotop()
				dbseek(xfilial("SC2")+cOP+"001")
				
				If  SC2->(found())
					nQtdEntreg := SC2->C2_QUJE
					RecLock("SC2",.f.)
					SC2->C2_QUJE := nQtdEntreg - QtdSZ3
					conout("ExcFardo: SC2 - Diminuido para "+ str(SC2->C2_QUJE))
					msunlock()
				EndIf
				
				//****************************************************************************
				//**** REAPONTAMENTO DA DIFERENวA ENTRE ESTORNADO E CANCELADA PELO USUมRIO ***
				//****************************************************************************
				//i guarda a quantidade excluํda anteriormente de fardos.
				
				if QtdSZ3 < QtdSD3
					nReap := 0
					nQtdDif := QtdSD3 - QtdSZ3
					conout("Diferen็a="+str(nQtdDif)+" QtdSZ3="+str(QtdSZ3)+" QtdSD3="+str(QtdSD3))
					
					if Alltrim(substr(cDocEst,9,1))<>''
						nReap := val(substr(cDocEst,9,1))+1
					Else
						nReap := 1
					EndIf
					_cDocNew := Alltrim(substr(cDocEst,1,8)) + Alltrim(str(nReap))  //Para registrar Documento diferente para cada Reapontamento
					conout("novo documento="+_cDocNew+" - nReap="+str(nReap))
					lMsErroAuto := .F.
					cModulo = "PCP"
					nModulo = 10
					nOpc := 3
	
					_aInf:={{"D3_TM" ,"001"                   ,Nil},;
						{"D3_OP"           ,cOP+"001"       ,Nil},;
						{"D3_COD"         ,cProd                ,Nil},;
						{"D3_UM"           ,cUM     ,Nil},;
						{"D3_QUANT"     , nQtdDif             ,Nil},;
						{"D3_LOCAL"      ,"01" ,Nil},;
						{"D3_DOC"         ,_cDocNew            ,Nil},;
						{"D3_EMISSAO" ,dDataBase          ,Nil},;
						{"D3_HORA" ,time()          ,Nil},;
						{"D3_CHAVE" ,"R0"          ,Nil},;
						{"D3_CF" ,"PR0"          ,Nil}}
	
					MSExecAuto({|x,y| Mata250(x,y)},_aInf,3)
//*******************************************************
//**** IMPRESSรO DE ETIQUETAS COM CำDIGO DE BARRAS    ***
//*******************************************************	
					If lMsErroAuto
						conout("Nใo foi possํvel reapontar diferen็a do documento "+_cDoc)
						MSGALERT("Nใo foi possํvel reapontar diferen็a do documento "+_cDoc)
					EndIf
				EndIf
			
			EndIF
		ENDIF
	
		dbSelectArea("SZ3")
		dbGotop()
		dbseek(xfilial("SZ3")+ cOP + strzero(nFardo,4))

		
		//EXCLUI OS REGISTROS DE FARDOS NO SZ3
		if  SZ3->(found())
			reclock("SZ3",.f.)
			dbdelete()
			msunlock()
			contCanc := contCanc+1
			conout("EXCFARDO: Excluํdo SZ3 "+ strzero(nFardo,4))
		else
			contErro := contErro+1
		endif
	
	Next

	MSGALERT(str(contCanc)+" fardos cancelados com sucesso.")
	if contErro > 0
		MSGALERT(str(contErro)+" fardos nใo encontrados.")
	EndIf
	u_Grid()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMONTAGRIDLEITOR บAutor ณWeiden M. Mendesบ Data ณ  10/14/11  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exclui etiquetas lidas por c๓digo de barras.         	  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ExcFardoBarras()

	Private oDlg5,oBtnAponta, oBtnCancel
	PRIVATE oGetCodBarFd
	
	Private oFont1 := TFont():New("MS Sans Serif",,022,,.T.,,,,,.F.,.F.)
	Private oFont2 := TFont():New("MS Sans Serif",,020,,.T.,,,,,.F.,.F.)
	Private oFont3 := TFont():New("MS Sans Serif",,020,,.F.,,,,,.F.,.F.)
	Private oSay1
	Private oSay2
	Private oSay3
	Private cGrav
	Private cGetEtqFd := Space(13)
	Private nItens
	Private cUltInv
	aColsExclui := {}
	Private aDados := {}
	//Private aColsEx := {}
	STATIC oMSNewApont
	Private aFields := {}

	SetPrvt("oDlg5","oBtnAponta","oBtnCancel","oSay","oSay2","oSay3","oGetCodBar")

	DEFINE MSDIALOG oDlg5 TITLE "Exclusใo de etiquetas" FROM 000, 000  TO 500, 800 COLORS 0, 16777215 PIXEL
	@ 026, 110 SAY oSay3 PROMPT "Codigo de Barras :" SIZE 051, 011 OF oDlg5 COLORS 0, 16777215 PIXEL
	@ 026, 166 MSGET oGetCodBarFd VAR cGetEtqFd SIZE 132, 010 OF oDlg5 COLORS 0, 16777215  ON CHANGE (IncluiGridLeitor()) PIXEL
	MontaGridFardo()
	@ 025, 010 SAY oSayGrav PROMPT "ITENS:" SIZE 060, 015 OF oDlg5 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 025, 065 SAY oSayGrav1 PROMPT nItens Picture "@E 999" SIZE 015, 015 OF oDlg5 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 024, 342 BUTTON oBtnCancel PROMPT "Excluir" SIZE 051, 013 OF oDlg5  ACTION (ExcFardo_OP(),oGetCodBarFd:SetFocus()) PIXEL
	//@ 024, 342 BUTTON oBtnCancel PROMPT "Excluir" SIZE 051, 013 OF oDlg5  ACTION (ExcFardo_OP(aColsExclui),oGetCodBarFd:SetFocus()) PIXEL
	//@ 024, 342 BUTTON oBtnCancel PROMPT "Excluir" SIZE 051, 013 OF oDlg5  ACTION (ExcFardoGrid(),oGetCodBarFd:SetFocus()) PIXEL
			
	oGetCodBarFd:SetFocus()
	ACTIVATE MSDIALOG oDlg5 CENTERED
Return

Static Function MontaGridFardo()

	aFields := {}
	nItens := 0

	AADD(aFields,{"It" ,"IT"    ,"" ,4 ,0, ,"๛","N","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Produto" ,"CODIGO"    ,"" ,7 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Descri็ใo" ,"DESCPROD"    ,"" ,30 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Num.Etiqueta(LOTE)" ,"LOTE"    ,"" ,15 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Documento " ,"DOC"    ,"" ,9 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )

	oMSNewApont := MsNewGetDados():New( 057, 005, 250, 396,, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2",,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg4, aFields,aColsExclui )
	oMSNewApont:oBrowse:bGotFocus :=  {||oGetCodBarFd:SetFocus()}

Return


Static Function IncluiGridLeitor()

	nX := 0

	cCodProd := ""
	cDescProd := ""
	cDocEtq := ""
	cQry := ""
	existeIt := .f.
	lApontado := .f.
	cHrApont := ""
	nLin := 0
	cEtiqueta := substr(cGetEtqFd,1,12)
//Private oMSNewApont

//verifica se edit de c๓digo de barras estแ vazio
	If	Alltrim(cEtiqueta) <> ""
	
		dbSelectArea("SZ3")
		dbgotop()
		DbSetOrder(1)
		dbseek(xfilial("SZ3")+substr(Alltrim(cEtiqueta),1,8)+substr(cEtiqueta,9,4))
	//VERIFICA SE EXISTE O ITEM NO PRODUTO.
	
		if SZ3->(found())  //.AND. if SZ3->Z3_ROMANEI==cNumRom //retirado verifica romaneio para funcionar fora do romaneio.
			cCodProd := SZ3->Z3_PRODUTO
			cDocEtq := SZ3->Z3_DOCSD3 //Para armazenar Documento a estornar - Incluido em 29/09/16
		
			dbSelectArea("SB1")
			DbSetOrder(1)
			dbseek(xfilial("SB1")+SZ3->Z3_PRODUTO)
		
			cDescProd := SB1->B1_DESC
		//Verifica se c๓digo jแ foi incluido no array
		
			For I:= 1 To Len(aDados)
				if UPPER(cEtiqueta) = UPPER(aDados[i][3])
					existeIt := .t.
				EndIf
			Next
		
			cHrApont := ""
		
			if 	! existeIt
				aColsExclui := {}
			//INCLUI ITEM PARA VETOR DO GRID
				Aadd(aDados,{Alltrim(cCodProd),;
					Alltrim(cDescProd),;
					Alltrim(cGetEtqFd),;
					Alltrim(cDocEtq)})
			
				For I:= 1 To Len(aDados)
					AADD(aColsExclui,Array(Len(aFields)+1))
					nLin := Len(aColsExclui)
				
					aColsExclui[nLin,01] := I  //item
					aColsExclui[nLin,02] := aDados[i][1] //cod. produto
					aColsExclui[nLin,03] := aDados[i][2] //Descri็ใo produto
					aColsExclui[nLin,04] := aDados[i][3] //Lote
					aColsExclui[nLin,05] := aDados[i][4] //Documento
				    
					aColsExclui[nLin,Len(aFields)+1] := .F.
					conout("aColsExclui[nLin,05]="+aColsExclui[nLin,05])
					conout(str(len(aFields)))
				Next
			//				nJaGrav := len(aFields)
				oMSNewApont := MsNewGetDados():New( 057, 005, 250, 396,, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2",,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg4, aFields, aColsExclui)
				oMSNewApont:refresh()
			Endif
			
		else
			MSGINFO("Etiqueta "+cEtiqueta+" nใo encontrada.")
			oMSNewApont:oBrowse:bGotFocus :=  {||oGetCodBarFd:SetFocus()}
		//oBtnResumo:bGotFocus :=  {||oGetCodBarFd:SetFocus()}
		endif
		nItens := len(aColsExclui)
		
	EndIf
	oMSNewApont:oBrowse:bGotFocus :=  {||oGetCodBarFd:SetFocus()}
//Volta o foco do Grid para o edit do codigo de barras.
Return( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEXCLFARDO_OP บAutor  ณMicrosiga        บ Data ณ  04/10/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ ESTORNA FARDOS Jม INCLUIDOS NO SISTEMA    			   บฑฑ
ฑฑบ          ณ                                                   	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ExcFardo_OP()

//	Local aEtqOrd := _array
	Local cOP := ""
	Local cProd := ""
	Local _cDoc :=""
	Local _cDocNew :=""
	Local contCanc := 0
	Local contErro := 0
	Local nQtdEntreg := 0
	Local QtdSZ3 := 0
	Local QtdSD3 := 0
	Local QtdDif := 0
	Local _aVetor := {}
	Local cont := 0

	Local nFardo := ""
	
	PRIVATE lMsErroAuto := .F.
//*************************************************************
//** CONTA FARDOS POR DOCUMENTO E ESTORNA O SD3 DOS MESMOS ****
//*************************************************************
	cont := 0
	
	if len(aColsExclui)>0
		
		ASORT(aColsExclui,,,{|x,y| x[5] < y[5]})
		
		conout("aColsExclui com elementos:"+ str(len(aColsExclui)))
		//ASORT(aEtqOrd,,,{|x,y| x[5] > y[5]})
		
		_cDoc := ""
		
		For lin := 1 To len(aColsExclui)
			conout(aColsExclui[lin][04])
		
			nFardo := substr(aColsExclui[lin][04],9,4)
			cOP		:= substr(aColsExclui[lin][04],1,8)
			dbSelectArea("SZ3")
			dbGotop()
			dbseek(xfilial("SZ3")+ cOP + nFardo)
			conout("EXCFARDO_OP: "+ cOP + nFardo)
	
		//Estorna SD3 ap๓s somar quantidade do documento e reaponta diferen็a.
			IF _cDoc <> SZ3->Z3_DOCSD3
		
				cProd := SZ3->Z3_PRODUTO
				_cDoc := SZ3->Z3_DOCSD3
				
				//VERIFICA SE D3_DOC estแ no modelo antigo.
				if substr(_cDoc,3,1)==":"
					MSGALERT("Etiqueta "+aColsExclui[lin][04]+" no formato antigo. Solicitar cancelamento ao Administrador do sistema.")
					Loop
				EndIf
				
				conout("EXCFARDO_OP: cDoc vแlido "+_cDoc+" - DOCSD3="+SZ3->Z3_DOCSD3+" cProd="+cProd+" nFardo="+nFardo)
			
			//CRIAR FUNวรO QUE RETORNA QUANTIDADE DO DOCUMENTO SZ3.
				QtdSZ3 := 0
				For x := 1 To len(aColsExclui)
					if 	Alltrim(aColsExclui[x][05]) == Alltrim(SZ3->Z3_DOCSD3)
						QtdSZ3 += 1
					EndIf
				Next
				conout("Quant do DOC Excluir:"+str(QtdSZ3))
				//QtdSZ3 := quantDocSZ3(_cDoc,cOP, nFardoIni,nFardoFim)

	//BUSCA NฺMERO DE DOCUMENTO (D3_DOC) NO ARQUIVO DE MOVIMENTAวีES - 13/09/16
				cQry := "select D3_DOC DOC, D3_QUANT, D3_UM "
				cQry += " from SD3010"
				cQry += " Where SUBSTRING(D3_DOC,1,8) = '"+ _cDoc+"'"
				cQry += " and D3_ESTORNO='' AND D_E_L_E_T_='' "
				cQry += " AND D3_CF='PR0' and D3_COD = '"+cProd+"'"
		
				cQry := ChangeQuery(cQry)
				TCQUERY cQry NEW ALIAS "DOCEST"
			
				cDocEst := DOCEST->DOC
				QtdSD3  := DOCEST->D3_QUANT
				cUM	    := DOCEST->D3_UM
			
				DOCEST->(DbCloseArea())
				conout("EXCFARDO: Encontrado apontamento com quant = "+ str(QtdSD3) +" no doc "+ _cDoc + "- cProd="+cProd)
//********************************************************
//** GERA MOVTO DE ESTORNO DE QUANT. SZ3 ENCONTRADA  ****
//********************************************************	
				
				_aVetor:={ {"D3_DOC" ,cDocEst+cProd ,NIL},;
					{"INDEX" ,2 ,NIL}}
	
				MSExecAuto({|x,y| MATA250(x,y)},_aVetor,5) //Estorno
					
				If lMsErroAuto
					MSGALERT("ExcFardo: Nใo foi possํvel estornar o estoque do DOC."+_cDoc)
					conout("ExcFardo: Nใo foi possํvel estornar fardos - DOC="+_cDoc)
					Return
				Else
					conout("ExcFardo: SD3 ESTORNADO - DOC="+_cDoc)
				
				//ATUALIZA CAMPO DE QUANTIDADE Jม ENTREGUE
					dbSelectArea("SC2")
					dbgotop()
					dbseek(xfilial("SC2")+cOP+"001")
				
					If  SC2->(found())
						nQtdEntreg := SC2->C2_QUJE
						RecLock("SC2",.f.)
						SC2->C2_QUJE := nQtdEntreg - QtdSZ3
						conout("ExcFardo: SC2 - Diminuido para "+ str(SC2->C2_QUJE))
						msunlock()
					EndIf
				
				//****************************************************************************
				//**** REAPONTAMENTO DA DIFERENวA ENTRE ESTORNADO E CANCELADA PELO USUมRIO ***
				//****************************************************************************
				//i guarda a quantidade excluํda anteriormente de fardos.
				
					if QtdSZ3 < QtdSD3
						nReap := 0
						nQtdDif := QtdSD3 - QtdSZ3
						conout("Diferen็a="+str(nQtdDif)+" QtdSZ3="+str(QtdSZ3)+" QtdSD3="+str(QtdSD3))
					
						if Alltrim(substr(cDocEst,9,1))<>''
							nReap := val(substr(cDocEst,9,1))+1
						Else
							nReap := 1
						EndIf
						_cDocNew := Alltrim(substr(cDocEst,1,8)) + Alltrim(str(nReap))  //Para registrar Documento diferente para cada Reapontamento
						conout("novo documento="+_cDocNew+" - nReap="+str(nReap))
						lMsErroAuto := .F.
						cModulo = "PCP"
						nModulo = 10
						nOpc := 3
	
						_aInf:={{"D3_TM" ,"001"                   ,Nil},;
							{"D3_OP"           ,cOP+"001"       ,Nil},;
							{"D3_COD"         ,cProd                ,Nil},;
							{"D3_UM"           ,cUM     ,Nil},;
							{"D3_QUANT"     , nQtdDif             ,Nil},;
							{"D3_LOCAL"      ,"01" ,Nil},;
							{"D3_DOC"         ,_cDocNew            ,Nil},;
							{"D3_EMISSAO" ,dDataBase          ,Nil},;
							{"D3_HORA" ,time()          ,Nil},;
							{"D3_CHAVE" ,"R0"          ,Nil},;
							{"D3_CF" ,"PR0"          ,Nil}}
	
						MSExecAuto({|x,y| Mata250(x,y)},_aInf,3)

						If lMsErroAuto
							conout("Nใo foi possํvel reapontar diferen็a do documento "+_cDoc)
							MSGALERT("Nใo foi possํvel reapontar diferen็a do documento "+_cDoc)
						EndIf
					EndIf //Fecha Reapontamento
				EndIF //Fecha If lMsErroAuto do Estorno
			ENDIF //Fecha IF _cDoc <> SZ3->Z3_DOCSD3
	
			dbSelectArea("SZ3")
			dbGotop()
			dbseek(xfilial("SZ3")+ cOP + nFardo)
	//EXCLUI OS REGISTROS DE FARDOS NO SZ3
			if  SZ3->(found())
				reclock("SZ3",.f.)
				dbdelete()
				msunlock()
				contCanc := contCanc+1
				conout("EXCFARDO: Excluํdo SZ3 "+ nFardo)
			else
				contErro := contErro+1
			endif
	
		Next

		MSGALERT(str(contCanc)+" fardos cancelados com sucesso.")
		if contErro > 0
			MSGALERT(str(contErro)+" fardos nใo encontrados.")
		EndIf
	EndIf
	MontaGridFardo()
	oDlg5:end()
Return


User Function TABSZ3()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	Private cPerg   := "SZ3"

	Private cString := "SZ3"

	dbSelectArea("SZ3")
	dbSetOrder(1)

	cPerg   := "SZ3"

	Pergunte(cPerg,.F.)
	SetKey(123,{|| Pergunte(cPerg,.f.)}) // Seta a tecla F12 para acionamento dos parametros

	AxCadastro(cString,"Cadastro de Fardos",".t.",".t.")


	Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros


Return

Static Function quantDocSZ3(Doc,OP, Ini,Fim)
	
	Local Quant := 0
	
	For x := Ini To Fim
		dbSelectArea("SZ3")
		dbGotop()
		dbseek(xfilial("SZ3")+ OP + strzero(x,4))
		
		if SZ3->Z3_DOCSD3 == Doc
			Quant += 1
		EndIf
	Next
	
	conout("QUANTDOCSZ3: "+ str(Quant))
	
Return(Quant)

Static Function DataLoteEtq()
	nAno = Year(date())
	
	cDtIni = ctod('31/12/'+ cValToChar(nAno-1))
	dDtFim = date()
	cDias = cValToChar(DateDiffDay(cDtIni, dDtFim))
	
	if (len(cDias) < 3)
		cDias = '0' + cValToChar(cDias)
	endif
	
	cDataLote = cValToChar(cDias)
return (cDataLote)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTELAPROD1 ver. 5.0 บAutor  ณ  Weiden Mendes Data ณ 27/07/15 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ TESTES PARA IMPRESSรO DE CำDIGO DE BARRAS		          บฑฑ
ฑฑบ          ณ  apontamento de produ็ใo.                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบVersใo    ณ  3.14 - Alterada posi็๕es dos textos devido restaura็ใo	  บฑฑ
ฑฑ 				de fแbrica da impressora t้rmica.						  บฑฑ
				5.0 - Inclusใo de etiqueta de devolu็ใo                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TesteCodBar()


	cPrinter := "DATAMAX"
	cPorta   := "LPT1"

	//***** CONFIGURAวีES PARA TESTE EM ZEBRA *************	
//	_nImpress:=2 			//APENAS PARA TESTES. RETIRAR ANTES DE POR EM PRODUวรO.
//	cPrinter:="ELTRON"  //APENAS PARA TESTES. RETIRAR ANTES DE POR EM PRODUวรO.
//*********************************************************************************

if x = 1 //CODE 128
	cPadraoBar   := "MB07"
	aConteudo :={{'01','07893316010411'}}
elseif  x = 2 //EAN 13
	cPadraoBar := "C"
	aConteudo :={{'01','07893316010411'}}
	
elseif  x = 3 //Interleaved
	cPadraoBar := "MB01"
	aConteudo 	:= '07893316010411'
elseif x = 4 //Code 39
	cPadraoBar := "MB02"
	aConteudo 	:= '07893316010411'
elseif x = 5
	cPadraoBar   := "MB04"
	aConteudo 	:= '07893316010411'
elseif x = 6
	cPadraoBar := "D"
	aConteudo :='07893316010411'

endif

MSCBPRINTER(cPrinter,cPorta, , , .F., , , , ,,.f. , )

MSCBCHKStatus(.f.)
	
	While  cont < 10

		

		MSCBBEGIN(1,6)
		MSCBSAYBAR ( 05, 05 , aConteudo , 'N',cPadraoBar,08,,.T.,,,3,2.5) // LOTE (OP) + FARDO
		MSCBEND()
			
			x := x + 1
	EndDo	
	

Return