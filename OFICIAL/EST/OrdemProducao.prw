#INCLUDE "RWMAKE.CH"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³RCOMR01   ³ Autor ³ Adriano Teixeira      ³ Data ³11.09.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao da Ordem de Produção - TmsPrinter                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Especifico PELKOTE                                          ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RELOP()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL oDlg := NIL
LOCAL cString	:= "SC2"
PRIVATE titulo 	:= ""
PRIVATE nLastKey:= 0
PRIVATE cPerg	:= "RELOP" //"FATR05" Criar perguntas para RELOP.
PRIVATE nomeProg:= FunName()
Private nTotal	:= 0
Private nSubTot	:= 0

AjustaSx1()
If ! Pergunte(cPerg,.T.)
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros					  		³
//³ mv_par01				// Numero da PT                   		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := FunName()            //Nome Default do relatorio em Disco

PRIVATE cTitulo := "Impressão de Ordem de Produção"
PRIVATE oPrn    := NIL
PRIVATE oFont1  := NIL
PRIVATE oFont2  := NIL
PRIVATE oFont3  := NIL
PRIVATE oFont4  := NIL
PRIVATE oFont5  := NIL
PRIVATE oFont6  := NIL
//Private cPerg := "FATR05"
Private nLastKey := 0
///Private nLin := 1650 // Linha de inicio da impressao das clausulas contratuais

DEFINE FONT oFont1 NAME "Times New Roman" SIZE 0,20 BOLD  OF oPrn
DEFINE FONT oFont2 NAME "Times New Roman" SIZE 0,14 BOLD OF oPrn
DEFINE FONT oFont3 NAME "Times New Roman" SIZE 0,14 OF oPrn
DEFINE FONT oFont4 NAME "Times New Roman" SIZE 0,14 ITALIC OF oPrn
DEFINE FONT oFont5 NAME "Times New Roman" SIZE 0,14 OF oPrn
DEFINE FONT oFont6 NAME "Courier New" BOLD

oFont08	 := TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
oFont08N := TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
oFont10	 := TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont11  := TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
oFont14	 := TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
oFont16	 := TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
oFont10N := TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont12  := TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont12N := TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont16N := TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
oFont14N := TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
oFont06	 := TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
oFont06N := TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)


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
@ 045,017 SAY "Ordem de Produção" 						OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE

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
¦¦¦Funçào    ¦ IMPRIMIR  ¦ Autor ¦ J.Marcelino Correa   ¦ Data ¦03.06.2005¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao Ordem de Produção   					          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Pelkote                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
STATIC FUNCTION Imprimir()

DesenhaOP()
Ms_Flush()
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ ORCAMENTO ¦ Autor ¦ J.Marcelino Correa   ¦ Data ¦03.06.2005¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao 										          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Pelkote                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
STATIC FUNCTION DesenhaOP()

Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
Local cNamUser := UsrRetName( cCodUser )//Retorna o nome do usuario 


cDia := SubStr(DtoS(dDataBase),7,2)
cMes := SubStr(DtoS(dDataBase),5,2)
cAno := SubStr(DtoS(dDataBase),1,4)
cMesExt := MesExtenso(Month(dDataBase))
cDataImpressao := cDia+" de "+cMesExt+" de "+cAno
QtdeTotal := 0

oPrn:StartPage()
cBitMap := "\\192.168.2.1\Protheus10\LogoPlincPeq.jpg" //" P:\Logo1.Bmp"
oPrn:SayBitmap(0050,0050,cBitMap,0300,0150)			//LinIni, ColIni,Imagem,ColFim,LinFim Imprime logo da Empresa: comprimento X altura

nLin    :=0430  //linha do item da OP


dbSelectArea("SC2")
dbSetOrder(01)
dbSeek(xFilial("SC2")+mv_par01)  
//*VERIFICAR  

While !Eof() .And. C2_NUM == mv_par01  //MV_PAR01: Numero OP
	
	dbSelectArea("SA1")
	dbSetOrder(01)
	dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
	
	


//TÍTULOS

	oPrn:Say(0050,0900, "ORDEM DE PRODUÇÃO Nº",oFont14N)     	
	oPrn:Say(0050,1600,OemToAnsi(SC2->C2_NUM),	oFont14N)

// DATA HORA IMPRESSÃO
/*	oPrn:Say(0040,1890,OemToAnsi(mv_par01),oFont14)
	dataHora:=Time()                            
    oPrn:Say(0030,2800,dataHora,oFont14N)
   	oPrn:Say(0030,2500,OemToAnsi(Ddatabase),oFont14) REVISAR
*/  




//DADOS OP                                              
	oPrn:Say(0120,1800,"DT. INICIO :",oFont12N)//	oPrn:Say(0220,0650,"DT. INICIO:",oFont12N)
	dData:=Dtoc(SC2->C2_DATPRI)
 	oPrn:Say(0120,2000,OemToAnsi(Ddata),oFont12) // 	oPrn:Say(0220,0850,OemToAnsi(Ddata),oFont12) 
	oPrn:Say(0220,0100,"EMITENTE:",oFont12N)       
	oPrn:Say(0220,0300,SubStr(cNamUser,1,13)            ,oFont12N)	//NOME DO EMITENTE
	oPrn:Say(0220,0600,"LOTE:",				oFont12N) //	oPrn:Say(0150,0400,"LOTE:",				oFont12N)
	
		cDiaIni := SubStr(DtoS(SC2->C2_DATPRI),7,2)
		cMesIni := SubStr(DtoS(SC2->C2_DATPRI),5,2)
		cAnoIni := SubStr(DtoS(SC2->C2_DATPRI),3,2)
		Turno := SubStr(SC2->C2_TURNO,3,1)
		Lote	:= cAnoIni+cMesIni+cDiaIni+Turno     
	oPrn:Say(0210,0750,Lote,				oFont14N)//	oPrn:Say(0150,0600,Lote,				oFont12N)
	oPrn:Say(0220,1000,"TURNO:",oFont12N)  		

		dbSelectArea("SH7")
		dbSetOrder(01)
		dbSeek(xFilial("SH7")+SC2->C2_TURNO)   
		
	oPrn:Say(0220,1150,SH7->H7_DESCRI,oFont12N)  			//	oPrn:Say(0220,1200,"TURNO:",oFont12N)  
	
	oPrn:Say(0220,1400,"LETRA: ______",oFont12N)  //	oPrn:Say(0220,1500,"LETRA: _________",oFont12N)  
	oPrn:Say(0220,1700,"ENCARREGADO:____________________" 	          	,oFont12N)		
	

//CABEÇALHO ITENS OP

	oPrn:Box(0300,0050,0400,2400) //Caixa de cabeçalho
	oPrn:Say(0330,0100,"Item"  	  		          	,oFont12N)
	oPrn:Say(0330,0250,"Codigo"  	            	,oFont12N)
	oPrn:Say(0330,0400,"Descricao"	            	,oFont12N)
	oPrn:Say(0330,1300,"Quantidade"	  	            ,oFont12N) //	oPrn:Say(0330,1100,"Quantidade"	  	            ,oFont12N)
	oPrn:Say(0330,1550,"Unid."		  	            ,oFont12N)
	oPrn:Say(0330,1700,"Pedido"	   	            	,oFont12N) 
	oPrn:Say(0330,1900,"Qtde Produzida"            	,oFont12N) 
	

//ITENS ORDEM DE PRODUÇÃO
		
		oPrn:Say(nLin,0100,OemToAnsi(SC2->C2_ITEM),			   oFont08)
		oPrn:Say(nLin,0250,OemToAnsi(SC2->C2_PRODUTO),		   oFont08)
	
		dbSelectArea("SB1")
		dbSetOrder(01)
		dbSeek(xFilial("SB1")+SC2->C2_PRODUTO)

		oPrn:Say(nLin,0400,OemToAnsi(SB1->B1_DESC),			   oFont08)
		oPrn:Say(nLin,1300,Transform(SC2->C2_QUANT,"@E 9,999,999.99"),		oFont08)
		oPrn:Say(nLin,1550,OemToAnsi(SC2->C2_UM),			   oFont08)
		QtdeTotal+= SC2->C2_QUANT
		
		dbSelectArea("SC5")
		dbSetOrder(01)
		dbSeek(xFilial("SC5")+SC2->C2_PEDIDO)
	
		dbSelectArea("SA1")
		dbSetOrder(01)
		dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)

//		oPrn:Say(nLin,2200,OemToAnsi(SA1->A1_NOME),			   oFont08)
		oPrn:Say(nLin,1700,OemToAnsi(SC2->C2_PEDIDO),		   oFont08)
		oPrn:Say(nLin,1900,Transform(SC2->C2_QUJE,"@E 9,999,999.99"),		   oFont08)
			
		
		nLin+=0050
		

	
	
	dbSelectArea("SC2")
	dbSkip()
EndDo                                                                                       
                                                              
nLin+=50
oPrn:Say(nLin,0100,"Total:"		  	            			,oFont08N)                          
oPrn:Say(nLin,1300,Transform(QtdeTotal,"@E 9,999,999.99")	,oFont08N)

//PLANILHA DE APONTAMENTO

nLin+=100
oPrn:Box(nLin,0050,nLin+100,2400) //Produto                      
oPrn:Say(nLin+40,1000,"APONTAMENTO DIÁRIO DE PRODUÇÃO" 	,oFont12N)
nLin+=100
oPrn:Box(nLin,0050,nLin+150,1100) //Produto
oPrn:Say(nLin+50,0500,"Produto" 	  		          	,oFont12N)
oPrn:Box(nLin,1100,nLin+150,1400) //Quantidade           
oPrn:Say(nLin+50,1150,"Quantidade" 	  		       	,oFont12N)
oPrn:Box(nLin,1400,nLin+80,1900) //Empacotadeira
oPrn:Say(nLin+20,1500,"Empacotadeira" 	  		       	,oFont12N)
oPrn:Box(nLin,1900,nLin+80,2400) //Tempo Apont.
oPrn:Say(nLin+20,2000,"Hora" 	  		          		,oFont12N)
oPrn:Box(nLin+80,1400,nLin+150,1550) //Num. Empacotadeira
oPrn:Say(nLin+90,1450,"Nº" 	  		          		,oFont12N)
oPrn:Box(nLin+80,1550,nLin+150,1900) //Operador
oPrn:Say(nLin+90,1650,"Operador"  		          		,oFont12N)
oPrn:Box(nLin+80,1900,nLin+150,2150) //Inicio
oPrn:Say(nLin+90,2000,"Inicio" 	  		          	,oFont12N)
oPrn:Box(nLin+80,2150,nLin+150,2400) //Fim
oPrn:Say(nLin+90,2250,"Fim" 	  		          		,oFont12N)

nLin+=150
         
While nLin < 3000                       
	oPrn:Box(nLin,0050,nLin+150,1100) //Produto
	oPrn:Box(nLin,1100,nLin+150,1400) //Quantidade           
	oPrn:Box(nLin,1400,nLin+150,1550) //Num. Empacotadeira
	oPrn:Box(nLin,1550,nLin+150,1900) //Operador
	oPrn:Box(nLin,1900,nLin+150,2150) //Inicio
	oPrn:Box(nLin,2150,nLin+150,2400) //Fim    

	nLin+=75
EndDo
oPrn:Say(nLin+100,100,"OBSERVAÇÕES:" 	  		          		,oFont12N)
  
oPrn:EndPage()

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
PutSx1(cPerg,"01","No Ordem Produção               ?"," "," ","mv_ch1","C",6,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe numero da Ordem de Produção"},{"Informe o numero da Ordem de Produção de"},{"Informe o Numero da Ordem de Produção"})
//PutSx1(cPerg,"02","Pedido Vendas Ate             ?"," "," ","mv_ch2","C",6,0,0,	"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o numero do Orcamento"},{"Informe o numero do Pedido de Vendas ate"},{"Informe o Numero do Pedido de Compras ate"})

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
EndIF

Return


