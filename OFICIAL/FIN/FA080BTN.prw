#INCLUDE "rwmake.ch"                                                              
#INCLUDE "protheus.ch"
#INCLUDE "hbutton.ch"

/*
+----------+-----------+----------+-------------------------+------+------------+
|Programa  |FA080BTN    | Autor    |Renata Alves            |Data  | 29.09.2010 |
+----------+-----------+----------+-------------------------+------+------------+
|Descricao | Ponto de Entrada que inclui botão na EnchoiceBar da rotina de bai- |
|          | xas a pagar.                                                       |
+----------+--------------------------------------------------------------------+
| USO      | Financeiro                                                         |
+----------+--------------------------------------------------------------------+
|                    ALTERACOES FEITAS DESDE A CRIACAO                          |
+----------+-----------+--------------------------------------------------------+
|Autor     | Data      | Descrição                                              |
+----------+-----------+--------------------------------------------------------+
|          |           |                                                        |
+----------+-----------+--------------------------------------------------------+
*/  

User Function FA080BTN()
	
	Local aButtons := {} // Botoes a adicionar
	aadd(aButtons,{'LIQCHECK',{|| u_fCheque()},'Cheques Recebidos','Cheques Recebidos'} )

Return (aButtons)                      

/*
+----------+-----------+----------+-------------------------+------+------------+
|Programa  |fCheque     | Autor   |Renata Alves             |Data  | 29.09.2010 |
+----------+-----------+----------+-------------------------+------+------------+
|Descricao | Tela do Ponto de Entrada. Utilizada para marcar os cheques recebi- |
|          | dos que serão utilizados no contas a pagar.                        |
+----------+--------------------------------------------------------------------+
| USO      | Financeiro                                                         |
+----------+--------------------------------------------------------------------+
|                    ALTERACOES FEITAS DESDE A CRIACAO                          |
+----------+-----------+--------------------------------------------------------+
|Autor     | Data      | Descrição                                              |
+----------+-----------+--------------------------------------------------------+
|          |           |                                                        |
+----------+-----------+--------------------------------------------------------+
*/  

User Function fCheque()

	Local aButtons := {}
	Static oLBLValor    
	Static cTexto := " "
	Static nVlrTot := 0 
	Static oSEF
	Static oMsgvalor
	Static aSEF := {}

  	DEFINE MSDIALOG oSEF TITLE "Cheques" FROM 000, 000  TO 550, 550 COLORS 0, 16777215 PIXEL

    aadd(aButtons,{'CMC7',{|| u_fPesqCh()},'CMC7','CMC7'})
    aadd(aButtons,{'PESQUISA',{|| u_fPesqCh2()},'Pesquisa','Pesquisa'})
    EnchoiceBar(oSEF, {||fOK(),nVlrTot := 0,cTexto:= "Teste",aSEF := {},aCheque := {},oSEF:End()}, {||nVlrTot := 0,cTexto:= "Teste",aSEF := {},aCheque := {},oSEF:End()},,aButtons)
    fListBox()                                                                         
    @ 240, 010 SAY oLblValor PROMPT cTexto SIZE 198, 007 OF oSEF COLORS 0, 16777215 PIXEL

  	ACTIVATE MSDIALOG oSEF CENTERED
    //DEFINE MSDIALOG oMsgValor TITLE cTexto FROM 450, 450  TO 550, 550 COLORS 0, 16777215 PIXEL 
    //ACTIVATE MSDIALOG oMsgValor 
Return

/*
+----------+-----------+----------+-------------------------+------+------------+
|Programa  |fListBox() | Autor    |Renata Alves             |Data  | 29.09.2010 |
+----------+-----------+----------+-------------------------+------+------------+
|Descricao | Função utilizada para carregar os cheques da tabela SEF que estão  |
|          | com o campo EF_CP <> "S". Carregar a MarkBrowse.                   |
+----------+--------------------------------------------------------------------+
| USO      | Financeiro                                                         |
+----------+--------------------------------------------------------------------+
|                    ALTERACOES FEITAS DESDE A CRIACAO                          |
+----------+-----------+--------------------------------------------------------+
|Autor     | Data      | Descrição                                              |
+----------+-----------+--------------------------------------------------------+
|          |           |                                                        |
+----------+-----------+--------------------------------------------------------+
*/  

Static Function fListBox()

	Local oOk := LoadBitmap( GetResources(), "LBOK")
	Local oNo := LoadBitmap( GetResources(), "LBNO")
	Static oCheque
	Static aCheque := {}

    If Select("QSEF") <> 0
		DbSelectArea("QSEF")
		DbCloseArea()
	EndIf	

    cQuery := "SELECT EF_NUM, EF_BANCO, EF_AGENCIA, EF_CONTA, EF_VALOR, R_E_C_N_O_ "
    cQuery += "FROM "+RetSqlName("SEF")+" "
	cQuery += "WHERE D_E_L_E_T_ = '' AND EF_CP <> 'S' " 
	cQuery += "ORDER BY EF_NUM"
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QSEF",.T.,.T.)
	dbGoTop()	
    
    Do While !Eof()   
	    Aadd(aCheque,{.F.,QSEF->EF_NUM,QSEF->EF_BANCO,QSEF->EF_AGENCIA,QSEF->EF_CONTA,Transform(QSEF->EF_VALOR, "@e 99,999,999,999.99"),QSEF->EF_VALOR,QSEF->R_E_C_N_O_})
	   	DbSkip()
	Enddo

    @ 014, 000 LISTBOX oCheque Fields HEADER "","N.Cheque","Banco","Agência","Conta","Valor" SIZE 250, 223 OF oSEF PIXEL ColSizes 50,50
    oCheque:SetArray(aCheque)
    oCheque:bLine := {|| {If(aCheque[oCheque:nAT,1],oOk,oNo),;
				             aCheque[oCheque:nAt,2],;
           					 aCheque[oCheque:nAt,3],;
					         aCheque[oCheque:nAt,4],;
					         aCheque[oCheque:nAt,5],;
						     aCheque[oCheque:nAt,6]}}
    // DoubleClick event
    oCheque:bLDblClick := {|| aCheque[oCheque:nAt,1] := !aCheque[oCheque:nAt,1], oCheque:DrawSelect(),fPainel(oCheque:nAt,aCheque[oCheque:nAt,1],aCheque[oCheque:nAt,7],aCheque[oCheque:nAt,8])}

Return()

/*
+----------+-----------+----------+-------------------------+------+------------+
|Programa  |fPainel    | Autor    |Renata Alves             |Data  | 29.09.2010 |
+----------+-----------+----------+-------------------------+------+------------+
|Descricao | Função utilizada para somar e subtrair os valores do cheque de a-  |
|          | cordo com a marcação no MarkBrowse e inserindo os dados na array   |
|          | aSEF e atualizando o objeto SAY para informar o valor dos cheques. |
+----------+--------------------------------------------------------------------+
| USO      | Financeiro                                                         |
+----------+--------------------------------------------------------------------+
|                    ALTERACOES FEITAS DESDE A CRIACAO                          |
+----------+-----------+--------------------------------------------------------+
|Autor     | Data      | Descrição                                              |
+----------+-----------+--------------------------------------------------------+
|          |           |                                                        |
+----------+-----------+--------------------------------------------------------+
*/

Static Function fPainel(nVetor,lOk,nValor,nRecno)
	
	If lOk	
		nVlrTot += nValor
		Aadd(aSEF,{nRecno,lOK})
	Else
		nVlrTot -= nValor
		Aadd(aSEF,{nRecno,lOK})
	Endif

	cTexto := "Valor a Pagar: R$ "+Transform(nValPgto,"@e 99,999,999,999.99")+" | Valor Total dos Cheques: R$ "+Transform(nVlrTot,"@e 99,999,999,999.99")
    @ 240, 010 SAY cTexto OF oLBLValor 
	oLBLValor:Refresh()
	
Return()                      

/*
+----------+-----------+----------+-------------------------+------+------------+
|Programa  |fOK        | Autor    |Renata Alves             |Data  | 29.09.2010 |
+----------+-----------+----------+-------------------------+------+------------+
|Descricao | Função acionada pelo ok da EnchoiceBar, que pega a array aSEF e re-|
|          | gistra os cheques na tabela SZ2 e marca o campo EF_CP := "S" para  |
|          | que o cheque não vá mais para o Markbrowse.                        |
+----------+--------------------------------------------------------------------+
| USO      | Financeiro                                                         |
+----------+--------------------------------------------------------------------+
|                    ALTERACOES FEITAS DESDE A CRIACAO                          |
+----------+-----------+--------------------------------------------------------+
|Autor     | Data      | Descrição                                              |
+----------+-----------+--------------------------------------------------------+
|          |           |                                                        |
+----------+-----------+--------------------------------------------------------+
*/

Static Function fOK()

	If nVlrTot <= nValPgto
	
		For nX := 1 to Len(aSEF)
			If aSEF[nX][2]
				DbSelectArea("SEF")
				DbSetOrder(1)
				DbGoTo(aSef[nX][1])
			 	RecLock("SEF",.F.)
			 		SEF->EF_CP := "S"
			 	MsUnlock()
			 	
			 	DbSelectArea("SZ2")
				RecLock("SZ2",.T.)
					SZ2->Z2_NCHEQUE := SEF->EF_NUM
					SZ2->Z2_BANCO   := SEF->EF_BANCO
					SZ2->Z2_AGENCIA := SEF->EF_AGENCIA
					SZ2->Z2_CONTA   := SEF->EF_CONTA
					SZ2->Z2_VALOR   := SEF->EF_VALOR
					SZ2->Z2_PREFCP  := SE2->E2_PREFIXO
					SZ2->Z2_TITCP   := SE2->E2_NUM
					SZ2->Z2_CODFOR  := SE2->E2_FORNECE
					SZ2->Z2_LOJAFOR := SE2->E2_LOJA
				MsUnlock()		 		
	 		Else
				DbSelectArea("SEF")
				DbSetOrder(1)
				DbGoTo(aSef[nX][1])
			 	RecLock("SEF",.F.)
			 		SEF->EF_CP := "N"
			 	MsUnlock()           
			 	
			 	DbSelectArea("SZ2")
			 	DbSetOrder(1)
			 	DbSeek(xFilial("SZ2")+SEF->EF_NUM+SEF->EF_BANCO+SEF->EF_AGENCIA+SEF->EF_CONTA)
			 	
			 	If Found()
			 		RecLock("SZ2",.F.)
					 	DbDelete()
					MsUnlock()
				Endif
		 	
			 Endif
		Next
		
		//Variável de valor de pagamento da tela de baixa de contas a pagar.
		nValPagto := nVlrTot
		cTexto := ""
		nVlrTot := 0
		aSEF := {}   
		aCheque := {}
	Else
	
		MsgAlert("Não é possível fazer pagamento com valor maior que o título.")
		cTexto := ""
		nVlrTot := 0
		aSEF := {}
		aCheque := {}
		Return(.F.)
	
	Endif
	
Return(.T.)

/*
+----------+-----------+----------+-------------------------+------+------------+
|Programa  |fPesqui    | Autor    |Renata Alves             |Data  | 29.09.2010 |
+----------+-----------+----------+-------------------------+------+------------+
|Descricao | Tela de Pesquisa do cheque, para passar o cheque na máquina de có- |
|          | digos.                                                             |
+----------+--------------------------------------------------------------------+
| USO      | Financeiro                                                         |
+----------+--------------------------------------------------------------------+
|                    ALTERACOES FEITAS DESDE A CRIACAO                          |
+----------+-----------+--------------------------------------------------------+
|Autor     | Data      | Descrição                                              |
+----------+-----------+--------------------------------------------------------+
|          |           |                                                        |
+----------+-----------+--------------------------------------------------------+
*/

User Function fPesqCh()

	Local oBTNCanc
	Local oBTNOK
	Local oGETIDCheque
	Local cGETIDCheque := SPACE(34)
	Static oIDCheque
	
	DEFINE MSDIALOG oIDCheque TITLE "Cheque" FROM 000, 000  TO 100, 500 COLORS 0, 16777215 PIXEL

    @ 012, 019 MSGET oGETIDCheque VAR cGETIDCheque SIZE 208, 010 OF oIDCheque COLORS 0, 16777215 PIXEL
    @ 028, 077 BUTTON oBTNOK PROMPT "OK" SIZE 037, 012 OF oIDCheque PIXEL ACTION (fMarcar(cGETIDCheque,1),oIDCheque:End())
    @ 027, 132 BUTTON oBTNCanc PROMPT "Cancelar" SIZE 037, 012 OF oIDCheque PIXEL ACTION (oIDCheque:End())

	ACTIVATE MSDIALOG oIDCheque CENTERED

Return

/*
+----------+-----------+----------+-------------------------+------+------------+
|Programa  |fPesqCh2   | Autor    |Rafael Almeida           |Data  | 14.12.2010 |
+----------+-----------+----------+-------------------------+------+------------+
|Descricao | Tela de Pesquisa do cheque, buscando pelo numero                   |
|          |                                                                    |
+----------+--------------------------------------------------------------------+
| USO      | Financeiro                                                         |
+----------+--------------------------------------------------------------------+
|                    ALTERACOES FEITAS DESDE A CRIACAO                          |
+----------+-----------+--------------------------------------------------------+
|Autor     | Data      | Descrição                                              |
+----------+-----------+--------------------------------------------------------+
|          |           |                                                        |
+----------+-----------+--------------------------------------------------------+
*/

User Function fPesqCh2()

	Local oBTNCanc
	Local oBTNOK
	Local oGETIDCheque
	Local cGETIDCheque := SPACE(34)
	Static oIDCheque
	
	DEFINE MSDIALOG oIDCheque TITLE "Cheque" FROM 000, 000  TO 100, 500 COLORS 0, 16777215 PIXEL

    @ 012, 019 MSGET oGETIDCheque VAR cGETIDCheque SIZE 208, 010 OF oIDCheque COLORS 0, 16777215 PIXEL
    @ 028, 077 BUTTON oBTNOK PROMPT "OK" SIZE 037, 012 OF oIDCheque PIXEL ACTION (fMarcar(cGETIDCheque,2),oIDCheque:End())
    @ 027, 132 BUTTON oBTNCanc PROMPT "Cancelar" SIZE 037, 012 OF oIDCheque PIXEL ACTION (oIDCheque:End())

	ACTIVATE MSDIALOG oIDCheque CENTERED

Return 

/*
+----------+-----------+----------+-------------------------+------+------------+
|Programa  |fMarcar    | Autor    |Renata Alves             |Data  | 29.09.2010 |
+----------+-----------+----------+-------------------------+------+------------+
|Descricao | Função utilizada para marcar o cheque, caso seja identificado pela |
|          | máquina de códigos.                                                |
+----------+--------------------------------------------------------------------+
| USO      | Financeiro                                                         |
+----------+--------------------------------------------------------------------+
|                    ALTERACOES FEITAS DESDE A CRIACAO                          |
+----------+-----------+--------------------------------------------------------+
|Autor     | Data      | Descrição                                              |
+----------+-----------+--------------------------------------------------------+
|          |           |                                                        |
+----------+-----------+--------------------------------------------------------+
*/

Static Function fMarcar(cID,nModo)

Local nPos := 0

If nModo == 1


	For nX := 1 to Len(aCheque)
		If Alltrim(aCheque[nX][2]) == SubStr(cID,14,6) .and. Alltrim(aCheque[nX][3]) == SubStr(cID,2,3) .and. Alltrim(aCheque[nX][4]) == SubStr(cID,5,4) .and. Alltrim(aCheque[nX][5]) == SubStr(cID,25,8)
        	aCheque[nX][1] := .T.
        	fPainel(nX,.T.,aCheque[nX][7],aCheque[nX][8])
        	oCheque:Refresh()
        	Return()
  		Endif
  	Next

Else

       nPOS := aScan(aCheque, { |P| alltrim(P[2]) == ALLTRIM(cID) })
        
       IF nPos != 0  
	   aCheque[nPos][1] := .T.
	    fPainel(nPos,.T.,aCheque[nPos][7],aCheque[nPos][8])
	   oCheque:Refresh()
           SysRefresh()
       EndIF
EndIf
	  	
Return .T.