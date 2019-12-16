#Include "PROTHEUS.CH"

/*
+----------+-----------+----------+-------------------------+------+------------+
|Programa  |F050BUT    | Autor    |Renata Alves             |Data  | 29.09.2010 |
+----------+-----------+----------+-------------------------+------+------------+
|Descricao | Ponto de Entrada da função Contas a Pagar, onde eu incluo botão na |
|          | enchoicebar, que é possível verificar quais cheques estão ligados à|
|          | contas a receber.                                                  |
+----------+--------------------------------------------------------------------+
| USO      | Financeiro                                                         |
+----------+--------------------------------------------------------------------+
|                    ALTERACOES FEITAS DESDE A CRIACAO                          |
+----------+-----------+--------------------------------------------------------+
|Autor     | Data      | Descrição                                              |
+----------+-----------+--------------------------------------------------------+
| 12.1.25  |           |                                                        |
+----------+-----------+--------------------------------------------------------+
*/

User Function F050BUT()

	Local aButtons := {} // Botoes a adicionar
	aadd(aButtons,{'LIQCHECK',{|| u_fCHQList()},'Cheques Recebidos','Cheques Recebidos'})

Return (aButtons)     

/*
+----------+-----------+----------+-------------------------+------+------------+
|Programa  |fCHQList   | Autor    |Renata Alves             |Data  | 29.09.2010 |
+----------+-----------+----------+-------------------------+------+------------+
|Descricao | Tela para visualizar os cheques recebidos que foram usados para pa-|
|          | gamento de contas.                                                 |
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

User Function fCHQList()

	Static oTela

	DEFINE MSDIALOG oTela TITLE "Cheques Recebidos" FROM 000, 000  TO 290, 500 COLORS 0, 16777215 PIXEL

    fListCheque()

	ACTIVATE MSDIALOG oTela CENTERED

Return

/*
+----------+-----------+----------+-------------------------+------+------------+
|Programa  |fListCheque| Autor    |Renata Alves             |Data  | 29.09.2010 |
+----------+-----------+----------+-------------------------+------+------------+
|Descricao | Faz a consulta e lista os cheques que estão ligados ao título a pa-|
|          | gar.                                                               |
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

Static Function fListCheque()

	Local oListCheque
	Local aListCheque := {}
	
    If Select("QSZ2") <> 0
		DbSelectArea("QSZ2")
		DbCloseArea()
	EndIf	
	
    cQuery := "SELECT Z2_NCHEQUE, Z2_BANCO, Z2_AGENCIA, Z2_CONTA, Z2_VALOR "
	cQuery += "FROM "+RetSqlName("SZ2")+" "
	cQuery += "WHERE Z2_TITCP = '"+SE2->E2_NUM+"' AND Z2_PREFCP = '"+SE2->E2_PREFIXO+"' AND Z2_CODFOR = '"+SE2->E2_FORNECE+"' AND Z2_LOJAFOR = '"+SE2->E2_LOJA+"' AND D_E_L_E_T_ = '' "
	cQuery += "ORDER BY Z2_NCHEQUE "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QSZ2",.T.,.T.)
	dbGoTop()	
    
    // Insert items here
	If Eof()
		Aadd(aListCheque,{"","","","",Transform(0,"@e 99,999,999,999.99")})	
	Endif
	
    Do While !Eof()
    	Aadd(aListCheque,{QSZ2->Z2_NCHEQUE,QSZ2->Z2_BANCO,QSZ2->Z2_AGENCIA,QSZ2->Z2_CONTA,Transform(QSZ2->Z2_VALOR,"@e 99,999,999,999.99")})
    	DbSkip()
    Enddo                               

    @ 001, 000 LISTBOX oListCheque Fields HEADER "Num.Cheque","Banco","Agência","Conta","Valor" SIZE 248, 143 OF oTela PIXEL ColSizes 50,50

    oListCheque:SetArray(aListCheque)
    oListCheque:bLine := {|| {aListCheque[oListCheque:nAt,1],;
						      aListCheque[oListCheque:nAt,2],;
						      aListCheque[oListCheque:nAt,3],;
						      aListCheque[oListCheque:nAt,4],;
						      aListCheque[oListCheque:nAt,5]}}
    // DoubleClick event
    oListCheque:bLDblClick := {|| aListCheque[oListCheque:nAt,1] := !aListCheque[oListCheque:nAt,1],;
    oListCheque:DrawSelect()}
      
Return