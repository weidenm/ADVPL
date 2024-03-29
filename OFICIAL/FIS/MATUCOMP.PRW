/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MATUCOMP �  Autor � Paulo Bindo        � Data �  16/03/10   ���
�������������������������������������������������������������������������͹��
���Descricao �  MONTA REGISTRO PARA PREENCHER DADOS DO SPED FISCAL        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� 12.1.25  � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Matucomp()
Local lExiste := .F.
dbSelectArea("CD7")
CD7->(dbSetOrder(1))
lExiste := CD7->(dbSeek(xFilial("CD7")+ParamIXB[1]+ParamIXB[2]+PADR(ParamIXB[3],TamSX3("CD7_DOC")[1])+ParamIXB[4]+ParamIXB[5]))
If lExiste
	RecLock(CD7,.F.)
	Replace CD7->CD7_LOTE	With  "55555555"
	MsUnlock("CD7")
EndIf
Return
// _________________________________________________________________________________________________
//|Quando se referir aos complementos para geracao dos registros C110, C111, C112, C113, C114 e C115|
//|  a tabela CDT tamb�m deve ser alimentada, pois ela que efetua o relacionamentos com as outras   |
//|  conforme registro. C110 = Tab. CDT, C111 = Tab. CDG, , C112 = Tab. CDC, C113 = Tab. CDD,       |
//|  C114 = Tab. CDE e C115 = Tab. CDF                                                              |
//|_________________________________________________________________________________________________|
User Function MATUCOMP()
cEntSai := ParamIXB[1]
cDoc    := ParamIXB[2]
cSerie  := ParamIXB[3]
cCliefor:= ParamIXB[4]
cLoja   := ParamIXB[5]
lExiste 	:= CDT->(dbSeek(xFilial("CDT")+cEntSai+cDoc+cSerie+cClieFor+cLoja))
If lExiste
	RecLock("CDT",.F.)
Else
	RecLock("CDT",.T.)
	CDT->CDT_FILIAL	:= xFilial("CDT")
	CDT->CDT_TPMOV	:= cEntSai
	CDT->CDT_DOC	:= cDoc
	CDT->CDT_SERIE	:= cSerie
	CDT->CDT_CLIFOR	:= cClieFor
	CDT->CDT_LOJA	:= cLojaEndIf
	CDT->CDT_IFCOMP := "000001"
        MsUnLock()
        FkCommit()
        RecLock("CDF",.T.)
        CDF->CDF_FILIAL	:= xFilial("CDF")
        CDF->CDF_TPMOV	:= cEntSai
        CDF->CDF_DOC	:= cDoc
        CDF->CDF_SERIE	:= cSerie
        CDF->CDF_CLIFOR	:= cClieFor
        CDF->CDF_LOJA	:= cLoja
        CDF->CDF_IFCOMP := "000001"
ENDIF

Return