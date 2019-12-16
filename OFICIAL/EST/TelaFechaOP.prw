#INCLUDE 'totvs.ch'
#INCLUDE 'FWMVCDEF.CH'

//-------------------------------------------------------------------
/*/{Protheus.doc} COMP025_MVC
Exemplo de montagem da modelo e interface de marcacao para uma
tabela em MVC
@author Ernani Forastieri e Rodrigo Antonio Godinho
@since 05/10/2009
@version 12.1.25
/*/
//-------------------------------------------------------------------
User Function FechaOP()

Private oMark
Private aRotina := MenuDef()

oMark := FWMarkBrowse():New()
oMark:SetAlias('SC2')
oMark:SetSemaphore(.T.)
oMark:SetDescription('Encerra Ordens de Producao')
oMark:SetFieldMark( 'C2_OK' )
oMark:SetAllMark( { || oMark:AllMark() } )
oMark:AddLegend( "EMPTY(C2_DATRF)", "YELLOW", "Em Aberto" )
oMark:AddLegend( "!EMPTY(C2_DATRF)", "RED" , "Encerrados" )
oMark:Activate()

Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.COMP025_MVC' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Encerra OP' ACTION 'U_EncerraOp()' OPERATION 2 ACCESS 0

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
User Function EncerraOp()

Local aArea := GetArea()
Local cMarca := oMark:Mark()
Local lInverte := oMark:IsInvert()

Local nCt := 0

SC2->( dbGoTop() )
While !SC2->( EOF() )
    If oMark:IsMark(cMarca)
        If EMPTY(C2_DATRF)
            reclock("SC2",.f.)
            SC2->C2_DATRF := ddatabase  //Após testes definir campo e conteúdo definitivo
            SC2->(MsUnlock())
            nCt++
        EndIf
    EndIf
    SC2->( dbSkip() )
End

    ApMsgInfo( 'Foram encerrados ' + AllTrim( Str( nCt ) ) + ' itens de Ordens de Produção.' )
RestArea( aArea )

Return NIL

