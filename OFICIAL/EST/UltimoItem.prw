
#Include "PROTHEUS.CH"    
#Include "RWMAKE.CH"
#Include "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � C6PEDCLI  � Autor � Weiden Mendes  � Data �  14/06/06      ���
�������������������������������������������������������������������������͹��
���Descricao � Valida��o do pedido pelo pedido do cliente.                 ��
���            Inclu�do como valida��o do campo B1_ITEMD            	  ���
�������������������������������������������������������������������������͹��
��� Retorno  � .T. ou .F.,Caso .T. grava Registro sen�o retorna a Inclus�o���
���          � altera��o do Produto.					  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ITEMOP()
    
    cItem   := "01"
    cData := GravaData(dDataBase,.F.,4) 
    
	cQuery:= "SELECT MAX(C2_ITEM) MAXCOD FROM SC2010"
	cQuery+= " WHERE D_E_L_E_T_='' AND C2_NUM='"+ cData +"'"

	TCQuery cQuery Alias ULTITOP New
	cItem := strzero(val(ULTITOP->MAXCOD)+1,2)
    ULTITOP->(DbCloseArea())

/*	dbSelectArea("SC2")
	dbseek(xfilial("SC2")+Alltrim(cData)+"01001")
	If  SC2->(found())
		cItem := SC2->C2_ITEM
        While SC2->C2_NUM == cData
			if SC2->C2_ITEM > cItem
				cItem := SC2->C2_ITEM
			EndIf
            SC2->(dbskip())                             
		EndDo
        cItem := StrZero(Val(SC2->C2_ITEM)+1,2)
	EndIf
    dbclosearea()	
*/

    return(cItem)  
                    
