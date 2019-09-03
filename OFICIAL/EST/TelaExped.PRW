#include "topconn.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#include "TBICONN.CH"
#include "TBICODE.CH"
#INCLUDE "ap5mail.ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTELAEXP ver. 4.0บAutor  ณ Weiden Mendes	 Data ณ  03/10/11 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para realizar expedi็ใo de produtos  e            บฑฑ
ฑฑบ          ณ  baixa de estoque simultaneamente.                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบVersใo    ณ  3.0 - Incluํda fun็ใo de gerar requisi็ใo e devolu็ใo	  บฑฑ
ฑฑ 				de produtos para do estoque.     			              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ //antigo
User Function SIGAESP1()

	Public cNumRom := ""
	Static Hoje := dtos(ddatabase)
	Static oDlg1
	Static BmpLogo
	Public oBtnCarreg
 
	Static oFont1 := TFont():New("MS Sans Serif",,024,,.T.,,,,,.F.,.F.)
	Static oFont2 := TFont():New("MS Sans Serif",,020,,.T.,,,,,.F.,.F.)
	Static oFont3 := TFont():New("MS Sans Serif",,020,,.F.,,,,,.F.,.F.)
	Static oFont4 := TFont():New("MS Sans Serif",,026,,.T.,,,,,.F.,.F.)

	aPerg := {}
	cPerg := "EXPETQ"

	Pergunte(cPerg,.F.)

	_nMostraFinaliz := Mv_Par01


	DEFINE MSDIALOG oDlg1 TITLE "Carregamento 4.0 - PLINC " FROM 000, 000  TO 500, 800 COLORS 0, 16777215 PIXEL

    //@ 000, 253 BITMAP BmpLogo SIZE 143, 034 OF oDlg1 FILENAME "\\server\protheus10\protheus_data\logo.jpg" NOBORDER PIXEL
	@ 025, 155 SAY oLblResp PROMPT "Separa็ใo da Carga: " SIZE 100, 011 OF oDlg1 FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 025, 250 SAY oTxtResp PROMPT pswret(1)[1][2] SIZE 060, 011 OF oDlg1 FONT oFont3 COLORS 0, 16777215 PIXEL
	u_GridRom()
	@ 010, 341 BUTTON oBtnCarreg PROMPT "Carregar" SIZE 051, 013 OF oDlg1 ACTION (u_carregam()) PIXEL
	IF  LEN(aDadosRoms)==0
		oBtnCarreg:disable()
	EndIf
	@ 025, 341 BUTTON oBtnAponta PROMPT "Parโmetros" SIZE 051, 013 OF oDlg1 ACTION Pergunte(cPerg,.T.,"Parโmetros") PIXEL
	@ 040, 341 BUTTON oBtnDevol PROMPT "Devolu็ใo" SIZE 051, 013 OF oDlg1 ACTION (u_devolfardos()) PIXEL
	ACTIVATE MSDIALOG oDlg1 CENTERED

Return

//***********************************************
//  Grid da tela inicial - Ordem de Produ็ใo
//***********************************************

User Function GridRom()

	aColsEx := {}
	aFields := {}
	cQry := ""
	//Static	aDados := {}
	Public aDadosRoms := {}
	STATIC oMSNewGe1

	AADD(aFields,{"Romaneio" ,"ROMAN"    ,"" ,9 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Rota" ,"ROTA"    ,"" ,30 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Veiculo" ,"VEICULO"    ,"" ,7 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Motorista" ,"MOTORISTA"    ,"" ,15 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Data Saida" ,"DTSAIDA"    ,"" ,10 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Inicio Carga" ,"DTINICIO"    ,"" ,10 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Status" ,"STATUS"    ,"" ,20 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
 
//CONSULTA DE DADOS PARA O GRID
	cQry:="SELECT *,'' AS DA3_COD, '' AS DA4_NOME " //INCLUIR MOTORISTA NA VISUALIZAวรO
	cQry += "FROM SZ1010 "
	cQry += "WHERE D_E_L_E_T_='' "
	cQry +=" AND Z1_EXPFIM='' AND Z1_DTSAIDA >='20181007' "   //+ Hoje +"' "
	//cQry +="AND Z1_DTFECH='' " //Verifica se Romaneio jแ foi finalizado.
	
	cQry := ChangeQuery(cQry)
	TCQUERY cQry NEW ALIAS "TRC"

	aDadosRom :={}
	
	While !TRC->(Eof())
		Aadd(aDadosRoms,{ TRC->Z1_NUM,;
			TRC->Z1_DESCRI,;
			TRC->Z1_MOTORI,;
			TRC->DA4_NOME,;
			stod(TRC->Z1_DTSAIDA),;
			stod(TRC->Z1_EXPINI),;
			TRC->Z1_STATUS})
		TRC->(DbSkip())
	End

	TRC->(DbCloseArea())
	
	
	For I:= 1 To Len(aDadosRoms)
		AADD(aColsEx,Array(Len(aFields)+1))
		nLin := Len(aColsEx)
		aColsEx[nLin,01] := aDadosRoms[i][1]
		aColsEx[nLin,02] := aDadosRoms[i][2]
		aColsEx[nLin,03] := aDadosRoms[i][3]
		aColsEx[nLin,04] := aDadosRoms[i][4]
		aColsEx[nLin,05] := aDadosRoms[i][5]
		aColsEx[nLin,06] := aDadosRoms[i][6]
		aColsEx[nLin,Len(aFields)+1] := .F.
	Next
		
	oMSNewGe1 := MsNewGetDados():New( 057, 005, 250, 396,, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2",,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg1, aFields, aColsEx)
	oMSNewGe1:oBrowse:refresh()
	oMSNewGe1:oBrowse:setfocus()
	

Return( Nil )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCARREGAM  บAutor  ณMicrosiga           บ Data ณ  10/13/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela para carregamento de Romaneio selecionado.            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function carregam()
	
	pos := oMSNewGe1:nAt
	cNumRom :=  trim(oMSNewGe1:aCols[pos][1])
	cRota	:= trim(oMSNewGe1:aCols[pos][2])
	cVeic	:= trim(oMSNewGe1:aCols[pos][3])
	cMotori	:= trim(oMSNewGe1:aCols[pos][4])
	cDtSaida := oMSNewGe1:aCols[pos][5]
		
	aFdOutrRom := {}
	aFdVenc := {}
	aFdExced :={}  //retirado para testar solu็ใo de excedentes registrados e no grid
	aFdNotExist := {}
	aFdFalta	:= {}
	nTotalGeral := 0
	nQtSemEtq := 0
	nApontSucess := 0
	nLeituras := 0
	Static Hoje := dtos(ddatabase)
	 
	Static oDlg2
	Static BmpLogo
	//Static oBtnAponta
	//Static oBtnImprimir
	Static oFont1 := TFont():New("MS Sans Serif",,024,,.T.,,,,,.F.,.F.)
	Static oFont2 := TFont():New("MS Sans Serif",,020,,.T.,,,,,.F.,.F.)
	Static oFont3 := TFont():New("MS Sans Serif",,020,,.F.,,,,,.F.,.F.)
	Static oFont4 := TFont():New("MS Sans Serif",,026,,.T.,,,,,.F.,.F.)
	Private cGetCodBar := Space(13)
	Static oCbxFinalizados
	Static lCbxFinalizados := .T.
	HrInicio := time()
	HrFim := ""
	cStatus := ""
	nQtdTotal := 0
	#define DS_MODALFRAME 128 //Desabilita fechar tela pelo X

	DEFINE MSDIALOG oDlg2 TITLE "Carregamento Romaneio "+cNumRom FROM 000, 000  TO 550, 1200 COLORS 0, 16777215 PIXEL Style DS_MODALFRAME
	@ 006, 004 BUTTON oBtnFinaliz PROMPT "FINALIZAR CARGA" SIZE 060, 015 OF oDlg2 ACTION (finalizarom()) PIXEL
	@ 030, 004 BUTTON oBtnApont PROMPT "PAUSAR CARGA" SIZE 060, 015 OF oDlg2 ACTION (oDlg2:End()) PIXEL // Alterado 07/03/16
	@ 030, 070 BUTTON oBtnApont PROMPT "EXCLUIR FARDOS" SIZE 060, 015 OF oDlg2 ACTION (u_retfardos()) PIXEL
	@ 006, 070 BUTTON oBtnResumo PROMPT "RESUMO" SIZE 060, 015 OF oDlg2 ACTION u_LOGRES() PIXEL
	@ 058, 004 GROUP oGroup1 TO 170, 136 PROMPT "" OF oDlg2 COLOR 0, 16777215 PIXEL
	@ 060, 010 SAY oLblVeic PROMPT "Veํculo:" SIZE 060, 011 OF oGroup1 FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 060, 045 SAY oTxtVeic PROMPT 	cVeic SIZE 020, 011 OF oGroup1 FONT oFont3 COLORS 0, 16777215 PIXEL
	@ 075, 010 SAY oLblSaida PROMPT "Saํda:"   SIZE 060, 011 OF oGroup1 FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 075, 040 SAY oTxtSaida PROMPT cDtSaida SIZE 040, 011 OF oGroup1 FONT oFont3 COLORS 0, 16777215 PIXEL
	@ 090, 010 SAY oLblRota PROMPT "Rota:" SIZE 060, 011 OF oGroup1 FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 090, 040 SAY oTxtRota PROMPT substr(cRota,1,20) SIZE 120, 011 OF oGroup1 FONT oFont3 COLORS 0, 16777215 PIXEL //Nome do responsแvel pela programa็ใo da produ็ใo
	@ 100, 010 SAY oTxtRota1 PROMPT substr(cRota,21,25) SIZE 070, 011 OF oGroup1 FONT oFont3 COLORS 0, 16777215 PIXEL //Nome do responsแvel pela programa็ใo da produ็ใo
	@ 115, 010 SAY oLblMot PROMPT "Motorista:" SIZE 049, 012 OF oGroup1 FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 115, 040 SAY oTxtMot PROMPT cMotori SIZE 035, 011 OF oGroup1 FONT oFont3 COLORS 0, 16777215 PIXEL
	@ 130, 010 SAY oLblResp PROMPT "Conferente: " SIZE 100, 011 OF oGroup1 FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 130, 060 SAY oTxtResp PROMPT pswret(1)[1][2] SIZE 060, 011 OF oGroup1 FONT oFont3 COLORS 0, 16777215 PIXEL
	@ 145, 010 SAY oLblResp PROMPT "Inํcio Separa็ใo: " SIZE 150, 011 OF oGroup1 FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 145, 085 SAY oLblResp PROMPT HrInicio SIZE 150, 011 OF oGroup1 FONT oFont3  COLORS 0, 16777215 PIXEL
	@ 005, 400 SAY oSay3 PROMPT "Codigo de Barras :" SIZE 051, 011 OF oDlg2 COLORS 0, 16777215 PIXEL
	@ 005, 450 MSGET oGetCodBar VAR cGetCodBar SIZE 132, 010 OF oDlg2 COLORS 0, 16777215  ON CHANGE (IncluiLeitor()) PIXEL
	u_GridCarga()
	@ 005,300 CHECKBOX oCbxFinalizados VAR lCbxFinalizados PROMPT "Mostra itens concluํdos" SIZE 080, 010 OF oDlg2 COLORS 0, 16777215 ON CHANGE ExibeFinaliz() PIXEL
	@ 260, 010 SAY oLblStatus1 PROMPT "TOTAL: " SIZE 100, 011 OF oDlg2 FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 260, 070 SAY oTxtStatus PROMPT str(nQtdTotal) OF oDlg2 FONT oFont3 COLORS 0, 16777215 PIXEL

//oBtnResumo:disable()
	oGetCodBar:SetFocus()
	ACTIVATE MSDIALOG oDlg2 CENTERED

Return

//***********************************************
//  Grid da tela inicial - Ordem de Produ็ใo
//***********************************************

User Function GridCarga()

	Public aColsExCg := {}
	aFieldsCg := {}
	aHeader := {}
	cQry := ""
	aDadosC := {}
	cProdGrid := ""
	nQtdFardo:=0
	_nResta := 0
	_nExced := 0
	_cMotFalta :=""
	Static lInicioCarg
	lInicioCarg := .f.
	Public cEmailErro :=""
	Public cAssunto :=""
	STATIC oMSNewGe2 := ""
	

	AADD(aFieldsCg,{"PRODUTO" ,"CODIGO"    ,"" ,10 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFieldsCg,{"DESCRICAO" ,"DESCRI"    ,"" ,40 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFieldsCg,{"QUANTIDADE"  ,"QUANT"   ,"" ,09 ,2, ,"๛","N","" ,"V",  ,  ,".F."} )
	AADD(aFieldsCg,{"REGISTRADO"  ,"REGISTRADO"   ,"" ,09 ,2, ,"๛","N","" ,"V",  ,  ,".F."} )
	AADD(aFieldsCg,{"RESTANTE"  ,"RESTANTE"   ,"" ,09 ,2, ,"๛","N","" ,"V",  ,  ,".F."} )
	AADD(aFieldsCg,{"EXCEDENTE"  ,"EXCEDENTE"   ,"" ,09 ,2, ,"๛","N","" ,"V",  ,  ,".F."} )
	AADD(aFieldsCg,{"MOTIVO FALTA"  ,"MOTFALTA"   ,"" ,08 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFieldsCg,{"GRUPO" ,"GRUPO"    ,"" ,6 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	//AADD(aFieldsCg,{"CARREGAR LOTE"  ,"LOTECARR"   ,"" ,08 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	

	cQry := "SELECT ISNULL(D.B1_GRUPO,'') B1_GRUPO, ISNULL(C.C6_PRODUTO,'') C6_PRODUTO, ISNULL(E.Z3_PRODUTO,'') Z3_PRODUTO, ISNULL(D.B1_ORDEM,'') B1_ORDEM,"
	cQry += " ISNULL(D.B1_PRVALID,0) B1_PRVALID,ISNULL(D.B1_DESC,'') B1_DESC, ISNULL(SUM(C.C6_QTDVEN),0) AS QTDVEN, ISNULL(QTDROM,0) QTDROM"
	cQry += " FROM         SC5010 AS B INNER JOIN"
	cQry += " SC6010 AS C ON B.C5_NUM = C.C6_NUM INNER JOIN"
	cQry += " SB1010 AS D ON C.C6_PRODUTO = D.B1_COD"
	cQry += " FULL JOIN EXP_ROMFARDOS E ON B.C5_ROMANEI = E.Z3_ROMANEI AND C.C6_PRODUTO=E.Z3_PRODUTO"
	cQry += " WHERE   (B.D_E_L_E_T_ = '' or B.D_E_L_E_T_ IS NULL) AND (C.D_E_L_E_T_ = '' OR C.D_E_L_E_T_ IS NULL) AND (D.D_E_L_E_T_ = '' OR D.D_E_L_E_T_ IS NULL)"
	cQry += " AND (B.C5_ROMANEI='"+cNumRom+"' OR E.Z3_ROMANEI='"+cNumRom+"')"
	cQry += " GROUP BY D.B1_GRUPO, C.C6_PRODUTO, E.Z3_PRODUTO,D.B1_ORDEM,D.B1_PRVALID,D.B1_DESC, QTDROM"
	cQry += " ORDER BY B1_ORDEM,C6_PRODUTO"

	cQry := ChangeQuery(cQry)
	TCQUERY cQry NEW ALIAS "TRC2"

	DBSelectArea("SZ3")
	nQtdTotal := 0
	While !TRC2->(Eof()) // versao 1.0
	
		nQtdFardo := TRC2->QTDROM
		nQtdTotal +=1

		if nQtdFardo <= TRC2->QTDVEN
			_nResta := TRC2->QTDVEN-nQtdFardo
			_nExced := 0
		else
			_nResta := 0
			_nExced := nQtdFardo-TRC2->QTDVEN
		EndIf
		
		if Alltrim(TRC2->C6_PRODUTO)<>""
			cProdGrid := TRC2->C6_PRODUTO
			cDescGrid := TRC2->B1_DESC
		Else
			cProdGrid := TRC2->Z3_PRODUTO
			dbSelectArea("SB1")
			dbGotop()
			DbSetOrder(1)
			dbseek(xfilial("SB1")+cProdGrid)
			cDescGrid := SB1->B1_DESC
			SB1->(DbCloseArea())
		End If
//VERIFICA SE PARAMETRO ESTม CONFIGURADO PARA MOSTRAR OU NรO ITENS ENCERRADOS.
		//if 	_nMostraFinaliz == 1 .or. (_nMostraFinaliz == 2 .and. TRC2->QTDVEN<>nQtdFardo)
//		if lCbxFinalizados == .t.  .or. (lCbxFinalizados == .f. .and. TRC2->QTDVEN<>nQtdFardo)
			
		Aadd(aDadosC,{cProdGrid,;
			cDescGrid,;
			TRC2->QTDVEN,;
			nQtdFardo,;
			_nResta,;
			_nExced,;
			_cMotFalta,;
			TRC2->B1_GRUPO})
			
			//dDtLoteOk,; //incluir no vetor caso for informar proximo lote a carregar
		//EndIf
		TRC2->(DbSkip())
	EndDo
	
	TRC2->(DbCloseArea())
	
	aHeader := aclone (aFieldsCg)

	For I:= 1 To Len(aDadosC)
		AADD(aColsExCg,Array(Len(aFieldsCg)+1))
		nLin := Len(aColsExCg)
	
		aColsExCg[nLin,01] := aDadosC[i][1]
		aColsExCg[nLin,02] := aDadosC[i][2]
		aColsExCg[nLin,03] := Transform(aDadosC[i][3],"@E 999,999,999")
		aColsExCg[nLin,04] := Transform(aDadosC[i][4],"@E 999,999,999")
		aColsExCg[nLin,05] := Transform(aDadosC[i][5],"@E 999,999,999")
		aColsExCg[nLin,06] := Transform(aDadosC[i][6],"@E 999,999,999")
		aColsExCg[nLin,07] := aDadosC[i][7]
		aColsExCg[nLin,08] := aDadosC[i][8]
	
		aColsExCg[nLin,Len(aFieldsCg)+1] := .F.
	Next
	
	oMSNewGe2 := MsNewGetDados():New( 020, 140, 270, 600,, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2",,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg2, aFieldsCg, aColsExCg)
	oMSNewGe2:oBrowse:lUseDefaultColors := .F.
	oMSNewGe2:oBrowse:SetBlkBackColor({|| GETDCLR(oMSNewGe2:aCols,oMSNewGe2:nAt)})
	ExibeFinaliz()
	oMSNewGe2:oBrowse:bGotFocus :=  {||oGetCodBar:SetFocus()}
	

Return( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINCLUILEITOR  Autor: Weiden        บ Data ณ  10/14/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclui itens no Grid a partir do cod. barras.              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IncluiLeitor()
	cCodProd := ""
	cDescProd := ""
	cHrApont := ""
	Private oMSNewApont
	nItens := len(oMSNewGe2:aCols)

	
//verifica se edit de c๓digo de barras estแ com tamanho incorreto ou turma nใo existente
	If	len(Alltrim(cGetCodBar)) <> 13 //.or. !substr(Alltrim(cGetCodBar),12,1) $ "123"    //Alltrim(cGetCodBar) <> ""
		MSGSTOP("O c๓digo "+ cGetCodBar +" nใo esta no formato e tamanho correto.")
		conout("TELAEXPED: O c๓digo "+ cGetCodBar +" nใo esta no formato e tamanho correto.")
		Return
	EndIf


	dbSelectArea("SZ3")
	DbSetOrder(1)
	dbGotop()
	//dbseek(xfilial("SZ3")+substr(Alltrim(cGetCodBar),1,8)+substr(cGetCodBar,9,3)+" "+substr(cGetCodBar,12,1))
	dbseek(xfilial("SZ3")+substr(Alltrim(cGetCodBar),1,12))
	
	if !SZ3->(found())
		MSGSTOP("Fardo nใo encontrado. Informe o administrador do sistema ou ger๊ncia.")
		conout("TELAEXPED: O fardo "+ cGetCodBar +" nใo foi encontrado no SZ3.")
		AADD(aFdNotExist,cGetCodBar)
		nLeituras += 1
		Return
	EndIf
		
	dbSelectArea("SB1")
	DbSetOrder(1)
	dbseek(xfilial("SB1")+SZ3->Z3_PRODUTO)
	cDescProd := SB1->B1_DESC
		
	//VERIFICA SE FARDO Jม FOI REGISTRADO			
	IF Trim(SZ3->Z3_ROMANEI)<>""
		if Trim(SZ3->Z3_ROMANEI)<>Trim(cNumRom)
			MSGSTOP("Fardo registrado em outro romaneio. Informar ger๊ncia.")
			conout("TELAEXPED: O fardo "+ cGetCodBar +" jแ estแ registrado no romaneio "+SZ3->Z3_ROMANEI)
			Aadd(aFdOutrRom,{Alltrim(cGetCodBar),;
				SZ3->Z3_PRODUTO,;
				SZ3->Z3_ROMANEI})
			nLeituras += 1
		EndIf
		Return
	EndIf

	cCodProd := SZ3->Z3_PRODUTO
	
/*			//VERIFICA SE ITEM DO ROMANEIO Jม FOI TODO CARREGADO
	For a := 1 To nItens
		If trim(oMSNewGe2:aCols[a][1]) == Trim(cCodProd)
			//dPrimeiLote := oMSNewGe2:aCols[a][6] //posi็ใo do vetor que tiver o primeiro lote
			
			if val(oMSNewGe2:aCols[a][5])<=0
//				MSGINFO("Fardo excede a quantidade total do romaneio.")
				nLeituras += 1
			//	If  MSGYESNO("Fardo excede a quantidade total do romaneio. Deseja incluir mesmo assim?" , "Confirma็ใo")
					Aadd(aFdExced,{Alltrim(cGetCodBar),;
						SZ3->Z3_PRODUTO})
			//	Else
			//		Return
			//	EndIf
				
				//Return
			EndIF
		endif
	Next
	*/
			
	//VERIFICA SE PRODUTO ESTม VENCIDO		
	/*
	IF ddatabase-SZ3->Z3_DATA > SB1->B1_PRVALID .and. SB1->B1_PRVALID>0
		MSGINFO("Produto vencido. Favor pegar outro fardo.")
		
		Aadd(aFdVenc,{Alltrim(cGetCodBar),;
			SZ3->Z3_PRODUTO,;
			SZ3->Z3_DATA+SB1->B1_PRVALID})
		nLeituras += 1
		Return
	EndIf
	*/
	
	 //VERIFICA O LOTE MAIS ANTIGO NO ESTOQUE PARA CARREGAR PRIMEIRO
	/* IF SZ3->Z3_DATA > dPrimeiLote
		MSGINFO("Existe lote mais antigo do dia "+ dtoc(dPrimeiLote) +". Favor carrega-lo primeiro.")
		Return
	EndIf
	*/	
	
	RecLock("SZ3",.f.)
	SZ3->Z3_ROMANEI := cNumRom   //CRIAR OUTRO CAMPO CHAMADO Z3_ROMANEIO PARA SUBSTITUIR
	SZ3->Z3_HREXP  := time()
	SZ3->Z3_DATEXP  	:= dDatabase  //DATA DE APONTAMENTO DO FARDO - INCLUIR CAMPO
	SZ3->(MsUnlock())
	nLeituras += 1
	
	if lInicioCarg == .f.
	
		dbSelectArea("SZ1")
		dbGotop()
		dbseek(xfilial("SZ1")+cNumRom+"01")
	
		if SZ1->(found()) //verifica se romaneio foi encontrado
			
			if Trim(SZ1->Z1_HRINI)==""
				RecLock("SZ1",.f.)
				SZ1->Z1_EXPINI := date()
				SZ1->Z1_HRINI := time()
				SZ1->(MsUnlock())
			End If
		Else
			MSGINFO("Romaneio nao encontrado no inicio. Informar administrador.")
			conout("TELAEXPED: Romaneio "+cNumRom+" nao encontrado no inicio. Informar administrador.")
		EndIf
	
		lInicioCarg := .t.

	EndIf
	
	nApontSucess += 1
	u_atual()
	ExibeFinaliz()
Return( Nil )


User Function atual()
	dbSelectArea("SZ3")
	dbGotop()
	dbseek(xfilial("SZ3")+substr(Alltrim(cGetCodBar),1,8)+substr(cGetCodBar,9,4)) //ALTERADO 28/07/15

	lExisteIt := .f.
	
	For nLin:= 1 To Len(aColsExCg)  //Array que guarda dados do Grid
		
		if	Trim(aColsExCg[nLin,01]) == Trim(SZ3->Z3_PRODUTO) //Se DadosGrid for igual ao produto registrado no momento
			aColsExCg[nLin,04] := str(val(aColsExCg[nLin,04])+1)
			if val(aColsExCg[nLin,05])>0
				aColsExCg[nLin,05] := str(val(aColsExCg[nLin,05])-1)
				aColsExCg[nLin,06] := "0"
			else
				aColsExCg[nLin,05] := "0"
				aColsExCg[nLin,06] := str(val(aColsExCg[nLin,06])+1)
			EndIf
			lExisteIt := .t.
			exit
		EndIf
	Next
	
	if lExisteIt == .f.
		u_GridCarga()
	EndIf
		
	oMSNewGe2:aCols := aclone (aColsExCg)
	oMSNewGe2:nAt = 1
	oMSNewGe2:oBrowse:Refresh()
	oMSNewGe2:Show ()
Return


Static Function ExibeFinaliz()

	aItensGrid := {}

	aItensGrid := aclone (aColsExCg)
	nLin:= 1
	While nLin <= Len(aItensGrid)
		if lCbxFinalizados= .f. .and. val(aItensGrid[nLin,05])<=0 .and. val(aItensGrid[nLin,06])=0
			ADEL(aItensGrid, nLin)
			ASIZE(aItensGrid,Len(aItensGrid)-1)
			nLin := 1
		EndIf
		nLin +=1
	EndDo

	oMSNewGe2:aCols := aclone (aItensGrid)
	oMSNewGe2:nAt = 1
	oMSNewGe2:oBrowse:Refresh()
	oMSNewGe2:Show ()
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FINALIZAROM	   Autor: Weiden        บ Data ณ  30/01/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Finaliza carregamento e inclusใo de intens no romaneio.    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FinalizaRom()

	cData := Dtoc(date())
	HrFim := time()
	aVetorReq := {}

	//if nLeituras > 0
	u_logres()
	
	dbSelectArea("SZ1")
	dbGotop()
	dbseek(xfilial("SZ1")+cNumRom+"01")
	
	if SZ1->(found())
		RecLock("SZ1",.f.)
		if  len(aFdFalta) > 0
			If ! MSGYESNO("Carregamento incompleto. Deseja finalizar mesmo assim?" , "Confirma็ใo")
				Return
			EndIf
			SZ1->Z1_STATUS :="carga parcial"
		Else
			If  len(aFdExced)>0	
				If ! MSGYESNO("Carregamento com excedentes. Deseja finalizar mesmo assim?" , "Confirma็ใo")
					Return
				EndIf
				SZ1->Z1_STATUS :="carga excedente"
			Else
				SZ1->Z1_STATUS := "carga concluํda"
			EndIf
		EndIf
		SZ1->Z1_EXPFIM := date()
		SZ1->Z1_HRFIM := HrFim
		
		dbSelectArea("SZ3")
		dbSetOrder(2)
		dbGotop()
		dbseek(xfilial("SZ3")+cNumRom)
		
		cProdCar := SZ3->Z3_PRODUTO
		nQtd := 0
		Do While SZ3->Z3_ROMANEI == cNumRom
			nQtd += 1
			reclock("SZ3",.f.)
			SZ3->Z3_REG := "R"  //Ap๓s testes definir campo e conte๚do definitivo
			SZ3->(MsUnlock())
			SZ3->(dbskip())
			
			if SZ3->Z3_PRODUTO <> cProdCar
			//*************************************************************
			//** GERA MOVTO DE REQUISIวรO DE PRODUTO ACABADO EXPEDIDO  ****
			//*************************************************************
			//Deve funcionar apenas quanto TES de Notas de Entrada e Devolu็ใo estiverem com Estoque=N.
				lMsErroAuto := .F.
					
				aVetorReq:={ {"D3_TM","501",NIL},;
					{"D3_COD",cProdCar,NIL},;
					{"D3_EMISSAO",ddatabase,NIL},;
					{"D3_DOC","R"+cNumRom,NIL},;
					{"D3_HORA",time(),NIL},;
					{"D3_QUANT",nQtd,NIL}}
				MSExecAuto({|x,y| mata240(x,y)},aVetorReq,3) //Inclusao
						
				If lMsErroAuto
					MSGALERT("Nใo foi possํvel requisitar os fardos.")
					U_ENVMAILEXP('sistemas@produtosplinc.com.br',"Erro na req. para expedi็ใo" ,"Nใo foi possํvel requisitar os produtos.")
				EndIf
				
				cProdCar := SZ3->Z3_PRODUTO
				nQtd := 0
			EndIf
			
		EndDo
					
		U_ENVMAILEXP('plinc.logistica@gmail.com',cAssunto ,cEmailErro)
		U_ENVMAILEXP('vendas@produtosplinc.com.br',cAssunto ,cEmailErro)
	//	U_ENVMAILEXP('sistemas@produtosplinc.com.br',cAssunto ,cEmailErro)
	Else
		MSGINFO("Nใo encontrado romaneio. Verificar com administrador.")
		conout("TELAEXPED: Nใo encontrado romaneio"+ cNumRom +" para finalizar.")
	EndIf
	//EndIf
	SZ1->(MsUnlock())
	oDlg2:End()
	u_GridRom()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFARDOS    บAutor  ณMicrosiga           บ Data ณ  10/06/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Tela de visualiza็ใo e exclusใo de Fardos Apontados.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RetFardos()

	Private oDlg4,oBtnAponta, oBtnCancel
	PRIVATE oGetCodBarFd, oGetVeic
	
	Private oFont1 := TFont():New("MS Sans Serif",,022,,.T.,,,,,.F.,.F.)
	Private oFont2 := TFont():New("MS Sans Serif",,020,,.T.,,,,,.F.,.F.)
	Private oFont3 := TFont():New("MS Sans Serif",,020,,.F.,,,,,.F.,.F.)
	Private oSay1
	Private oSay2
	Private oSay3
	Private cGrav
	Private cGetEtqFd := Space(13)
	Private cGetVeic := space(6)
	Private nItens
	Private cUltInv
	aColsExclui := {}
	Private aDados := {}
	//Private aColsEx := {}
	STATIC oMSNewApont
	Private aFields := {}

	SetPrvt("oDlg4","oBtnAponta","oBtnCancel","oSay","oSay2","oSay3","oGetCodBar")

	DEFINE MSDIALOG oDlg4 TITLE "Exclusใo de Fardos do Romaneio" FROM 000, 000  TO 500, 800 COLORS 0, 16777215 PIXEL
	@ 006, 010 SAY oSay1 PROMPT "Romaneio:" SIZE 060, 017 OF oDlg4 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 006, 070 SAY oSay2 PROMPT cNumRom Picture "@!" SIZE 070, 010 OF oDlg4 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 030, 110 SAY oSay3 PROMPT "Codigo de Barras :" SIZE 051, 011 OF oDlg4 COLORS 0, 16777215 PIXEL
	@ 029, 166 MSGET oGetCodBarFd VAR cGetEtqFd SIZE 132, 010 OF oDlg4 COLORS 0, 16777215  ON CHANGE (IncluiGridLeitor(1)) PIXEL
	MontaGridFardo()
	@ 029, 010 SAY oSayGrav PROMPT "ITENS:" SIZE 060, 015 OF oDlg4 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 029, 065 SAY oSayGrav1 PROMPT nItens Picture "@E 999" SIZE 015, 015 OF oDlg4 FONT oFont1 COLORS 0, 16777215 PIXEL
	//@ 005, 342 BUTTON oBtnResumo PROMPT "Resumo" SIZE 051, 013 OF oDlg4 ACTION (u_LOGRES(),oGetCodBarFd:SetFocus()) PIXEL
	@ 024, 342 BUTTON oBtnCancel PROMPT "Excluir" SIZE 051, 013 OF oDlg4  ACTION (FardosConf(1),oGetCodBarFd:SetFocus()) PIXEL
	
//	oBtnResumo:disable()
	oGetCodBarFd:SetFocus()
	ACTIVATE MSDIALOG oDlg4 CENTERED

Return


User Function DevolFardos()

	Private oDlg4,oBtnAponta, oBtnCancel
	PRIVATE oGetCodBarFd, oGetVeic
	
	Private oFont1 := TFont():New("MS Sans Serif",,022,,.T.,,,,,.F.,.F.)
	Private oFont2 := TFont():New("MS Sans Serif",,020,,.T.,,,,,.F.,.F.)
	Private oFont3 := TFont():New("MS Sans Serif",,020,,.F.,,,,,.F.,.F.)
	Private oSay1
	Private oSay2
	Private oSay3
	Private cGrav
	Private cGetEtqFd := Space(13)
	Private cGetVeic := space(3)
	Private nItens
	Private cUltInv
	aColsExclui := {}
	Private aDados := {}
	//Private aColsEx := {}
	STATIC oMSNewApont
	Private aFields := {}

	SetPrvt("oDlg4","oBtnAponta","oBtnCancel","oSay","oSay2","oSay3","oGetCodBar")

	DEFINE MSDIALOG oDlg4 TITLE "Devolu็ใo de Fardos" FROM 000, 000  TO 500, 800 COLORS 0, 16777215 PIXEL
	@ 006, 010 SAY oSay1 PROMPT "Romaneio:" SIZE 060, 017 OF oDlg4 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 006, 070 SAY oSay2 PROMPT cNumRom Picture "@!" SIZE 070, 010 OF oDlg4 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 006, 166 SAY oSay3 PROMPT "Veํculo :" SIZE 051, 011 OF oDlg4 COLORS 0, 16777215 PIXEL
	@ 005, 200 MSGET oGetVeic VAR cGetVeic SIZE 50, 010 OF oDlg4 COLORS 0, 16777215  PIXEL
	@ 030, 110 SAY oSay3 PROMPT "Codigo de Barras :" SIZE 051, 011 OF oDlg4 COLORS 0, 16777215 PIXEL
	@ 029, 166 MSGET oGetCodBarFd VAR cGetEtqFd SIZE 132, 010 OF oDlg4 COLORS 0, 16777215  ON CHANGE (IncluiGridLeitor(2)) PIXEL
	MontaGridFardo()
	@ 029, 010 SAY oSayGrav PROMPT "ITENS:" SIZE 060, 015 OF oDlg4 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 029, 065 SAY oSayGrav1 PROMPT nItens Picture "@E 999" SIZE 015, 015 OF oDlg4 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 024, 342 BUTTON oBtnCancel PROMPT "Confirmar" SIZE 051, 013 OF oDlg4  ACTION (FardosConf(2),oGetCodBarFd:SetFocus()) PIXEL
	
//	oBtnResumo:disable()
	oGetCodBarFd:SetFocus()
	ACTIVATE MSDIALOG oDlg4 CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMONTAGRIDLEITOR บAutor ณWeiden M. Mendesบ Data ณ  10/14/11  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta o Grid que recebe a leitura de codigo de barras	  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MontaGridFardo()

	//aDados := {}
	aFields := {}
	nItens := 0

	AADD(aFields,{"It" ,"IT"    ,"" ,4 ,0, ,"๛","N","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Produto" ,"CODIGO"    ,"" ,7 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Descri็ใo" ,"DESCPROD"    ,"" ,30 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Num.Etiqueta(LOTE)" ,"LOTE"    ,"" ,15 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )

	oMSNewApont := MsNewGetDados():New( 057, 005, 250, 396,, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2",,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg4, aFields,aColsExclui )
	oMSNewApont:oBrowse:bGotFocus :=  {||oGetCodBarFd:SetFocus()}

Return


Static Function IncluiGridLeitor(nTipoRet)

	nX := 0

	cCodProd := ""
	cDescProd := ""
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
		//dbseek(xfilial("SZ3")+substr(Alltrim(cEtiqueta),1,8)+substr(cEtiqueta,9,3)+" "+substr(cEtiqueta,12,1))
		dbseek(xfilial("SZ3")+substr(Alltrim(cEtiqueta),1,8)+substr(cEtiqueta,9,4)) //ALTERADO 28/07/15
	//VERIFICA SE EXISTE O ITEM NO PRODUTO.
	
		if SZ3->(found())  //.AND. if SZ3->Z3_ROMANEI==cNumRom //retirado verifica romaneio para funcionar fora do romaneio.
		
			If  Trim(SZ3->Z3_ROMANEI) <> "" .or. SZ3->Z3_REG='D' //CASO FARDO FOR ENCONTRADO*
			
				cCodProd := SZ3->Z3_PRODUTO
			
				//****************************************************************************************************
				//***  Verifica se romaneio estแ fechado. S๓ serแ permitido devolu็ใo em romaneios finalizados.  *****
				//****************************************************************************************************
		/*	dbSelectArea("SZ1")
				DbSetOrder(1)
				dbseek(xfilial("SZ1")+SZ3->Z3_ROMANEI+"01")	
				
				if SZ3->(found())
				
				  if SZ1->Z1_DTFECH = "" 
				  	if  nTipoRet = 2
				  		MSGINFO("Nใo ้ possํvel devolver produto de romaneio em aberto. Fechar romaneio antes de realizar a devolu็ใo.")
				  	EndIf
				  else
				  	if  nTipoRet = 1 .and. //Verificar se etiqueta pertence ao Romaneio posicionado.
				  	
				  	Endif
				  EndIf
				EndIf 	*/
				
				dbSelectArea("SB1")
				DbSetOrder(1)
				dbseek(xfilial("SB1")+SZ3->Z3_PRODUTO)
		
				cDescProd := SB1->B1_DESC
		
		//Verifica se c๓digo jแ foi incluido no array
		
				For I:= 1 To Len(aDados)

					if UPPER(cEtiqueta) = SUBSTRING(UPPER(aColsExclui[I][4]),1,12)  // UPPER(aDados[i][3])
					
						existeIt := .t.
					EndIf
				Next
		
				cHrApont := ""
		
				if 	! existeIt
					aColsExclui := {}
			//INCLUI ITEM PARA VETOR DO GRID
					Aadd(aDados,{Alltrim(cCodProd),;
						Alltrim(cDescProd),;
						Alltrim(cGetEtqFd)})
			
					For I:= 1 To Len(aDados)
						AADD(aColsExclui,Array(Len(aFields)+1))
						nLin := Len(aColsExclui)
				
						aColsExclui[nLin,01] := I  //item
						aColsExclui[nLin,02] := aDados[i][1] //cod. produto
						aColsExclui[nLin,03] := aDados[i][2] //Descri็ใo produto
						aColsExclui[nLin,04] := aDados[i][3] //Lote
										
						aColsExclui[nLin,Len(aFields)+1] := .F.
					Next
			//				nJaGrav := len(aFields)
					oMSNewApont := MsNewGetDados():New( 057, 005, 250, 396,, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2",,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg4, aFields, aColsExclui)
					oMSNewApont:refresh()
				Endif
			Else
				//MSGINFO("Etiqueta "+cEtiqueta+" nใo foi carregada.") 
				
				////   INCLUIR CONTADOR DE ETIQUETA NรO CARREGADA
			
			EndIf
		else
			//MSGINFO("Etiqueta "+cEtiqueta+" nใo encontrada.")
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
Static Function FardosConf(nTipoFunc)

	//Local aVetor := {}
	Local nQtdExclui := 0
	nPos := 0
	cRomDev := ""
	_aFardDev := {}
//_aFardDev[n][1] = Produto  
//_aFardDev[n][2] = Romaneio   
//_aFardDev[n][3] = Quantidade  
	
	//	pos := oMSNewApont:nAt  //somente se for excluir selecionando o item.
	if  ! MSGYESNO("Deseja excluir os fardos lidos do romaneio?", "Confirma็ใo")
		Return
	EndIf

	//L๊ array que cont้m fardos lidos no GRID.
	if len(aColsExclui)>0
		for i:= 1 to len(aColsExclui)    //len(oMSNewApont:acols)
			nEtq :=  SUBSTR(aColsExclui[i][4],1,12) // Lote/Etiqueta //Alterado 28/07/15
	
			dbSelectArea("SZ3")
			dbGotop()
			dbseek(xfilial("SZ3")+nEtq)
			conout("TELAEXPED: Linha vetor: "+ str(i))
			if  SZ3->(found())
				If  Trim(SZ3->Z3_ROMANEI) <> ""  .or. SZ3->Z3_REG='D' //VERIFICA SE ROMANEIO ESTม PREENCHIDO
					conout("TELAEXPED: Rom. antes:"+SZ3->Z3_ROMANEI)
					reclock("SZ3",.f.)
					if SZ3->Z3_DATEXP < date()  //VERIFICA SE DATA DE DEVOLUวรO ษ MAIOR QUE DATA DA EXPEDIวรO
						cRomDev := SZ3->Z3_ROMANEI
						SZ3->Z3_ROMDEV := cRomDev
						SZ3->Z3_DTDEV := date()
						SZ3->Z3_VEICDEV := cGetVeic  //Veํculo de devolu็ใo
					EndIf
					SZ3->Z3_ROMANEI:=""
					SZ3->Z3_HREXP:=""
				//	SZ3->Z3_DATEXP:="" //INCLUIR FUNCAO PARA LIMPAR CAMPO.
					msunlock()
								
					//Preenche vetor com somat๓rio de fardos por Produto+Romaneio.
					lexiste := .f.
					if Alltrim(SZ3->Z3_REG)<>"" //Verifica se foi registrada saํda do Estoque. Se nใo saiu pelo SD3 nใo devolve.
						For x:=1 to len(_aFardDev)
							If Alltrim(_aFardDev[ x ][1]) == Alltrim(Z3_PRODUTO) .and. Alltrim(_aFardDev[ x ][2]) == Alltrim(cRomDev)
	
								_aFardDev[x][3] += 1
								lexiste := .t.
								conout("TELAEXPED: EXISTE"+ _aFardDev[x][1]+" - "+  _aFardDev[x][2]+" - "+ str(_aFardDev[x][3]))
			
							EndIf
						Next

						If lexiste = .f.  //Se nใo for encontrado item cria novo Produto+Romaneio
							AADD(_aFardDev,{ SZ3->Z3_PRODUTO, cRomDev, 1})
							conout("TELAEXPED: NOVO- "+SZ3->Z3_PRODUTO+" - "+ SZ3->Z3_ROMANEI+" - "+ "1")
						Endif
						//LIMPAR CAMPO Z3_REG (REGISTRADO) PARA LIBERAR PARA OUTRO CARREGAMENTO
						reclock("SZ3",.f.)
						SZ3->Z3_REG := ""
						msunlock()  
					EndIF
					nQtdExclui += 1
				Else
					MSGINFO("Etiqueta "+nEtq+" nใo foi carregada.")
					conout("TELAEXPED: Etiqueta "+nEtq+" nใo foi carregada. linha vetor:"+ str(i))
				EndIf
			Else
				MSGINFO("Etiqueta "+nEtq+" nใo encontrada.")
				conout("TELAEXPED: Etiqueta "+nEtq+" nใo encontrada.linha vetor:"+ str(i))
			endif
		Next
		
		For d:=1 to len(_aFardDev)
				
				if nTipoFunc == 2 //Se rotina for de devolu็ใo de fardos
					_dDoc := "D"+ time()
				Else  ///Quando rotina for de  exclusใo de fardos do romaneio.
					_dDoc := "R"+_aFardDev[d][2]
				EndIf
				
			//************************************************************
			//** GERA MOVTO DE DEVOLUวรO DE PRODUTO ACABADO EXPEDIDO  ****
			//************************************************************
			lMsErroAuto := .F.
					
			aVetorReq:={ {"D3_TM","002",NIL},;
				{"D3_COD",_aFardDev[d][1],NIL},;
				{"D3_EMISSAO",ddatabase,NIL},;
				{"D3_DOC","R"+_aFardDev[d][2],NIL},;
				{"D3_HORA",time(),NIL},;
				{"D3_QUANT",_aFardDev[d][3],NIL}}
			MSExecAuto({|x,y| mata240(x,y)},aVetorReq,3) //Inclusao
			conout("TELAEXPED: 3-"+_aFardDev[d][1]+"-"+"R"+_aFardDev[d][2]+"-"+str(_aFardDev[d][3]))
			
			If lMsErroAuto
				U_ENVMAILEXP('sistemas@produtosplinc.com.br',"Erro na req. para expedi็ใo" ,"Nใo foi possํvel requisitar os produtos.")
				MSGALERT("Nใo foi possํvel requisitar os fardos.")
						
				conout("TELAEXPED: FIM - Erro ao realizar requisi็ใo.")
			Else
				conout("TELAEXPED: FIM - Registrado com sucesso.")
			EndIf
		Next
		
		MSGINFO("Excluํdos do romaneio "+ Str(nQtdExclui) +" fardos registrados.")
		conout("TELAEXPED: Excluํdos do romaneio "+ Str(nQtdExclui) +" fardos registrados.")
		
		MontaGridFardo()
		
		if cNumRom <>'' //para verificar se rotina FARDOS() foi aberto fora ou dentro da rotina de carregamento.
			u_GridCarga()
		EndIf
		oDlg4:end()
	else
		MSGINFO("Nใo existe item lido para excluir.")
		
	EndIf
		
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
//Static Function EtiqOP(_nQuant,_cOP,_cTurma )
User Function ENVMAILEXP( cTo, cAssunto, cMensagem )
 
	Local cQuery    := ""
	Local cData
	Local cServer   := AllTrim(GetNewPar("MV_RELSERV"," "))
	Local cAccount := AllTrim(GetNewPar("MV_RELACNT"," "))
	Local cPassword := AllTrim(GetNewPar("MV_RELPSW" ," "))
	Local lSmtpAuth := GetMv("MV_RELAUTH",,.F.)
	Local cFrom     := cAccount
//Local cTo       := "weidencore@gmail.com"
	Local cCC     := ""
//Local cSubject := "Teste"
	Local lOk       := .T.
	Local lAutOk    := .F.
//Local cBody     := ""

             
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
			ConOut("TELAEXPED: Email enviado com sucesso")
		Else
			GET MAIL ERROR cErro
			ConOut("TELAEXPED: Nใo foi possํvel enviar o Email." +Chr(13)+Chr(10)+ cErro)
			Return .f.
		EndIf
	Else
		GET MAIL ERROR cErro
		Conout("TELAEXPED: Erro na conexใo com o SMTP Server." +Chr(13)+Chr(10)+ cErro)
		Return .f.
	EndIf
	DISCONNECT SMTP SERVER


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTELAPROD1 บAutor  ณMicrosiga           บ Data ณ  10/25/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela LOG do sistema. Irแ receber resumo do apontamento,   บฑฑ
ฑฑบ          ณ com erros e acertos.                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LOGRES()

	_cHora := time()
	aTexto := {}
	aButtons := {}
	cTexto1 := ""
	nFaltaIt := 0
	nFaltaFd := 0
	
	TotalFardos()

	If len(aFdFalta)>0
		cAssunto	:= "SEPARAวรO DA CARGA "+cNumRom+" FINALIZADA INCOMPLETA"
		cEmailErro :="SEPARAวรO DA CARGA FOI FINALIZADA SEM COMPLETAR TODOS OS ITENS."+ENTER
		cEmailErro +="Romaneio: " +cNumRom+ENTER
		cEmailErro +="Hora Inicio:"+ HrInicio +ENTER
		cEmailErro +="Hora Fim:"+ HrFim +ENTER
		cEmailErro += ENTER+"Total Lido:"+ str(nTotalGeral) +ENTER
		cEmailErro += "Total sem Etiqueta:"+ str(nQtSemEtq) +ENTER
		cEmailErro +="Total Geral:"+ str(nTotalGeral+nQtSemEtq) +ENTER
		cEmailErro +=ENTER+"Produtos Faltantes:"+ENTER
		AADD(aTexto,cAssunto)
		AADD(aTexto,"Romaneio: " +cNumRom)
		AADD(aTexto,"Hora:"+ _cHora)
		//AADD(aTexto,"Produtos Faltantes:")
		
		For i:= 1 To Len(aFdFalta)
			cEmailErro += aFdFalta[i][2]+"    "+aFdFalta[i][1]+ENTER
			//AADD(aTexto,aFdFalta[i][1]+"   "+aFdFalta[i][2])
			nFaltaIt += 1
			nFaltaFd += val(aFdFalta[i][2])
		Next
		AADD(aTexto,"Faltam  "+Alltrim(str(nFaltaFd))+ "  unidades em  "+Alltrim(str(nFaltaIt))+"  itens do romaneio.")
		cEmailErro +="Total Faltas: "+Alltrim(str(nFaltaFd))+ "  unidades em  "+Alltrim(str(nFaltaIt))+"  itens do romaneio."+ENTER
		AADD(aTexto,"")
		
	Else
		If len(aFdExced)>0 .or. len(aFdVenc)>0 .or. len(aFdNotExist)>0 .or. len(aFdOutrRom)>0 
			cAssunto	:= "CARREGAMENTO ROMANEIO "+cNumRom+" FINALIZADO COM IRREGULARIDADES"
		Else
			cAssunto	:= "CARREGAMENTO ROMANEIO "+cNumRom+" FINALIZADO TOTALMENTE"
		EndIf
		
		AADD(aTexto,cAssunto)
		cEmailErro +="Romaneio: " +cNumRom+ENTER
		cEmailErro +="Hora Inicio:"+ HrInicio +ENTER
		cEmailErro +="Hora Fim:"+ HrFim +ENTER
		cEmailErro +=ENTER+"Total Lido:"+ str(nTotalGeral) +ENTER
		cEmailErro +="Total sem Etiqueta:"+ str(nQtSemEtq) +ENTER
		cEmailErro +="Total Geral:"+ str(nTotalGeral+nQtSemEtq) +ENTER
		AADD(aTexto,"Romaneio: " +cNumRom)
		AADD(aTexto,"Hora:"+ _cHora)
	EndIf
	cEmailErro +=ENTER+"EVENTOS OCORRIDOS DURANTE O CARREGAMENTO (Verificar diretamente com conferente):"+ENTER
	AADD(aTexto,"EVENTOS OCORRIDOS DURANTE O CARREGAMENTO:")

	If len(aFdExced)>0
		cEmailErro +=ENTER+"Fardos registrados excedendo a quantidade do romaneio:"+ENTER
		AADD(aTexto,"Fardos registrados excedendo a quantidade do romaneio:")
		For I:= 1 To Len(aFdExced)
			cEmailErro += aFdExced[i][1]+" :  "+aFdExced[i][2]+ENTER
			AADD(aTexto,aFdExced[i][1]+" :   "+aFdExced[i][2])
		Next
	EndIf

	If len(aFdVenc)>0
			//cEmailErro :="Fardos lidos com prazo de validade vencido:"+ENTER
		cEmailErro +="Fardos lidos com prazo de validade vencido:"
		AADD(aTexto,"Fardos lidos com prazo de validade vencido:")
		For I:= 1 To Len(aFdVenc)
			cEmailErro += aFdVenc[i][1]+"   "+aFdVenc[i][2]+"   "+aFdVenc[i][3]+ENTER
			AADD(aTexto,aFdVenc[i][1]+"   "+aFdVenc[i][2]+"   "+aFdVenc[i][3])
		Next
	EndIf

	If len(aFdOutrRom)>0
		cEmailErro +="Fardos lidos jแ registrados em outros romaneios:"+ENTER
		AADD(aTexto,"Fardos lidos jแ registrados em outros romaneios:")
		For I:= 1 To Len(aFdOutrRom)
			cEmailErro += aFdOutrRom[i][1]+"   "+aFdOutrRom[i][2]+"   "+aFdOutrRom[i][3]+ENTER
			AADD(aTexto,aFdOutrRom[i][1]+"   "+aFdOutrRom[i][2]+"   "+aFdOutrRom[i][3])
		Next
	EndIf

	If len(aFdNotExist)>0
		cEmailErro +="Fardos lidos nใo encontrados no sistema:" //+ENTER
		AADD(aTexto,"Fardos lidos nใo encontrados no sistema:")
		cTexto1 :=""
		For i:= 1 To Len(aFdNotExist)
			cEmailErro += aFdNotExist[i]+","  //ENTER
			cTexto1 += aFdNotExist[i]+","
		Next
		AADD(aTexto,cTexto1)
	EndIf

/*  DEFINE DIALOG oDlgLog TITLE "Resumo do Apontamento" FROM 180,180 TO 550,700 PIXEL
   oTMultiget1 := TMultiget():New(01,01,{|u|if(Pcount()>0,cTexto1:=u,cTxtSucess+cTxtAnter+cTxtErro+cTxtNaoLida+cTexto1)},;
                           oDlg,260,92,,,,,,.T.)
	oTMultiget1:lWordWrap:= .t.
  ACTIVATE DIALOG oDlgLog CENTERED  */

/*	AADD(aButtons, { 1,.T.,{|| nOpca := 1        , FechaBatch() }})
	FORMBATCH("Resumo do Apontamento", aTexto,aButtons,,500,500 )  */
	cTexto1 := ""
	FOR i:= 1 to len(aTexto)
		cTexto1 += aTexto[i]+ENTER
	Next
	MSGINFO(cTexto1)

Return

// Fun็ใo para tratamento das regras de cores para a grid da MsNewGetDados
Static Function GETDCLR(aLinha,nLinha)
	Local nRet := 0
	Local nCor2 :=  14540253  // 16777215 // Branco - RGB(255,255,255)
	Local nCor3 := 16776960 // Ciano - RGB(0,255,255)
	Local nCor4 :=  5070329 //fVERMELHO
//Local nCor3 := 65280 //VERDE

	if Alltrim(aLinha[nLinha][5])<>""
		If val(aLinha[nLinha][5])>0 //.AND. aLinha[nLinha][nUsado]
			nRet := nCor2
		ElseIf val(aLinha[nLinha][5])=0
			nRet := nCor3
		EndIf
	
		If val(aLinha[nLinha][6])>0
			nRet := nCor4
		Endif
	Else
		Return
	EndIf

Return nRet


Static Function TotalFardos()
	aFdFalta := {}
	aFdExced := {}
	nTotalGeral := 0
	nQtSemEtq := 0
	//aFdTotal := {} //Para caso necessite ver todos os produtos carregados.
	
	For I:= 1 To Len(aColsExCg)
		if Alltrim(aColsExCg[i][8]) <> "1203" //Alterado 07/03/16 - at้ encontrar solu็ใo de etiquetamento dos produtos.
			if val(aColsExCg[i][5]) > 0
				Aadd(aFdFalta,{aColsExCg[i][2],;
					aColsExCg[i][5]})
			EndIf
		EndIf
	
		if val(aColsExCg[i][6]) > 0
			Aadd(aFdExced,{aColsExCg[i][2],;
				aColsExCg[i][6]})
		EndIf
		
		//Produtos ainda nใo etiquetados
		if Alltrim(aColsExCg[i][8]) == "1203" 
			nQtSemEtq := nQtSemEtq + val(aColsExCg[i][3]) //Quantidade solicitada
		EndIf
				
		nTotalGeral := nTotalGeral + val(aColsExCg[i][4])	//Quantidade jแ carregada
	
		////Para caso necessite ver todos os produtos carregados no email
		// Aadd(aFdTotal,{aColsExCg[i][2],;
		//		aColsExCg[i][6]})  
	Next

/*
	For I:= 1 To Len(aColsExCg)
		if val(aColsExCg[i][6]) > 0
			Aadd(aFdExced,{aColsExCg[i][2],;
				aColsExCg[i][6]})
		EndIf
	Next
*/
Return
