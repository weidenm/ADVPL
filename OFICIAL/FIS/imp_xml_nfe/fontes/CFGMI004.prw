#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFGMI004  บ Autor ณ Paulo Bindo        บ Data ณ  15/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Importa os arquivos XML para a rotina de geracao NFE       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ 12.1.25  ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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


//conOut("ImportaXML: iniciando - "+ time())
FwLogMsg("INFO", /*cTransactionId*/, "ImportaXML", FunName(), "", "01", "ImportaXML: iniciando - "+ time(), 0, (nStart - Seconds()), {}) // nStart ้ declarada no inicio da fun็ใo
RpcSetType(3)
RpcSetEnv("01","01")

//CRIA DIRETORIOS            

MakeDir(GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile )+'NFE\')
MakeDir(Trim(cStartPath)) //CRIA DIRETOTIO ENTRADA
MakeDir(cStartLido) //CRIA DIRETORIO ARQUIVOS IMPORTADOS
MakeDir(c2StartPath) //CRIA DIRETOTIO ANO
MakeDir(c3StartPath) //CRIA DIRETOTIO MES
MakeDir(c4StartPath) //CRIA DIRETOTIO NOTAS LANวADAS ANTERIORMENTE
MakeDir(cStartError) //CRIA DIRETORIO ERRO
  //conOut("ImportaXML: criado pastas")
  FwLogMsg("INFO", /*cTransactionId*/, "ImportaXML", FunName(), "", "01", "ImportaXML: criado pastas", 0, (nStart - Seconds()), {}) // nStart ้ declarada no inicio da fun็ใo

//aFiles := Directory(GetSrvProfString("RootPath","") +"\" +cStartPath2 +"*.xml")
aFiles := Directory(GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile )+"NFE\entrada\*.xml")
//aFiles := Directory(GetSrvProfString("RootPath","") +"\NFE\*.xml")

//CONOUT(GetSrvProfString("RootPath","") +"\NFE\*.xml")



nXml := 0
cErroGeral :=""

For nX := 1 To Len(aFiles)
	nXml++
	//conout(aFiles[nX,1])
	U_ReadXML(aFiles[nX,1],.T.)
	//conOut("ImportaXML: lidos "+ str(nXml) +" xml")
	FwLogMsg("INFO", /*cTransactionId*/, "ImportaXML", FunName(), "", "01", "ImportaXML: lidos "+ str(nXml) +" xml", 0, (nStart - Seconds()), {}) // nStart ้ declarada no inicio da fun็ใo
    cErroGeral +=  "ImportaXML: lidos "+ str(nXml) +" xml"
	//QUANDO TIVER 500 XML SAI DA ROTINA, SENAO ESTOURA O ARRAY DO XML
	If nXml == 500
		Return
	EndIf
	
Next nX
	U_EnvMail('fiscal@produtosplinc.com.br','Geral Erros ImportaXML - '+ time() ,cErroGeral)

RpcClearEnv()

//conOut("ImportaXML: Finalizado - "+ time())
FwLogMsg("INFO", /*cTransactionId*/, "ImportaXML", FunName(), "", "01", "ImportaXML: Finalizado - "+ time(), 0, (nStart - Seconds()), {}) // nStart ้ declarada no inicio da fun็ใo

Return
