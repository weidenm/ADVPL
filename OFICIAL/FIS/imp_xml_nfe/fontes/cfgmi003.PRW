#INCLUDE "rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "XMLXFUN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFGMI003  º Autor ³ Paulo Bindo        º Data ³  15/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Baixa Mensagens De NFE                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º12.1.25   ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CFGMI003()
Local lWeb := .F.
Local aFileAtch := {}
Local cServer
Local lOk := .T.
Local lRelauth
Local lRet	   := .F.
Local cFrom
Local cConta
Local cSenhaa
Local cIniFile 		:= GetADV97()
Local cStartPath 	:= GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile )+'NFE\ENTRADA\'
Local nMessages		:= 0
Local aContas		:={{'fiscal@produtosplinc.com.br'}}
Local zX
Local nX
Local nY

//Local aContas		:={{'nfentrada.plinc@gmail.com'}}
//Local aContas		:={{'compras@produtosplinc.com.br'},{'informatica@produtosplinc.com.br'}  //,;
//{'suaconta@seudominio'},{'suaconta@seudominio'},{'suaconta@seudominio'}}
  
    /*
	  local oServer := Nil 
      local oMessage := Nil 
      local nErr     := 0 
      local cPopAddr := "pop.gmail.com"      // Endereco do servidor POP3 
      local cSMTPAddr := "smtp.googlemail.com"     // Endereco do servidor SMTP 
      local cPOPPort := 995                  // Porta do servidor POP 
      local cSMTPPort := 465                   // Porta do servidor SMTP 
      local cUser     := "nfentrada.plinc@gmail.com"     // Usuario que ira realizar a autenticacao 
      local cPass     := "plinc381"             // Senha do usuario 
      local nSMTPTime := 60                     // Timeout SMTP 
      */

//VERIFICA SE ESTA RODANDO VIA MENU OU SCHEDULE
If Select("SX6") == 0
	lWeb := .T.
	RpcSetType(3)
	RpcSetEnv("01","01")
EndIf

//cServer	 := 'smtp.produtosplinc.com.br'
//cServer	 := 'pop.produtosplinc.com.br'
//cServer	 := 'smtp.gmail.com:465'
cServer	 := 'email-ssl.com.br:587'
lRelauth := GetNewPar("MV_RELAUTH",.F.)		// Parametro que indica se existe autenticacao no e-mail
cSenhaa  := 'br381fiscoplinc'   //GetMV("MV_RELPSW")
//cSenhaa  := 'plinc381'   //GetMV("MV_RELPSW")



//CRIA DIRETORIOS
MakeDir(GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile )+'NFE\')
MakeDir(Trim(cStartPath)) //CRIA DIRETOTIO ENTRADA


For zX:=1 To Len(aContas)
	cFrom	 := aContas[zX][1]
	cConta   := aContas[zX][1] //SubStr(aContas[zX][1],1,At('@',aContas[zX][1])-1)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Conta quantas mensagens existem                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	CONNECT POP SERVER cServer ;
	ACCOUNT cConta ;
	PASSWORD cSenhaa ;
	TIMEOUT 30 ;
	RESULT lRet
	
  	POP MESSAGE COUNT nMessages
	
if ! lRet
		
		FwLogMsg("INFO", /*cTransactionId*/, "CFGMI003", FunName(), "", "01", "Nao foi possivel conectar.", 0, (nStart - Seconds()), {}) // nStart é declarada no inicio da função
else
	If nMessages > 0 .And. lRet
		
		FwLogMsg("INFO", /*cTransactionId*/, "CFGMI003", FunName(), "", "01", "A conta NFE contem "+StrZero(nMessages,8)+" mensagem(s)", 0, (nStart - Seconds()), {}) // nStart é declarada no inicio da função

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Recebe as mensagens e grava os arquivos XML           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nXml := 0
		For nX := 1 to nMessages
			aFileAtch := {}
			
			MailReceive(nX,,,,,,,aFileAtch,cStartPath,.T.)
			
			For nY := 1 to Len(aFileAtch)
				If ".XML" $ Upper(aFileAtch[nY][1])
					nXml++

					FwLogMsg("INFO", /*cTransactionId*/, "CFGMI003", FunName(), "", "01","Recebido o arquivo " + aFileAtch[nY][1], 0, (nStart - Seconds()), {}) // nStart é declarada no inicio da função
					
					cStrAtch := Memoread(aFileAtch[nY][1])
					
					CREATE oXML XMLSTRING cStrAtch
					//QUANDO TIVER 500 XML SAI DA ROTINA, SENAO ESTOURA O ARRAY DO XML
					If nXml == 500
						Return
					EndIf
					
					
				Else
					Ferase(aFileAtch[nY][1])
				Endif
				
			Next nY
			
		Next nX
		
	Else
		FwLogMsg("INFO", /*cTransactionId*/, "CFGMI003", FunName(), "", "01", Time()+" - Nao existem arquivos a serem recebidos" , 0, (nStart - Seconds()), {}) // nStart é declarada no inicio da função
	Endif
EndIf
	
	DISCONNECT POP SERVER
Next

If lWeb
	RpcClearEnv()
EndIf
Return
