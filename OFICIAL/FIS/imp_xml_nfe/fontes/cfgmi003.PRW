#INCLUDE "rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "XMLXFUN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFGMI003  � Autor � Paulo Bindo        � Data �  15/01/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Baixa Mensagens De NFE                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	
	//������������������������������������������������������Ŀ
	//�Conta quantas mensagens existem                       �
	//��������������������������������������������������������

	CONNECT POP SERVER cServer ;
	ACCOUNT cConta ;
	PASSWORD cSenhaa ;
	TIMEOUT 30 ;
	RESULT lRet
	
  	POP MESSAGE COUNT nMessages
	
if ! lRet
		conout(" ")
		conout(Replicate("=",80))
		conout(OemtoAnsi("Nao foi possivel conectar.") ) //###
		conout(Replicate("=",80))
else
	If nMessages > 0 .And. lRet
		
		conout(" ")
		conout(Replicate("=",80))
		conout(OemtoAnsi("A conta NFE contem "+StrZero(nMessages,8)+" mensagem(s)") ) //###
		conout(Replicate("=",80))
		
		//������������������������������������������������������Ŀ
		//�Recebe as mensagens e grava os arquivos XML           �
		//��������������������������������������������������������
		nXml := 0
		For nX := 1 to nMessages
			aFileAtch := {}
			
			MailReceive(nX,,,,,,,aFileAtch,cStartPath,.T.)
			
			For nY := 1 to Len(aFileAtch)
				If ".XML" $ Upper(aFileAtch[nY][1])
					nXml++
					ConOut(" ")
					ConOut(Replicate("=",80))
					ConOut("Recebido o arquivo " + aFileAtch[nY][1]) //
					ConOut(Replicate("=",80))
					
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
		Conout(Replicate("=",80))
		ConOut( Time()+" - Nao existem arquivos a serem recebidos" )
		Conout(Replicate("=",80))
	Endif
EndIf
	
	DISCONNECT POP SERVER
Next

If lWeb
	RpcClearEnv()
EndIf
Return