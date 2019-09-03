#Include "PROTHEUS.CH"

/*
+----------+-----------+----------+-------------------------+------+------------+
|Programa  |FA080OWN   | Autor    |Renata Alves             |Data  | 07.10.2010 |
+----------+-----------+----------+-------------------------+------+------------+
|Descricao | Ponto de Entrada, que ao excluir a baixa de contas a pagar, os che-|
|          | ques também serão excluídos da Tabela SZ2 e o campo EF_CP será lim-|
|          | pado.                                                              |
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

User Function FA080OWN()
	
    If Select("QSZ2") <> 0
		DbSelectArea("QSZ2")
		DbCloseArea()
	EndIf	
	
    cQuery := "SELECT * "
	cQuery += "FROM "+RetSqlName("SZ2")+" "
	cQuery += "WHERE Z2_TITCP = '"+SE2->E2_NUM+"' AND Z2_PREFCP = '"+SE2->E2_PREFIXO+"' AND Z2_CODFOR = '"+SE2->E2_FORNECE+"' AND Z2_LOJAFOR = '"+SE2->E2_LOJA+"' AND D_E_L_E_T_ = '' "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QSZ2",.T.,.T.)
	dbGoTop()						
	
	Do While !Eof()
		DbSelectArea("SZ2")
		DbGoTo(QSZ2->R_E_C_N_O_)
		
		DbSelectArea("SEF")
		DbSetOrder(1)
		DbSeek(xFilial("SEF")+SZ2->Z2_BANCO+SZ2->Z2_AGENCIA+SZ2->Z2_CONTA+SZ2->Z2_NCHEQUE)
		
		RecLock("SEF")
			SEF->EF_CP := ""
		MsUnlock()
		
		RecLock("SZ2",.F.)
			DbDelete()
		MsUnlock()
		
		DbSelectArea("QSZ2")
		DbSkip()
	Enddo

Return(.T.)