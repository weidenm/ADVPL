#include "rwmake.ch"
#include "topconn.ch"

User Function MTA440C9

u_SomaDadosGrav()    //CalVolumeEnv.prw
u_tesinteligente() //TESINTEL.PRW

Return


//SOMA VOLUME GRAVADO - ROTINA LIBERA PEDIDO

User Function SomaDadosGrav()


	cQuery :=" SELECT C6_NUM, SUM(C6_QTDVEN) AS QUANT FROM SC6010 "
	cQuery += " WHERE C6_NUM = '"+ SC6->C6_NUM + "' AND D_E_L_E_T_ <> '*'"
	cQuery += " GROUP BY C6_NUM"

	TCQuery cQuery Alias LIBVOL New

	RecLock("SC5",.f.)

	if SC5->C5_TIPO=='N'
		SC5->C5_VOLUME1 := LIBVOL->QUANT
		SC5->C5_ESPECI1 := "UN"
	EndIf

	SC5->(msunlock())

	dbSelectArea("LIBVOL")
	dbCloseArea()

Return


//No Campo C6_QTDVEN cria um gatilho U_CALCVOL(M->C6_QTDVEN) para o pr�prio campo C6_QTDVEN
//Pega esta fun��o e salva como calcvol.prw

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa � CALCVOL Autor � Luiz Alberto � Data � 29/11/11 ���
�������������������������������������������������������������������������Ĵ��
���Objetivo � Funcao responsavel pelo preenchimento do campo volume ��
do Pedido de Vendas
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CalcVol(nValor)
	Local nVol := 0

	nPosItem := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_ITEM"})
	nPosProd := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_PRODUTO"})
	nPosQtde := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_QTDVEN"})

	For _nItem := 1 to Len(aCols)
		If ! aCols[_nItem,Len(aHeader)+1]
			nVol += aCols[_nItem,nPosQtde]
		EndIf
	Next

if SC5->C5_TIPO=='N'
	M->C5_VOLUME1 := nVol
	M->C5_ESPECI1 := "UN"
EndIf

	GetDRefresh()
Return nValor