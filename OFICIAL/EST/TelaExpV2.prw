#include "topconn.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#include "TBICONN.CH"
#include "TBICODE.CH"
#INCLUDE "ap5mail.ch"
#include "TOTVS.CH"
#DEFINE ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTELAEXPV2 ver. 8.0 บAutor  ณ Weiden Mendes + Dataณ 03/10/11 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para realizar expedi็ใo de produtos  e            บฑฑ
ฑฑบ          ณ  baixa de estoque simultaneamente.                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบVersใo    ณ  Nova tela e layout para itens concluํdos.  				  บฑฑ
ฑฑ 12.1.25	 ณ	Tamanho e fonte dos textos melhorados		              บฑฑ
ฑฑ 8.0 		 ณ	Carregamento de romaneio por item. Marca excedente vermelhoบฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//User Function SIGAQIP()

//User Function SIGAWMS
User Function Exped2()

	Static oMSNewGe1
	//Static cNumRom := ""
	Static Hoje := dtos(ddatabase)
	Static oDlg1
	Static BmpLogo
	Static oBtnCarreg
	Static pos, I 
	Static cNumRom 
	Static cRota	
	Static cVeic	
	Static cRomIt
	Static nProxIt
	//Static cMotori
	Static cDtSaida
	Static aDadosRoms := {}

	Static oFont1 := TFont():New("Arial",,018,,.T.,,,,,.F.,.F.)
	Static oFont2 := TFont():New("Arial",,020,,.T.,,,,,.F.,.F.)
	Static oFont3 := TFont():New("Arial",,024,,.F.,,,,,.F.,.F.)
	Static oFont4 := TFont():New("Arial",,026,,.T.,,,,,.F.,.F.)
	Static oFont5 := TFont():New("Arial",,028,,.T.,,,,,.F.,.F.)
	 
	nProxIt := 0
	aPerg := {}
	cPerg := "EXPETQ"
	Pergunte(cPerg,.F.)

	DEFINE MSDIALOG oDlg1 TITLE "Carregamento V2 2020-12 - PLINC " FROM 000, 000  TO 500, 800 COLORS 0, 16777215 PIXEL
    @ 000, 004 BITMAP BmpLogo SIZE 143, 045 OF oDlg1 FILENAME "\\srvpp08\Microsiga\protheus_data\system\logoRel.bmp" NOBORDER PIXEL
	@ 025, 155 SAY oLblResp PROMPT "Separa็ใo da Carga: " SIZE 100, 011 OF oDlg1 FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 025, 250 SAY oTxtResp PROMPT pswret(1)[1][2] SIZE 060, 011 OF oDlg1 FONT oFont2 COLORS 0, 16777215 PIXEL
	GridRom()
	@ 010, 341 BUTTON oBtnCarreg PROMPT "Carregar" SIZE 051, 013 OF oDlg1 ACTION (TelaCarga()) PIXEL
	IF  LEN(aDadosRoms)==0
		oBtnCarreg:disable()
	EndIf
	@ 025, 341 BUTTON oBtnAponta PROMPT "Parโmetros" SIZE 051, 013 OF oDlg1 ACTION Pergunte(cPerg,.T.,"Parโmetros") PIXEL
	@ 040, 341 BUTTON oBtnDevol PROMPT "Devolu็ใo" SIZE 051, 013 OF oDlg1 ACTION (devolfardos()) PIXEL
	ACTIVATE MSDIALOG oDlg1 CENTERED

Return

//***********************************************
//  Grid da tela inicial - Ordem de Produ็ใo
//***********************************************

Static Function GridRom()

	Local I
	Static TRC
	
	Static aColsEx := {}
	Static aFields := {}
	cQry := ""
	
	AADD(aFields,{"Romaneio" ,"ROMAN"    ,"" ,9 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Item" ,"ITEM"    ,"" ,3 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Rota" ,"ROTA"    ,"" ,30 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Veiculo" ,"VEICULO"    ,"" ,7 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Data Saida" ,"DTSAIDA"    ,"" ,10 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Data Saida" ,"DTINICIO"    ,"" ,10 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Status" ,"STATUS"    ,"" ,20 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Item" ,"PROX.ITEM"    ,"" ,3 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
 
//CONSULTA DE DADOS PARA O GRID
cQry := "SELECT A.Z1_NUM, A.Z1_ROTA, A.Z1_DESCRI, A.Z1_DTSAIDA, LTRIM(A.Z1_VEICULO) AS Z1_VEICULO, A.Z1_DTFECH, "
cQry += " A.Z1_MOTORI, A.Z1_STATUS, A.Z1_EXPINI,  MITEM, PROXIT  "
cQry += " FROM SZ1010 A INNER JOIN ROMITEM B ON  A.Z1_NUM = B.Z1_NUM"
cQry += " WHERE A.D_E_L_E_T_='' AND A.Z1_DTSAIDA >='20190101'  "
cQry += " GROUP BY A.Z1_NUM, A.Z1_ROTA, A.Z1_DESCRI, A.Z1_DTSAIDA, A.Z1_VEICULO, A.Z1_DTFECH, "
cQry += "  A.Z1_MOTORI, A.Z1_STATUS, A.Z1_EXPINI,MITEM,  PROXIT   "
cQry += " ORDER BY A.Z1_NUM "

cQry := ChangeQuery(cQry)
TCQUERY cQry NEW ALIAS "TRC"

	aDadosRom :={}
	
	While !TRC->(Eof())
		Aadd(aDadosRoms,{ TRC->Z1_NUM,;
			TRC->MITEM,;
			TRC->Z1_DESCRI,;
			TRC->Z1_VEICULO,;
			stod(TRC->Z1_DTSAIDA),;
			stod(TRC->Z1_EXPINI),;
			TRC->Z1_STATUS,;
			TRC->PROXIT})
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
		aColsEx[nLin,07] := aDadosRoms[i][7]
		aColsEx[nLin,08] := aDadosRoms[i][8]
		aColsEx[nLin,Len(aFields)+1] := .F.
	Next
	
oMSNewGe1 := TCBrowse():New(057, 005, 395, 185,,{'Romaneio','Item','Rota','Veiculo','Data Saida','Data Inicio', 'Status'},{35,20,130,30,45,45,40},oDlg1,,,,,,,oFont1,,,,,.F.,,.T.,,.F.,,,.T.)
oMSNewGe1 :AddColumn(TCColumn():New("ROMANEIO"	, {|| aColsEx[oMSNewGe1:nAt,01]},"@!",,,"CENTER", 35,.F.,.F.,,{|| .F. },,.F., ) )
oMSNewGe1 :AddColumn(TCColumn():New("ITEM"	,{|| aColsEx[oMSNewGe1:nAt,02]},"@!",,,"CENTER", 20,.F.,.F.,,{|| .F. },,.F., ) )
oMSNewGe1 :AddColumn(TCColumn():New("ROTA"	, {|| aColsEx[oMSNewGe1:nAt,03]},"@!",,,"CENTER",130,.F.,.F.,,{|| .F. },,.F., ) )
oMSNewGe1 :AddColumn(TCColumn():New("VEICULO"	, {|| aColsEx[oMSNewGe1:nAt,04]},"@!",,,"CENTER", 30,.F.,.F.,,{|| .F. },,.F., ) )
oMSNewGe1 :AddColumn(TCColumn():New("DATA SAIDA"	, {|| aColsEx[oMSNewGe1:nAt,05]},"@!",,,"CENTER", 45,.F.,.F.,,{|| .F. },,.F., ) )
oMSNewGe1 :AddColumn(TCColumn():New("DATA INICIO"	, {|| aColsEx[oMSNewGe1:nAt,06]},"@!",,,"CENTER", 45,.F.,.F.,,{|| .F. },,.F., ) )
oMSNewGe1 :AddColumn(TCColumn():New("STATUS"	, {|| aColsEx[oMSNewGe1:nAt,07]},"@!",,,"CENTER", 40,.F.,.F.,,{|| .F. },,.F., ) )

oMSNewGe1:nLinhas := 1
oMSNewGe1:SetArray(aColsEx)
oMSNewGe1:Refresh()


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
Static Function carregam()

	Static aFdOutrRom := {}
	Static aFdVenc := {}
	Static aFdExced :={}  //retirado para testar solu็ใo de excedentes registrados e no grid
	Static aFdNotExist := {}
	Static aFdFalta	:= {}
	Static nTotalGeral := 0
	Static nQtSemEtq := 0
	Static nApontSucess := 0
	Static nLeituras := 0
	Static Hoje := dtos(ddatabase)

	cQry := ""
	Static aDadosC := {}
	Static cProdGrid := ""
	Static nQtdFardo:=0
	Static _nResta := 0
	Static _nExced := 0
	Static _cMotFalta :=""
	Static nPesoCarr := 0
	Static nQtdCarr := 0
	Static nPesoRom := 0
	Static nPesoPedTot := 0 
	Static TRC2 := {}

	pos := oMSNewGe1:nAt
	cNumRom :=  trim(oMSNewGe1:aArray[pos][1])
	if nItem = 2  //campo Item 2 (proximo)
		//cRomIt	:= val(trim(oMSNewGe1:aCols[pos][8]))
		if nProxIt == 1
			nProxIt := val(trim(oMSNewGe1:aArray[pos][2]))
		else
			nProxIt := nProxIt - 1
		EndIf
		cRomIt := strzero(nProxIt,2,0)
	else
		nProxIt := val(trim(oMSNewGe1:aArray[pos][2]))
		cRomIt	:= trim(oMSNewGe1:aArray[pos][2])
	EndIF

	cRota	:= trim(oMSNewGe1:aArray[pos][3])
	cVeic	:= trim(oMSNewGe1:aArray[pos][4])
	//cMotori	:= trim(oMSNewGe1:aCols[pos][5])
	cDtSaida := oMSNewGe1:aArray[pos][5]
	

//PRODUTO POR ITEM DE ROMANEIO PARA CARREGAMENTO
/*  //SQL QUE BUSCA GERAL DO ROMANEIO
cQry := " SELECT ISNULL(D.B1_GRUPO,'') B1_GRUPO, ISNULL(A.C6_PRODUTO,'') C6_PRODUTO, ISNULL(B.Z3_PRODUTO,'') Z3_PRODUTO, ISNULL(D.B1_ORDEM,'') B1_ORDEM "
cQry += " ,ISNULL(D.B1_PRVALID,0) B1_PRVALID,ISNULL(D.B1_DESC,'') B1_DESC, ISNULL(SUM(A.QTDPED),0) AS QTDVEN,  ISNULL(SUM(QTDROM),0) QTDROM,  ISNULL(SUM(QTDROM),0)*D.B1_PESO AS PESO "
cQry += " FROM EXP_ROMPEDIDO A LEFT JOIN EXP_ROMFARDOS B ON A.Z1_NUM = B.Z3_ROMANEI AND A.C6_PRODUTO=B.Z3_PRODUTO "
cQry += " INNER JOIN  SB1010 AS D ON A.C6_PRODUTO = D.B1_COD"
cQry += " WHERE  A.Z1_NUM='"+cNumRom+"' "
cQry += " GROUP BY A.Z1_NUM, A.C6_PRODUTO, A.Z1_EXPINI, B1_GRUPO, Z3_PRODUTO, B1_ORDEM,B1_PRVALID, B1_DESC, B1_PESO"
cQry += " ORDER BY B1_ORDEM,C6_PRODUTO"  
*/

/*cQry := "  SELECT A.Z1_NUM,  A.Z1_ITEM, A.C6_PRODUTO, D.B1_GRUPO, D.B1_ORDEM, D.B1_DESC, D.B1_PESO, SUM(A.QTDPED) AS QTDVEN, SUM(QTDROM) AS QTDROM"
cQry += " FROM EXP_ROMITPEDIDO A LEFT OUTER JOIN EXP_ROMITFARDOS B ON A.Z1_NUM = B.Z3_ROMANEI AND A.C6_PRODUTO=B.Z3_PRODUTO AND A.Z1_ITEM=B.Z1_ITEM "
cQry += " INNER JOIN  SB1010 AS D ON A.C6_PRODUTO = D.B1_COD WHERE  A.Z1_NUM='"+cNumRom+"' AND A.Z1_ITEM='"+cRomIt+"' "
cQry += "  GROUP BY A.Z1_NUM,  A.Z1_ITEM, A.C6_PRODUTO, B1_GRUPO, B1_ORDEM, B1_DESC, B1_PESO "
cQry += "  ORDER BY B1_ORDEM,C6_PRODUTO "
*/

cQry := " SELECT  Z3_ROMANEI AS Z1_NUM,  Z1_ITEM, Z3_PRODUTO AS C6_PRODUTO, D.B1_GRUPO, D.B1_ORDEM, D.B1_DESC, D.B1_PESO, 0 AS QTDVEN, QTDROM "
cQry += " FROM  EXP_ROMITFARDOS B INNER JOIN  SB1010 AS D ON B.Z3_PRODUTO = D.B1_COD WHERE  B.Z3_ROMANEI='"+cNumRom+"' AND Z1_ITEM='"+cRomIt+"' "
cQry += " AND Z3_PRODUTO NOT IN (SELECT C6_PRODUTO FROM EXP_ROMITPEDIDO WHERE Z1_NUM='"+cNumRom+"' AND Z1_ITEM='"+cRomIt+"' )" 
cQry += " UNION SELECT A.Z1_NUM,  A.Z1_ITEM, A.C6_PRODUTO, D.B1_GRUPO, D.B1_ORDEM, D.B1_DESC, D.B1_PESO, A.QTDPED AS QTDVEN, QTDROM "
cQry += " FROM EXP_ROMITPEDIDO A LEFT OUTER JOIN EXP_ROMITFARDOS B ON A.Z1_NUM = B.Z3_ROMANEI AND A.C6_PRODUTO=B.Z3_PRODUTO AND A.Z1_ITEM=B.Z1_ITEM "
cQry += " INNER JOIN  SB1010 AS D ON A.C6_PRODUTO = D.B1_COD WHERE  A.Z1_NUM='"+cNumRom+"' AND A.Z1_ITEM='"+cRomIt+"' " 
cQry += " ORDER BY B1_ORDEM,C6_PRODUTO "


cQry := ChangeQuery(cQry)
TCQUERY cQry NEW ALIAS "TRC2"

DBSelectArea("SZ3")
aDadosC := {}

While !TRC2->(Eof())  

	nQtdFardo := TRC2->QTDROM //Quantidade carregada no romaneio
	nPesoRom :=  TRC2->B1_PESO*TRC2->QTDROM
	nPesoPed := TRC2->B1_PESO*TRC2->QTDVEN
	nQtdCarr := nQtdCarr + TRC2->QTDROM  //Total Quantidade carregada
	
	nPesoCarr:= nPesoCarr + nPesoRom  //Total peso carregado
	nPesoPedTot := nPesoPedTot + nPesoPed

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

	Aadd(aDadosC,{cProdGrid,;
		cDescGrid,;
		TRC2->QTDVEN,;
		nQtdFardo,;
		_nResta,;
		_nExced,;
		_cMotFalta,;
		TRC2->B1_GRUPO,;
		nPesoRom })
		
		//dDtLoteOk,; //incluir no vetor caso for informar proximo lote a carregar
	TRC2->(DbSkip())
EndDo

TRC2->(DbCloseArea())

Return

//***********************************************
//  Grid da tela inicial - Ordem de Produ็ใo
//***********************************************
Static Function TelaCarga(It)
	 
	Static oDlg2
	Static BmpLogo
	//Static oBtnAponta
	//Static oBtnImprimir


	Public oFontGrid
	Public nTamCod
	Public nTamDesc
	Public nColTela
	Public nLinTela
	Public nTamTela    //1= 15"  2=21" 3=32" 4=42"
	Public nColG1
	Public nLinG1
	Public nColG2
	Public nLinG2
	Public nLinh
	Public nTamProd
	Static nItem

	Public oGetCodBar
	Public cGetCodBar := Space(13)
	Public oCbxFinalizados
	Public lCbxFinalizados := .T.

	nItem := It 
	HrInicio := time()
	HrFim := ""
	cStatus := ""
	nCod := 0
	#define DS_MODALFRAME 128 //Desabilita fechar tela pelo X


//	Static lInicioCarg
//	lInicioCarg := .f.
	Public cEmailErro :=""
	Public cAssunto :=""

// Local aSize := {}
 //Local bOk := {|| }
 //Local bCancel:= {|| }
	aSize := MsAdvSize(.F.)
 /*
 MsAdvSize (http://tdn.totvs.com/display/public/mp/MsAdvSize+-+Dimensionamento+de+Janelas)
 https://tdn.totvs.com/pages/releaseview.action?pageId=6815046
  aSize[1] = 1 -> Linha inicial แrea trabalho.  aSize[2] = 2 -> Coluna inicial แrea trabalho.	 aSize[3] = 3 -> Linha final แrea trabalho. 	
  aSize[4] = 4 -> Coluna final แrea trabalho.	aSize[5] = 5 -> Coluna final dialog (janela).	aSize[6] = 6 -> Linha final dialog (janela).
 aSize[7] = 7 -> Linha inicial dialog (janela).
 */

//Agora montamos uma array com os elementos da tela: //Aonde devemos informar
//AAdd( aObjects, { Tamanho X (horizontal) , Tamanho Y (vertical), Dimensiona X , Dimensiona Y, Retorna dimens๕es X e Y ao inv้s de linha / coluna final } )
	aObjects := {}
	AAdd( aObjects, { 330 , 120, .T. , .T. , .F. } ) //Botใo Grid
	AAdd( aObjects, { 330 , 100, .T. , .T. , .F. } )

//Montamos a array com o valor da tela, aonde:
//aInfo := { 1=Linha inicial, 2=Coluna Inicial, 3=Linha Final, 4=Coluna Final, Separa็ใo X, Separa็ใo Y, Separa็ใo X da borda (Opcional), Separa็ใo Y da borda (Opcional) }
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5 , 5 , 5 , 5 }

	//DEFINE FONTE DE ACORDO COM TAMANHO DA TELA
	if aSize[3] > 900 .and. aSize[4] > 400
		oFontGrid := oFont5
		nTamDesc := 300
		nTamTela := 1
		nColTela := 1913  
		nLinTela := 1043
		nColG1	:= 563
		nLinG1 	:= 443
		nColG2	:= 363
		nLinG2	:= 443
		nLinh	:= 2
		nTamProd := 230
		nCod := 50
		
	Else
		oFontGrid := oFont1
		nTamDesc := 150
		nTamTela := 2
		nColTela := 1359  //aSize[5]
		nLinTela := 731   //aSize[6]
		nColG1	:= 410
		nLinG1 	:= 300
		nColG2	:= 240
		nLinG2	:= 300
		nLinh	:= 1
		nTamProd := 130
		nCod := 30
	EndIf

//Passamos agora todas as informa็๕es para o calculo das dimen็๕es://MsObjSize( aInfo, aObjects, Mantem Propor็ใo , Disposi็ใo Horizontal )
	aPosObj := MsObjSize( aInfo, aObjects, .T. , .F. )

	Carregam()

////Define MsDialog oDialog TITLE "Titulo" STYLE DS_MODALFRAME From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
 //Se nใo utilizar o MsAdvSize, pode-se utilizar a propriedade lMaximized igual a T para maximizar a janela
 //oDialog:lMaximized := .T. //Maximiza a janela
 //Usando o estilo STYLE DS_MODALFRAME, remove o botใo X

///******************************************************************************
//****************         MONTAGEM DA TELA            ************************
//*****************************************************************************
	DEFINE MSDIALOG oDlg2 TITLE "Carregamento Romaneio "+cNumRom FROM 0, 0 TO nLinTela-170, nColTela-70 COLORS 0, 16777215 PIXEL Style DS_MODALFRAME
	@ 002, 003 SAY oLblNum PROMPT cNumRom + "-" +cRomIt   SIZE 060, 011 OF oDlg2 FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 007, 050 SAY oSay3 PROMPT "Codigo de Barras :" SIZE 051, 011 OF oDlg2 COLORS 0, 16777215 PIXEL
	@ 005, 100 MSGET oGetCodBar VAR cGetCodBar SIZE 132, 010 OF oDlg2 COLORS 0, 16777215  ON CHANGE (IncluiLeitor()) PIXEL
	@ 002, 250 GROUP oGroup1 TO 020, 600 PROMPT "" OF oDlg2 COLOR 0, 16777215 PIXEL
	@ 004, 255 SAY oLblVeic PROMPT "Veํculo:" SIZE 060, 011 OF oGroup1 FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 004, 290 SAY oTxtVeic PROMPT 	cVeic SIZE 040, 011 OF oGroup1 FONT oFont3 COLORS 0, 16777215 PIXEL
	@ 004, 310 SAY oLblRota PROMPT "Rota:" SIZE 060, 011 OF oGroup1 FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 004, 340 SAY oTxtRota PROMPT cRota SIZE 200, 011 OF oGroup1 FONT oFont1 COLORS 0, 16777215 PIXEL 
	@ 004, 460 SAY oLblSaida PROMPT "Saํda:"   SIZE 060, 011 OF oGroup1 FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 004, 500 SAY oTxtSaida PROMPT cDtSaida SIZE 060, 011 OF oGroup1 FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 002, nColG1+175 BUTTON oBtnResumo PROMPT "PROX. ITEM" SIZE 040, 015 OF oDlg2 ACTION  ItemSenha() PIXEL	
	@ 002, nColG1+220 BUTTON oBtnExc PROMPT "EXC.FARDOS" SIZE 040, 015 OF oDlg2 ACTION (retfardos()) PIXEL
	@ 002, nColG1+265 BUTTON oBtnApont PROMPT "PAUSAR" SIZE 040, 015 OF oDlg2 ACTION (PausaRom()) PIXEL  
	@ 002, nColG1+310 BUTTON oBtnFinaliz PROMPT "FINALIZAR" SIZE 040, 015 OF oDlg2 ACTION (finalizaSenha()) PIXEL
	@ 030, 010 SAY oLblPend PROMPT "PENDENTES"   SIZE 060, 011 OF oDlg2 FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 030, nColG1+200 SAY oLblPeso PROMPT "PESO: "   SIZE 060, 011 OF oDlg2 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 030, nColG1+210 SAY oLblTotPeso PROMPT str(nPesoCarr)   SIZE 060, 011 OF oDlg2 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 030, nColG1+300 SAY oLblTotal PROMPT "TOTAL: " SIZE 100, 011 OF oDlg2 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 030, nColG1+306 SAY oTxtValTot PROMPT str(nQtdCarr) OF oDlg2 FONT oFont1 COLORS 0, 16777215 PIXEL
	GridCarga()	
	ACTIVATE MSDIALOG oDlg2 CENTERED	

Return

Static Function GridCarga()

Local I	
Static aFieldsCg := {}
Static aColsExCg  
Static aColsConc 
Public oBrowse := {}
Public oBrwFinaliz := {}
	
//******************************************************************************
//****************         MONTAGEM DOS DADOS           ************************
//******************************************************************************

AADD(aFieldsCg,{"PRODUTO" ,"CODIGO"    ,"" ,10 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
AADD(aFieldsCg,{"DESCRICAO" ,"DESCRI"    ,"" ,40 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
AADD(aFieldsCg,{"QUANTIDADE"  ,"QUANT"   ,"" ,09 ,2, ,"๛","N","" ,"V",  ,  ,".F."} )
AADD(aFieldsCg,{"REGISTRADO"  ,"REGISTRADO"   ,"" ,09 ,2, ,"๛","N","" ,"V",  ,  ,".F."} )
AADD(aFieldsCg,{"RESTANTE"  ,"RESTANTE"   ,"" ,09 ,2, ,"๛","N","" ,"V",  ,  ,".F."} )
AADD(aFieldsCg,{"EXCEDENTE"  ,"EXCEDENTE"   ,"" ,09 ,2, ,"๛","N","" ,"V",  ,  ,".F."} )
AADD(aFieldsCg,{"MOTIVO FALTA"  ,"MOTFALTA"   ,"" ,08 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
AADD(aFieldsCg,{"GRUPO" ,"GRUPO"    ,"" ,6 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )
//AADD(aFieldsCg,{"CARREGAR LOTE"  ,"LOTECARR"   ,"" ,08 ,0, ,"๛","C","" ,"V",  ,  ,".F."} )

//Preenche matrix de Itens a carregar

 aColsExCg := {}

For I:= 1 To Len(aDadosC)
	
	IF aDadosC[i][5] <> 0  .or.  aDadosC[i][6] > 0
		AADD(aColsExCg,Array(Len(aFieldsCg)+1))
		nLin := Len(aColsExCg)

		aColsExCg[nLin,01] := aDadosC[i][1]
		aColsExCg[nLin,02] := aDadosC[i][2]
		aColsExCg[nLin,03] := Transform(aDadosC[i][3],"@E 9999") 	//Quantidade
		aColsExCg[nLin,04] := Transform(aDadosC[i][4],"@E 9999")	//Registrado 	 
		aColsExCg[nLin,05] := Transform(aDadosC[i][5],"@E 9999")	//Restante  
		aColsExCg[nLin,06] := Transform(aDadosC[i][6],"@E 9999")	//Excedente
		aColsExCg[nLin,07] := aDadosC[i][7]
		aColsExCg[nLin,08] := aDadosC[i][8]
		aColsExCg[nLin,09] := Transform(aDadosC[i][9],"@E 9999")  
		
		aColsExCg[nLin,Len(aFieldsCg)+1] := .F.

	ENDIF

Next

//Preenche matrix de Itens concluํdos
aColsConc := {}
For I:= 1 To Len(aDadosC)

	IF  aDadosC[i][5]  = 0  .and.  aDadosC[i][6] = 0
		AADD(aColsConc,Array(Len(aFieldsCg)+1))
		nLin := Len(aColsConc)

		aColsConc[nLin,01] := aDadosC[i][1]
		aColsConc[nLin,02] := aDadosC[i][2]
		aColsConc[nLin,03] := Transform(aDadosC[i][3],"@E 9999") 
		aColsConc[nLin,04] := Transform(aDadosC[i][4],"@E 9999") 
		aColsConc[nLin,05] := Transform(aDadosC[i][5],"@E 9999") 
		aColsConc[nLin,06] := Transform(aDadosC[i][6],"@E 9999") 
		aColsConc[nLin,07] := aDadosC[i][7]
		aColsConc[nLin,08] := aDadosC[i][8]
		aColsConc[nLin,09] := Transform(aDadosC[i][9],"@E 9999")  

		aColsConc[nLin,Len(aFieldsCg)+1] := .F.
	EndIf
Next

	// Cria Botoes com metodos bแsicos
//	TButton():New( 025, 500, "PgUp", oDlg2,{|| oBrowse:PageUp(30), oBrowse:setFocus() },30,010,,,.F.,.T.,.F.,,.F.,,,.F. )
//*************************************************************
//	TButton():New( 025, 530, "PgDn" , oDlg2,{|| oBrowse:PageDown(30), oBrowse:setFocus() },30,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	//TButton():New( 196, 002, "Linha atual", oDlg2,{|| alert(oBrowse:nAt) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	//TButton():New( 208, 052, "Nr Linhas", oDlg2,{|| alert(oBrowse:nLen) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	//TButton():New( 208, 002, "Linhas visiveis", oDlg2,{|| alert(oBrowse:nRowCount()) },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)

oBrowse := {}

// Cria Browse
oBrowse := TCBrowse():New(040,10,nColG1,nLinG1-50,,{'','PRODUTO','DESCRIวรO','QUANTIDADE','REGISTRADO','RESTANTE','EXCEDENTE','MOTIVO FALTA'},{10,50,50,50,50,50,50,50},oDlg2,,,,,,,oFontGrid,,,,,.F.,,.T.,,.F.,,,.T.)
//oBrowse := TCBrowse():New(040,020,500,450,,{'','PRODUTO','DESCRIวรO','QUANTIDADE','REGISTRADO','RESTANTE','EXCEDENTE','MOTIVO FALTA'},{10,50,50,50,50,50,50,50},oDlg2,,,,,,,oFontGrid,,,,,.F.,,.T.,,.F.,,,.T.)
oBrowse:AddColumn(TCColumn():New("PRODUTO"	, {|| aColsExCg[oBrowse:nAt,01]},"@!",,,"CENTER", nCod,.F.,.F.,,{|| .F. },,.F., ) )
oBrowse:AddColumn(TCColumn():New("DESCRIวรO"	, {|| aColsExCg[oBrowse:nAt,02]},"@!",,,"CENTER", nTamDesc,.F.,.F.,,{|| .F. },,.F., ) )
oBrowse:AddColumn(TCColumn():New("QUANTIDADE"	, {|| aColsExCg[oBrowse:nAt,03]},"@E 9999",,,"CENTER"  , 040,.F.,.F.,,,,.F., ) )
oBrowse:AddColumn(TCColumn():New("REGISTRADO"	, {|| aColsExCg[oBrowse:nAt,04]},"@E 9999",,,"CENTER", 040,.F.,.T.,,,,.F., ) )
oBrowse:AddColumn(TCColumn():New("RESTANTE" 	, {|| aColsExCg[oBrowse:nAt,05]},"@E 9999",,,"CENTER"  , 040,.F.,.T.,,,,.F., ) )
oBrowse:AddColumn(TCColumn():New("EXCEDENTE" 	, {|| aColsExCg[oBrowse:nAt,06]},"@E 9999",,,"CENTER"  , 040,.F.,.T.,,,,.F., ) )

oBrowse:nLinhas := nLinh
oBrowse:SetArray(aColsExCg)
oBrowse:lUseDefaultColors := .F.
oBrowse:SetBlkBackColor({|| GETDCLR(oBrowse:nAt)})
oBrowse:Refresh()

oBrwFinaliz := TCBrowse():New(040,nColG1+20,nColG2-30,nLinG2-50,,{'','PRODUTO','DESCRIวรO','QUANTIDADE'},{20,200,005},oDlg2,,,,,,,oFontGrid,,,,,.F.,,.T.,,.F.,,,.T.)
oBrwFinaliz :AddColumn(TCColumn():New("PRODUTO"	, {|| aColsConc[oBrwFinaliz:nAt,01]},"@!",,,"CENTER", nCod,.F.,.F.,,{|| .F. },,.F., ) )
oBrwFinaliz :AddColumn(TCColumn():New("DESCRIวรO"	, {|| aColsConc[oBrwFinaliz:nAt,02]},"@!",,,"CENTER", nTamProd,.F.,.F.,,{|| .F. },,.F., ) )
oBrwFinaliz :AddColumn(TCColumn():New("QUANT."	, {|| aColsConc[oBrwFinaliz:nAt,03]},"@E 9999",,,"CENTER"  , 005,.F.,.F.,,,,.F., ) )

oBrwFinaliz:nLinhas := nLinh
oBrwFinaliz:SetArray(aColsConc)
//oBrwFinaliz:lUseDefaultColors := .F.
//oBrwFinaliz:SetBlkBackColor({|| GETDCLR2(oBrwFinaliz:nAt)})
oBrwFinaliz:Refresh()

oBrowse:bGotFocus :=  {||oGetCodBar:SetFocus()}
oBrwFinaliz:bGotFocus :=  {||oGetCodBar:SetFocus()}
oGetCodBar:SetFocus()

Return

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
	Static cCodProdBar := ""
	Static cDescProd := ""
	//Private oMSNewApont
	cHrApont := ""
	
	nItens := oBrowse:nLen //nItens := len(oMSNewGe2:aCols)
 
	//Verifica se tamanho do c๓digo estแ correto
	If	len(Alltrim(cGetCodBar)) = 13
		
		dbSelectArea("SZ3")
		DbSetOrder(1)
		dbGotop()
		dbseek(xfilial("SZ3")+substr(Alltrim(cGetCodBar),1,12))
		//Verifica se fardo foi encontrado
		if SZ3->(found())
			//VERIFICA SE FARDO Jม FOI REGISTRADO			
			IF Trim(SZ3->Z3_ROMANEI)=""
				
				cCodProdBar := SZ3->Z3_PRODUTO
					dbSelectArea("SB1")
					DbSetOrder(1)
					dbseek(xfilial("SB1")+SZ3->Z3_PRODUTO)
					cDescProd := SB1->B1_DESC  
				
				RecLock("SZ3",.f.)
				SZ3->Z3_ROMANEI 	:= cNumRom   //CRIAR OUTRO CAMPO CHAMADO Z3_ROMANEIO PARA SUBSTITUIR
				SZ3->Z3_LOTE 	:= cNumRom+cRomIt
				SZ3->Z3_HREXP  		:= time()
				SZ3->Z3_DATEXP  	:= dDatabase  //DATA DE APONTAMENTO DO FARDO - INCLUIR CAMPO
				SZ3->(MsUnlock())
				atual()
				nLeituras += 1
				nApontSucess += 1
			else
				if Trim(SZ3->Z3_ROMANEI)<>Trim(cNumRom)  //Caso n๚mero registrado for diferente do romaneio atual.
					MSGSTOP("Fardo registrado em outro romaneio. Informar ger๊ncia.")
					conout("TELAEXPED: O fardo "+ cGetCodBar +" jแ estแ registrado no romaneio "+SZ3->Z3_ROMANEI)
					Aadd(aFdOutrRom,{Alltrim(cGetCodBar),;
						SZ3->Z3_PRODUTO,;
						SZ3->Z3_ROMANEI})
					nLeituras += 1
				EndIf
				Return
			EndIf
		else
			MSGSTOP("Fardo nใo encontrado. Informe o administrador do sistema ou ger๊ncia.")
			conout("TELAEXPED: O fardo "+ cGetCodBar +" nใo foi encontrado no SZ3.")
			AADD(aFdNotExist,cGetCodBar)
			nLeituras += 1
			Return
		EndIf
	Else
		MSGSTOP("O c๓digo "+ cGetCodBar +" nใo esta no formato e tamanho correto.")
		conout("TELAEXPED: O c๓digo "+ cGetCodBar +" nใo esta no formato e tamanho correto.")
		Return
	EndIf

	if nLeituras = 1		
		dbSelectArea("SZ1")
		dbGotop()
		//dbseek(xfilial("SZ1")+cNumRom+"01")
		dbseek(xfilial("SZ1")+cNumRom+cRomIt)
	
		if SZ1->(found())   //verifica se romaneio foi encontrado
			if Trim(SZ1->Z1_HRINI)==""
				RecLock("SZ1",.f.)
				SZ1->Z1_EXPINI := date()
				SZ1->Z1_HRINI := time()
				SZ1->(MsUnlock())
			End If
		Else
			MSGINFO("Romaneio nao encontrado no inicio. Informar administrador.")
			conout("TELAEXPED: Romaneio "+cNumRom+cRomIt+" nao encontrado no inicio. Informar administrador.")
		EndIf
	EndIf

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
Return( Nil )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  ATUAL           Autor: Weiden        บ Data ณ  10/14/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Atualiza dados nos grid.					              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function atual()

	Local nLin := 0
	Local lGrid1 := .f.
	//dbSelectArea("SZ3")
	//dbGotop()
	//dbseek(xfilial("SZ3")+substr(Alltrim(cGetCodBar),1,8)+substr(cGetCodBar,9,4)) //ALTERADO 28/07/15

//Atualiza Grid 1 - Itens Pendentes
	For nLin:= 1 To Len(aColsExCg)  //Array que guarda dados do Grid
		
		if	Trim(aColsExCg[nLin,01]) == Trim(cCodProdBar) 
			
			lGrid1 = .t.
			aColsExCg[nLin,04] :=  Transform(val(aColsExCg[nLin,04])+1,"@E 9999") //str(val(aColsExCg[nLin,04])+1)
			
			if val(aColsExCg[nLin,04])<=val(aColsExCg[nLin,03])
				aColsExCg[nLin,05] :=  Transform(val(aColsExCg[nLin,05])-1,"@E 9999")  //str(val(aColsExCg[nLin,05])-1)				
			else
				aColsExCg[nLin,06] := Transform(val(aColsExCg[nLin,06])+1,"@E 9999")  //str(val(aColsExCg[nLin,06])+1)
			EndIf
			
			if  val(aColsExCg[nLin,05])=0 .and. val(aColsExCg[nLin,06])=0
				AADD(aColsConc,Array(Len(aFieldsCg)+1))
				Linew := Len(aColsConc)
				aColsConc[Linew,01] := aColsExCg[nLin,01]  //Produto
				aColsConc[Linew,02] := aColsExCg[nLin,02]  //Descri็ใo
				aColsConc[Linew,03] := aColsExCg[nLin,03]  //Quantidade total
				aColsConc[Linew,04] := aColsExCg[nLin,04]  //Registrado
				aColsConc[Linew,05] := aColsExCg[nLin,05]  //Restante
				aColsConc[Linew,06] := aColsExCg[nLin,06]  //Excedente
				aColsConc[Linew,07] := aColsExCg[nLin,07]  //Motivo Falta
				aColsConc[Linew,08] := aColsExCg[nLin,08]  //Grupo
				lConcAtu := .t.
			EndIf
			exit
		EndIf
	Next

	//Atualiza Grid 2 - Itens Concluํdos, caso produto nใo estiver no Grid 1.
	if lGrid1 = .f. //Caso produto nใo esteja no primeiro grid, procurar o mesmo no segundo grid (concluํdos)
		For nLin:= 1 To Len(aColsConc)   //Array que guarda dados do Grid
				
			if	Trim(aColsConc[nLin,01]) == Trim(cCodProdBar) 
				aColsConc[nLin,04] := Transform(val(aColsConc[nLin,04])+1,"@E 9999")  //str(val(aColsConc[nLin,04])+1)
				
				if val(aColsConc[nLin,04])<= val(aColsConc[nLin,03])
					aColsConc[nLin,05] :=  Transform(val(aColsConc[nLin,05])-1,"@E 9999") //  str(val(aColsConc[nLin,05])-1)				
				else
					aColsConc[nLin,06] :=   Transform(val(aColsConc[nLin,06])+1,"@E 9999") //str(val(aColsConc[nLin,06])+1)
				EndIf
				lGrid1 := .t.
				
				if  val(aColsConc[nLin,04])>val(aColsConc[nLin,03])
					AADD(aColsExCg,Array(Len(aFieldsCg)+1))
					Linew := Len(aColsExCg)
					aColsExCg[Linew,01] := aColsConc[nLin,01]
					aColsExCg[Linew,02] := aColsConc[nLin,02]
					aColsExCg[Linew,03] := aColsConc[nLin,03]
					aColsExCg[Linew,04] := aColsConc[nLin,04]
					aColsExCg[Linew,05] := aColsConc[nLin,05] 
					aColsExCg[Linew,06] := aColsConc[nLin,06]
					aColsExCg[Linew,07] := aColsConc[nLin,07]
					aColsExCg[Linew,08] := aColsConc[nLin,08]
				End If
				exit
			EndIf
		Next   
	EndIf

	//Exclui registros concluํdos de array do Grid Pendentes
	nLin := 1			
	While nLin <= Len(aColsExCg) 
		if	aColsExCg[nLin,03] == aColsExCg[nLin,04]
			ADEL(aColsExCg, nLin)
			ASIZE(aColsExCg,Len(aColsExCg)-1)
			nLin := 1 
			Loop
		EndIf
		nLin++
	EndDo
	//Exclui registros pendentes do array do Grid Concluidos
	nLin := 1
	While nLin <= Len(aColsConc)  //Exclui registros do array
		if	 aColsConc[nLin,03] <> aColsConc[nLin,04]
			ADEL(aColsConc, nLin)
			ASIZE(aColsConc,Len(aColsConc)-1)
			nLin := 1
			Loop 
		EndIf
		nLin++
	EndDo

	//Caso item lido nใo estar em nenhum Grid (fora do romaneio)
	if lGrid1 = .f.
			AADD(aColsExCg,Array(Len(aFieldsCg)+1))
			Linew := Len(aColsExCg)
			aColsExCg[Linew,01] := cCodProdBar
			aColsExCg[Linew,02] := cDescProd
			aColsExCg[Linew,03] := 0
			aColsExCg[Linew,04] := 1
			aColsExCg[Linew,05] := 0 
			aColsExCg[Linew,06] := 1
			aColsExCg[Linew,07] := ""
			aColsExCg[Linew,08] := ""
	EndIf

	//oBrowse:nLinhas := nLinh
	oBrowse:SetArray(aColsExCg)
	oBrowse:lUseDefaultColors := .F.
	oBrowse:SetBlkBackColor({|| GETDCLR(oBrowse:nAt)})
	oBrowse:Refresh()
		
	//oBrwFinaliz:nLinhas := nLinh
	oBrwFinaliz:SetArray(aColsConc)
	//oBrwFinaliz:lUseDefaultColors := .F.
	//oBrwFinaliz:SetBlkBackColor({|| GETDCLR2(oBrwFinaliz:nAt)})
	oBrwFinaliz:Refresh()

	oGetCodBar:SetFocus()
	oBrowse:bGotFocus :=  {||oGetCodBar:SetFocus()}	

Return

/*
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

	obrowse:SetArray(aColsExCg)   //oMSNewGe2:aCols := aclone (aColsExCg)
	obrowse:bWhen          := { || Len(aColsExCg) > 0 }
	obrowse:Refresh()

Return
*/

Static Function FinalizaSenha()

	Static oDlgPwd, oGet, oBtnFinaliz 
	Static cPassW := space(20)
		
	DEFINE DIALOG oDlgPwd TITLE "Senha Carga" FROM 180,180 TO 280,420 PIXEL
	
	@ 10,10 GET oGet VAR cPassW SIZE 100,15 OF oDlgPwd PIXEL VALID !empty(cPassW) PASSWORD
	@ 30, 50 BUTTON oBtnFinaliz PROMPT "Confirmar" SIZE 060, 015 OF oDlgPwd ACTION (finalizarom()) PIXEL

	ACTIVATE DIALOG oDlgPwd CENTERED

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

if Alltrim(cPassW)  == "plinc123"
	//Alert("Senha OK")
	oDlgPwd:End()

	cData := Dtoc(date())
	HrFim := time()
	aVetorReq := {}

	//logres()
	
	dbSelectArea("SZ1")
	dbGotop()
	//dbseek(xfilial("SZ1")+cNumRom+"01")
	dbseek(xfilial("SZ1")+cNumRom+cRomIt)

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
	//	SZ1->Z1_ITROM := cRomIt
		
		//Marca fardo como registrado e finalizado
		/*
		dbSelectArea("SZ3")
		dbSetOrder(2)
		dbGotop()
		dbseek(xfilial("SZ3")+cNumRom+cRomIt)
		
		cProdCar := SZ3->Z3_PRODUTO
		nQtd := 0
		Do While SZ3->Z3_ROMANEI == cNumRom
			nQtd += 1
			reclock("SZ3",.f.)
			SZ3->Z3_REG := "R"  //Ap๓s testes definir campo e conte๚do definitivo
			SZ3->(MsUnlock())
			SZ3->(dbskip())
		EndDo */
					
	//	ENVMAILEXP('plinc.logistica@gmail.com',cAssunto ,cEmailErro)
		//ENVMAILEXP('vendas@produtosplinc.com.br',cAssunto ,cEmailErro)
		U_ENVMAILEXP('sistemas@produtosplinc.com.br',cAssunto ,cEmailErro)
	Else
		MSGINFO("Nใo encontrado romaneio. Verificar com administrador.")
		conout("TELAEXPED: Nใo encontrado romaneio" +cNumRom+cRomIt +" para finalizar.")
	EndIf
	SZ1->(MsUnlock())
	oDlg2:End()
	//GridRom()
	//carregam(2)
	TelaCarga(2)
else
	Alert("Senha Incorreta!")
	oDlgPwd:End()
EndIf

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
Static Function RetFardos()

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
	//@ 005, 342 BUTTON oBtnResumo PROMPT "Resumo" SIZE 051, 013 OF oDlg4 ACTION (LOGRES(),oGetCodBarFd:SetFocus()) PIXEL
	@ 024, 342 BUTTON oBtnCancel PROMPT "Excluir" SIZE 051, 013 OF oDlg4  ACTION (FardosConf(1),oDlg4:End()) PIXEL
	
//	oBtnResumo:disable()
	oGetCodBarFd:SetFocus()
	ACTIVATE MSDIALOG oDlg4 CENTERED

Return


Static Function DevolFardos()

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
	@ 007, 070 SAY oSay2 PROMPT cNumRom Picture "@!" SIZE 070, 010 OF oDlg4 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 007, 110 SAY oSay3 PROMPT "Veํculo :" SIZE 051, 011 OF oDlg4 COLORS 0, 16777215 PIXEL
	@ 005, 166 MSGET oGetVeic VAR cGetVeic SIZE 50, 010 OF oDlg4 COLORS 0, 16777215  PIXEL
	@ 030, 110 SAY oSay3 PROMPT "Codigo de Barras :" SIZE 051, 011 OF oDlg4 COLORS 0, 16777215 PIXEL
	@ 029, 166 MSGET oGetCodBarFd VAR cGetEtqFd SIZE 132, 010 OF oDlg4 COLORS 0, 16777215  ON CHANGE (IncluiGridLeitor(2)) PIXEL
	MontaGridFardo()
	@ 029, 010 SAY oSayGrav PROMPT "ITENS:" SIZE 060, 015 OF oDlg4 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 029, 065 SAY oSayGrav1 PROMPT nItens Picture "@E 999" SIZE 015, 015 OF oDlg4 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 010, 342 BUTTON oBtnCancel PROMPT "Confirmar" SIZE 051, 013 OF oDlg4  ACTION (FardosConf(2),oGetCodBarFd:SetFocus()) PIXEL
	
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
	I := 0
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
		dbseek(xfilial("SZ3")+substr(Alltrim(cEtiqueta),1,8)+substr(cEtiqueta,9,4)) //ALTERADO 28/07/15
	//VERIFICA SE EXISTE O ITEM NO PRODUTO.
	
		if SZ3->(found())  //.AND. if SZ3->Z3_ROMANEI==cNumRom //retirado verifica romaneio para funcionar fora do romaneio.
		
			If  Trim(SZ3->Z3_ROMANEI) <> "" .or. SZ3->Z3_REG='D' //CASO FARDO FOR ENCONTRADO*
			
				cCodProd := SZ3->Z3_PRODUTO
				
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
					oMSNewApont := MsNewGetDados():New( 057, 005, 250, 396,, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2",,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg4, aFields, aColsExclui)
					oMSNewApont:refresh()
				Endif
			Else
				
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
	x := 0
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
					SZ3->Z3_LOTE:=""
					SZ3->Z3_HREXP:=""
				//	SZ3->Z3_DATEXP:="" //INCLUIR FUNCAO PARA LIMPAR CAMPO.
					msunlock()
								
					//Preenche vetor com somat๓rio de fardos por Produto+Romaneio.
					lexiste := .f.
				//	if Alltrim(SZ3->Z3_REG)<>"" //Verifica se foi registrada saํda do Estoque. Se nใo saiu pelo SD3 nใo devolve.
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
						//reclock("SZ3",.f.)
						//SZ3->Z3_REG := ""
						//msunlock()
				//	EndIF
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
		
		MSGINFO("Excluํdos do romaneio "+ Str(nQtdExclui) +" fardos registrados.")
		conout("TELAEXPED: Excluํdos do romaneio "+ Str(nQtdExclui) +" fardos registrados.")
		
		//MontaGridFardo()
		
		if cNumRom <>'' //para verificar se rotina FARDOS() foi aberto fora ou dentro da rotina de carregamento.
			Carregam() 
			GridCarga() // alterado porque o GridCarga foi mudado para apenas preencher e nใo mais buscar dados.
		EndIf
		oDlg4:end()
	else
		MSGINFO("Nใo existe item lido para excluir.")
		
	EndIf
		
Return


Static Function ENVMAILEXP( cTo, cAssunto, cMensagem )
 
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


Static Function LOGRES()

	_cHora := time()
	aTexto := {}
	aButtons := {}
	cTexto1 := ""
	nFaltaIt := 0
	nFaltaFd := 0
	
	TotalFardos()

	If len(aFdFalta)>0
		cAssunto	:= "SEPARAวรO DA CARGA "+cNumRom+cRomIt+" FINALIZADA INCOMPLETA"
		cEmailErro :="SEPARAวรO DA CARGA FOI FINALIZADA SEM COMPLETAR TODOS OS ITENS."+ENTER
		cEmailErro +="Romaneio: " +cNumRom+cRomIt+ENTER
		cEmailErro +="Hora Inicio:"+ HrInicio +ENTER
		cEmailErro +="Hora Fim:"+ HrFim +ENTER
		cEmailErro += ENTER+"Total Lido:"+ str(nTotalGeral) +ENTER
		cEmailErro += "Total sem Etiqueta:"+ str(nQtSemEtq) +ENTER
		cEmailErro +="Total Geral:"+ str(nTotalGeral+nQtSemEtq) +ENTER
		cEmailErro +=ENTER+"Produtos Faltantes:"+ENTER
		AADD(aTexto,cAssunto)
		AADD(aTexto,"Romaneio: " +cNumRom+cRomIt)
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
			cAssunto	:= "CARREGAMENTO ROMANEIO "+cNumRom+cRomIt+" FINALIZADO COM IRREGULARIDADES"
		Else
			cAssunto	:= "CARREGAMENTO ROMANEIO "+cNumRom+cRomIt+" FINALIZADO TOTALMENTE"
		EndIf
		
		AADD(aTexto,cAssunto)
		cEmailErro +="Romaneio: "+cNumRom+cRomIt+ENTER
		cEmailErro +="Hora Inicio:"+ HrInicio +ENTER
		cEmailErro +="Hora Fim:"+ HrFim +ENTER
		cEmailErro +=ENTER+"Total Lido:"+ str(nTotalGeral) +ENTER
		cEmailErro +="Total sem Etiqueta:"+ str(nQtSemEtq) +ENTER
		cEmailErro +="Total Geral:"+ str(nTotalGeral+nQtSemEtq) +ENTER
		AADD(aTexto,"Romaneio: " +cNumRom+cRomIt)
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

	cTexto1 := ""
	FOR i:= 1 to len(aTexto)
		cTexto1 += aTexto[i]+ENTER
	Next
	MSGINFO(cTexto1)

Return

// Fun็ใo para tratamento das regras de cores para a grid da MsNewGetDados
Static Function GETDCLR(nLinha)
	Local nRet := 0
	Local nCor3 := 16776960 // Verde Claro - RGB(0,255,255) //Local nCor3 := 65280 //VERDE
	Local nCor4 :=  5070329 //fVERMELHO
	Local nCor2 := 16777215 //branco

	if len(aColsExCg) > 0
		if Alltrim(aColsExCg[nLinha][5])<>"" .and. nlinha <= len(aColsExCg)
			If val(aColsExCg[nLinha][6])>0  .and. aColsExCg[nLinha][6]<>"" //_nExced
				nRet := nCor4
			Else 
				nRet := nCor3 
			Endif
		else
			nRet := nCor4
		EndIF
	EndIf
	
Return nRet


Static Function GETDCLR2(nLinha)
	Local nRet := 0
	Local nCor3 := 16776960 // Verde Claro - RGB(0,255,255) //Local nCor3 := 65280 //VERDE
	Local nCor4 := 5070329 //fVERMELHO
	Local nCor2 := 16777215 
	 
	nRet := nCor3
	/*
if len(aColsConc) > 0
 	if Alltrim(aColsConc[nLinha][5])<>""  //_nResta
		If val(aColsConc[nLinha][5])>0 //.AND. aLinha[nLinha][nUsado]
			nRet := nCor2
		Else
			If val(aColsConc[nLinha][5])=0
				If val(aColsConc[nLinha][6])>0  //_nExced
					nRet := nCor4
				Else 
					nRet := nCor3
				Endif
			EndIf
		EndIf	

	Else
		Return
	EndIf
EndIf  
*/
Return nRet


Static Function TotalFardos()
	aFdFalta := {}
	aFdExced := {}
	//nTotalGeral := 0
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



Static Function ItemSenha()

	Static oDlgPwd, oGet, oBtnFinaliz 
	Static cPassW2 := space(20)
	Static cItem := space(2)

	//Alert("tela senha")	
	DEFINE DIALOG oDlgPwd2 TITLE "Senha Supervisor" FROM 180,180 TO 280,420 PIXEL
	//@ 10,10 GET oGet VAR cItem SIZE 100,15 OF oDlgPwd2 PIXEL  
	@ 10,20 GET oGet VAR cPassW2 SIZE 100,15 OF oDlgPwd2 PIXEL VALID !empty(cPassW2) PASSWORD
	@ 30, 50 BUTTON oBtnFinaliz PROMPT "Confirmar" SIZE 060, 015 OF oDlgPwd2 ACTION (MudaItRom()) PIXEL

	ACTIVATE DIALOG oDlgPwd2 CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MUDAITROM	   Autor: Weiden        บ Data ณ  30/01/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Finaliza carregamento e inclusใo de intens no romaneio.    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MudaItRom()

	if Alltrim(cPassW2)  == "ronso"
		
		oDlgPwd2:End()
		oDlg2:End()
		TelaCarga(2)

	else
		Alert("Senha Incorreta!")
		oDlgPwd2:End()
	EndIf

Return

Static Function PausaRom()

	oDlg2:End()
	AtuaRom()

Return


Static Function AtuaRom()

	Static TRCA
	
	aColsEx := {}

//CONSULTA DE DADOS PARA O GRID
cQry := "SELECT A.Z1_NUM, A.Z1_ROTA, A.Z1_DESCRI, A.Z1_DTSAIDA, LTRIM(A.Z1_VEICULO) AS Z1_VEICULO, A.Z1_DTFECH, "
cQry += " A.Z1_MOTORI, A.Z1_STATUS, A.Z1_EXPINI,  MITEM, PROXIT  "
cQry += " FROM SZ1010 A INNER JOIN ROMITEM B ON  A.Z1_NUM = B.Z1_NUM"
cQry += " WHERE A.D_E_L_E_T_='' AND A.Z1_DTSAIDA >='20190101'  "
cQry += " GROUP BY A.Z1_NUM, A.Z1_ROTA, A.Z1_DESCRI, A.Z1_DTSAIDA, A.Z1_VEICULO, A.Z1_DTFECH, "
cQry += "  A.Z1_MOTORI, A.Z1_STATUS, A.Z1_EXPINI,MITEM,  PROXIT   "
cQry += " ORDER BY A.Z1_NUM "

cQry := ChangeQuery(cQry)
TCQUERY cQry NEW ALIAS "TRCA"

	aDadosRom :={}
	
	While !TRCA->(Eof())
		Aadd(aColsEx,{ TRCA->Z1_NUM,;
			TRCA->MITEM,;
			TRCA->Z1_DESCRI,;
			TRCA->Z1_VEICULO,;
			stod(TRCA->Z1_DTSAIDA),;
			stod(TRCA->Z1_EXPINI),;
			TRCA->Z1_STATUS,;
			TRCA->PROXIT})
		TRCA->(DbSkip())
		
	End

	TRCA->(DbCloseArea())

	oMSNewGe1:SetArray(aColsEx)
	oMsNewGe1:Refresh()
	
	
Return( Nil )
