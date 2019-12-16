#include "rwmake.ch" 
#include "topconn.ch" 
#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TBICONN.CH" 
/* 
FABRICIO AMARO - 06/06/2011  - vers�o: 12.1.25
ROTINA PARA REGISTRAR A APLICA��O DOS UPDATES 
RESUMO: PARA CADA UPDATE O SISTEMA IR� GRAVAR UM ARQUIVO COM O MESMO NOME DO UPDATE MAIS (+) A DATA DOFONTE DESSE UPDATE 
SE NA PROXIMA APLICACAO O SISTEMA VERIFICAR QUE A DATA � DIFERENTE, IRA APLICAR NOVAMENTE 
OBS.: SE CLICADO EM SIM PARA EXECUTAR O UPDATE, E DEPOIS CANCELAR O UPDATE (ROTINA PADRAO) FICAR� GRAVADO NESSE LOG QUE ELE J� FOI EXECUTADO, 
PORTANTO, PARA ESSE CASO, IR NA PASTA DO LOG E APAGAR O ARQUIVO PARA QUE ELE POSSA SER EXECUTADO NOVAMENTE. 
*/ 
User Function MeusUpds()
	
	Private oGera2 
	
	p11 := .T.   
	cLocUpd   := "UPDS\"    //PASTA NA SYSTEM QUE FICAR�GUARDADO O LOG DOS UPDATES - SUGEST�O: CRIE ESSA PASTA 
	cUpd   := SPACE(15)   
	
	If p11    
		cLocSystem  := "D:\TOTVS 11\Microsiga\Protheus\Protheus_Data\system_new\"  //CAMINHO COMPLETO DA PASTA SYSTEM 
		cLocSmart  := "D:\TOTVS 11\Microsiga\Protheus\bin\smartclient\"  //CAMINHO COMPLETO DA PASTA SMARTCLIENT 
		cTCP   := "TCP"    //COMUNICA��O TCP COM O SERVIDOR 
		cAmbiente  := "NOVAVERSAO"    //AMBIENTE 
		cProgCli  := "SmartClient.exe"    //NOME DO PROGRAMA DO SMARTCLIENT (PROTHEUS10 = TOTVSSMARTCLIENT.EXE | PROTHEUS 11 = SMARTCLIENT.EXE) 
	Else     
		cLocSystem  := "A:\Protheus10\Treinamento\system\"  //CAMINHO COMPLETO DA PASTA SYSTEM 
		cLocSmart  := "A:\Protheus10\bin\smartclient\"  //CAMINHO COMPLETO DA PASTA SMARTCLIENT 
		cTCP   := "TCP"   //COMUNICA��O TCP COM O SERVIDOR
		cAmbiente  := "Treinamento"   //AMBIENTE 
		cProgCli  := "TotvsSmartClient.exe"   //NOME DO PROGRAMA DO SMARTCLIENT (PROTHEUS10 = TOTVSSMARTCLIENT.EXE | PROTHEUS 11 = SMARTCLIENT.EXE) 
	EndIf    
	
	cLog	:= ""   
	cLog2	:= ""   
	nCont1	:= 0 

	//VARIAVEIS ESPECIFICAS PARA A PESQUISA DAS FUN��ES NO RPO 
	aType := {}   
	aFile := {}   
	aLine := {}   
	aDate := {}   
	aTime := {} 

	//MONTAGEM DA TELA PARA PASSAGEM DOS PARAMETROS   
	@ 200,1 TO 400,400 DIALOG oGera2 TITLE OemToAnsi("Aplica��o dos Updates") 
	@ 10,018 Say "INFORME AS INICIAIS DO UPDATE - EXEMPLO: UPDCOM | UPDEST" PIXEL OF oGera2 
	@ 70,018 MSGET oVar VAR cUpd Picture "@!" SIZE 040,10 PIXEL OF oGera2 
	@ 80,170 BMPBUTTON TYPE 01 ACTION {Close(oGera2)}   
	Activate Dialog oGera2 Centered 
	
	cUpd := Alltrim(cUpd) 
	
	IF Alltrim(cUpd) == ""    
		Alert("N�o foi informado nenhum UPDATE!") 
		Return 
	EndIf   
	
	If MsgBox("Ser� iniado a execu��o dos UPDs. Desejacontinuar?","Aten��o","YESNO") 
		cNomFunc  := "U_"+cUpd+"*" //O * SERVE PRA PESQUISAR O RESTANTE DA STRING 
		//PESQUISA AS FUN��ES NO RPO 
		aRet := GetFuncArray(cNomFunc, @aType, @aFile, @aLine, @aDate, @aTime) 
		
		For nCont := 1 To Len(aRet) 
		
			//PRIMEIRO VERIFICA SE ESSE ARQUIVO J� EXISTE NAPASTA \SYSTEM\UPDS OU NO CAMINHO ESPECIFICADO 
			cArqUpd := aRet[nCont] +"_"+ StrTran(dtoc(aDate[nCont]),"/","_") 
			cArqUpd := cLocSystem + cLocUpd + cArqUpd + ".UPDATE" 
			cTemArq := FOPEN(cArqUpd) 
			
			//SE O ARQUIVO J� EXISTIR 
			If !(cTemArq <= 0) 
				cLog2 += aRet[nCont] +";" 
			Else 
				nCont1++ 
				
				If MsgBox("Executa "+aRet[nCont]+"?","Aten��o","YESNO") 
				
					//EXECUTA O SMARTCLIENT COM OS PARAMETROS DO UPDATE 
					WinExec(cLocSmart+cPROgCli+" -Q -P="+aRet[nCont]+" -C="+cTCP+" -E="+cAmbiente+" -M") 
		
					//ARMAZENA O LOG GERAL 
					cLog += aRet[nCont] +";" 
					
					//CRIA NA PASTA SYSTEM O UPDATE PARA DIZER QUEELE J� FOI EXECUTADO 
					MemoWrite(cArqUpd,cArqUpd) 
				
				EndIf 
				
			EndIf 
	
		Next 

		cArq := cLocSystem + cLocUpd + cUpd + ".TXT" 
		MemoWrite(cArq,cLog) 
	  
		If nCont1 > 0
			cMsg :=  "Compatibilizadores executado com sucesso! Foi gravado os LOG's na pasta SYSTEM" 
		Else 
			cMsg :=  "N�o foi executado nenhum compatibilizador!" 
		EndIf 
	
		MsgBox(cMsg,"Acabou","INFO") 
		
		If MsgBox("Deseja executar novamente a rotina MeusUpd's?","Meus Upds","YESNO")
			U_MEUSUPDS() 
		EndIf 
	
	EndIf  

Return