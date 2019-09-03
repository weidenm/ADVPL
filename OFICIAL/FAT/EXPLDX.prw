
#INCLUDE "RWMAKE.CH"
#include "topconn.ch"
#include "tbiconn.ch"

/* 
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IMP 4.0   �Autor  � 					� Data �  15/04/16    ���
�������������������������������������������������������������������������͹��
���Desc.     � IMPORTA DADOS DO OFICIAL PARA TOTVS	                     ���
���PROGRAMA  �                                                            ���
�������������������������������������������������������������������������͹��
���Desc.     � Considera todos os registros,mesmo os j� atualizados e     ���
��� vers�o   � com LOG                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                     c   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function EXPLDX()

	    
Processa({||ExpLdx_exec()},"Aguarde...","Exportando pedidos do Landix para Oficial.") 

Return Nil
 


Static Function ExpLdx_exec()

cQuery := " EXEC SRVPP03.LANDIX_FLX.dbo.LDX_EXPORTA_AFV "
TCSQLexec(cQuery)

	
Return