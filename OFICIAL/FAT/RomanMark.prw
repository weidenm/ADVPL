#INCLUDE 'totvs.ch'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "RWMAKE.CH"
#include "topconn.ch"
#include "tbiconn.ch"
#DEFINE ENTER Chr(13)+Chr(10)

//-------------------------------------------------------------------
/*/{Protheus.doc} COMP025_MVC
Exemplo de montagem da modelo e interface de marcacao para uma
tabela em MVC
@author Ernani Forastieri e Rodrigo Antonio Godinho
@since 05/10/2009
@version 12.1.25
/*/
//-------------------------------------------------------------------
User Function MontaRomMVC()


aPerg := {}
cPerg := "MONROM"
Private oMark
Private aRotina := MenuDef()

Pergunte(cPerg,.T.,"Selecao de Romaneio")

oMark := FWMarkBrowse():New()
oMark:SetAlias('SC5')
oMark:SetSemaphore(.T.)
oMark:SetDescription('Montagem de Romaneio')
oMark:SetFieldMark( 'C5_OK' )
oMark:SetAllMark( { || oMark:AllMark() } )
oMark:AddLegend( "!EMPTY(C5_NOTA)", "RED" , "Faturado" )
oMark:AddLegend( "EMPTY(C5_NOTA) .AND. EMPTY(C5_ROMANEI)", "GREEN", "Aberto" )
oMark:AddLegend( "EMPTY(C5_NOTA) .AND. !EMPTY(C5_ROMANEI)", "WHITE" , "Em Romaneio" )


oMark:Activate()

Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina TITLE 'Gerar Romaneio' ACTION 'U_incluirom()' OPERATION 2 ACCESS 0
//ADD OPTION aRotina TITLE 'Gerar NF Trasnferência' ACTION 'U_incluitransf()' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Parâmetros' ACTION 'U_ParamRom()' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Liberar pedidos' ACTION 'u_zLibPed(MV_PAR01)' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir' ACTION 'u_excluirom()' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir Romaneio' ACTION 'u_ROMAN()' OPERATION 2 ACCESS 0

//ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.COMP025_MVC' OPERATION 2 ACCESS 0

Return aRotina

//-------------------------------------------------------------------
Static Function ModelDef()

// Utilizo um model que ja existe

Return FWLoadModel( 'COMP011_MVC' )

//-------------------------------------------------------------------
Static Function ViewDef()

// Utilizo uma View que ja existe
Return FWLoadView( 'COMP011_MVC' )

//-------------------------------------------------------------------
User Function incluirom()

Local aArea := GetArea()
Local cMarca := oMark:Mark()
Local lInverte := oMark:IsInvert()

Local nCt := 0
Local nPesoTot := 0
Local nCapacid := 0  //DA3_CAPACN
Local cVeiculo := "" //Z1_VEICULO


Local nSeconds    := 0 // Segundos que iniciou a
Local nX          := 0 // Contador de Repeticoes

aPerg := {}
cPerg := "MONRON"

	Pergunte(cPerg,.F.)

    Public _cRomanei := MV_PAR01
    Public _cItRom   := MV_PAR02
    
SC5->( dbGoTop() )
dbSelectArea("SC5")
dbSetOrder(2)
//SC5->(dbSeek(xFilial("SC5")+DTOS(ddatabase-20),.T.)) 
MsSeek(xFilial("SC5")+DTOS(ddatabase-90))
conout("Data filtro"+dtos(ddatabase-90))
nSeconds := Seconds()

While !SC5->( EOF() )
    If oMark:IsMark(cMarca)
        reclock("SC5",.f.)
        if EMPTY(C5_NOTA)
            If EMPTY(C5_ROMANEI) 
                SC5->C5_ROMANEI := _cRomanei  //Após testes definir campo e conteúdo definitivo
                SC5->C5_ROMIT:=  _cItRom
                nCt++
            EndIf
        EndIf
        SC5->C5_OK := ""
        SC5->(MsUnlock())
        nX ++
    EndIf
    SC5->( dbSkip() )
End
        ConOut("Tempo: " + AllTrim(Str(Seconds() - nSeconds)) + " Repetiçoes:" + str(nX))
        ApMsgInfo( 'Relacionados ' + AllTrim( Str( nCt ) ) + ' pedidos ao romaneio '+ _cRomanei+"-"+_cItRom )
RestArea( aArea )

Return NIL


User Function excluirom()

    Local aArea    := GetArea()
    Local cMarca   := oMark:Mark()
    Local lInverte := oMark:IsInvert()

    Local nCt      := 0

    Local nSeconds := 0 // Segundos que iniciou a
    Local nX       := 0 // Contador de Repeticoes

    SC5->( dbGoTop() )
    dbSelectArea("SC5")
    dbSetOrder(2)
    //SC5->(dbSeek(xFilial("SC5")+DTOS(ddatabase-20),.T.)) 
    MsSeek(xFilial("SC5")+DTOS(ddatabase-90))
    nSeconds        := Seconds()

    While !SC5->( EOF() )
        If oMark:IsMark(cMarca)
            reclock("SC5",.f.)
            if EMPTY(C5_NOTA)
                If !EMPTY(C5_ROMANEI)
                    
                    SC5->C5_ROMANEI := "" //Após testes definir campo e conteúdo definitivo
                    SC5->C5_ROMIT   := ""
                    nCt++
                EndIf
            EndIf
            SC5->C5_OK      := ""
            SC5->(MsUnlock())
            nX ++
        EndIf
        SC5->( dbSkip() )
    End
            ConOut("Tempo: " + AllTrim(Str(Seconds() - nSeconds)) + " Repetiçoes:" + str(nX))
            ApMsgInfo( 'Foram removidos ' + AllTrim( Str( nCt ) ) + ' pedidos de romaneios.')
    RestArea( aArea )

Return NIL


User Function ParamRom()

aPerg := {}
cPerg := "MONROM"

Pergunte(cPerg,.T.,"Seleção de Romaneio")

//Public _cRomanei := MV_PAR01
//Public _cItRom   := MV_PAR02

Return


 
User Function zLibPed(cRom)

    Local aArea     := GetArea()
    Local aAreaC5   := SC5->(GetArea())
    Local aAreaC6   := SC6->(GetArea())
    Local aAreaC9   := SC9->(GetArea())
    Local cPedido   := SC5->C5_NUM
    Local aAreaAux  := {}
    Local cBlqCred  := "  "
    Local cBlqEst   := "  "
    Local aLocal    := {}
    Local nItLib    := 0
    Local nItPed    := 0
    Local nContPed  := 0
    Local lbloq     := .f.
    Local cPedBloq  := ""
   // Default cPedido := ""
   // Default cRom :=""
    
    DbSelectArea('SC5')
    SC5->(DbSetOrder(10)) //C5_FILIAL + C5_NUM
    SC5->(DbGoTop())
     
    DbSelectArea('SC6')
    SC6->(DbSetOrder(1)) //C6_FILIAL + C6_NUM + C6_ITEM
    SC6->(DbGoTop())
 
    DbSelectArea('SC9')
    SC9->(DbSetOrder(1)) //C9_FILIAL + C9_PEDIDO + C9_ITEM
    SC9->(DbGoTop())

    If SC5->(DbSeek(FWxFilial('SC5') + cRom))
     
        While ! SC5->(EoF()) .And. SC5->C5_FILIAL = FWxFilial('SC5') .And. SC5->C5_ROMANEI == cRom

            lbloq   := .f.
            nItLib    := 0
            nItPed    := 0

            if Alltrim(SC5->C5_NOTA) == ""
              
                cPedido := SC5->C5_NUM

              //  ALERT(SC5->C5_NUM)
                If SC6->(DbSeek(FWxFilial('SC6') + SC5->C5_NUM  ))
                    aAreaAux := SC6->(GetArea())
            
                    //Percorre todos os itens
                    While ! SC6->(EoF()) .And. SC6->C6_FILIAL = FWxFilial('SC6') .And. SC6->C6_NUM == SC5->C5_NUM
                        //Posiciona na liberação do item do pedido e estorna a liberação
                        SC9->(DbSeek(FWxFilial('SC9')+SC6->C6_NUM+SC6->C6_ITEM))
                        While  (!SC9->(Eof())) .AND. SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM) == FWxFilial('SC9')+SC6->(C6_NUM+C6_ITEM)
                            SC9->(a460Estorna(.T.))
                            SC9->(DbSkip())
                        EndDo
            
                        SC6->(DbSkip())
                    EndDo
            
                   // RecLock("SC5", .F.)
                   //     C5_LIBEROK := ""
                   // SC5->(MsUnLock())
            
                    //Percorre todos os itens
                    RestArea(aAreaAux)

                    While ! SC6->(EoF()) .And. SC6->C6_FILIAL = FWxFilial('SC6') .And. SC6->C6_NUM == SC5->C5_NUM
                        
                        nItPed += 1

                        DbSelectArea('SB2')
                        SB2->(DbSetOrder(1)) //C6_FILIAL + C6_NUM + C6_ITEM
                        SB2->(DbGoTop())
                        DbSeek(FWxFilial('SB2') + SC6->C6_PRODUTO)

                        if SB2->B2_QATU <= 0 .and. SC6->C6_FILIAL = '02'  //Por enquanto, bloquear apenas produtos da filial 02.
                            cBlqEst := "02"
                            StaticCall(FATXFUN, MaGravaSC9, SC6->C6_QTDVEN, cBlqCred, cBlqEst, aLocal)
                            lbloq   := .t.
                            RecLock("SC5", .F.)
                            SC5->C5_BLQ := "1"
                            SC5->(MsUnLock())
                            Alert("O produto "+SC6->C6_PRODUTO+" do pedido "+SC6->C6_NUM+" foi bloqueado por falta de estoque.")
                         else
                            StaticCall(FATXFUN, MaGravaSC9, SC6->C6_QTDVEN, cBlqCred, cBlqEst, aLocal)
                            nItLib += 1
                        endif 
                        SC6->(DbSkip())
                    EndDo
                    
                    if nItPed = nItLib
                        nContPed += 1
                    EndIf

                    if lbloq = .t.
                        cPedBloq := cPedBloq+ Alltrim(SC5->C5_NUM) + ', '
                    EndIf

                EndIf

            EndIf //Fim verifica C5_NOTA      
            SC5->(DbSkip())
        EndDo
    
        MsgInfo("Concluído a liberação de "+Alltrim(str(nContPed))+" pedidos do romaneio "+Alltrim(cRom)+".")
        
        if Alltrim(cPedBloq)<>""
            MsgInfo("Pedidos "+cPedBloq+ " foram bloqueados por estoque.") 
        EndIf   
    
    EndIf
 
    RestArea(aAreaC9)
    RestArea(aAreaC6)
    RestArea(aAreaC5)
    RestArea(aArea)

Return


User Function OM200TPC()
/*onde item 1, codigo do produto;
item 2, tipo de carga do produto;
item 3, var. logica, .T. para validar o pedido;
item 4, array com tipos de cargas selecionadas.*/
   
    Local cProduto := PARAMIXB[1]
    Local cTipCar  := PARAMIXB[2]
    Local lCont    := PARAMIXB[3]
    Local aMod     := PARAMIXB[4]
    Local cQuery   := ""

    Static aFdFalta := {}

    If Select("PEDLIB") > 0
		dbSelectArea("PEDLIB")
		dbCloseArea()
	EndIf

    cQuery := "select C5_NUM, C5_VOLUME1, SUM(C9_QTDLIB) QTDLIB from SC5010 A INNER JOIN SC9010 B ON A.C5_NUM = B.C9_PEDIDO "
    cQuery += " WHERE  A.D_E_L_E_T_='' AND B.D_E_L_E_T_='' AND C5_NOTA ='' AND C9_BLEST=''"
    cQuery += " and C5_NUM='"+ SC9->C9_PEDIDO + "'"  
    cQuery += " GROUP BY C5_NUM, C5_VOLUME1 "
   // cQuery += " HAVING C5_VOLUME1 > SUM(C9_QTDLIB) "

	TCQuery cQuery Alias PEDLIB New

    If Select("PEDLIB") <= 0
        lCont := .f.
    //      Aadd(aFdFalta,{SC9->C9_PEDIDO,;
      //                       SC9->C9_ITEM,;
        //					"Sem liberação"})
    else
        If PEDLIB->C5_VOLUME1 > PEDLIB->QTDLIB
          //   Aadd(aFdFalta,{SC9->C9_PEDIDO,;
            //                 SC9->C9_ITEM,;
        	//				"Liberado Parcial"})
            lCont := .f.
        Else 
            If PEDLIB->C5_VOLUME1 < PEDLIB->QTDLIB
              //   Aadd(aFdFalta,{SC9->C9_PEDIDO,;
                //             SC9->C9_ITEM,;
        		//			"Volume incorreto"})
                lCont := .f.
            EndIf
        EndIf
    EndIf 

Return lCont


/*
User Function OM200GR2()
    LOGRES()
Return
*/


Static Function LOGRES()

	_cHora := time()
	aTexto := {}
	aButtons := {}
	cTexto1 := ""
	nFaltaIt := 0
	nFaltaFd := 0
    cPedido := ""
	
   // cAssunto	:= "PEDIDOS NÃO DISPONÍVEIS"
	//	AADD(aTexto,cAssunto)
		AADD(aTexto,"Bloqueados Parcialmente: ")

	If len(aFdFalta)>0//len(aFdFalta)>0
			//AADD(aTexto,"Hora:"+ _cHora)
		For i:= 1 To Len(aFdFalta)
            if cPedido <> aFdFalta[i][1]
                cPedido := aFdFalta[i][1]
                nFaltaIt += 1    
            EndIf
            
			AADD(aTexto,aFdFalta[i][1]+"   "+aFdFalta[i][2]+"   "+aFdFalta[i][3])
			
		//	nFaltaFd += val(aFdFalta[i][2])
		Next
		//AADD(aTexto,"Faltam  "+Alltrim(str(nFaltaFd))+ "  unidades em  "+Alltrim(str(nFaltaIt))+"  itens do romaneio.")
		AADD(aTexto,"Bloqueados  "+Alltrim(str(nFaltaIt))+ "  pedidos parcialmente ou com volume incorreto.")
        AADD(aTexto,"")
		
	EndIf
		
	cTexto1 := ""
	FOR i:= 1 to len(aTexto)
		cTexto1 += aTexto[i]+ENTER
	Next
	//MSGINFO(cTexto1)
    MessageBox(cTexto1,"PEDIDOS NÃO DISPONÍVEIS",48)

Return
