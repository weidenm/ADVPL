#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PEDVEN   ³ Autor ³ Weiden M. Mendes      ³ Data ³ 13/09/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pedido de Venda com formulário                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³  									                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Do Pedido		                     ³
//³ mv_par02             // Ate o Pedido	                     ³
//³ mv_par03             // Da Carga                             ³
//³ mv_par04             // Ate a Carga 						 ³
//³ mv_par05             // Placa Veiculo                        ³
//³ mv_par06             // Data de saída da nota fiscal         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


User Function PEDVEN()

	//SetPrvt("ALFA,CBTXT,CBCONT,NORDEM,Z,M")
	SetPrvt("TAMANHO,LIMITE,NOMEPROG,NLASTKEY,NCONTLINH,CSTRING")
	SetPrvt("WNREL,CPERG,TITULO,CDESC1,CDESC2,CDESC3")
	SetPrvt("ARETURN,_IMPDSAIDA,cPedInic,cPedFina,CCARGAINI,CCARGAFIN,CSERINTFI,NTIPONTFI")
	SetPrvt("_CPLACA,_DSAIDA,NTOTADOLAR,NPBRUTO,NTOTALPRO,NQUANTPRO,ANUMPED,_NVOLUME,_CESPECIE,_NPESO, NTOTALBRU, NTOTDESC, NDESCVIST")
	SetPrvt("CLISTPEDI,NBASEICMS,NVALRFRET,NVALRSEGU,NVALRICMS,NVALROUTR")
	SetPrvt("NVALRDESP,ACLASFISC")
	SetPrvt("ATEMPSTRU,CARQTRAB1,CARQTRAB2,CARQTRAB3,LFIRST")
	SetPrvt("NPOSISTR,NPERCICMS,AARRAPEDI,CCODIPEDI,CCODITES,CCODIFIOP,CCODIFIOPSP,CTEXTOP,CTEXTOPSP,CENDEENT")
	SetPrvt("NCONTAUXI,CLOTEAUXI,CSERIFATU,NCONTITEM,NTOTAITEM,NVALORTRAN")
	SetPrvt("CVALREXTEN,NCONTLIN,NVERI,CMENNOTA,NTAMMENS,CNOMECLFO")
	SetPrvt("CCGCCLIFO,CTELEDDD,CTELECLFO,CENDECLFO,CBAIRCLFO,CCEPCLIFO,CMUNICLFO")
	SetPrvt("CESTACLFO,CINSCCLFO,XPARC_DUP,XVENC_DUP,XVALOR_DUP,XDUPLICATAS")
	SetPrvt("NTAMEXTE,NPOVAZ,NPOFIN,LTEST,CEXTENSO1,CEXTENSO2")
	SetPrvt("A,LCONTITEM,NTAMPROD,NPOS,NLINCLAS,NCONT")

	//Alfa       := 0
	//CbTxt      := ""
	//CbCont     := ""
	//nOrdem     := 0
//	Z          := 0
	//M          := 0
	Tamanho    := "P"
//	Limite     := 50//132
	NomeProg   := "PedVenda" //"NFiscal"
	nLastKey   := 0
//	nContLinh  := 0
	cString    := "SC5"   //"SF2"
	wnrel      := "sigaped" //"siganf"
	cPerg      := "PEDVEN" //"NFSIGW"
	Titulo     := PADC("Pedido de Venda",74)
	cDesc1     := PADC("Este programa ira emitir o controle interno de Pedido de Venda",74)
	cDesc2     := ""
	cDesc3     := ""
	aReturn    := { "Especial", ,"Administracao", 1, 2, 1,"",1 }
	cObsCli	   := "" //Receber a observacao do cadastro do cliente <TLM>

// Inicializa pergunta "Data Saï¿½da da Nota" com a database
	//dataSaida := DtoC(ddatabase)

	Pergunte(cPerg,.F.)               // Pergunta no SX1

//wnrel      := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)
	wnrel := SetPrint(cString,NomeProg,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)
//SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

	If (nLastKey == 27)
		Return
	Endif

	SetDefault(aReturn,cString)

	cPedInic   := Mv_Par01    //Do pedido
	cPedFina   := Mv_Par02    //Ate o pedido
	cCargaIni   := Mv_Par03    //Da carga  '
	cCargaFin	:= Mv_Par04    //Ate a carga

//nPBruto    := 0
	nTotalBru  := 0
	nDescVist  := 0
	nTotDesc   := 0
	nTotalPro  := 0
	nQuantPro  := 0
	VolTotal   := 0
	aNumPed    := {}
	cListPedi  := ""
	aClasFisc  := {}

	If (nLastKey == 27)
		Return
	Endif

	CriaTraba()

	GravTrab()

	RptStatus({|| Imprime()})  // Substituido pelo assistente de conversao do AP5 IDE em 01/11/01 ==>    RptStatus({|| Execute(Imprime)})

	DBSelectArea("TRBI")
	dbCloseArea()

	DBSelectArea("TRBC")
	dbCloseArea()

//DBSelectArea("TRBF")
//dbCloseArea()

	FErase(cArqTrab1 + ".*")
	FErase(cArqTrab2 + ".*")
//FErase(cArqTrab3 + ".*")

	Set Device To Screen

	If aReturn[5] == 1
	
		dbcommitAll()
		ourspool(wnrel)
	Endif

	MS_FLUSH()

Return



Static Function CriaTraba()
//****************************************************************************
//* Cria os arquivos de trabalho
//*
//******

	aTempStru := {}

	Aadd(aTempStru,{"Pedido","C",06,0})
	Aadd(aTempStru,{"ItemPed" ,"C",02,0})
//Aadd(aTempStru,{"NumeNtFi"  ,"C",06,0})
//Aadd(aTempStru,{"SeriNtFi","C",03,0})
	Aadd(aTempStru,{"CodiProd","C",15,0})
	Aadd(aTempStru,{"DescProd","C",200,0})
//Aadd(aTempStru,{"ClasFisc","C",02,0})
//Aadd(aTempStru,{"SituTrib","C",03,0})
	Aadd(aTempStru,{"CodiUnid","C",02,0})
	Aadd(aTempStru,{"Tipo"    ,"C",02,0})
	Aadd(aTempStru,{"QtdeProd","N",13,2})
	Aadd(aTempStru,{"ValrUnit","N",11,2})
	Aadd(aTempStru,{"ValrTota","N",11,2})
	Aadd(aTempStru,{"ValrDesc","N",11,2}) //Alterado/Incluï¿½do em 16/08/18
	Aadd(aTempStru,{"PrecoTab","N",11,2})  //Alterado/Incluï¿½do em 16/08/18
	Aadd(aTempStru,{"PercDescIt","N",05,2})

	cArqTrab1 := CriaTrab(aTempStru,.T.)

	dbUseArea( .T.,, cArqTrab1, "TRBI",.F.,.F.)
	IndRegua("TRBI",cArqTrab1,"Pedido+ItemPed+CodiProd",,,"Selecionando Registros...")

	aTempStru := {}

	Aadd(aTempStru,{"Pedido","C",06,0})
	Aadd(aTempStru,{"DataEmis","D",08,0})
	Aadd(aTempStru,{"ValrNota","N",11,2})
	Aadd(aTempStru,{"TipoClFo","C",01,0})
	Aadd(aTempStru,{"CodiClFo","C",06,0})
	Aadd(aTempStru,{"LojaClFo","C",02,0})
	Aadd(aTempStru,{"ValrMerc","N",11,2})
	Aadd(aTempStru,{"ValrDesc","N",11,2})
	Aadd(aTempStru,{"NumeDupl","C",06,0})
	Aadd(aTempStru,{"CondPaga","C",03,0})
	Aadd(aTempStru,{"Tabela","C",03,0})
//Aadd(aTempStru,{"PesoBrut","N",09,2})
//Aadd(aTempStru,{"PesoLiqu","N",09,2})
//Aadd(aTempStru,{"TipoClie","C",01,0}) //TipoClFo
	Aadd(aTempStru,{"Vendedor","C",06,0})
	Aadd(aTempStru,{"QtdeVolu","N",05,0})
//Aadd(aTempStru,{"Tipo"    ,"C",01,0})
//Aadd(aTempStru,{"Especie" ,"C",05,0})
	Aadd(aTempStru,{"Observ","C",80,0})
//Aadd(aTempStru,{"TClasFis","C",150,0})
	Aadd(aTempStru,{"PercDesc","N",05,2})  //Alterado/Incluï¿½do em 16/08/18


	cArqTrab2 := CriaTrab(aTempStru,.T.)

	dbUseArea( .T.,, cArqTrab2, "TRBC",.F.,.F.)
	IndRegua("TRBC",cArqTrab2,"Pedido",,,"Selecionando Registros...")

	aTempStru := {}

Return


Static Function GravTrab()
// *****************************************************************************
// * Grava os dados no arquivo de trabalho
// *
// ***

	DBSelectArea("SC5")
	dbSetOrder(1)
	DBSeek(xFilial("SC5")+cPedInic,.T.)


	Do While (! Eof())                 .And. ;
			(SC5->C5_Filial == xFilial("SC5")) .And. ;
			(SC5->C5_NUM    <= cPedFina)
	
		lFirst    := .T.
		I:=1
		aClasFisc := {}
		aArraPedi := {}
	//	PedVenda  := ""
	
	   //Alterado por Weiden 25/03/2013
		if SC5->C5_BLQ == "1"
			SC5->(DBSKIP())
			LOOP
		endif
	
	//<TLM - 08/10/10>
	//Se nao considera os pedidos de ja impressos
		If mv_par10 == 2
		
		//Se o pedido ja tiver sido impresso
			If SC5->C5_IMPRESS == "1"
				SC5->(DBSKIP())
				LOOP
			EndIf
		
		EndIf

	//Seta o pedido como jï¿½ impresso
		Reclock("SC5",.F.)
	
		SC5->C5_IMPRESS := "1"
	
		SC5->(MsUnlock())
	//</TLM>
/*	
	DBSelectArea("SA1")
	DBSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
	
	nPosiStr  := AT(SA1->A1_Est,GetMV("MV_ESTICM"))
	nPercICMS := Val(SubStr(GetMV("MV_ESTICM"),nPosiStr+2,2))
*/
		aArraPedi := {}
		DBSelectArea("SC6")
		DBSetOrder(1)
		DBSeek(xFilial("SC6")+SC5->C5_NUM)
	
		While (! Eof())                          .And. ;
				(SC6->C6_Filial == xFilial("SC6")) .And. ;
				(SC6->C6_NUM    == SC5->C5_NUM)
		
		
		
		/*	If Select("ITENSPED") > 0
				dbSelectArea("ITENSPED")
				dbCloseArea()
			EndIf		
				cQuery := "  SELECT PER_DESCACRES, VLR_VENDA  FROM  SRVPP01.LANDIX_FLX.dbo.TAFITE  WHERE NUM_PEDIDO = '" + STR(SC5->C5_NUMLDX) +"' AND COD_PRODUTO = '"+ SC6->C6_PRODUTO +"'"
					//cQuery += "  SRVPP01.LANDIX_FLX.dbo.TAFCAB LC ON str(A.C6_NUMLDX)+A.C6_CLI+A.C6_LOJA = str(LC.NUM_PEDIDO)+LC.COD_CLIENTE COLLATE Latin1_General_BIN "
				TCQuery cQuery Alias ITENSPED New
		*/
		
			DBSelectArea("SB1")
			dbSetOrder(1)
			DBSeek(xFilial("SB1")+SC6->C6_PRODUTO)
	
		//	dbSelectArea("ITENSPED")	
		
			DBSelectArea("TRBI")
			dbSetOrder(1)
			RecLock("TRBI",.T.)

		
			
			Replace  Pedido    With  SC6->C6_NUM
			Replace  ItemPed   With  SC6->C6_ITEM
			Replace  CodiProd  With  SC6->C6_PRODUTO 
			Replace  DescProd  With  SC6->C6_DESCRI //IIf(SB1->B1_TIPO == "SP",SC6->C6_DESCRI,Left(Alltrim(SC6->C6_DESCRI),40))
			Replace  CodiUnid  With  SC6->C6_UM
			Replace  Tipo      With  SB1->B1_Tipo
			Replace  QtdeProd  With  SC6->C6_QTDVEN
			Replace  ValrUnit  With  SC6->C6_PRCVEN //Iif(ITENSPED->VLR_VENDA>0,ITENSPED->VLR_VENDA,SC6->C6_PRCVEN)  //ITENSPED->VLR_VENDA    //SC6->C6_PRCVEN 
			Replace  ValrTota  With  SC6->C6_VALOR  
			Replace  ValrDesc  With  SC6->C6_VALDESC  
		//	Replace  PercDescIt  Whit  ITENSPED->PER_DESCACRES
		//	Replace  PrecoTab  With  Iif(SC6->C6_PRUNIT>SC6->C6_PRCVEN,SC6->C6_PRUNIT,SC6->C6_PRCVEN) // SC6->C6_PRUNIT //Alterado/Incluï¿½do em 16/08/18
			
			MsUnlock()
			
			DBSelectArea("SC6")
			DBSkip()
		EndDo
	
	//MONTA ARRAY DO CABEï¿½ALHO
		DBSelectArea("TRBC")
		RecLock("TRBC",.T.)
	
		Replace  Pedido  With   SC5->C5_NUM//SF2->F2_Doc
		Replace  DataEmis  With   SC5->C5_EMISSAO//SF2->F2_Emissao
		Replace  CodiClFo  With   SC5->C5_Cliente
		Replace  LojaClFo  With   SC5->C5_LojaCli
		Replace  Vendedor  With   SC5->C5_VEND1
		Replace  CondPaga  With   SC5->C5_Condpag
		Replace  Tabela	   With   SC5->C5_Tabela
		Replace  QtdeVolu  With   SC5->C5_Volume1
		Replace  Observ	   With   cObsCli
		Replace  PercDesc  With   SC5->C5_DESC1
	
		If (SF2->F2_Tipo $ "N/C/P/I/S/T/O")
			Replace  TipoClFo  With  "C"
		Else
			Replace  TipoClFo  With  "F"
		EndIf
	
/*	For I=1 To Len(aClasFisc)
		Replace TClasFis With Chr(64+I)+"-"+aClasFisc[I]
	Next
	*/
		MsUnlock()
	
//	nPBruto    := 0
		aNumPed    := {}
		cListPedi  := ""
	
		DBSelectArea("SC5")
		dbSkip()
	EndDo

Return


Static Function Imprime()
//*****************************************************************************
//* Imprime a Nota Fiscal de Entrada e de Saida
//*
//***

	DBSelectArea("TRBC")
	DBGoTop()
//SetPrc(0,0)
	Li:=1
	_nIt:=0
	aArea:=GetArea() // Guarda a area atual

	Do While (! Eof())
	//LI := nLin //LI = Linha Inicio		Li:=1
		ImprCabe()
	
		if _nIt > 27
			RestArea(aArea) // volta para area atual
		else
			nTotalBru  := 0
			nDescVist  := 0
			nDescVist2  := 0
			nTotDesc   := 0
			nTotalPro  := 0
			nQuantPro  := 0
			VolTotal   := 0
		
			DBSelectArea("TRBI")
			DBSeek(TRBC->Pedido)
		EndIf
	
		nLin := LI+16 //nLin (linha dos itens)
		_nIt := 0 //Zera contador de itens
	
	//@ nLin, 001 PSAY Chr(15)
	
		Do While (! Eof())                     .And. ;
				(TRBI->Pedido == TRBC->Pedido)
		
			_nIt := _nIt + 1  //Contador de itens
		
			if _nIt > 27  //Nï¿½o imprime mais do que 29 itens na mesma folha.
				aArea:=GetArea() // Guarda a area atual
				exit
			endif

			ImprItem()
		
			DBSelectArea("TRBI")
			dbSkip()
		EndDo
	
		nLin:=nLin + 1
	
//	DBSelectArea("TRBI")
//	DBSkip(-1)  
	
		DBSelectArea("SC5")
		DBSetOrder(1)
		DBSeek(xFilial("SC5")+TRBC->Pedido)
	
		@ LI+45,000 PSay Chr(18)
	
		ImprRoda()
	
	//	@ 00, 000 PSAY Chr(27) + "C" + Chr(18)
	//	@ 00, 005 PSAY Chr(27) + "C" + Chr(64)
	
		LI := LI + 68 //Prï¿½xima folha
	
		if _nIt <= 27
			DBSelectArea("TRBC")
			dbSkip()
		EndIf
	EndDo


Return


Static Function ImprCabe()
*****************************************************************************
* Imprime a Nota Fiscal de Entrada e de Saida (Cabecalho)
*
***
	DBSelectArea("SC5")
	DBSetOrder(1)
	DBSeek(xFilial("SC5")+TRBC->Pedido)

	cMenNota  := Alltrim(SC5->C5_MenNota)

	@ LI, 000 PSAY Chr(27) + "0" + Chr(18)
	@ LI, 000 PSAY Chr(27) + "C" + Chr(96)

//@ 01, 001 PSAY " "

//DBSelectArea("SF4")
//DBSeek(xFilial("SF4")+TRBC->CodiTes)

	DBSelectArea("SX5")
	DBSeek(xFilial("SX5")+"13"+SF4->F4_CF)


// DATA HORA IMPRESSï¿½O

	HoraImpr := Time()
	DataImpr := Ddatabase

	@ LI+4, 036 PSAY DataImpr
	@ LI+4, 050 PSAY HoraImpr
	@ LI+4, 062 PSAY TRBC->Vendedor
	@ LI+4, 072 PSAY TRBC->Pedido


	DBSelectArea("SA1")
	DBSeek(xFilial("SA1")+TRBC->CodiClFo+TRBC->LojaClFo)
	cCodiClFo := SA1->A1_COD
	cNomeClfo := SA1->A1_Nome
	cFantasClfo := SA1->A1_FANTAS
	cCGCCliFo := SA1->A1_CGC
	cTeleDDD := SA1->A1_DDD
	cTeleClFo := SA1->A1_Tel
	cEndeClFo := SA1->A1_End
	cBairClFo := SA1->A1_Bairro
	cCEPCliFo := SA1->A1_CEP
	cMuniClFo := SA1->A1_Mun
	cEstaClFo := SA1->A1_Est
	cInscClFo := SA1->A1_InscR
	cEndeCobr := SA1->A1_ENDCOB
	cEndeEnt := SA1->A1_ENDENT
	cPracaCob := SA1->A1_MUNC
	cUFCob    := SA1->A1_EstC
	cCepCob   := SA1->A1_CEPC


//@ LI+04, 001 PSAY Chr(15)

	@ LI+06, 039 PSAY cCodiClFo + " - " +cNomeClFo
	@ LI+07, 039 PSAY cFantasClfo
	@ LI+09, 039 PSAY cEndeClFo
	@ LI+10, 039 PSAY cBairClFo
	@ LI+10, 061 PSAY cMuniClFo
	@ LI+11, 039 PSAY "("+Alltrim(cTeleDDD)+")"+Alltrim(cTeleClFo)
	@ LI+11, 061 PSAY cCEPCliFo        Picture"@R 99999-999"
	@ LI+11, 077 PSAY cEstaClFo
	@ LI+13, 038 PSAY cCGCCliFo        Picture "@R 99.999.999/9999-99"
//@ LI+10, 070 PSAY TRBC->DataEmis
	@ LI+13, 061 PSAY cInscClFo


// Monta array com as duplicatas
	DBSelectArea("SE1")                   // * Contas a Receber
	DBSetOrder(1)

	DBSelectArea("TRBC")

Return


Static Function ImprItem()
*****************************************************************************
* Imprime a Nota Fiscal de Entrada e de Saida (Itens)
*
***
	nPrecoItem := 0

	nLin := nLin + 1

	dbSelectArea("DA1")
	dbsetorder(1)
	dbseek(xfilial("DA1")+TRBC->Tabela+TRBI->CodiProd)
		
	nPrecoTabela := DA1->DA1_PRCVEN  //Busca preço bruto direto na tabela

	nPrecoItem := TRBI->QtdeProd*nPrecoTabela   ///TRBI->PrecoTab

	@ nLin, 000 PSay Left(TRBI->CodiProd,11) // +" "+Left(TRBI->DescProd,32)
	@ nLin, 008 PSay Left(TRBI->DescProd,42)
	@ nLin, 044 PSAY TRBI->CodiUnid
	@ nLin, 049 PSAY TRBI->QtdeProd  Picture "@E 999,999"
	@ nLin, 056 PSAY nPrecoTabela  Picture "@E 999,999.99"  //Alterado em 16/08/18 //
	//@ nLin, 056 PSAY TRBI->ValrUnit  Picture "@E 999,999.99"  //Retornado em 04/12/18
	@ nLin, 067 PSAY nPrecoItem  Picture "@E 999,999.99"  //Alterado em 16/08/18 //
	//@ nLin, 067 PSAY TRBI->ValrTota  Picture "@E 999,999.99"  //Retornado em 04/12/18

	nTotalBru := nTotalBru + nPrecoItem
	nTotalPro := nTotalPro + (TRBI->ValrUnit*TRBI->QtdeProd) //TRBI->ValrTota
	nQuantPro := nQuantPro + TRBI->QtdeProd
	IF TRBC->CondPaga $ "027/049"  //Verifica se condiï¿½ï¿½o tem desconto ï¿½ Vista 1%
		nDescVist := nDescVist + (round(nPrecoTabela*0.01,2)*TRBI->QtdeProd)
	EndIF

	IF TRBC->CondPaga $ "010"  //Verifica se condiï¿½ï¿½o tem desconto ï¿½ Vista 1%
		nDescVist2 := nDescVist2 + (round(nPrecoTabela*0.02,2)*TRBI->QtdeProd)
	EndIF
	//alert(str(TRBI->ValrUnit))
	nTotDesc  := nTotDesc + ((nPrecoTabela-TRBI->ValrUnit)*TRBI->QtdeProd) //-nDescVist-nDescVist2)  //Outros Descontos 
	//PercDescIt //Percentual de Desconto
	//Alert(str(nTotDesc))
	DbSelectArea("SB5")
	dbSeek(xFilial("SB5")+TRBI->CodiProd)
	Volume 		:= TRBI->QtdeProd*SB5->B5_COMPRLC*SB5->B5_LARGLC*SB5->B5_ALTURLC
	VolTotal 	:= VolTotal + Volume


	DBSelectArea("TRBI")


Return


Static Function ImprRoda()
*****************************************************************************
* Imprime a Nota Fiscal de Entrada e de Saida (Rodape)
*
***

	cVolume := TRBC->QtdeVolu
	//nDesc := IIF(nTotDesc-nDescVist<>0,nTotDesc-nDescVist,0)
	//nDescAV := IIF(nDescVist<>0,nDescVist,0)

	DBSelectArea("SC5")
	DBSetOrder(1)
	DBSeek(xFilial("SC5")+TRBC->Pedido)

	DBSelectArea("SA1")
	DBSeek(xFilial("SA1")+TRBC->CodiClFo+TRBC->LojaClFo)
	cObsCli := Alltrim(SA1->A1_OBSERV) + " - " + Alltrim(SC5->C5_OBS)  //SUBSTR(SA1->A1_OBSERV + " - " + SC5->C5_OBS,1,115) //<TLM>

	IF (Alltrim(SA1->A1_ATUALIZ)="" .or. Alltrim(SA1->A1_ATUALIZ)="E")
		cOBSAtu := "ENVIAR FICHA DE ATUALIZACAO"
	Else
		cOBSAtu := ""
	END IF 
	
	DBSelectArea("SE4")
	DBSeek(xFilial("SE4")+TRBC->CondPaga)
	cCondPgto := SE4->E4_DESCRI

	if _nIt <= 27
		if nDescVist > 0 
			@ LI+45, 050 PSAY "DESCONTO A VISTA:"
			@ LI+45, 067 PSAY nDescVist  Picture "@E 999,999.99"    //Desconto - Alterado Incluï¿½do 16/08/18
		EndIf

		if nDescVist2 > 0 
			@ LI+45, 050 PSAY "DESCONTO A VISTA:"
			@ LI+45, 067 PSAY nDescVist2  Picture "@E 999,999.99"    //Desconto - Alterado Incluï¿½do 16/08/18
		EndIf

		
		@ LI+46, 001 PSAY  "NAO EFETUAR PAGAMENTO EM DINHEIRO NA ENTREGA."
		if nTotDesc > 0 
			@ LI+47, 050 PSAY "OUTROS DESCONTOS:"
			@ LI+47, 067 PSAY nTotDesc-nDescVist-nDescVist2  Picture "@E 999,999.99"    //Desconto - Alterado Incluï¿½do 16/08/18
		EndIf
		@ LI+49, 001  PSAY cCondPgto
		@ LI+49, 030 PSAY  VolTotal   Picture "@E 99,999.99"
		@ LI+49, 045  PSAY nQuantPro  Picture "@E 999,999"    //Quantidade Total
		@ LI+49, 068  PSAY nTotalBru  Picture "@E 9,999,999.99"    //Valor Total Bruto (sem descontos) - Alterado/Incluï¿½do 16/08/18
		@ LI+52, 001 PSAY  cEndeEnt
		@ LI+52, 068  PSAY nTotalPro  Picture "@E 9,999,999.99"    //Valor das mercadorias
		@ LI+55, 001 PSAY  "CONFERIR O PEDIDO NA ENTREGA,NAO ACEITAMOS RECLAMACOES POSTERIORES"
		if alltrim(cObsCli)<>""
			@ LI+57, 001 PSAY  substring(cObsCli,1,90) + " / " + cOBSAtu //Observacao do cliente
		else
			@ LI+57, 001 PSAY  Alltrim(cOBSAtu)
		ENDIF
	else
	
		@ LI+49, 003  PSAY "Continua..."
		@ LI+49, 030 PSAY  "*****"
		@ LI+49, 045  PSAY "*****"
		@ LI+49, 068  PSAY "*****"
	
	EndIf

	DBSelectArea("TRBC")

Return
