#include "rwmake.ch"
#include "topconn.ch"
#Include "Protheus.ch"      

//----------------------------------------------------------------------------
// PONTO DE ENTRADA PARA SUGERIR QUANTIDADE LIBERADA AUTOMATICAMENTE NO PV
// VALIDA TODA TELA DE DIGITAÇÃO DO PEDIDO  -  12.1.25
//----------------------------------------------------------------------------

User Function MTA410()        

/*
   if SC6->C6_FILIAL <> "01" .or. SC5->C5_TIPO <> "N"
      Return .t. 
   EndIf

   nPosQuant := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_QTDVEN"})
   nPosQtdlb := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_QTDLIB"})
   _nPOSValor:= aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_VALOR"})  // valor final
   cFilial   := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_FILIAL"})


   _nTotalpedido := 0
   _TotalQuant := 0

      FOR _I := 1 TO LEN(ACOLS)
         _QTDPED:=ACOLS[_I][nPosQuant]
         _QTDLIB:=ACOLS[_I][nPosQtdlb]
         _nValor:=ACOLS[_I][_nPOSValor]
         _TAM:=LEN(ACOLS[_I])     
         _DELETADO:=ACOLS[_I][_TAM]     //verifica se não é uma linha deletada

            if !_DELETADO 
               acols[_I][nPosQtdlb]:= acols[_I][nPosQuant]
               _nTotalpedido := _nTotalpedido + _nValor
               _TotalQuant := _TotalQuant + _QTDPED
               
            endif

      NEXT
   
   M->C5_VOLUME1 := _TotalQuant
   GETDREFRESH() 
 */


 /*

// VERIFICO SE TEM MAIS DE UM PEDIDO PARA O MESMO DIA
// PARA POSICIONAR NO REGISTRO ANTERIOR  /*

   nC5ordem := sc5->(dbsetorder())
   nC5Rec   := sc5->(recno())
   DBSELECTAREA("SC5")
   DBSETORDER(10)
   DBSEEK(xFilial("SC5")+_cCliente+_cLoja+DTOS(_dDataent))

   IF FOUND() .AND. SC5->C5_NUM <> M->C5_NUM

      IF !MsgNoYes("Encontrado Pedido para Esta Data de Entrega-> "+SC5->C5_NUM+CHR(13)+;
                   " Confirma?")
         sc5->(dbsetorder(nC5ordem))
         sc5->(dbgoto(nC5Rec))
         Return(.F.)         
      ENDIF   

   ENDIF

// VOLTA O PONTEIRO 

   sc5->(dbsetorder(nC5ordem))
   sc5->(dbgoto(nC5Rec))
*/
Return .T.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Pt.Entrada³MTA410T   ³ Autor ³ Info.Mauricea         ³ Data ³ 07.12.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri?"o ³Ponto para liberar todo o pedido automaticamente            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function mta410t()   

   SetPrvt("_cFilial,_cPedido,")

   _cFilial:= xFilial()

   if _cFilial <> "01" .or. SC5->C5_TIPO <> "N"
      Return .T.
   EndIf

   _cPedido    := SC5->C5_NUM

   dbSelectArea("SC5")
   dbSetOrder(1)
   dbSeek(xFilial("SC5")+_cPedido,.T.)
   If Found()
      While C5_FILIAL == "01" .AND. C5_NUM == _cPedido
      
            RecLock("SC5",.F.)
            Replace C5_LIBEROK With "S"
            If C5_TPFRETE != "F"
               Replace C5_TPFRETE With "C"
            Endif
            MsUnLock()
            dbSkip()
      End
   Endif

   dbSelectArea("SC9")
   dbSetOrder(1)
   dbSeek(xFilial("SC9")+_cPedido,.T.)
   If Found()
      While C9_FILIAL == "01" .AND. C9_PEDIDO == _cPedido
            RecLock("SC9",.F.)
            Replace C9_OK      With  "  "
            Replace C9_BLEST   With  "  "
            //Replace C9_BLCRED  With  "  "
            Replace C9_BLOQUEI With  "  "
            MsUnLock()
            dbSkip()
      End
   Endif

Return

//Chamado no programa de exclusão de Pedidos de Venda. 
//Retorna se deve ou não excluir pedido de venda
User Function A410EXC()
 
 _cPedido := SC5->C5_NUM

   
if Alltrim(SC5->C5_LIBEROK) <> ""
     RecLock("SC5",.F.)
         SC5->C5_LIBEROK := ""
     MsUnLock()
EndIf

dbSelectArea("SC6")
dbSetOrder(1)
dbSeek(xFilial("SC6")+_cPedido,.T.)


 While ! eof() .and. SC6->C6_NUM == _cPedido
    If SC6->C6_QTDEMP <> 0   
        RecLock("SC6",.F.)
        SC6->C6_QTDEMP := 0
        MsUnLock()
    EndIf
    dbskip()
Enddo
   
Return .T.
 
 
 /*
User Function ValidCliente()

_dStatus := ""

IF M->C5_TIPO == "N" .and. SA1->A1_RISCO == "E"

    IF Alltrim(SA1->A1_DSTATUS) <> ""
       dbSelectArea("SX5")
       dbSetOrder(1)
        dbSeek(xFilial("SX5")+"Z1"+SA1->A1_DSTATUS)
        _dStatus := SX5->X5_DESCRI
    EndIf

//cCodFil := M0_CODFIL

    MsgInfo("Pedido bloqueado por crédito - Risco E. "+CHR(13)+;
              "Motivo:"+ _dStatus )

    Return("      ")         

ENDIF

Return(M->C5_CLIENTE)
*/

// ****************************************************
//                                                   //
// VALIDA ATRASO CHAMADO POR GATILHO                 //
//                                                   //
// ****************************************************
/*
User Function ValidAtraso()

	nAtr := 0

	cQry := "select SUM(E1_SALDO) AS NATRASO from SE1010 "
	cQry += " WHERE E1_SALDO > 0  AND D_E_L_E_T_ <>'*'"
	cQry += " AND E1_CLIENTE = '" + M->C5_CLIENTE + "' AND E1_VENCREA < '" + dtos(ddatabase) + "'"

	cQry := ChangeQuery(cQry)
	TCQUERY cQry NEW ALIAS "ATR"

	nAtr := ATR->NATRASO

	if nAtr > 0
		msginfo("O cliente tem o valor de R$ "+ Alltrim(str(nAtr)) + " em atraso. Detalhes na consulta posição do cliente.")
	endif

	dbCloseArea("ATR")

Return(SA1->A1_LOJA)
*/


/*------------------------------------------------------------------------------------------------------*
 | P.E.:  M410LIOK                                                                                      |
 | Desc:  Validação da linha do Pedido de Venda                                                         |
 | Links: http://tdn.totvs.com/pages/releaseview.action?pageId=6784149                                  |
 *------------------------------------------------------------------------------------------------------*/
/*
User Function M410LIOK() 

Local lRet     := .T. 

//Local nVol		:= 0
//Local cProduto := ""

 M->C5_X_TOTAL := u_zTotPed(M->C5_NUM, 2)
 GetDRefresh()
*/

/*
//dbSelectArea("SB1") 
//SB1->(dbSetOrder(1)) //B1_FILIAL+B1_COD  

		nPosQtde := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_QTDVEN"})
		n:= 0
		For _nItem := 1 to Len(aCols)
				nVol += aCols[_nItem,nPosQtde]
				//nValor += aCols[_nItem,nPosTot]
		//		DbSelectArea("SB5")
		//		dbSeek(xFilial("SB5")+cProduto)
		//		Volume 		:= aCols[_nItem,nPosQtde]*SB5->B5_COMPRLC*SB5->B5_LARGLC*SB5->B5_ALTURLC
		//		VolPedido 	:= VolPedido + Volume
		//		dbCloseArea("SB5")			
		Next
		//M->C5_VOLUME1 := nVol
		//GetDRefresh()  //Atualiza campos do cabeçalho, mas está gerando erro com esse ponto
		//RestArea(aArea) 
*/	

//Return lRet 

