
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"     
#include "TOTVS.CH"  

/*
+---------------------------------------------------------------------------+
| Programa  : MNTR14     |    Autor  : Alex Schneider   | Data : 26/04/13   |
+---------------------------------------------------------------------------+
| Objetivo  : Exemplificar a impress�o de relatorios em arquivo (.csv, .txt.)
+---------------------------------------------------------------------------+
| Descri��o : Imprime todos os c�digos e nomes dos bens em tela e em arquivo .csv
+---------------------------------------------------------------------------+
|   Autor   |   Data     |             Descri��o da Altera��o               | 
+---------------------------------------------------------------------------+
|
+---------------------------------------------------------------------------+
*/ 

User Function NOMEDOFONTE() 
     
 cPerg           := Padr("NOMEDOFONTE",len(SX1->X1_GRUPO)," ")  
 cDesc1          := "TITULO."
 cDesc2          := "DESCRI��O DO RELATORIO "
 cDesc3          := "DESCRI��O DO RELATORIO "
 cPict           := ""
 tamanho         := "G"
 nomeprog        := "NOMEDOFONTE" //  impressao no cabecalho
 aReturn         := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
 titulo          := "TITULO DO RELATORIO"
 nLin            := 80
 Cabec2          := ""
 Cabec1          := ""
 wnrel           := "NOMEDOFONTE" //nome para impressao em disco
 cString         := "ST9"
 nTipo           := 15       // usado na fun��o bNewPage
 m_pag           := 01       // Inicio pagina 
 cQuery          := ""
 cPath           := ""  
 cMontaTxt       := ""
 cQueryP     := "" 
 cOrdem      := ""
 cPerg       := "NOMEDOFONTE" 

 // Neste relatorio ser�o impressos todos os bens, 
 //por isso este pergunte � somente um exemplo ilustrativo, 
 //ou seja, n�o esta sendo utilizado realmente
 ValidPerg()
 Pergunte(cPerg,.F.) 

 wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

 If nLastKey == 27
  Return
 Endif

 SetDefault(aReturn,cString)

 If nLastKey == 27
 Return
 Endif

 //Inicializa os codigos de caracter da impressora
 nTipo := IIF(aReturn[4]==1,15,18) 

 // RPTSTATUS monta janela com a regua de processamento.
 RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo) 

Return 


//////////////////////////////////////////////////////////////////////////
// RunReport: Monta o relatorio
//////////////////////////////////////////////////////////////////////////
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,cPath) 


 // Bloco de c�digo executado para inserir nova p�gina
 bNewPage := {|| Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo), nLin:=9}
 
  //01234567890123456789012345678901234567890
         //0         1         2         3         4    
  // 999999       xxxxxxxxxxxxxxxxxxxxxxxxxxxx 
 Cabec1 := " C�digo bem   Nome                      "    
 cMontaTxt += "C�digo bem;Nome" + CRLF                  
 // Exemplo de query para consulta ao banco
 cQueryP :=   "SELECT  T9_CODBEM,T9_NOME FROM "+RetSqlName("ST9")+" "+; 
       "WHERE "+RetSqlName("ST9")+".D_E_L_E_T_ <> '*' "

 TCQUERY cQueryP NEW ALIAS "TRBCPK"  
 // Salto de P�gina
 IIF(nLin > 70, EVAL(bNewPage),)
 nLin++

 // Sele��o da tabela temporaria criada pela consulta 
 DbSelectArea("TRBCPK")
 DbGotop()

 While !Eof()

 // Salto de P�gina
 IIF(nLin > 70, EVAL(bNewPage),)  
 
 // imprime na visualiza�ao do relatorio
 @nlin, 001 PSAY TRBCPK->T9_CODBEM  
 @nlin, 014 PSAY TRBCPK->T9_NOME 
 
 nLin++ // soma mais uma linha

 // guarda informa��o em string para gravar o arquivo .csv
 cMontaTxt += TRBCPK->T9_CODBEM + ";"
 cMontaTxt += TRBCPK->T9_NOME + ";"
 
 cMontaTxt += CRLF // Salto de linha para .csv (excel)  
 dbSkip()   // pr�xima linha

 Enddo

 dbCloseArea("TRBCPK") // finaliza sele��o da area

 // Chama a fun��o que gera o arquivo csv com os dados.
 criaCSV()


 // Finaliza a execucao do relatorio...
 SET DEVICE TO SCREEN
  
 // Se impressao em disco, chama o gerenciador de impressao...
 If aReturn[5]==1
 dbCommitAll()
 SET PRINTER TO
 OurSpool(wnrel) // gerenciador de impress�o do Siga
 Endif
 
 //Descarrega spool de impress�o.
 //Ap�s os comandos de impress�o as informa��es ficam armazenadas no 
 //spool e s�o descarregadas em seus destinos atrav�s da fun��o  Ms_Flush()


return



////////////////////////////////////////////////////////////////////////
// Exportando dados para planilha 
////////////////////////////////////////////////////////////////////////
Static Function criaCSV()

 // Nome do arquivo criado, o nome � composto por uma descri��o 
 //a data e a hora da cria��o, para que n�o existam nomes iguais
 cNomeArq := "C:\Relatorio_"+SubStr(DtoS(date()),7,2)+"_"+SubStr(DtoS(date()),5,2)+"_"+SubStr(DtoS(date()),1,4)+"_"+Transform(Time(),"@E 99999999")+".csv"

 // criar arquivo texto vazio a partir do root path no servidor
 nHandle := FCREATE(cNomeArq)

 FWrite(nHandle,cMontaTxt)

 // encerra grava��o no arquivo
 FClose(nHandle)

 MsgAlert("Relatorio salvo em: "+"C:\Relatorio_"+SubStr(DtoS(date()),7,2)+"_"+SubStr(DtoS(date()),5,2)+"_"+SubStr(DtoS(date()),1,4)+"_"+Transform(Time(),"@E 99999999")+".csv")

return



///////////////////////////////////////////////////////////////////////
// ValidPerg: Parametros para gera��o do relatorio � apenas um exemplo 
//////////////////////////////////////////////////////////////////////
Static Function ValidPerg

 Local aHelp1  := {"Informe o bem a ser pesqusado     ","  "," "}

 PutSx1( cPerg, "01","De bem?            ","","","mv_ch1" 

,"C",6,0,0,"G","","ST9","","","mv_par01","","","","","","","","","","","","","","","","",aHelp1,aHelp1,aHelp1)
 PutSx1( cPerg, "02","At� bem?           ","","","mv_ch1" 

,"C",6,0,0,"G","","ST9","","","mv_par02","","","","","","","","","","","","","","","","",aHelp1,aHelp1,aHelp1)

Return


