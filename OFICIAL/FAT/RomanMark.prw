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
oMark:AddLegend( "EMPTY(C5_NOTA) .AND. !EMPTY(C5_ROMANEI)", "YELLOW" , "Em Romaneio" )

oMark:Activate()

Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina TITLE 'Gerar Romaneio' ACTION 'U_incluirom()' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Parâmetros' ACTION 'U_ParamRom()' OPERATION 2 ACCESS 0
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

    Local aArea := GetArea()
    Local cMarca := oMark:Mark()
    Local lInverte := oMark:IsInvert()

    Local nCt := 0

    Local nSeconds    := 0 // Segundos que iniciou a
    Local nX          := 0 // Contador de Repeticoes

    SC5->( dbGoTop() )
    dbSelectArea("SC5")
    dbSetOrder(2)
    //SC5->(dbSeek(xFilial("SC5")+DTOS(ddatabase-20),.T.)) 
    MsSeek(xFilial("SC5")+DTOS(ddatabase-90))
    nSeconds := Seconds()

    While !SC5->( EOF() )
        If oMark:IsMark(cMarca)
            reclock("SC5",.f.)
            if EMPTY(C5_NOTA)
                If !EMPTY(C5_ROMANEI) 
                    
                    SC5->C5_ROMANEI := ""  //Após testes definir campo e conteúdo definitivo
                    SC5->C5_ROMIT:=  ""
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

