#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFGMI004  � Autor � Paulo Bindo        � Data �  15/01/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Importa os arquivos XML para a rotina de geracao NFE       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CFGMI004()
Local aFiles := {}
Local nX	 := 0                
Private aContas		:= {}
Private cIniFile	:= GetADV97()                                      
Private cStartPath 	:= GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile )+'NFE\ENTRADA\'
Private cStartLido	:= Trim(cStartPath)+"LANCADOS\"
Private c2StartPath	:= Trim(cStartLido)+AllTrim(Str(Year(Date())))+"\" 
Private c3StartPath	:= Trim(c2StartPath)+AllTrim(Str(Month(Date())))+"\"	//MES
Private cStartError	:= Trim(cStartPath)+"ERRO\"
Private c4StartPath	:= Trim(c3StartPath)+"LANCANT\"
Private c5StartPath	:= Trim(cStartPath)+"EVENTOS\"


conOut("ImportaXML: iniciando - "+ time())
RpcSetType(3)
RpcSetEnv("01","01")

//CRIA DIRETORIOS            

MakeDir(GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile )+'NFE\')
MakeDir(Trim(cStartPath)) //CRIA DIRETOTIO ENTRADA
MakeDir(cStartLido) //CRIA DIRETORIO ARQUIVOS IMPORTADOS
MakeDir(c2StartPath) //CRIA DIRETOTIO ANO
MakeDir(c3StartPath) //CRIA DIRETOTIO MES
MakeDir(c4StartPath) //CRIA DIRETOTIO NOTAS LAN�ADAS ANTERIORMENTE
MakeDir(cStartError) //CRIA DIRETORIO ERRO
  conOut("ImportaXML: criado pastas")


//aFiles := Directory(GetSrvProfString("RootPath","") +"\" +cStartPath2 +"*.xml")
aFiles := Directory(GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile )+"NFE\entrada\*.xml")
//aFiles := Directory(GetSrvProfString("RootPath","") +"\NFE\*.xml")

CONOUT(GetSrvProfString("RootPath","") +"\NFE\*.xml")

nXml := 0
cErroGeral :=""

For nX := 1 To Len(aFiles)
	nXml++
	conout(aFiles[nX,1])
	U_ReadXML(aFiles[nX,1],.T.)
    conOut("ImportaXML: lidos "+ str(nXml) +" xml")
    cErroGeral +=  "ImportaXML: lidos "+ str(nXml) +" xml"
	//QUANDO TIVER 500 XML SAI DA ROTINA, SENAO ESTOURA O ARRAY DO XML
	If nXml == 500
		Return
	EndIf
	
Next nX
	U_EnvMail('fiscal@produtosplinc.com.br','Geral Erros ImportaXML - '+ time() ,cErroGeral)

RpcClearEnv()

conOut("ImportaXML: Finalizado - "+ time())
Return
