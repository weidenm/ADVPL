#INCLUDE 'totvs.ch'
#INCLUDE 'FWMVCDEF.CH'

//-------------------------------------------------------------------
/*/{Protheus.doc} COMP025_MVC
Exemplo de montagem da modelo e interface de marcacao para uma
tabela em MVC
@author Ernani Forastieri e Rodrigo Antonio Godinho
@since 05/10/2009
@version P10
/*/
//-------------------------------------------------------------------
User Function MontaRomMVC()

Private oMark
Private aRotina := MenuDef()

oMark := FWMarkBrowse():New()
oMark:SetAlias('SC5')
oMark:SetSemaphore(.T.)
oMark:SetDescription('Montagem de Romaneio')
oMark:SetFieldMark( 'C5_OK' )
oMark:SetAllMark( { || oMark:AllMark() } )
oMark:AddLegend( "!EMPTY(C5_NOTA)", "RED" , "Faturado" )
oMark:AddLegend( "EMPTY(C5_NOTA) .AND. EMPTY(C5_ROMANEI)", "GREEN", "Aberto" )
oMark:AddLegend( "EMPTY(C5_NOTA) .AND. !EMPTY(C5_ROMANEI)", "YELLOW" , "Em Romaneio" )

oMark:Activate()

Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.COMP025_MVC' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir em Romaneio' ACTION 'U_incluirom()' OPERATION 2 ACCESS 0

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

SC5->( dbGoTop() )
While !SC5->( EOF() )
    If oMark:IsMark(cMarca)
        If EMPTY(C5_ROMANEI) .and. EMPTY(C5_NOTA)
           // reclock("SC5",.f.)
          //  SC5->C5_ROMANEI :=   //Após testes definir campo e conteúdo definitivo
           // SC5->C5_ROMIT:=  
           // SC5->(MsUnlock())
            nCt++
        EndIf
    EndIf
    SC5->( dbSkip() )
End

        ApMsgInfo( 'Foram relacionados ' + AllTrim( Str( nCt ) ) + ' pedidos ao romaneio.' )
RestArea( aArea )

Return NIL

