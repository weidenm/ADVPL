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
±±³Fun‡…o    ³RCOMR01   ³ Autor ³ Weiden M. Mendes     ¦ Data ¦18.09.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do Romaneio - TmsPrinter		                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  12.1.25 ³ Especifico PELKOTE                                          ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ROMAN()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	LOCAL oDlg := NIL
	LOCAL cString	:= "SZ1"
	PRIVATE titulo 	:= ""
	PRIVATE nLastKey:= 0
	PRIVATE cPerg	:= "ROMAN" //"FATR05" Criar perguntas para RELOP.
	PRIVATE nomeProg:= FunName()
	Private nTotal	:= 0
	Private nSubTot	:= 0

	//AjustaSx1()
	If ! Pergunte(cPerg,.T.)
		Return
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros					  		³
//³ mv_par01				// Numero da PT                   		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel := FunName()            //Nome Default do relatorio em Disco

	PRIVATE cTitulo := "Impressão do Controle de Carregamento - Romaneio"
	PRIVATE oPrn    := NIL
	PRIVATE oFont1  := NIL
	PRIVATE oFont2  := NIL
	PRIVATE oFont3  := NIL
	PRIVATE oFont4  := NIL
	PRIVATE oFont5  := NIL
	PRIVATE oFont6  := NIL

	Private nLastKey := 0

	DEFINE FONT oFont1 NAME "Times New Roman" SIZE 0,20 BOLD  OF oPrn
	DEFINE FONT oFont2 NAME "Times New Roman" SIZE 0,14 BOLD OF oPrn
	DEFINE FONT oFont3 NAME "Times New Roman" SIZE 0,14 OF oPrn
	DEFINE FONT oFont4 NAME "Times New Roman" SIZE 0,14 ITALIC OF oPrn
	DEFINE FONT oFont5 NAME "Times New Roman" SIZE 0,14 OF oPrn
	DEFINE FONT oFont6 NAME "Courier New" BOLD
	DEFINE FONT oFont08I NAME "Times New Roman" SIZE 0,08 ITALIC OF oPrn

	oFont06	 := TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
	oFont06N := TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)
	oFont08	 := TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
	oFont08N := TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
	oFont10	 := TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
	oFont10N := TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
	oFont11  := TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
	oFont11N := TFont():New("Arial",11,11,,.T.,,,,.T.,.F.)
	oFont12  := TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
	oFont12N := TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)
	oFont14	 := TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
	oFont14N := TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
	oFont16	 := TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
	oFont16N := TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)



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
	Imprimir()
	oPrn:EndPage()
	oPrn:End()

	DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
	@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

	@ 015,017 SAY "Esta rotina tem por objetivo imprimir"	OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
	@ 030,017 SAY "o impresso customizado:"					OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
	@ 045,017 SAY "Romaneio" 						OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
	@ 06,167 BUTTON "&Imprime" 		SIZE 036,012 ACTION oPrn:Print()   	OF oDlg PIXEL
	@ 28,167 BUTTON "Pre&view" 		SIZE 036,012 ACTION oPrn:Preview() 	OF oDlg PIXEL
	@ 49,167 BUTTON "Sai&r"    		SIZE 036,012 ACTION oDlg:End()     	OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	oPrn:End()

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

	MontaRoman()
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
STATIC FUNCTION MontaRoman()

	Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
	Local cNamUser := UsrRetName( cCodUser )//Retorna o nome do usuario
	cObsFardo:= ""

//cDia := SubStr(DtoS(dDataBase),7,2)
//cMes := SubStr(DtoS(dDataBase),5,2)
//cAno := SubStr(DtoS(dDataBase),1,4)
//cMesExt := MesExtenso(Month(dDataBase))
//cDataImpressao := cDia+" de "+cMesExt+" de "+cAno


	oPrn:StartPage()
	cBitMap := "\\192.168.2.1\Protheus10\LogoPlincPeq.jpg" //CORRIGIR

	dbSelectArea("SZ1")
	dbSetOrder(01)
	dbSeek(xFilial("SZ1")+mv_par01)

	nLin    :=0530  //linha do item da OP
	nRomaneio	:= SZ1->Z1_NUM
	nVia	 	:= 1

	While !Eof() .And. SZ1->Z1_NUM >= mv_par01	.And. SZ1->Z1_NUM <= mv_par02 //MV_PAR01: Numero romaneio
	
		
		if nVia == 1  //1ª via =  Geral da Carga
		//	cQuery:= "SELECT C5_ROMANEI,C5_ROMIT,C5_CLIENTE, C5_NUM,C5_EMISSAO,A1_NOME,A1_COD,A1_END,A1_MUN,A1_EST,C5_OBS,A1_CODSEG, SUM(C6_VALOR) AS VALOR"
			cQuery:= "SELECT C5_ROMANEI,C5_ROMIT,C5_CLIENTE, C5_NUM,C5_EMISSAO,A1_NOME,A1_COD,A1_END,A1_MUN,A1_EST,C5_OBS,SUM(C6_VALOR) AS VALOR"
			cQuery+= " FROM (" +  RetSqlName("SC5") + " A INNER JOIN " +  RetSqlName("SA1") + " B ON A.C5_CLIENTE = B.A1_COD) "
			cQuery+= " INNER JOIN " +  RetSqlName("SC6") + " C ON A.C5_NUM = C.C6_NUM"
			cQuery+= " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND C.D_E_L_E_T_ = '' AND C5_ROMANEI  ='" + SZ1->Z1_NUM + "'"
			//cQuery+= " GROUP BY C5_ROMANEI,C5_ROMIT, A1_NOME,C5_CLIENTE, C5_NUM,C5_EMISSAO,A1_COD,A1_END,A1_MUN,A1_EST, C5_OBS, A1_CODSEG"
			cQuery+= " GROUP BY C5_ROMANEI,C5_ROMIT, A1_NOME,C5_CLIENTE, C5_NUM,C5_EMISSAO,A1_COD,A1_END,A1_MUN,A1_EST, C5_OBS"
			cQuery+= " ORDER BY C5_ROMANEI,C5_ROMIT"
		
			cDestino := SZ1->Z1_DESCRI
			dData:=Dtoc(SZ1->Z1_DTSAIDA)
			cVeiculo := SZ1->Z1_VEICULO
		
			dbSelectArea("DA4")
			dbSetOrder(01)
			dbSeek(xFilial("DA4")+SZ1->Z1_MOTORI)
		
			SZ1->Z1_MOTORI
			cMotorista := DA4->DA4_NREDUZ
		
			cIndexKey := "C5_ROMANEI+C5_ROMIT"

			QtdeTotal 	:= 0
			VolTotal	:= 0
			ValorTot	:= 0
			PesoTotal	:= 0
			PesoTotLiq	:= 0
		                                                                  
		//	cQuery += " ORDER BY C5_ROMANEI"
		else  //Itens do Romaneio
			if nVia == 2
				cQuery := "SELECT C5_ROMANEI,B1_ORDEM,B1_DESC,C6_PRODUTO, SUM(C6_QTDVEN)AS SOMA_QTD "
				cQuery += " FROM (" +  RetSqlName("SC5") + " A INNER JOIN " +  RetSqlName("SC6") + " B"
				cQuery += " ON A.C5_NUM = B.C6_NUM) INNER JOIN " +  RetSqlName("SB1") + " C ON B.C6_PRODUTO = C.B1_COD "
				cQuery += " WHERE A.D_E_L_E_T_ = ''  AND B.D_E_L_E_T_ = '' AND C5_ROMANEI = '" + SZ1->Z1_NUM +"'"
				cQuery +=" GROUP BY C5_ROMANEI,B1_ORDEM, B1_DESC, C6_PRODUTO"
				cQuery+= " ORDER BY C5_ROMANEI,B1_ORDEM"

				cIndexKey := "C5_ROMANEI+B1_ORDEM"
			else
				cQuery := "SELECT C5_ROMANEI,C5_ROMIT,B1_ORDEM,B1_DESC,C6_PRODUTO, SUM(C6_QTDVEN)AS SOMA_QTD "
				cQuery += " FROM (" +  RetSqlName("SC5") + " A INNER JOIN " +  RetSqlName("SC6") + " B"
				cQuery += " ON A.C5_NUM = B.C6_NUM )  INNER JOIN " +  RetSqlName("SB1") + " C ON B.C6_PRODUTO = C.B1_COD "
				cQuery += "	WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND C5_ROMANEI ='" + SZ1->Z1_NUM + "' AND C5_ROMIT = '" + SZ1->Z1_ITEM+ "'"
				cQuery +=" GROUP BY C5_ROMANEI,C5_ROMIT,B1_ORDEM,B1_DESC,C6_PRODUTO"
				cQuery+= " ORDER BY C5_ROMANEI,C5_ROMIT,B1_ORDEM"

				cIndexKey := "C5_ROMANEI+C5_ROMIT+B1_ORDEM"
			EndIf
		EndIf
	
		TCQuery cQuery Alias ROMITENS New
	
		dbSelectArea("ROMITENS")
//	ROMITENS->(dbGoTop())
//	dbUseArea( .T.,, cArqTrab1, "TRBI",.F.,.F.)
  //	IndRegua("TRBI",cArqTrab1,"Pedido+ItemPed+CodiProd",,,"Selecionando Registros...")
                                                                                                  
		cIndexName := Criatrab(NIL,.F.)
//cIndexKey := "C5_FILIAL+C5_NUM"

		IndRegua("ROMITENS", cIndexName, cIndexKey,,,"Selecionando dados")

		oPrn:SayBitmap(0050,0050,cBitMap,0300,0150)			//LinIni, ColIni,Imagem,ColFim,LinFim Imprime logo da Empresa: comprimento X altura
	
	//IMPRIME A 1ª VIA DO ROMANEIO
		If nVia == 1
			oPrn:Say(0050,0500, "GERAL DA CARGA POR PEDIDO - ROMANEIO  Nº",oFont14N)
			oPrn:Say(0050,1800,OemToAnsi(ROMITENS->C5_ROMANEI),	oFont14N)
				
		// DATA HORA IMPRESSÃO
			dataHora:=Time()
			oPrn:Say(0070,2200,dataHora,oFont12)
			dDataEmiss:=Dtoc(ddatabase)
			oPrn:Say(0120,2200,OemToAnsi(DdataEmiss),oFont12)
		
		//DADOS ROMANEIO
		
			oPrn:Say(0320,0100,"CARGA:_________________",oFont12N)
		//**INCLUIR NUMERO DA CARGA
		//	oPrn:Say(0230,0350,OemToAnsi(SZ1->Z1_DESCRI),		   oFont11)
		
			oPrn:Say(0230,0100,"VEICULO: ",oFont11N)
			oPrn:Say(0230,0350, cVeiculo,				oFont11)
			oPrn:Say(0230,0850,"MOTORISTA: ",				oFont11N)
			oPrn:Say(0230,1150, cMotorista,				oFont11)
			oPrn:Say(0230,1700,"AJUDANTE: ________________",oFont11N)
		
		//		oPrn:Say(0220,0100,"EMITENTE:",oFont12N)
		//		oPrn:Say(0220,0300,SubStr(cNamUser,1,13)            ,oFont12N)	//NOME DO EMITENTE
		
		//CABEÇALHO ITENS DO ROMANEIO
		
			oPrn:Box(0400,0050,0500,2300) //Caixa de cabeçalho
		//		oPrn:Say(0330,0100,"Item"  	  		          	,oFont12N)
			oPrn:Say(0430,0100,"Dt. Venda"  	            	,oFont12)
			oPrn:Say(0430,0300,"Cliente"	            	,oFont12)
			oPrn:Say(0430,1400,"Pedido"	  	            ,oFont12) //	oPrn:Say(0330,1100,"Quantidade"	  	            ,oFont12N)
			oPrn:Say(0430,1600,"Val.Total"		  	        ,oFont12)
			oPrn:Say(0430,1800,"Nota Fiscal"	   	         	,oFont12)
			oPrn:Say(0430,2050,"Item Rom."	   	            	,oFont12)
		                                                      
		//ITENS DO ROMANEIO
			nitens := 1
			lCabeçalho := .f.
			While !Eof()

				dbSelectArea("SC5")
				dbSetOrder(01)
				dbSeek(xFilial("SC5")+ROMITENS->C5_NUM)
		
				dbSelectArea("SC6")
				dbGotop("SC6")
				dbSetOrder(01)
				dbSeek(xFilial("SC6")+ROMITENS->C5_NUM)
			
				While SC6->C6_NUM == ROMITENS->C5_NUM
					dbSelectArea("SB1")
					dbSetOrder(01)
					dbSeek(xFilial("SB1")+SC6->C6_PRODUTO)
			
					QtdeTotal	+= SC6->C6_QTDVEN
					PesoTotal 	+= SC6->C6_QTDVEN*SB1->B1_PESBRU
					PesoTotLiq  += SC6->C6_QTDVEN*SB1->B1_PESO
			
					dbSelectArea("SB5")
					dbSetOrder(01)
					dbSeek(xFilial("SB5")+SC6->C6_PRODUTO)
			
					Volume 		:= SC6->C6_QTDVEN*SB5->B5_COMPRLC*SB5->B5_LARGLC*SB5->B5_ALTURLC
					VolTotal 	:= VolTotal + Volume
					SC6->(dbSkip())
				EndDo
		
				dDtEmissao:=Dtoc(SC5->C5_EMISSAO)//			dData:=Dtoc(ROMITENS->C5_EMISSAO)
				oPrn:Say(nLin,0100,OemToAnsi(dDtEmissao),oFont10)
				oPrn:Say(nLin,0300,OemToAnsi(ROMITENS->A1_COD)+" - "+ OemToAnsi(substr(ROMITENS->A1_NOME,1,40)),			   oFont10)
				oPrn:Say(nLin,1400,OemToAnsi(ROMITENS->C5_NUM),			   oFont10)
				oPrn:Say(nLin,1600,Transform(ROMITENS->VALOR,"@E 9,999,999.99"),		oFont10)
			//******** NOTA FISCAL - INCLUIR ******
				oPrn:Say(nLin,2150,OemToAnsi(ROMITENS->C5_ROMIT),			   oFont12N)
				oPrn:Say(nLin+50,0100,OemToAnsi(trim(ROMITENS->A1_END))+" - "+ OemToAnsi(trim(ROMITENS->A1_MUN))+" - "+ OemToAnsi(trim(ROMITENS->A1_EST)), oFont10)
				
		//		IF ROMITENS->A1_CODSEG ='000006' .OR. ROMITENS->A1_CODSEG ='000007'
		//			cObsFardo:= "FARDO CODIGO DE BARRAS / "
		//		ENDIF

				if len(Trim(ROMITENS->C5_OBS))>0 
					oPrn:Say(nLin+100,0100,"OBS: "+OemToAnsi(cObsFardo+Alltrim(ROMITENS->C5_OBS)), oFont10N)
					oPrn:Line(nLin+140,00100,nLin+140,2300)
					nLin+=155
				Else
					oPrn:Line(nLin+100,00100,nLin+100,2300)
					nLin+=125
				EndIf
				//oPrn:Box(nLin+30,00100,nLin+110,2300)
				ValorTot	+= ROMITENS->VALOR
			
				dbSelectArea("ROMITENS")
				dbSkip()
				//nLin+=120
				nitens += 1
						
			//VERIFICA SE ESTÁ NO FINAL DA PÁGINA E JOGA QUEBRA DE PÁGINA
				IF  nitens > 20
			//if !lCabeçalho 	
					oPrn:Say(0300,0700,"VOLUME: Prox. Pagina",oFont11N)
				//oPrn:Say(0300,0850, Transform(VolTotal,"@E 9,999,999.99"),oFont10N)
					oPrn:Say(0300,1200,"PESO BRUTO: Prox.pag.",oFont11N)
				//oPrn:Say(0300,1450, Transform(PesoTotal,"@E 9,999,999.99"),	oFont10N)	
					oPrn:Say(0300,1750,"PESO LIQUIDO: Prox.Pag",oFont11N)
				//oPrn:Say(0300,2000, Transform(PesoTotLiq,"@E 9,999,999.99"),	oFont10N)
			//	lCabeçalho := .t.
			//EndIf	
					nitens := 1
					nLin := 530 //nLin := 120
					oPrn:EndPage()
	 			                    
	//CABEÇALHO P/ 2ª PAGINA 
					oPrn:Say(0050,0500, "GERAL DA CARGA POR PEDIDO - ROMANEIO  Nº",oFont14N)
					oPrn:Say(0050,1800,OemToAnsi(ROMITENS->C5_ROMANEI),	oFont14N)
		// DATA HORA IMPRESSÃO
					dataHora:=Time()
					oPrn:Say(0070,2200,dataHora,oFont12)
					dDataEmiss:=Dtoc(ddatabase)
					oPrn:Say(0120,2200,OemToAnsi(DdataEmiss),oFont12)
		//DADOS ROMANEIO
					oPrn:Say(0320,0100,"CARGA:_________________",oFont11N)
		//**INCLUIR NUMERO DA CARGA
					oPrn:Say(0230,0100,"VEICULO: ",oFont12N)
					oPrn:Say(0230,0350, cVeiculo,				oFont11)
					oPrn:Say(0230,0850,"MOTORISTA: ",				oFont11N)
					oPrn:Say(0230,1150, cMotorista,				oFont11)
					oPrn:Say(0230,1700,"AJUDANTE: ________________",oFont11N)
		//CABEÇALHO ITENS DO ROMANEIO
					oPrn:Box(0400,0050,0500,2300) //Caixa de cabeçalho
					oPrn:Say(0430,0100,"Dt. Venda"  	            	,oFont11)
					oPrn:Say(0430,0300,"Cliente"	            	,oFont11)
					oPrn:Say(0430,1400,"Pedido"	  	            ,oFont11) //	oPrn:Say(0330,1100,"Quantidade"	  	            ,oFont12N)
					oPrn:Say(0430,1600,"Val.Total"		  	        ,oFont11)
					oPrn:Say(0430,1800,"Nota Fiscal"	   	         	,oFont11)
					oPrn:Say(0430,2050,"Item Rom."	   	            	,oFont11)
		  	
				EndIf
			EndDo
		
		//if !lCabeçalho 	
			oPrn:Say(0320,0700,"VOLUME:",oFont11N)
			oPrn:Say(0320,0850, Transform(VolTotal,"@E 9,999,999.99"),oFont10N)
			oPrn:Say(0320,1100,"PESO BRUTO:",oFont11N)
			oPrn:Say(0320,1420, Transform(PesoTotal,"@E 9,999,999.99"),	oFont10N)
			oPrn:Say(0320,1700,"PESO LIQUIDO:",oFont11N)
			oPrn:Say(0320,2050, Transform(PesoTotLiq,"@E 9,999,999.99"),	oFont10N)
		//	lCabeçalho := .t.
		//EndIf
				
			dbSelectArea("ROMITENS")
			dbCloseArea()
		
		//Caso for a primeira via,programa não muda para proximo registro para imprimir o relatório do 1º item
			nVia := nVia + 1
		//Manter Total abaixo do cabeçalho
			//IF nLin < 320
				//oPrn:Say(0360,0100,"TOTAL:"	  	            			,oFont11N)
				//oPrn:Say(0360,1600,Transform(ValorTot,"@E 9,999,999.99")	,oFont11N)
			//else
				oPrn:Say(nLin+50,0100,"TOTAL:"	  	            			,oFont11N)
				oPrn:Say(nLin+50,1600,Transform(ValorTot,"@E 9,999,999.99")	,oFont11N)
			//EndIf
		
			
			dbSelectArea("SZ1")
		
		Else
			if nVia == 2
				oPrn:Say(0050,0700, "GERAL DA CARGA - ROMANEIO  Nº ",oFont14N)
				oPrn:Say(0050,1600,OemToAnsi(ROMITENS->C5_ROMANEI),	oFont14N)
			
			else
				oPrn:Say(0050,0500, "CONTROLE DE CARGA - ROMANEIO  Nº ",oFont14N)
				oPrn:Say(0050,1550,OemToAnsi(ROMITENS->C5_ROMANEI)+" - ITEM "+OemToAnsi(ROMITENS->C5_ROMIT),	oFont14N)
			
			EndIf
		// DATA HORA IMPRESSÃO
			dataHora:=Time()
			oPrn:Say(0070,2100,dataHora,oFont12)
			dDataEmiss:=Dtoc(ddatabase)
			oPrn:Say(0120,2100,OemToAnsi(DdataEmiss),oFont12)
		
		//DADOS ROMANEIO
		
		//Data e hora impressão
			oPrn:Say(0230,0100,"DESTINO:",oFont12N)
			oPrn:Say(0230,0350,OemToAnsi(cDestino),		   oFont11)
			oPrn:Say(0230,1400,"DATA SAÍDA:",oFont12N)
			oPrn:Say(0230,1700,OemToAnsi(Ddata),oFont12)
		//		oPrn:Say(0220,0100,"EMITENTE:",oFont12N)
		//		oPrn:Say(0220,0300,SubStr(cNamUser,1,13)            ,oFont12N)	//NOME DO EMITENTE
			oPrn:Say(0320,0100,"VEICULO: ",oFont12N)
		//oPrn:Say(0320,0800,"MOTORISTA:__________________________",				oFont12N)  
		//		oPrn:Say(0210,0750, cMotorista,				oFont14N) 
		//oPrn:Say(0320,1700,"CARGA: ________________",oFont12N)
		
		//CABEÇALHO ITENS DO ROMANEIO
		
			oPrn:Box(0400,0050,0500,2400) //Caixa de cabeçalho
//		oPrn:Say(0330,0100,"Item"  	  		          	,oFont12N)
			oPrn:Say(0430,0200,"Codigo"  	            	,oFont12)
			oPrn:Say(0430,0400,"Descricao"	            	,oFont12)
			oPrn:Say(0430,1400,"Quantidade"	  	            ,oFont12) //	oPrn:Say(0330,1100,"Quantidade"	  	            ,oFont12N)
			oPrn:Say(0430,1650,"Unid."		  	            ,oFont12)
			oPrn:Say(0430,1800,"Volume"	   	            	,oFont12)
			QtdeTotal := 0
			VolTotal :=	0
		//ITENS DO ROMANEIO
			nitens :=1		
			While !Eof()
			
				oPrn:Say(nLin,0200,OemToAnsi(ROMITENS->C6_PRODUTO),		   oFont10)
			
				dbSelectArea("SB1")
				dbSetOrder(01)
				dbSeek(xFilial("SB1")+ROMITENS->C6_PRODUTO)
			
				oPrn:Say(nLin,0400,OemToAnsi(SB1->B1_DESC),			   oFont10)
				oPrn:Say(nLin,1400,Transform(ROMITENS->SOMA_QTD,"@E 9,999,999.99"),		oFont10)
				oPrn:Say(nLin,1650,OemToAnsi(SB1->B1_UM),			   oFont10)
				QtdeTotal	+= ROMITENS->SOMA_QTD
			
				dbSelectArea("SB5")
				dbSetOrder(01)
				dbSeek(xFilial("SB5")+ROMITENS->C6_PRODUTO)
			
				Volume 		:= ROMITENS->SOMA_QTD*SB5->B5_COMPRLC*SB5->B5_LARGLC*SB5->B5_ALTURLC
				VolTotal 	:= VolTotal + Volume
			//oPrn:Say(nLin,1800,Transform(Volume,"@E 9,999,999.99"),		oFont11)
				oPrn:Say(nLin,1800,Transform(Volume,"@E 9,999,999.99"),	oFont10)
				oPrn:Line(nLin+35,00100,nLin+35,2300)
			
				dbSelectArea("ROMITENS")
				dbSkip()
				nLin+=50
				nitens+=1
			
			//Segunda pagina - Alterado em 13/08/2018
			IF  nitens > 63
					nitens := 1
					nLin := 120
					oPrn:EndPage()
			EndIf		
					
			EndDo
			dbSelectArea("ROMITENS")
			dbCloseArea()
		
			If nVia == 2  //Busca pedidos do romaneio para apresentar em cada via.
				cQuery := "SELECT C5_ROMANEI,C5_NUM, C5_OBS FROM " +  RetSqlName("SC5")
				cQuery += "  WHERE D_E_L_E_T_ <> '*' AND C5_ROMANEI ='" + SZ1->Z1_NUM + "'"
				cQuery +=" GROUP BY C5_ROMANEI,C5_NUM, C5_OBS "
			//	cQuery += " ORDER BY C5_ROMANEI"
			Else
				cQuery := "SELECT C5_ROMANEI,C5_NUM, C5_OBS FROM " +  RetSqlName("SC5")
				cQuery += "  WHERE D_E_L_E_T_ <> '*' AND C5_ROMANEI ='" + SZ1->Z1_NUM + "' AND C5_ROMIT = '" + SZ1->Z1_ITEM + "'"
				cQuery +=" GROUP BY C5_ROMANEI,C5_NUM, C5_OBS "
			//	cQuery += " ORDER BY C5_ROMANEI"
			EndIf
		
			TCQuery cQuery Alias PEDIDOS New
			dbGoTop()
			npedidos := 1
			cPed1		:= ""
			cPed2		:= ""
			cPed3		:= ""
	
			While !Eof()
				if npedidos <= 12   //verifica se quant. de pedidos ultrapassa tamanho da linha.
					cPed1 := cPed1 + PEDIDOS->C5_NUM + ", "
				else
					if npedidos <= 28
						cPed2 := cPed2 + PEDIDOS->C5_NUM + ", "
					else
						cPed3 := cPed3 + PEDIDOS->C5_NUM + ", "
					EndIf
				EndIf
				dbskip()
				npedidos += 1
			
			EndDo
		
			oPrn:Say(nLin+50,0100,"TOTAL:"		  	            			,oFont11N)
			oPrn:Say(nLin+50,1400,Transform(QtdeTotal,"@E 9,999,999.99")	,oFont11N)
			oPrn:Say(nLin+50,1800,Transform(VolTotal,"@E 9,999,999.99")	,oFont11N)

			oPrn:Say(nLin+200,0100,"Romaneio referente aos pedidos "+ cPed1,	oFont10)
			oPrn:Say(nLin+250,0100, cPed2,	oFont10)
			oPrn:Say(nLin+300,0100, cPed3,	oFont10)
				
			dbGoTop()
			nLinObs := 0
			While !Eof() .and. nVia > 2
				if LEN(Trim(PEDIDOS->C5_OBS))>0 
					if nLinObs == 0 
						oPrn:Say(nLin+400,0100,"OBSERVAÇÕES DOS PEDIDOS ",	oFont10N)
					EndIf
					oPrn:Say(nLin+nLinObs+450,0100, PEDIDOS->C5_NUM + ": " +Trim(PEDIDOS->C5_OBS),	oFont10)
					nLinObs += 50
				EndIf
				dbskip()
			EndDo
			dbCloseArea()
			
			//Caso for a primeira via,programa não muda para proximo registro para imprimir o relatório do 1º item
			dbSelectArea("SZ1")
			if nVia > 2
					dbSkip()
			EndIf
					
			nVia := nVia + 1
		EndIf
	
		if nRomaneio <> SZ1->Z1_NUM
			nRomaneio 	:= SZ1->Z1_NUM
			nVia		:= 1
		EndIf
		
		nLin    :=0530  //linha inicial dos itens do romaneio
		oPrn:EndPage()
	
	EndDo

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³  J.Marcelino Correa  ³    03.06.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

	Local aArea := GetArea()
	PutSx1(cPerg,"01","No Romaneio de               ?"," "," ","mv_ch1","C",6,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe numero inicial do romaneio"},{"Informe o numero do romaneio de"},{"Informe o Numero do Romaneio"})
	PutSx1(cPerg,"02","No Romaneio Ate              ?"," "," ","mv_ch2","C",6,0,0,	"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o numero final do romaneio"},{"Informe o Numero do Romaneio ate"},{"Informe o Numero do Romaneio ate"})

	RestArea(aArea)

Return


//Processo para salvar relatório como imagem

aCaminho           := {"\\192.168.2.1\teste.jpg"}
filepath          := "\192.168.1.2"
nwidthpage      := 630
nheightpage     := 870

aFiles := Directory(aCaminho[1])
For i:=1 to Len(aFiles)
	fErase("\\192.168.2.1\"+aFiles[1])
Next i

oPrint:SaveAllAsJpeg(filepath,nwidthpage,nheightpage,100)   //Gera arquivos JPEG na Pasta \Protheus_data\Images\

aFiles := {}
aFiles := Directory(aCaminho[1])

//Visualizacao e finalizacao do relatorio

oPrint:Setup()
oPrint:Preview()
oPrint:EndPage()
MS_FLUSH()

If MV_PAR03 = 1               //Envia E-mail
	EMAIL()
EndIf

Return


