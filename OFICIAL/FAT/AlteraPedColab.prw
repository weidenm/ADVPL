#Include 'PROTHEUS.CH'
#Include 'XMLXFUN.CH'
#Include 'FILEIO.CH'
#Include "FWEVENTVIEWCONSTS.CH"
  
  
User Function MA411Grv()
  
Local aCabPed           := PARAMIXB[1] //Cabeçalho do pedido
Local aItePed           := PARAMIXB[2] //Itens do pedido
Local nOpc              := PARAMIXB[3] //Operação do sistema
Local cXML              := PARAMIXB[4] //Conteúdo do XML
Local nPosQuant         := 0
Local nPosVlrUnit       := 0
Local nPosTotal         := 0
Local nPosTES           := 0   
Local nPosCusto         := 0
Local nPosStore         := 0
Local nPosProd          := 0
Local nX                := 0
Local nY                := 0
Local oXML              := TXMLManager():New()
Local aItens            := {}
  
//-------------------------------------------------------------------
// Parseia o XML.
//------------------------------------------------------------------- 
If ( ! Empty( cXML ) .And. ( oXML:Read( cXML ) ) )
  
    //-------------------------------------------------------------------
    // Recupera os itens do pedido. 
    //-------------------------------------------------------------------         
    aItens          := oXML:XPathGetChildArray( "/BusinessContent/SalesOrderItens" )
     
    nPosCusto     := aScan( aCabPed, { |z| z[1] == "C5_CLIENTE" } )
    nPosStore     := aScan( aCabPed, { |z| z[1] == "C5_LOJACLI" } )
    nPosQuant     := aScan( aItePed[1], {|z| z[1] == "C6_QTDVEN" } )
    nPosVlrUnit   := aScan( aItePed[1], {|z| z[1] == "C6_PRCVEN" } )
    nPosTotal     := aScan( aItePed[1], {|z| z[1] == "C6_VALOR" } )
    nPosProd      := aScan( aItePed[1], { |z| z[1] == "C6_PRODUTO" } )
    nPosTES       := aScan( aItePed[1], { |z| z[1] == "C6_TES" } )
    nPosQtdLib    := aScan( aItePed[1], { |z| z[1] == "C6_QTDLIB" } )     
    // nPosTipLib     := aScan( aCabPed, { |z| z[1] == "C5_TIPLIB" } )  

  //  aCabPed[nPosTipLib][2] := '2'

    For nX := 1 To Len( aItens )


        aItePed[nX][nPosQtdLib][2] := 0 

        dbSelectArea("SB1")
		DbSetOrder(1)
		dbseek(xfilial("SB1")+SC6->C6_PRODUTO) //ALTERAR PARA PARÂMETRO DE PRODUTO

        //Preenche quantidade da segunda unidade de medida com a quantidade do XML.
        nQtde    := Val( oXML:XPathGetNodeValue( aItens[nX][2] +"/Quantity" )    )
        aItePed[nX][nPosQuant][2]  := A410Arred(nQtde / SB1->B1_CONV,"C6_QTDVEN")

        nVlrUnit    := Val( oXML:XPathGetNodeValue( aItens[nX][2] +"/UnityPrice" )    )
          
        //------------------------------------------------------------------- 
        // Altera o preço de venda
        //------------------------------------------------------------------- 
  
        If nVlrUnit > 0
            aItePed[nX][nPosVlrUnit][2] := nVlrUnit * SB1->B1_CONV
            aItePed[nX][nPosTotal][2]   := A410Arred( aItePed[nX][nPosVlrUnit][2] * aItePed[nX][nPosQuant][2] , "C6_VALOR" )
        EndIf
         
        //-------------------------------------------------- ---------------- 
        //          Preenche o TES de acordo com o TES Inteligente
        // Parâmetros da rotina:
        // ExpN1 = Documento de 1-Entrada / 2-Saida                    
        // ExpC2 = Tipo de Operacao Tabela "DF" do SX5                 
        // ExpC3 = Codigo do Cliente ou Fornecedor
        // ExpC4 = Loja do Cliente ou Fornecedor                       
        // ExpC5 = Tipo CF
        // ExpC6 = Produto                          
        // ExpC7 = Campo   
        //------------------------------------------------------------------- 
        aItePed[nX][nPosTES][2] := MaTesInt( 2, '01', aCabPed[nPosCusto][2], aCabPed[nPosStore][2], 'C', aItePed[nX][nPosProd][2] )   
       
    Next nX
EndIf
  
Return{ aCabPed, aItePed }
