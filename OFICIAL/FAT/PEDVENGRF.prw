#INCLUDE "RWMAKE.CH"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±i
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PEDVENGRF  ³ Autor ³ Weiden M. Mendes     ¦ Data ¦17.07.2020³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao de Pedido de Vendas     		                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  12.1.25 ³ Especifico PELKOTE                                          ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PEDVENGRF()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	LOCAL oDlg := NIL
	LOCAL cString	:= "SZ1"
	PRIVATE titulo 	:= ""
	PRIVATE nLastKey:= 0
	PRIVATE cPerg	:= "PEDVEN" //"FATR05" Criar perguntas para RELOP.
	PRIVATE nomeProg:= FunName()
	Private nTotal	:= 0
	Private nSubTot	:= 0

	//AjustaSx1()
	If ! Pergunte(cPerg,.T.)
		Return
	Endif

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
	wnrel := FunName()            //Nome Default do relatorio em Disco

	PRIVATE cTitulo := "Pedidos de Venda - Gráfico"
	PRIVATE oPrn    := NIL
	PRIVATE oFont1  := NIL
	PRIVATE oFont2  := NIL
	PRIVATE oFont3  := NIL
	PRIVATE oFont4  := NIL
	PRIVATE oFont5  := NIL
	PRIVATE oFont6  := NIL

//Variaveis vindas do Pedven
	SetPrvt("TAMANHO,LIMITE,NOMEPROG,NLASTKEY,NCONTLINH,CSTRING")
	SetPrvt("WNREL,CPERG,TITULO,CDESC1,CDESC2,CDESC3")
	SetPrvt("ARETURN,_IMPDSAIDA,cPedInic,cPedFina,CCARGAINI,CCARGAFIN,CSERINTFI,NTIPONTFI")
	SetPrvt("_CPLACA,_DSAIDA,NPBRUTO,NTOTALPRO,NQUANTPRO,ANUMPED,_NVOLUME,_NPESO, NTOTALBRU, NTOTDESC, NDESCVIST")
	SetPrvt("ATEMPSTRU,CARQTRAB1,CARQTRAB2,CARQTRAB3,LFIRST")
	SetPrvt("CCODITES,CCODIFIOP,CTEXTOP,CTEXTOPSP,CENDEENT")
	SetPrvt("NCONTAUXI,CLOTEAUXI,CSERIFATU,NCONTITEM,NTOTAITEM,NVALORTRAN")
	SetPrvt("CVALREXTEN,NCONTLIN,NVERI,CMENNOTA,NTAMMENS,CNOMECLFO")
	SetPrvt("CCGCCLI,CTELEDDD,CTELECL,CEND,CBAIRCLFO,CCEPCLI,CMUNICLFO")
	SetPrvt("CINSCCLI,XPARC_DUP,XVENC_DUP,XVALOR_DUP,XDUPLICATAS")
	SetPrvt("NTAMEXTE,NPOVAZ,NPOFIN,LTEST,CEXTENSO1,CEXTENSO2")
	SetPrvt("A,LCONTITEM,NTAMPROD,NPOS,NLINCLAS,NCONT")
	SetPrvt("NOMECLI, NOMEFAN, MUNICIP,ESTADO, BAIRRO")

	Private nLastKey := 0

	DEFINE FONT oFont1 NAME "Times New Roman" SIZE 0,20 BOLD  OF oPrn
	DEFINE FONT oFont2 NAME "Times New Roman" SIZE 0,14 BOLD OF oPrn
	DEFINE FONT oFont3 NAME "Times New Roman" SIZE 0,14 OF oPrn
	DEFINE FONT oFont4 NAME "Times New Roman" SIZE 0,14 ITALIC OF oPrn
	DEFINE FONT oFont5 NAME "Times New Roman" SIZE 0,14 OF oPrn
	DEFINE FONT oFont6 NAME "Courier New" BOLD
	DEFINE FONT oFont08I NAME "Times New Roman" SIZE 0,08 ITALIC OF oPrn

	//oFont06  := TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
	//oFont06N := TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)
	oFont08	 := TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
	oFont08N := TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
	oFont09N := TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)
	oFont09	 := TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)
	oFont10	 := TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
	oFont10N := TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
	oFont11  := TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
	oFont11N := TFont():New("Arial",11,11,,.T.,,,,.T.,.F.)
	oFont12  := TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
	oFont12N := TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)
	oFont14	 := TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
	oFont14N := TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
//	oFont16	 := TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
///	oFont16N := TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)

//Inicializacao variaveis pedven
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
	//aNumPed    := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tela de Entrada de Dados - Parametros                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLastKey  := IIf(LastKey() == 27,27,nLastKey)

	If nLastKey == 27
		Return
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do lay-out / impressao                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oPrn := TMSPrinter():New(cTitulo)
	oPrn:Setup()
	oPrn:SetPortrait()//SetPortrait() //SetLansCape()
	oPrn:StartPage()
	
	CriaTraba() //vindo do pedven.prw
	GravTrab() //vindo do pedven.prw

    Imprimir()
	oPrn:EndPage()
	oPrn:End()
    

	DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
	@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

	@ 015,017 SAY "Esta rotina tem por objetivo imprimir"	OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
	@ 030,017 SAY "o impresso customizado:"					OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
	@ 045,017 SAY "Pedido de Venda" 						OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
	@ 06,167 BUTTON "&Imprime" 		SIZE 036,012 ACTION oPrn:Print()   	OF oDlg PIXEL
	@ 28,167 BUTTON "Pre&view" 		SIZE 036,012 ACTION oPrn:Preview() 	OF oDlg PIXEL
	@ 49,167 BUTTON "Sai&r"    		SIZE 036,012 ACTION oDlg:End()     	OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	oPrn:End()

Return


Static Function CriaTraba()
//****************************************************************************
//* Cria os arquivos de trabalho
//*
//******

/*lOk := .T.
While .T.    
	IF !ChkFile("SA1",.T.)        
		nResp := Alert("Outro usuario usando! Tenta de ;                 novo?",{"Sim","Nao"})        
		If nResp == 2            
			lOk := .F.            
			Exit        
		Endif    
	Endif
EndDo
*/
		
	IF ChkFile("TRBI",.f.) //Verifica se arquivo existe e está aberto
		TRBI->(dbcloseArea())
	EndIf

	
	IF ChkFile("TRBC",.f.) 
		TRBC->(dbcloseArea())
	EndIf	

	aTempStru := {}

	Aadd(aTempStru,{"Pedido","C",06,0})
	Aadd(aTempStru,{"ItemPed" ,"C",02,0})
	Aadd(aTempStru,{"CodiProd","C",15,0})
	Aadd(aTempStru,{"DescProd","C",200,0})
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
	Aadd(aTempStru,{"Vendedor","C",06,0})
	Aadd(aTempStru,{"QtdeVolu","N",05,0})
	Aadd(aTempStru,{"Observ","C",80,0})
	Aadd(aTempStru,{"PercDesc","N",05,2})  
	Aadd(aTempStru,{"NomeCli","C",50,0})
	Aadd(aTempStru,{"NomeFan","C",50,0})
	Aadd(aTempStru,{"Municip","C",30,0})
	Aadd(aTempStru,{"Bairro","C",20,0})
	Aadd(aTempStru,{"Estado","C",2,0})
	Aadd(aTempStru,{"cEnd","C",60,0})
	Aadd(aTempStru,{"cCepCli","C",10,0})
	Aadd(aTempStru,{"cTeleDDD","C",3,0})
	Aadd(aTempStru,{"cTeleCl","C",30,0})
	Aadd(aTempStru,{"cCGCCli","C",20,0})
	Aadd(aTempStru,{"cInsccli","C",20,0})
	Aadd(aTempStru,{"cEndEnt","C",40,0})

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

	//Seta o pedido como ja impresso
		Reclock("SC5",.F.)
		SC5->C5_IMPRESS := "1"
		SC5->(MsUnlock())
	//</TLM>

		aArraPedi := {}
		DBSelectArea("SC6")
		DBSetOrder(1)
		DBSeek(xFilial("SC6")+SC5->C5_NUM)
	
		While (! Eof())                          .And. ;
				(SC6->C6_Filial == xFilial("SC6")) .And. ;
				(SC6->C6_NUM    == SC5->C5_NUM)
		
           // conout(SC6->C6_NUM+" "+SC6->C6_ITEM)
		
			DBSelectArea("SB1")
			dbSetOrder(1)
			DBSeek(xFilial("SB1")+SC6->C6_PRODUTO)

            DBSelectArea("SA1")
			dbSetOrder(1)
			DBSeek(xFilial("SA1")+SC5->C5_CLIENTE)

			dbSelectArea("DA1")
			dbsetorder(1)
			dbseek(xfilial("DA1")+SC5->C5_TABELA+SC6->C6_PRODUTO)
		
	nPrecoTabela := DA1->DA1_PRCVEN  //Busca preço bruto direto na tabela

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
			Replace  PrecoTab  With  DA1->DA1_PRCVEN
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
		Replace  Observ	   With   Alltrim(SA1->A1_OBSERV) + " - " + Alltrim(SC5->C5_OBS)
		Replace  PercDesc  With   SC5->C5_DESC1
		Replace  NomeCli   With   SA1->A1_NOME
		Replace  NomeFan   With   SA1->A1_FANTAS
		Replace  cEnd	   With	  SA1->A1_END
		Replace  Bairro	   With   SA1->A1_BAIRRO
		Replace  Municip   With   SA1->A1_MUN
		Replace  Estado	   With   SA1->A1_EST
		Replace	 cCepCli   With   SA1->A1_CEP
		Replace  cTeleDDD  With   SA1->A1_DDD
		Replace  cTeleCl   With   Alltrim(SA1->A1_TEL) +" / "+Alltrim(SA1->A1_CEL)
		Replace  cCGCCli   With   SA1->A1_CGC
		Replace  cInscCli  With   SA1->A1_INSCR
		Replace  cEndEnt   With   SA1->A1_ENDENT
      
		MsUnlock()
	
//	nPBruto    := 0
		aNumPed    := {}
		cListPedi  := ""
	
		DBSelectArea("SC5")
		dbSkip()
	EndDo

Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ IMPRIMIR  ¦ Autor ¦ Weiden M. Mendes     ¦ Data ¦18.09.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao Romaneio										  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Pelkote                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
STATIC FUNCTION Imprimir()

	MontaPedido()
	Ms_Flush()
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ ORCAMENTO ¦ Autor ¦ Weiden M. Mendes     ¦ Data ¦18.09.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao 										          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Pelkote                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
STATIC FUNCTION MontaPedido()

	Static QtdeTotal 
	Static VolTotal
	Static ValrBru
	Static ValrTotal
	Static nTotDesc
	Static nDescVist2
	Static nDescVist
	Static nLin
	Static nVia

	Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
	Local cNamUser := UsrRetName( cCodUser )//Retorna o nome do usuario
	cObsFardo:= ""

//cDia := SubStr(DtoS(dDataBase),7,2)
//cMes := SubStr(DtoS(dDataBase),5,2)
//cAno := SubStr(DtoS(dDataBase),1,4)
//cMesExt := MesExtenso(Month(dDataBase))
//cDataImpressao := cDia+" de "+cMesExt+" de "+cAno


	oPrn:StartPage()
	cBitMap := "\\srvpp08\Microsiga\protheus_data\system\LogoRel.bmp" //CORRIGIR

	dbSelectArea("TRBC")
	//dbSetOrder(01)
	dbGotop("TRBC")
    //dbSeek(xFilial("TRBC")+mv_par01)


	nPedido	:= TRBC->Pedido
	nVia	 	:= 1

	While !Eof() //.And. TRBC->Pedido >= mv_par01	.And. TRBC->Pedido <= mv_par02 //MV_PAR01: Numero romaneio
	 conout("Pedido "+TRBC->Pedido)

//	dbUseArea( .T.,, cArqTrab1, "TRBI",.F.,.F.)
  //	IndRegua("TRBI",cArqTrab1,"Pedido+ItemPed+CodiProd",,,"Selecionando Registros...")

 // DBSelectArea("TRBC")
  //  DBGoTop()

//Imprime parte superior A4
	If nVia = 1
		oPrn:Line( 1700,050,1700,2400 )
		nLin := 020
		ImprimeCabe()
		nLin :=0440  //linha do item 
		ImprimeItens()
		if nVia = 1 //Se a via não foi alterada por excesso de itens ( maior que 21 ) 
			nLin :=1300 //linha do Rodapé 
			ImprRoda()  //Imprime rodapé
			
			nVia := 2
		Else		
			nVia := 1
			oPrn:EndPage()
		EndIf
	Else
		if nVia = 2
			oPrn:Line( 1700,050,1700,2400 )
			nLin := 1750
			ImprimeCabe()
			nLin :=2170  //linha do item 
			ImprimeItens()
			
			if nVia = 2  //Se a via não foi alterada por excesso de itens ( maior que 21 ) 
				nLin :=3050 //linha do Rodapé 
				ImprRoda()  //Imprime rodapé
				nVia := 1
				oPrn:EndPage()
			Else
				nVia := 2
			EndIf
			
		EndIf
	EndIf
								
    TRBC->(dbskip())

	EndDo

  //  dbcloseArea(TRBC)
    //dbcloseArea(TRBI)

Return

//*****************************************************************************
//* Imprime Pedido de Venda (Cabeçalho)
//*
//***
Static Function ImprimeCabe()
 
 	oPrn:SayBitmap(nLin,0020,cBitMap,0300,0300)			//LinIni, ColIni,Imagem,ColFim,LinFim Imprime logo da Empresa: comprimento X altura
	oPrn:Say(nLin,1950, "PEDIDO Nº "+OemToAnsi(TRBC->Pedido),oFont12N)  //050
	nLin += 30
	nLin += 20
	oPrn:Say(nLin,300,"Veículo: ___________",	oFont10N) 
	oPrn:Say(nLin,750,"Motorista: ________________",	oFont10N) 		
	oPrn:Say(nLin,1350,"Ajudante: _______________",	oFont10N) 
	nLin += 30
	oPrn:Say(nLin,2000,"Vendedor: ",oFont10N)
	oPrn:Say(nLin,2200,TRBC->Vendedor,oFont10N)		
	// DATA HORA IMPRESSÃO
	//	dataHora:=Time()
	//	oPrn:Say(0120,2100,dataHora,oFont12)
	
 	//nLin += 030	
	
		//DADOS CLIENTE
	nLin += 050 //0150
			oPrn:Say(nLin,0300,"Cliente: ",			   oFont10N) 
			oPrn:Say(nLin,0430, OemToAnsi(TRBC->CodiClFo)+" - "+ OemToAnsi(Alltrim(TRBC->NomeCli))+" ("+ OemToAnsi(Alltrim(TRBC->NomeFan))+")",			   oFont10N)
			//oPrn:Say(nLin,0400, OemToAnsi(TRBC->CodiClFo)+" - "+ OemToAnsi(substr(TRBC->NomeCli,1,40))+" ("+ OemToAnsi(Alltrim(TRBC->NomeFan,1,20))+")",			   oFont10N)
			//oPrn:Say(nLin,0400, " ("+ OemToAnsi(substr(TRBC->NomeFan,1,20))+")",			   oFont09)
		
	nLin += 50 //0200
			oPrn:Say(nLin,0300,"Endereço: ", oFont10N)
			oPrn:Say(nLin,0500,OemToAnsi(trim(TRBC->cEnd))+" - "+ OemToAnsi(trim(TRBC->Bairro))+" - "+ OemToAnsi(trim(TRBC->Municip))+" - "+ OemToAnsi(trim(TRBC->Estado)), oFont10N)
	nLin += 50	//250	
			oPrn:Say(nLin,0300,"CEP:",oFont10N)
			oPrn:Say(nLin,0400,OemToAnsi(TRBC->cCEPCli),		   oFont10)
			oPrn:Say(nLin,0600,"Telefones:",oFont10N)
			oPrn:Say(nLin,0790,OemToAnsi(TRBC->cTeleDDD)+"-"+OemToAnsi(TRBC->cTeleCl),		   oFont10)
			oPrn:Say(nLin,1450,"CNPJ/CGC:",oFont10N)
			oPrn:Say(nLin,1660,OemToAnsi(TRBC->cCGCCli),		   oFont10)
			oPrn:Say(nLin,2010,"IE:",oFont10N)
			oPrn:Say(nLin,2070,OemToAnsi(TRBC->cInscCli),		   oFont10)
	nLin += 50		//0300
			oPrn:Say(nLin,0300,"End.Entrega:",oFont10N)
			oPrn:Say(nLin,0550,OemToAnsi(TRBC->cEndEnt),		   oFont10N)
			dDataEmiss:=Dtoc(ddatabase)
			oPrn:Say(nLin,2050,"Data: "+ OemToAnsi(DdataEmiss),oFont09N) //050

		
		//Data e hora impressão
		//	oPrn:Say(0220,0100,"EMITENTE:",oFont12N)
		//	oPrn:Say(0220,0300,SubStr(cNamUser,1,13)            ,oFont12N)	//NOME DO EMITENTE
		
		//CABEÇALHO ITENS DO ROMANEIO
	nLin +=	50//0400
			oPrn:Box(nLin,0050,nLin+80,2400) //Caixa de cabeçalho
//		oPrn:Say(0330,0100,"Item"  	  		          	,oFont12N)
	nLin +=20 
			oPrn:Say(nLin,0200,"Codigo"  	            	,oFont10N)
			oPrn:Say(nLin,0400,"Nome do Produto"	            	,oFont10N)
			oPrn:Say(nLin,1400,"Quantidade"	  	            ,oFont10N) //	oPrn:Say(0330,1100,"Quantidade"	  	            ,oFont12N)
			oPrn:Say(nLin,1650,"Unid."		  	            ,oFont10N)
			oPrn:Say(nLin,1800,"Preço Unit."	   	            	,oFont10N)
            oPrn:Say(nLin,2200,"Total"	   	            	,oFont10N)
			
Return

//*****************************************************************************
//* Imprime a Pedido de Venda (Itens)
//*
//***
Static Function ImprimeItens()

QtdeTotal := 0
VolTotal :=	0
ValrBru := 0
ValrTotal := 0
nTotDesc  := 0
nDescVist2 := 0   
nDescVist := 0
lMudaPag := .f.	
nitens :=0		
		//ITENS DO ROMANEIO
            DBSelectArea("TRBI")
			DBSeek(TRBC->Pedido)
			
			While !Eof() .AND. TRBI->Pedido == TRBC->Pedido
			    nitens+=1
				
				IF  nitens > 21 .and. lMudaPag = .f.	
						
					If nVia = 2
						
						nLin := 3250
						oPrn:Say(nLin,1600,"CONTINUA NA PROX. PAG.",oFont11N)
						oPrn:Say(nLin+50,1700,"***********",oFont11N)
						oPrn:Say(nLin+100,1700,"***********",oFont11N)
						oPrn:EndPage()
						nVia := 1
						nLin := 020
						ImprimeCabe()
						//nLin :=1300 //linha do Rodapé 
						//ImprRoda()  //Imprime rodapé
						nLin :=0440  //linha do item 
							
					Else
						if nVia = 1
							nLin := 1400
							oPrn:Say(nLin,1600,"CONTINUA NA PROX. PAG.",oFont11N)
							oPrn:Say(nLin+50,1700,"***********",oFont11N)
							oPrn:Say(nLin+100,1700,"***********",oFont11N)
						
							nVia := 2
							nLin := 1750
							ImprimeCabe()
						//	nLin :=3050 //linha do Rodapé 
						//	ImprRoda()  //Imprime rodapé
							nLin :=2170  //linha do item 		
						EndIf
					EndIf
					lMudaPag := .t.	
				EndIf

				oPrn:Say(nLin,0200,OemToAnsi(TRBI->CodiProd),		   oFont09)
			
				dbSelectArea("SB1")
				dbSetOrder(01)
				dbSeek(xFilial("SB1")+TRBI->CodiProd)
				oPrn:Say(nLin,0150,Transform(nitens,"@E 99"),			   oFont09)
				oPrn:Say(nLin,0400,OemToAnsi(TRBI->DescProd),			   oFont09)
				oPrn:Say(nLin,1400,Transform(TRBI->QtdeProd,"@E 9,999,999.99"),		oFont09)
				oPrn:Say(nLin,1650,OemToAnsi(TRBI->CodiUnid),			   oFont09)
				oPrn:Say(nLin,1900,Transform(TRBI->PrecoTab,"@E 9,999,999.99"),	oFont09,,,,1)   //oPrn:Say(nLin,1900,Transform(TRBI->ValrUnit,"@E 9,999,999.99"),	oFont10,,,,1)
				oPrn:Say(nLin,2300,Transform(TRBI->PrecoTab*TRBI->QtdeProd,"@E 9,999,999.99"),	oFont09,,,,1)
				nLin+=035
				oPrn:Line( nLin,050,nLin,2400 )	
				
				QtdeTotal	+= TRBI->QtdeProd
				ValrBru 	+= TRBI->PrecoTab*TRBI->QtdeProd
				ValrTotal	+= TRBI->ValrTota
		
			//CALCULO DO VOLUME DO PEDIDO
				dbSelectArea("SB5")
				dbSetOrder(01)
				dbSeek(xFilial("SB5")+TRBI->CodiProd)
			
				Volume 		:= TRBI->QtdeProd*SB5->B5_COMPRLC*SB5->B5_LARGLC*SB5->B5_ALTURLC
				VolTotal 	:= VolTotal + Volume
			
				//CALCULO DOS DESCONTOS
				IF TRBC->CondPaga $ "027/049" 
					nDescVist := nDescVist + (round(TRBI->PrecoTab*0.01,2)*TRBI->QtdeProd)
				EndIF

				IF TRBC->CondPaga $ "010"  
					nDescVist2 := nDescVist2 + (round(TRBI->PrecoTab*0.02,2)*TRBI->QtdeProd)
				EndIF
		
				nTotDesc  := nTotDesc + ((TRBI->PrecoTab-TRBI->ValrUnit)*TRBI->QtdeProd)
							
				dbSelectArea("TRBI")
				TRBI->(dbSkip())
				nLin+=5		
				
							//CONTINUACAO PEDIDO - DESENVOLVER SEGUNDA PARTE DO PEDIDO
		
			EndDo

//Imprimir rodape com quantidade total correta
				IF  nitens > 21 //.and. lMudaPag = .f.	
						//nitens := 1
						
					If nVia = 1
						nLin :=1300 //linha do Rodapé 
						ImprRoda()  //Imprime rodapé
							
					Else
						if nVia = 2
							nLin :=3050 //linha do Rodapé 
							ImprRoda()  //Imprime rodapé
							
						EndIf
					EndIf
					//lMudaPag := .t.	
				EndIf					
			
Return

//*****************************************************************************
//* Imprime o Pedido de Venda (Rodape)
//*
//***
Static Function ImprRoda()
	
	cObsAtu := ""
	cVolume := TRBC->QtdeVolu

	oPrn:Line( nLin,050,nLin,2400 )

	//	oPrn:Say(nLin+100,0020, Transform(nLin+110, "@E 99999")		  	            			,oFont09N)
		nLin += 20
		oPrn:Say(nLin,1250,"Quant:",oFont10N)
		oPrn:Say(nLin,1510,Transform(QtdeTotal,"@E 9,999,999.99"),	oFont10,,,,1)   //oPrn:Say(nLin,1900,Transform(TRBI->ValrUnit,"@E 9,999,999.99"),	oFont10,,,,1)
		oPrn:Say(nLin,1800,"Valor Bruto:",oFont10N)
		oPrn:Say(nLin,2300,Transform(ValrBru,"@E 9,999,999.99"),	oFont10,,,,1)

		DBSelectArea("SE4")
		DBSeek(xFilial("SE4")+TRBC->CondPaga)
		cCondPgto := SE4->E4_DESCRI

		oPrn:Say(nLin,0100,"Forma Patgo:",oFont10N)
		oPrn:Say(nLin,0350,OemToAnsi(cCondPgto),		   oFont10)
		oPrn:Say(nLin,0750,"Volume:",oFont10N)
		oPrn:Say(nLin,1000, Transform(VolTotal,"@E 9,999,999.99"),	oFont10N,,,,1)

//DESCONTOS		
	nLin += 50
	oPrn:Say(nLin,0100,"Desc.A Vista:",oFont10N)
	if nDescVist > 0 
			oPrn:Say(nLin,0450,Transform(nDescVist,"@E 9,999,999.99"),	oFont10,,,,1)
	Else 	
	//	if nDescVist2 > 0 
			oPrn:Say(nLin,0450,Transform(nDescVist2 ,"@E 9,999,999.99"),	oFont10,,,,1)
	//	EndIf
	EndIf

	oPrn:Say(nLin,0650,"Outros Desc.:",oFont10N)
//	if nTotDesc > 0 
		oPrn:Say(nLin,1000,Transform(nTotDesc-nDescVist-nDescVist2 ,"@E 9,999,999.99"),	oFont10,,,,1)
//	EndIf

	//TOTAL A PAGAR
	//nLin += 10
	oPrn:Say(nLin,1800,"Total:",oFont11N)
	oPrn:Say(nLin,2300,Transform(ValrTotal,"@E 9,999,999.99"),	oFont11N,,,,1)
	nLin += 50 //+210
	oPrn:Say(nLin,0100,"Observação:",oFont10N)
	oPrn:Say(nLin,0360, Trim(TRBC->Observ),	oFont10N)
	nLin += 60  //30
	oPrn:Say(nLin,2000,"ST : _____________",oFont10N)
	oPrn:Say(nLin,1400,"Crédito:    _____________",oFont10N)
	nLin += 50  //80
 	//oPrn:Say(nLin,1850,"Crédito:    ________________",oFont10N)
	nLin += 20 //+320
	oPrn:Say(nLin,0050,"NAO EFETUAR PAGAMENTO EM DINHEIRO NA ENTREGA.",oFont11N)
	nLin += 50 //+350	
	oPrn:Say(nLin,0050,"CONFERIR O PEDIDO NA ENTREGA,NAO ACEITAMOS RECLAMACOES POSTERIORES",oFont11N)
	oPrn:Say(nLin,1900,"A Pagar:    _____________",oFont10N)
	//nLin += 30 //+400	
	//OBSERVAÇÕES

	/*	IF (Alltrim(SA1->A1_ATUALIZ)="" .or. Alltrim(SA1->A1_ATUALIZ)="E")
			cOBSAtu := "ENVIAR FICHA DE ATUALIZACAO"
		ENDIF 
*/	
		
	//nLin += 90 //+400	
	//oPrn:Say(nLin,001,Transform(nLin,"@E 9999"),oFont09)
	//oPrn:Line( nLin,050,nLin,2400 )

	DBSelectArea("TRBC")

Return


