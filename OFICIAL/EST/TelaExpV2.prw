#include "topconn.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#include "TBICONN.CH"
#include "TBICODE.CH"
#INCLUDE "ap5mail.ch"
#include "TOTVS.CH"
#DEFINE ENTER Chr(13)+Chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TELAEXPV2 ver.5.0 �Autor  � Weiden Mendes	 Data �  03/10/11 ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para realizar expedi��o de produtos  e            ���
���          �  baixa de estoque simultaneamente.                         ���
�������������������������������������������������������������������������͹��
���Vers�o    �  3.0 - Inclu�da fun��o de gerar requisi��o e devolu��o	  ���
�� 				de produtos para do estoque.     			              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SIGAQIP()

//User Function SIGAWMS
//User Function Exped2

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


	DEFINE MSDIALOG oDlg1 TITLE "Carregamento V2 5.0 - PLINC " FROM 000, 000  TO 500, 800 COLORS 0, 16777215 PIXEL

    @ 000, 004 BITMAP BmpLogo SIZE 143, 045 OF oDlg1 FILENAME "\\srvpp02\Microsiga\protheus_data\system\logoRel.bmp" NOBORDER PIXEL
	@ 025, 155 SAY oLblResp PROMPT "Separa��o da Carga: " SIZE 100, 011 OF oDlg1 FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 025, 250 SAY oTxtResp PROMPT pswret(1)[1][2] SIZE 060, 011 OF oDlg1 FONT oFont3 COLORS 0, 16777215 PIXEL
	GridRom()
	@ 010, 341 BUTTON oBtnCarreg PROMPT "Carregar" SIZE 051, 013 OF oDlg1 ACTION (carregam()) PIXEL
	IF  LEN(aDadosRoms)==0
		oBtnCarreg:disable()
	EndIf
	@ 025, 341 BUTTON oBtnAponta PROMPT "Par�metros" SIZE 051, 013 OF oDlg1 ACTION Pergunte(cPerg,.T.,"Par�metros") PIXEL
	@ 040, 341 BUTTON oBtnDevol PROMPT "Devolu��o" SIZE 051, 013 OF oDlg1 ACTION (devolfardos()) PIXEL
	ACTIVATE MSDIALOG oDlg1 CENTERED

Return

//***********************************************
//  Grid da tela inicial - Ordem de Produ��o
//***********************************************

Static Function GridRom()

	aColsEx := {}
	aFields := {}
	cQry := ""
	//Static	aDados := {}
	Public aDadosRoms := {}
	STATIC oMSNewGe1

	AADD(aFields,{"Romaneio" ,"ROMAN"    ,"" ,9 ,0, ,"�","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Rota" ,"ROTA"    ,"" ,30 ,0, ,"�","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Veiculo" ,"VEICULO"    ,"" ,7 ,0, ,"�","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Motorista" ,"MOTORISTA"    ,"" ,15 ,0, ,"�","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Data Saida" ,"DTSAIDA"    ,"" ,10 ,0, ,"�","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Data Saida" ,"DTINICIO"    ,"" ,10 ,0, ,"�","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Status" ,"STATUS"    ,"" ,20 ,0, ,"�","C","" ,"V",  ,  ,".F."} )
 
//CONSULTA DE DADOS PARA O GRID
	cQry:="SELECT *,'' AS DA3_COD, '' AS DA4_NOME " //INCLUIR MOTORISTA NA VISUALIZA��O
	cQry += "FROM SZ1010 "
	cQry += "WHERE D_E_L_E_T_='' "
	cQry +=" AND Z1_EXPFIM='' AND Z1_DTSAIDA >='20181007'"      //+ Hoje +"' "
	//cQry +=" AND Z1_DTFECH='' " //Verifica se Romaneio j� foi finalizado.
	
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CARREGAM  �Autor  �Microsiga           � Data �  10/13/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Tela para carregamento de Romaneio selecionado.            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function carregam()
	
	pos := oMSNewGe1:nAt
	cNumRom :=  trim(oMSNewGe1:aCols[pos][1])
	cRota	:= trim(oMSNewGe1:aCols[pos][2])
	cVeic	:= trim(oMSNewGe1:aCols[pos][3])
	cMotori	:= trim(oMSNewGe1:aCols[pos][4])
	cDtSaida := oMSNewGe1:aCols[pos][5]
		
	aFdOutrRom := {}
	aFdVenc := {}
	aFdExced :={}  //retirado para testar solu��o de excedentes registrados e no grid
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

// Local aSize := {}
 //Local bOk := {|| }
 //Local bCancel:= {|| }
	aSize := MsAdvSize(.F.)
 /*
 MsAdvSize (http://tdn.totvs.com/display/public/mp/MsAdvSize+-+Dimensionamento+de+Janelas)
 aSize[1] = 1 -> Linha inicial �rea trabalho.
 aSize[2] = 2 -> Coluna inicial �rea trabalho.
 aSize[3] = 3 -> Linha final �rea trabalho.
 aSize[4] = 4 -> Coluna final �rea trabalho.
 aSize[5] = 5 -> Coluna final dialog (janela).
 aSize[6] = 6 -> Linha final dialog (janela).
 aSize[7] = 7 -> Linha inicial dialog (janela).
 */

//Agora montamos uma array com os elementos da tela:
//Aonde devemos informar
//AAdd( aObjects, { Tamanho X (horizontal) , Tamanho Y (vertical), Dimensiona X , Dimensiona Y, Retorna dimens�es X e Y ao inv�s de linha / coluna final } )
	aObjects := {}
	AAdd( aObjects, { 330 , 120, .T. , .T. , .F. } ) //Bot�o Grid
	AAdd( aObjects, { 330 , 100, .T. , .T. , .F. } )

//Montamos a array com o valor da tela, aonde:
//aInfo := { 1=Linha inicial, 2=Coluna Inicial, 3=Linha Final, 4=Coluna Final, Separa��o X, Separa��o Y, Separa��o X da borda (Opcional), Separa��o Y da borda (Opcional) }
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5 , 5 , 5 , 5 }

//Passamos agora todas as informa��es para o calculo das dimen��es:
//MsObjSize( aInfo, aObjects, Mantem Propor��o , Disposi��o Horizontal )
	aPosObj := MsObjSize( aInfo, aObjects, .T. , .F. )

////Define MsDialog oDialog TITLE "Titulo" STYLE DS_MODALFRAME From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
 //Se n�o utilizar o MsAdvSize, pode-se utilizar a propriedade lMaximized igual a T para maximizar a janela
 //oDialog:lMaximized := .T. //Maximiza a janela
 //Usando o estilo STYLE DS_MODALFRAME, remove o bot�o X

	TelaCarga()


Return

//***********************************************
//  Grid da tela inicial - Ordem de Produ��o
//***********************************************
Static Function TelaCarga()

	Local aList := {}

	pos := oMSNewGe1:nAt
	cNumRom :=  trim(oMSNewGe1:aCols[pos][1])
	cRota	:= trim(oMSNewGe1:aCols[pos][2])
	cVeic	:= trim(oMSNewGe1:aCols[pos][3])
	cMotori	:= trim(oMSNewGe1:aCols[pos][4])
	cDtSaida := oMSNewGe1:aCols[pos][5]
		
	aFdOutrRom := {}
	aFdVenc := {}
	aFdExced :={}  //retirado para testar solu��o de excedentes registrados e no grid
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
 	//Static oFont1 := TFont():New("MS Sans Serif",,018,,.T.,,,,,.F.,.F.)
	Static oFont1 := TFont():New("Arial",,018,,.T.,,,,,.F.,.F.)
	Static oFont2 := TFont():New("Arial",,020,,.T.,,,,,.F.,.F.)
	Static oFont3 := TFont():New("Arial",,024,,.F.,,,,,.F.,.F.)
	Static oFont4 := TFont():New("Arial",,026,,.T.,,,,,.F.,.F.)
	Static oFont5 := TFont():New("Arial",,028,,.T.,,,,,.F.,.F.)
	Static oFontGrid
	Static nTamCod
	Static nTamDesc

//Parametros TFonte ("Tipo Fonte", ,Tamanho Fonte , , ,Italico (.T./.F.))
//oFont1      := TFont():New("Arial",09,20,     ,.T.,,,,,.F.)


	Private cGetCodBar := Space(13)
	Static oCbxFinalizados
	Static lCbxFinalizados := .T.
	HrInicio := time()
	HrFim := ""
	cStatus := ""
	nQtdTotal := 0
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
 aSize[1] = 1 -> Linha inicial �rea trabalho.
 aSize[2] = 2 -> Coluna inicial �rea trabalho.
 aSize[3] = 3 -> Linha final �rea trabalho.
 aSize[4] = 4 -> Coluna final �rea trabalho.
 aSize[5] = 5 -> Coluna final dialog (janela).
 aSize[6] = 6 -> Linha final dialog (janela).
 aSize[7] = 7 -> Linha inicial dialog (janela).
 */

//Agora montamos uma array com os elementos da tela: //Aonde devemos informar
//AAdd( aObjects, { Tamanho X (horizontal) , Tamanho Y (vertical), Dimensiona X , Dimensiona Y, Retorna dimens�es X e Y ao inv�s de linha / coluna final } )
	aObjects := {}
	AAdd( aObjects, { 330 , 120, .T. , .T. , .F. } ) //Bot�o Grid
	AAdd( aObjects, { 330 , 100, .T. , .T. , .F. } )

//Montamos a array com o valor da tela, aonde:
//aInfo := { 1=Linha inicial, 2=Coluna Inicial, 3=Linha Final, 4=Coluna Final, Separa��o X, Separa��o Y, Separa��o X da borda (Opcional), Separa��o Y da borda (Opcional) }
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5 , 5 , 5 , 5 }


	//DEFINE FONTE DE ACORDO COM TAMANHO DA TELA
	if aSize[3] > 900 .and. aSize[4] > 400
		oFontGrid := oFont5
		nTamDesc := 300
	Else
		oFontGrid := oFont1
		nTamDesc := 200
	EndIf

//Passamos agora todas as informa��es para o calculo das dimen��es://MsObjSize( aInfo, aObjects, Mantem Propor��o , Disposi��o Horizontal )
	aPosObj := MsObjSize( aInfo, aObjects, .T. , .F. )

////Define MsDialog oDialog TITLE "Titulo" STYLE DS_MODALFRAME From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
 //Se n�o utilizar o MsAdvSize, pode-se utilizar a propriedade lMaximized igual a T para maximizar a janela
 //oDialog:lMaximized := .T. //Maximiza a janela
 //Usando o estilo STYLE DS_MODALFRAME, remove o bot�o X

//******************************************************************************
//****************         MONTAGEM DA TELA            ************************
//******************************************************************************
	DEFINE MSDIALOG oDlg2 TITLE "Carregamento Romaneio "+cNumRom FROM aSize[7], 0 TO aSize[6], aSize[5] COLORS 0, 16777215 PIXEL Style DS_MODALFRAME
	@ 002, 002 BUTTON oBtnFinaliz PROMPT "FINALIZAR CARGA" SIZE 055, 015 OF oDlg2 ACTION (finalizarom()) PIXEL
	@ 020, 002 BUTTON oBtnApont PROMPT "PAUSAR CARGA" SIZE 055, 015 OF oDlg2 ACTION (oDlg2:End()) PIXEL // Alterado 07/03/16
	@ 002, 060 BUTTON oBtnResumo PROMPT "RESUMO" SIZE 050, 015 OF oDlg2 ACTION LOGRES() PIXEL	
	@ 020, 060 BUTTON oBtnApont PROMPT "EXCLUIR FARDOS" SIZE 050, 015 OF oDlg2 ACTION (retfardos()) PIXEL
	@ 002, 130 GROUP oGroup1 TO 030, 450 PROMPT "" OF oDlg2 COLOR 0, 16777215 PIXEL
	@ 004, 135 SAY oLblVeic PROMPT "Ve�culo:" SIZE 060, 011 OF oGroup1 FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 004, 170 SAY oTxtVeic PROMPT 	cVeic SIZE 040, 011 OF oGroup1 FONT oFont3 COLORS 0, 16777215 PIXEL
	@ 015, 135 SAY oLblSaida PROMPT "Sa�da:"   SIZE 060, 011 OF oGroup1 FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 015, 170 SAY oTxtSaida PROMPT cDtSaida SIZE 060, 011 OF oGroup1 FONT oFont3 COLORS 0, 16777215 PIXEL
	@ 004, 240 SAY oLblRota PROMPT "Rota:" SIZE 060, 011 OF oGroup1 FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 003, 270 SAY oTxtRota PROMPT cRota SIZE 200, 011 OF oGroup1 FONT oFont3 COLORS 0, 16777215 PIXEL //Nome do respons�vel pela programa��o da produ��o
	//@ 003, 380 SAY oTxtRota1 PROMPT substr(cRota,21,25) SIZE 070, 011 OF oGroup1 FONT oFont3 COLORS 0, 16777215 PIXEL //Nome do respons�vel pela programa��o da produ��o
	//@ 115, 010 SAY oLblMot PROMPT "Motorista:" SIZE 049, 012 OF oGroup1 FONT oFont2 COLORS 0, 16777215 PIXEL
	//@ 115, 040 SAY oTxtMot PROMPT cMotori SIZE 035, 011 OF oGroup1 FONT oFont3 COLORS 0, 16777215 PIXEL
	//@ 130, 010 SAY oLblResp PROMPT "Conferente: " SIZE 100, 011 OF oGroup1 FONT oFont2 COLORS 0, 16777215 PIXEL
	//@ 130, 060 SAY oTxtResp PROMPT pswret(1)[1][2] SIZE 060, 011 OF oGroup1 FONT oFont3 COLORS 0, 16777215 PIXEL
	//@ 145, 010 SAY oLblResp PROMPT "In�cio Separa��o: " SIZE 150, 011 OF oGroup1 FONT oFont2 COLORS 0, 16777215 PIXEL
	//@ 145, 085 SAY oLblResp PROMPT HrInicio SIZE 150, 011 OF oGroup1 FONT oFont3  CfOLORS 0, 16777215 PIXEL
	@ 005, 600 SAY oSay3 PROMPT "Codigo de Barras :" SIZE 051, 011 OF oDlg2 COLORS 0, 16777215 PIXEL
	@ 005, 650 MSGET oGetCodBar VAR cGetCodBar SIZE 132, 010 OF oDlg2 COLORS 0, 16777215  ON CHANGE (IncluiLeitor()) PIXEL
	@ 040, 600 SAY oLblSaida PROMPT "CONCLU�DOS"   SIZE 060, 011 OF oGroup1 FONT oFont2 COLORS 0, 16777215 PIXEL
	//@ 005,550 CHECKBOX oCbxFinalizados VAR lCbxFinalizados PROMPT "Mostra itens conclu�dos" SIZE 080, 010 OF oDlg2 COLORS 0, 16777215 ON CHANGE ExibeFinaliz() PIXEL
	@ 1200, 010 SAY oLblStatus1 PROMPT "TOTAL: " SIZE 100, 011 OF oDlg2 FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 1200, 070 SAY oTxtStatus PROMPT str(nQtdTotal) OF oDlg2 FONT oFont3 COLORS 0, 16777215 PIXEL

	GridCarga()		

	ACTIVATE MSDIALOG oDlg2 CENTERED
	
Return

Static Function GridCarga()
	
Public aFieldsCg := {}
Public aColsExCg := {}
Public aColsConc := {}
Static oBrowse := {}
Static oBrwFinaliz := {}
	cQry := ""
	aDadosC := {}
	cProdGrid := ""
	nQtdFardo:=0
	_nResta := 0
	_nExced := 0
	_cMotFalta :=""
//******************************************************************************
//****************         MONTAGEM DOS DADOS           ************************
//******************************************************************************

AADD(aFieldsCg,{"PRODUTO" ,"CODIGO"    ,"" ,10 ,0, ,"�","C","" ,"V",  ,  ,".F."} )
AADD(aFieldsCg,{"DESCRICAO" ,"DESCRI"    ,"" ,40 ,0, ,"�","C","" ,"V",  ,  ,".F."} )
AADD(aFieldsCg,{"QUANTIDADE"  ,"QUANT"   ,"" ,09 ,2, ,"�","N","" ,"V",  ,  ,".F."} )
AADD(aFieldsCg,{"REGISTRADO"  ,"REGISTRADO"   ,"" ,09 ,2, ,"�","N","" ,"V",  ,  ,".F."} )
AADD(aFieldsCg,{"RESTANTE"  ,"RESTANTE"   ,"" ,09 ,2, ,"�","N","" ,"V",  ,  ,".F."} )
AADD(aFieldsCg,{"EXCEDENTE"  ,"EXCEDENTE"   ,"" ,09 ,2, ,"�","N","" ,"V",  ,  ,".F."} )
AADD(aFieldsCg,{"MOTIVO FALTA"  ,"MOTFALTA"   ,"" ,08 ,0, ,"�","C","" ,"V",  ,  ,".F."} )
AADD(aFieldsCg,{"GRUPO" ,"GRUPO"    ,"" ,6 ,0, ,"�","C","" ,"V",  ,  ,".F."} )
//AADD(aFieldsCg,{"CARREGAR LOTE"  ,"LOTECARR"   ,"" ,08 ,0, ,"�","C","" ,"V",  ,  ,".F."} )

	
cQry := " SELECT ISNULL(D.B1_GRUPO,'') B1_GRUPO, ISNULL(A.C6_PRODUTO,'') C6_PRODUTO, ISNULL(B.Z3_PRODUTO,'') Z3_PRODUTO, ISNULL(D.B1_ORDEM,'') B1_ORDEM "
cQry += " ,ISNULL(D.B1_PRVALID,0) B1_PRVALID,ISNULL(D.B1_DESC,'') B1_DESC, ISNULL(SUM(A.QTDPED),0) AS QTDVEN,  ISNULL(SUM(QTDROM),0) QTDROM "
cQry += " FROM EXP_ROMPEDIDO A LEFT JOIN EXP_ROMFARDOS B ON A.Z1_NUM = B.Z3_ROMANEI AND A.C6_PRODUTO=B.Z3_PRODUTO "
cQry += " INNER JOIN  SB1010 AS D ON A.C6_PRODUTO = D.B1_COD"
cQry += " WHERE  A.Z1_NUM='"+cNumRom+"' "
cQry += " GROUP BY A.Z1_NUM, A.C6_PRODUTO, A.Z1_EXPINI, B1_GRUPO, Z3_PRODUTO, B1_ORDEM,B1_PRVALID, B1_DESC"
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

		
	Aadd(aDadosC,{cProdGrid,;
		cDescGrid,;
		TRC2->QTDVEN,;
		nQtdFardo,;
		_nResta,;
		_nExced,;
		_cMotFalta,;
		TRC2->B1_GRUPO})
		
		//dDtLoteOk,; //incluir no vetor caso for informar proximo lote a carregar
	
	TRC2->(DbSkip())
EndDo

TRC2->(DbCloseArea())

//Preenche matrix de Itens a carregar
For I:= 1 To Len(aDadosC)

	IF aDadosC[i][5] <> 0  .or.  aDadosC[i][6] > 0
		AADD(aColsExCg,Array(Len(aFieldsCg)+1))
		nLin := Len(aColsExCg)
	
		aColsExCg[nLin,01] := aDadosC[i][1]
		aColsExCg[nLin,02] := aDadosC[i][2]
		aColsExCg[nLin,03] := Transform(aDadosC[i][3],"@E 9999") 	
		aColsExCg[nLin,04] := Transform(aDadosC[i][4],"@E 9999")  
		aColsExCg[nLin,05] := Transform(aDadosC[i][5],"@E 9999")  
		aColsExCg[nLin,06] := Transform(aDadosC[i][6],"@E 9999")  
		aColsExCg[nLin,07] := aDadosC[i][7]
		aColsExCg[nLin,08] := aDadosC[i][8]
		
		aColsExCg[nLin,Len(aFieldsCg)+1] := .F.
	ENDIF
Next

//Preenche matrix de Itens conclu�dos
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

		aColsConc[nLin,Len(aFieldsCg)+1] := .F.
	EndIf
Next



// Cria Browse
oBrowse := TCBrowse():New(040,020,aSize[5]-1350,aSize[6]-600,,{'','PRODUTO','DESCRI��O','QUANTIDADE','REGISTRADO','RESTANTE','EXCEDENTE','MOTIVO FALTA'},{10,50,50,50,50,50,50,50},oDlg2,,,,,,,oFontGrid,,,,,.F.,,.T.,,.F.,,,.T.)
//oBrowse := TCBrowse():New(040,020,500,450,,{'','PRODUTO','DESCRI��O','QUANTIDADE','REGISTRADO','RESTANTE','EXCEDENTE','MOTIVO FALTA'},{10,50,50,50,50,50,50,50},oDlg2,,,,,,,oFontGrid,,,,,.F.,,.T.,,.F.,,,.T.)
oBrowse:AddColumn(TCColumn():New("PRODUTO"	, {|| aColsExCg[oBrowse:nAt,01]},"@!",,,"CENTER", 040,.F.,.F.,,{|| .F. },,.F., ) )
oBrowse:AddColumn(TCColumn():New("DESCRI��O"	, {|| aColsExCg[oBrowse:nAt,02]},"@!",,,"CENTER", nTamDesc,.F.,.F.,,{|| .F. },,.F., ) )
oBrowse:AddColumn(TCColumn():New("QUANTIDADE"	, {|| aColsExCg[oBrowse:nAt,03]},"@E 9999",,,"CENTER"  , 040,.F.,.F.,,,,.F., ) )
oBrowse:AddColumn(TCColumn():New("REGISTRADO"	, {|| aColsExCg[oBrowse:nAt,04]},"@E 9999",,,"CENTER", 040,.F.,.T.,,,,.F., ) )
oBrowse:AddColumn(TCColumn():New("RESTANTE" 	, {|| aColsExCg[oBrowse:nAt,05]},"@E 9999",,,"CENTER"  , 040,.F.,.T.,,,,.F., ) )
oBrowse:AddColumn(TCColumn():New("EXCEDENTE" 	, {|| aColsExCg[oBrowse:nAt,06]},"@E 9999",,,"CENTER"  , 040,.F.,.T.,,,,.F., ) )

//A coluna 6 precisa est� com a op��o de editar .T.
oBrowse:nLinhas := 2
oBrowse:SetArray(aColsExCg)
//oBrowse:bWhen        := { || Len(aColsExCg) > 0 }
//	oBrowse:bRClicked    := { || fEdita(@aColsExCg, oLista, "@!", 9)}  //Irei editar a coluna 6
/*      // Evento de clique no cabe�alho da browse
	oBrowse:bHeaderClick := {|o, nCol| alert('bHeaderClick') }
	// Evento de duplo click na celula
	oBrowse:bLDblClick := {|| alert('bLDblClick') }
*/
	// Cria Botoes com metodos b�sicos
	TButton():New( 025, 500, "PgUp", oDlg2,{|| oBrowse:PageUp(30), oBrowse:setFocus() },30,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New( 025, 530, "PgDn" , oDlg2,{|| oBrowse:PageDown(30), oBrowse:setFocus() },30,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	//TButton():New( 196, 002, "Linha atual", oDlg2,{|| alert(oBrowse:nAt) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	//TButton():New( 208, 052, "Nr Linhas", oDlg2,{|| alert(oBrowse:nLen) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	//TButton():New( 208, 002, "Linhas visiveis", oDlg2,{|| alert(oBrowse:nRowCount()) },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
oBrowse:lUseDefaultColors := .F.
oBrowse:SetBlkBackColor({|| GETDCLR(oBrowse:nAt)})
oBrowse:Refresh()

oBrwFinaliz := TCBrowse():New(040,aSize[5]-1320,aSize[5]-1550,aSize[6]-600,,{'','PRODUTO','DESCRI��O','QUANTIDADE'},{20,100,10},oDlg2,,,,,,,oFontGrid,,,,,.F.,,.T.,,.F.,,,.T.)
oBrwFinaliz :AddColumn(TCColumn():New("PRODUTO"	, {|| aColsConc[oBrwFinaliz:nAt,01]},"@!",,,"CENTER", 050,.F.,.F.,,{|| .F. },,.F., ) )
oBrwFinaliz :AddColumn(TCColumn():New("DESCRI��O"	, {|| aColsConc[oBrwFinaliz:nAt,02]},"@!",,,"CENTER", 150,.F.,.F.,,{|| .F. },,.F., ) )
oBrwFinaliz :AddColumn(TCColumn():New("QUANTIDADE"	, {|| aColsConc[oBrwFinaliz:nAt,03]},"@E 9999",,,"CENTER"  , 020,.F.,.F.,,,,.F., ) )

oBrwFinaliz:nLinhas := 2
oBrwFinaliz:SetArray(aColsConc)
oBrwFinaliz:lUseDefaultColors := .F.
oBrwFinaliz:SetBlkBackColor({|| GETDCLR2(oBrwFinaliz:nAt)})
oBrwFinaliz:Refresh()

oGetCodBar:SetFocus()
oBrowse:bGotFocus :=  {||oGetCodBar:SetFocus()}

oBrwFinaliz:bGotFocus :=  {||oGetCodBar:SetFocus()}


Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �INCLUILEITOR  Autor: Weiden        � Data �  10/14/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Inclui itens no Grid a partir do cod. barras.              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function IncluiLeitor()
	cCodProd := ""
	cDescProd := ""
	cHrApont := ""
	Private oMSNewApont
	nItens := oBrowse:nLen //nItens := len(oMSNewGe2:aCols)
 
	
	
//verifica se edit de c�digo de barras est� com tamanho incorreto ou turma n�o existente
	If	len(Alltrim(cGetCodBar)) <> 13 //.or. !substr(Alltrim(cGetCodBar),12,1) $ "123"    //Alltrim(cGetCodBar) <> ""
		MSGSTOP("O c�digo "+ cGetCodBar +" n�o esta no formato e tamanho correto.")
		conout("TELAEXPED: O c�digo "+ cGetCodBar +" n�o esta no formato e tamanho correto.")
		Return
	EndIf


	dbSelectArea("SZ3")
	DbSetOrder(1)
	dbGotop()
	dbseek(xfilial("SZ3")+substr(Alltrim(cGetCodBar),1,12))
	
	if !SZ3->(found())
		MSGSTOP("Fardo n�o encontrado. Informe o administrador do sistema ou ger�ncia.")
		conout("TELAEXPED: O fardo "+ cGetCodBar +" n�o foi encontrado no SZ3.")
		AADD(aFdNotExist,cGetCodBar)
		nLeituras += 1
		Return
	EndIf
		
	dbSelectArea("SB1")
	DbSetOrder(1)
	dbseek(xfilial("SB1")+SZ3->Z3_PRODUTO)
	cDescProd := SB1->B1_DESC
		
	//VERIFICA SE FARDO J� FOI REGISTRADO			
	IF Trim(SZ3->Z3_ROMANEI)<>""
		if Trim(SZ3->Z3_ROMANEI)<>Trim(cNumRom)
			MSGSTOP("Fardo registrado em outro romaneio. Informar ger�ncia.")
			conout("TELAEXPED: O fardo "+ cGetCodBar +" j� est� registrado no romaneio "+SZ3->Z3_ROMANEI)
			Aadd(aFdOutrRom,{Alltrim(cGetCodBar),;
				SZ3->Z3_PRODUTO,;
				SZ3->Z3_ROMANEI})
			nLeituras += 1
		EndIf
		Return
	EndIf

	cCodProd := SZ3->Z3_PRODUTO
	
	//VERIFICA SE PRODUTO EST� VENCIDO		
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
	
//		lInicioCarg := .t.
//	EndIf

	nApontSucess += 1
	//atual()
	GridCarga()

Return( Nil )


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  ATUAL           Autor: Weiden        � Data �  10/14/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Atualiza dados nos grid.					              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function atual()
	dbSelectArea("SZ3")
	dbGotop()
	dbseek(xfilial("SZ3")+substr(Alltrim(cGetCodBar),1,8)+substr(cGetCodBar,9,4)) //ALTERADO 28/07/15

	lExisteIt := .f.

	alert("aColsCont="+str(Len(aColsConc)))
	alert("aColsExCg="+str(Len(aColsExCg)))
	
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
			
		//	if val(aColsExCg[nLin,05])=0 .and. val(aColsExCg[nLin,06]) = 0
		//		GridCarga()
		//		Return
		//	EndIf
			if  val(aColsExCg[nLin,05])=0 .and. val(aColsExCg[nLin,06])=0
				AADD(aColsConc,Array(Len(aFieldsCg)+1))
				Linew := Len(aColsConc)
				aColsConc[Linew,01] := aColsExCg[nLin,01]
				aColsConc[Linew,02] := aColsExCg[nLin,02]
				aColsConc[Linew,03] := aColsExCg[nLin,03]
				aColsConc[Linew,04] := aColsExCg[nLin,04]
				aColsConc[Linew,05] := aColsExCg[nLin,05] 
				aColsConc[Linew,06] := aColsExCg[nLin,06]
				aColsConc[Linew,07] := aColsExCg[nLin,07]
				aColsConc[Linew,08] := aColsExCg[nLin,08]
				
				ADEL(aColsExCg, nLin)
				ASIZE(aColsExCg,Len(aColsExCg)-1)
				//nLin := 1
			EndIf
			exit
		EndIf
	Next

	For nLin:= 1 To Len(aColsConc)  //Array que guarda dados do Grid
			
		if	Trim(aColsConc[nLin,01]) == Trim(SZ3->Z3_PRODUTO) //Se DadosGrid for igual ao produto registrado no momento
			aColsConc[nLin,04] := str(val(aColsConc[nLin,04])+1)
			
			if val(aColsConc[nLin,05])>0
				aColsConc[nLin,05] := str(val(aColsConc[nLin,05])-1)
				aColsConc[nLin,06] := "0"
				
			else
				aColsConc[nLin,05] := "0"
				aColsConc[nLin,06] := str(val(aColsConc[nLin,06])+1)
			EndIf
			lExisteIt := .t.
			
		//	if val(aColsConc[nLin,05])>0 .or. val(aColsConc[nLin,06]) > 0
		//		GridCarga()
		//		Return
		//	EndIf
			if  val(aColsConc[nLin,05])>0 .or. val(aColsConc[nLin,06])>0
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
				
				ADEL(aColsConc, nLin)
				ASIZE(aColsConc,Len(aColsConc)-1)
				
			EndIf
			exit

		EndIf
	Next
	alert("aColsCont="+str(Len(aColsConc)))
	alert("aColsExCg="+str(Len(aColsExCg)))

//	obrowse:SetArray(aColsExCg)   //oMSNewGe2:aCols := aclone (aColsExCg)

	//aItensGrid := {}
	//aItensGrid := aclone (aColsExCg)
/*	nLin:= 1
	While nLin <= Len(aColsExCg)
		if  val(aColsExCg[nLin,05])=0 .and. val(aColsExCg[nLin,06])=0
			AADD(aColsConc,Array(Len(aFieldsCg)+1))
			Linew := Len(aColsConc)
			aColsConc[Linew,01] := aColsExCg[nLin,01]
			aColsConc[Linew,02] := aColsExCg[nLin,02]
			aColsConc[Linew,03] := aColsExCg[nLin,03]
			aColsConc[Linew,04] := aColsExCg[nLin,04]
			aColsConc[Linew,05] := aColsExCg[nLin,05] 
			aColsConc[Linew,06] := aColsExCg[nLin,06]
			aColsConc[Linew,07] := aColsExCg[nLin,07]
			aColsConc[Linew,08] := aColsExCg[nLin,08]
			
			ADEL(aColsExCg, nLin)
			ASIZE(aColsExCg,Len(aColsExCg)-1)
			nLin := 1
		EndIf
		nLin +=1
	EndDo
	*/

	obrowse:SetArray(aColsExCg)   //oMSNewGe2:aCols := aclone (aColsExCg)
//	obrowse:bWhen          := { || Len(aColsExCg) > 0 }
	oBrowse:SetBlkBackColor({|| GETDCLR(oBrowse:nAt)})
	obrowse:Refresh()
	//oBrowse:SetArray(aColsExCg)

	
        // Cria Browse
/*	oBrowse := TCBrowse():New(040,020,aSize[5]-1350,aSize[6]-600,,{'','PRODUTO','DESCRI��O','QUANTIDADE','REGISTRADO','RESTANTE','EXCEDENTE','MOTIVO FALTA'},{10,50,50,50,50,50,50,50},oDlg2,,,,,,,oFontGrid,,,,,.F.,,.T.,,.F.,,,.T.)
	oBrowse:AddColumn(TCColumn():New("PRODUTO"	, {|| aColsExCg[oBrowse:nAt,01]},"@!",,,"CENTER", 040,.F.,.F.,,{|| .F. },,.F., ) )
	oBrowse:AddColumn(TCColumn():New("DESCRI��O"	, {|| aColsExCg[oBrowse:nAt,02]},"@!",,,"CENTER", nTamDesc,.F.,.F.,,{|| .F. },,.F., ) )
	oBrowse:AddColumn(TCColumn():New("QUANTIDADE"	, {|| aColsExCg[oBrowse:nAt,03]},"@E 9999",,,"CENTER"  , 040,.F.,.F.,,,,.F., ) )
	oBrowse:AddColumn(TCColumn():New("REGISTRADO"	, {|| aColsExCg[oBrowse:nAt,04]},"@E 9999",,,"CENTER", 040,.F.,.T.,,,,.F., ) )
	oBrowse:AddColumn(TCColumn():New("RESTANTE" 	, {|| aColsExCg[oBrowse:nAt,05]},"@E 9999",,,"CENTER"  , 040,.F.,.T.,,,,.F., ) )
	oBrowse:AddColumn(TCColumn():New("EXCEDENTE" 	, {|| aColsExCg[oBrowse:nAt,06]},"@E 9999",,,"CENTER"  , 040,.F.,.T.,,,,.F., ) )

	oBrowse:nLinhas := 2
	//oBrowse:bWhen        := { || Len(aColsExCg) > 0 }
	oBrowse:lUseDefaultColors := .F.
	oBrowse:SetBlkBackColor({|| GETDCLR(oBrowse:nAt)})
	oBrowse:Refresh()
*/	
	oBrwFinaliz:SetArray(aColsConc)
	oBrwFinaliz:SetBlkBackColor({|| GETDCLR2(oBrwFinaliz:nAt)})
	oBrwFinaliz:Refresh()
	

	/*	
	oBrwFinaliz := TCBrowse():New(040,aSize[5]-1320,aSize[5]-1550,aSize[6]-600,,{'','PRODUTO','DESCRI��O','QUANTIDADE'},{20,100,10},oDlg2,,,,,,,oFontGrid,,,,,.F.,,.T.,,.F.,,,.T.)
	oBrwFinaliz :AddColumn(TCColumn():New("PRODUTO"	, {|| aColsConc[oBrwFinaliz:nAt,01]},"@!",,,"CENTER", 050,.F.,.F.,,{|| .F. },,.F., ) )
	oBrwFinaliz :AddColumn(TCColumn():New("DESCRI��O"	, {|| aColsConc[oBrwFinaliz:nAt,02]},"@!",,,"CENTER", 150,.F.,.F.,,{|| .F. },,.F., ) )
	oBrwFinaliz :AddColumn(TCColumn():New("QUANTIDADE"	, {|| aColsConc[oBrwFinaliz:nAt,03]},"@E 9999",,,"CENTER"  , 020,.F.,.F.,,,,.F., ) )

	oBrwFinaliz:nLinhas := 2
	//oBrwFinaliz:SetArray(aColsConc)
	oBrwFinaliz:lUseDefaultColors := .F.
	oBrwFinaliz:SetBlkBackColor({|| GETDCLR2(oBrwFinaliz:nAt)})
	oBrwFinaliz:Refresh()
*/
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

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FINALIZAROM	   Autor: Weiden        � Data �  30/01/2015  ���
�������������������������������������������������������������������������͹��
���Desc.     � Finaliza carregamento e inclus�o de intens no romaneio.    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FinalizaRom()

	cData := Dtoc(date())
	HrFim := time()
	aVetorReq := {}

	//if nLeituras > 0
	logres()
	
	dbSelectArea("SZ1")
	dbGotop()
	dbseek(xfilial("SZ1")+cNumRom+"01")
	
	if SZ1->(found())
		RecLock("SZ1",.f.)
		if  len(aFdFalta) > 0
			If ! MSGYESNO("Carregamento incompleto. Deseja finalizar mesmo assim?" , "Confirma��o")
				Return
			EndIf
			SZ1->Z1_STATUS :="carga parcial"
		Else
			If  len(aFdExced)>0
				If ! MSGYESNO("Carregamento com excedentes. Deseja finalizar mesmo assim?" , "Confirma��o")
					Return
				EndIf
				SZ1->Z1_STATUS :="carga excedente"
			Else
				SZ1->Z1_STATUS := "carga conclu�da"
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
			SZ3->Z3_REG := "R"  //Ap�s testes definir campo e conte�do definitivo
			SZ3->(MsUnlock())
			SZ3->(dbskip())
			
			
			//*************************************************************
			//** GERA MOVTO DE REQUISI��O DE PRODUTO ACABADO EXPEDIDO  ****
			//*************************************************************
		/*	if SZ3->Z3_PRODUTO <> cProdCar
			//Deve funcionar apenas quanto TES de Notas de Entrada e Devolu��o estiverem com Estoque=N.
				lMsErroAuto := .F.
					
				aVetorReq:={ {"D3_TM","501",NIL},;
					{"D3_COD",cProdCar,NIL},;
					{"D3_EMISSAO",ddatabase,NIL},;
					{"D3_DOC","R"+cNumRom,NIL},;
					{"D3_HORA",time(),NIL},;
					{"D3_QUANT",nQtd,NIL}}
				MSExecAuto({|x,y| mata240(x,y)},aVetorReq,3) //Inclusao
						
				If lMsErroAuto
					MSGALERT("N�o foi poss�vel requisitar os fardos.")
					ENVMAILEXP('sistemas@produtosplinc.com.br',"Erro na req. para expedi��o" ,"N�o foi poss�vel requisitar os produtos.")
				EndIf
				
				cProdCar := SZ3->Z3_PRODUTO
				nQtd := 0
			EndIf  */
			
		EndDo
					
	//	ENVMAILEXP('plinc.logistica@gmail.com',cAssunto ,cEmailErro)
		//ENVMAILEXP('vendas@produtosplinc.com.br',cAssunto ,cEmailErro)
		U_ENVMAILEXP('sistemas@produtosplinc.com.br',cAssunto ,cEmailErro)
	Else
		MSGINFO("N�o encontrado romaneio. Verificar com administrador.")
		conout("TELAEXPED: N�o encontrado romaneio"+ cNumRom +" para finalizar.")
	EndIf
	//EndIf
	SZ1->(MsUnlock())
	oDlg2:End()
	GridRom()
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FARDOS    �Autor  �Microsiga           � Data �  10/06/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Tela de visualiza��o e exclus�o de Fardos Apontados.      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

	DEFINE MSDIALOG oDlg4 TITLE "Exclus�o de Fardos do Romaneio" FROM 000, 000  TO 500, 800 COLORS 0, 16777215 PIXEL
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

	DEFINE MSDIALOG oDlg4 TITLE "Devolu��o de Fardos" FROM 000, 000  TO 500, 800 COLORS 0, 16777215 PIXEL
	@ 006, 010 SAY oSay1 PROMPT "Romaneio:" SIZE 060, 017 OF oDlg4 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 007, 070 SAY oSay2 PROMPT cNumRom Picture "@!" SIZE 070, 010 OF oDlg4 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 007, 110 SAY oSay3 PROMPT "Ve�culo :" SIZE 051, 011 OF oDlg4 COLORS 0, 16777215 PIXEL
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MONTAGRIDLEITOR �Autor �Weiden M. Mendes� Data �  10/14/11  ���
�������������������������������������������������������������������������͹��
���Desc.     � Monta o Grid que recebe a leitura de codigo de barras	  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MontaGridFardo()

	//aDados := {}
	aFields := {}
	nItens := 0

	AADD(aFields,{"It" ,"IT"    ,"" ,4 ,0, ,"�","N","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Produto" ,"CODIGO"    ,"" ,7 ,0, ,"�","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Descri��o" ,"DESCPROD"    ,"" ,30 ,0, ,"�","C","" ,"V",  ,  ,".F."} )
	AADD(aFields,{"Num.Etiqueta(LOTE)" ,"LOTE"    ,"" ,15 ,0, ,"�","C","" ,"V",  ,  ,".F."} )

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

//verifica se edit de c�digo de barras est� vazio
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
				//***  Verifica se romaneio est� fechado. S� ser� permitido devolu��o em romaneios finalizados.  *****
				//****************************************************************************************************
		/*	dbSelectArea("SZ1")
				DbSetOrder(1)
				dbseek(xfilial("SZ1")+SZ3->Z3_ROMANEI+"01")	
				
				if SZ3->(found())
				
				  if SZ1->Z1_DTFECH = "" 
				  	if  nTipoRet = 2
				  		MSGINFO("N�o � poss�vel devolver produto de romaneio em aberto. Fechar romaneio antes de realizar a devolu��o.")
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
		
		//Verifica se c�digo j� foi incluido no array
		
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
						aColsExclui[nLin,03] := aDados[i][2] //Descri��o produto
						aColsExclui[nLin,04] := aDados[i][3] //Lote
										
						aColsExclui[nLin,Len(aFields)+1] := .F.
					Next
			//				nJaGrav := len(aFields)
					oMSNewApont := MsNewGetDados():New( 057, 005, 250, 396,, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2",,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg4, aFields, aColsExclui)
					oMSNewApont:refresh()
				Endif
			Else
				//MSGINFO("Etiqueta "+cEtiqueta+" n�o foi carregada.") 
				
				////   INCLUIR CONTADOR DE ETIQUETA N�O CARREGADA
			
			EndIf
		else
			//MSGINFO("Etiqueta "+cEtiqueta+" n�o encontrada.")
			oMSNewApont:oBrowse:bGotFocus :=  {||oGetCodBarFd:SetFocus()}
		//oBtnResumo:bGotFocus :=  {||oGetCodBarFd:SetFocus()}
		endif
		nItens := len(aColsExclui)
		
	EndIf
	oMSNewApont:oBrowse:bGotFocus :=  {||oGetCodBarFd:SetFocus()}
//Volta o foco do Grid para o edit do codigo de barras.
Return( Nil )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EXCLFARDO �Autor  �Microsiga           � Data �  10/25/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � ESTORNA FARDOS J� INCLUIDOS NO SISTEMA    			   ���
���          � com erros e acertos.                             	      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	if  ! MSGYESNO("Deseja excluir os fardos lidos do romaneio?", "Confirma��o")
		Return
	EndIf

	//L� array que cont�m fardos lidos no GRID.
	if len(aColsExclui)>0
		for i:= 1 to len(aColsExclui)    //len(oMSNewApont:acols)
			nEtq :=  SUBSTR(aColsExclui[i][4],1,12) // Lote/Etiqueta //Alterado 28/07/15
	
			dbSelectArea("SZ3")
			dbGotop()
			dbseek(xfilial("SZ3")+nEtq)
			conout("TELAEXPED: Linha vetor: "+ str(i))
			if  SZ3->(found())
				If  Trim(SZ3->Z3_ROMANEI) <> ""  .or. SZ3->Z3_REG='D' //VERIFICA SE ROMANEIO EST� PREENCHIDO
					conout("TELAEXPED: Rom. antes:"+SZ3->Z3_ROMANEI)
					reclock("SZ3",.f.)
					if SZ3->Z3_DATEXP < date()  //VERIFICA SE DATA DE DEVOLU��O � MAIOR QUE DATA DA EXPEDI��O
						cRomDev := SZ3->Z3_ROMANEI
						SZ3->Z3_ROMDEV := cRomDev
						SZ3->Z3_DTDEV := date()
						SZ3->Z3_VEICDEV := cGetVeic  //Ve�culo de devolu��o
					EndIf
					SZ3->Z3_ROMANEI:=""
					SZ3->Z3_HREXP:=""
				//	SZ3->Z3_DATEXP:="" //INCLUIR FUNCAO PARA LIMPAR CAMPO.
					msunlock()
								
					//Preenche vetor com somat�rio de fardos por Produto+Romaneio.
					lexiste := .f.
					if Alltrim(SZ3->Z3_REG)<>"" //Verifica se foi registrada sa�da do Estoque. Se n�o saiu pelo SD3 n�o devolve.
						For x:=1 to len(_aFardDev)
							If Alltrim(_aFardDev[ x ][1]) == Alltrim(Z3_PRODUTO) .and. Alltrim(_aFardDev[ x ][2]) == Alltrim(cRomDev)
	
								_aFardDev[x][3] += 1
								lexiste := .t.
								conout("TELAEXPED: EXISTE"+ _aFardDev[x][1]+" - "+  _aFardDev[x][2]+" - "+ str(_aFardDev[x][3]))
			
							EndIf
						Next

						If lexiste = .f.  //Se n�o for encontrado item cria novo Produto+Romaneio
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
					MSGINFO("Etiqueta "+nEtq+" n�o foi carregada.")
					conout("TELAEXPED: Etiqueta "+nEtq+" n�o foi carregada. linha vetor:"+ str(i))
				EndIf
			Else
				MSGINFO("Etiqueta "+nEtq+" n�o encontrada.")
				conout("TELAEXPED: Etiqueta "+nEtq+" n�o encontrada.linha vetor:"+ str(i))
			endif
		Next
		
		For d:=1 to len(_aFardDev)
				
			if nTipoFunc == 2 //Se rotina for de devolu��o de fardos
				_dDoc := "D"+ time()
			Else  ///Quando rotina for de  exclus�o de fardos do romaneio.
				_dDoc := "R"+_aFardDev[d][2]
			EndIf
				
			//************************************************************
			//** GERA MOVTO DE DEVOLU��O DE PRODUTO ACABADO EXPEDIDO  **** - 
			//************************************************************
			/*  --Retirado dia 05/09 para utilizar no OFICIAL
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
				ENVMAILEXP('sistemas@produtosplinc.com.br',"Erro na req. para expedi��o" ,"N�o foi poss�vel requisitar os produtos.")
				MSGALERT("N�o foi poss�vel requisitar os fardos.")
						
				conout("TELAEXPED: FIM - Erro ao realizar requisi��o.")
			Else
				conout("TELAEXPED: FIM - Registrado com sucesso.")
			EndIf
			*/
		Next
		
		MSGINFO("Exclu�dos do romaneio "+ Str(nQtdExclui) +" fardos registrados.")
		conout("TELAEXPED: Exclu�dos do romaneio "+ Str(nQtdExclui) +" fardos registrados.")
		
		MontaGridFardo()
		
		if cNumRom <>'' //para verificar se rotina FARDOS() foi aberto fora ou dentro da rotina de carregamento.
			GridCarga()
		EndIf
		oDlg4:end()
	else
		MSGINFO("N�o existe item lido para excluir.")
		
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
			ConOut("TELAEXPED: N�o foi poss�vel enviar o Email." +Chr(13)+Chr(10)+ cErro)
			Return .f.
		EndIf
	Else
		GET MAIL ERROR cErro
		Conout("TELAEXPED: Erro na conex�o com o SMTP Server." +Chr(13)+Chr(10)+ cErro)
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
		cAssunto	:= "SEPARA��O DA CARGA "+cNumRom+" FINALIZADA INCOMPLETA"
		cEmailErro :="SEPARA��O DA CARGA FOI FINALIZADA SEM COMPLETAR TODOS OS ITENS."+ENTER
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
		cEmailErro +="Fardos lidos j� registrados em outros romaneios:"+ENTER
		AADD(aTexto,"Fardos lidos j� registrados em outros romaneios:")
		For I:= 1 To Len(aFdOutrRom)
			cEmailErro += aFdOutrRom[i][1]+"   "+aFdOutrRom[i][2]+"   "+aFdOutrRom[i][3]+ENTER
			AADD(aTexto,aFdOutrRom[i][1]+"   "+aFdOutrRom[i][2]+"   "+aFdOutrRom[i][3])
		Next
	EndIf

	If len(aFdNotExist)>0
		cEmailErro +="Fardos lidos n�o encontrados no sistema:" //+ENTER
		AADD(aTexto,"Fardos lidos n�o encontrados no sistema:")
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

// Fun��o para tratamento das regras de cores para a grid da MsNewGetDados
Static Function GETDCLR(nLinha)
	Local nRet := 0
	Local nCor3 := 16776960 // Verde Claro - RGB(0,255,255) //Local nCor3 := 65280 //VERDE
	Local nCor4 :=  5070329 //fVERMELHO
	Local nCor2 := 16777215 
	
	if len(aColsExCg) > 0
		if Alltrim(aColsExCg[nLinha][5])<>""  //_nResta
			If val(aColsExCg[nLinha][5])>0 //.AND. aLinha[nLinha][nUsado]
				nRet := nCor2
			Else
				If val(aColsExCg[nLinha][5])=0
					If val(aColsExCg[nLinha][6])>0  //_nExced
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

Return nRet


Static Function GETDCLR2(nLinha)
	Local nRet := 0
	Local nCor3 := 16776960 // Verde Claro - RGB(0,255,255) //Local nCor3 := 65280 //VERDE
	Local nCor4 :=  5070329 //fVERMELHO
	Local nCor2 := 16777215 
	 
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

Return nRet


Static Function TotalFardos()
	aFdFalta := {}
	aFdExced := {}
	nTotalGeral := 0
	nQtSemEtq := 0
	//aFdTotal := {} //Para caso necessite ver todos os produtos carregados.
	
	For I:= 1 To Len(aColsExCg)
		if Alltrim(aColsExCg[i][8]) <> "1203" //Alterado 07/03/16 - at� encontrar solu��o de etiquetamento dos produtos.
			if val(aColsExCg[i][5]) > 0
				Aadd(aFdFalta,{aColsExCg[i][2],;
					aColsExCg[i][5]})
			EndIf
		EndIf
	
		if val(aColsExCg[i][6]) > 0
			Aadd(aFdExced,{aColsExCg[i][2],;
				aColsExCg[i][6]})
		EndIf
		
		//Produtos ainda n�o etiquetados
		if Alltrim(aColsExCg[i][8]) == "1203"
			nQtSemEtq := nQtSemEtq + val(aColsExCg[i][3]) //Quantidade solicitada
		EndIf
				
		nTotalGeral := nTotalGeral + val(aColsExCg[i][4])	//Quantidade j� carregada
	
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
