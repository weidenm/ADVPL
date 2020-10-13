#INCLUDE 'totvs.ch'
#INCLUDE 'FWMVCDEF.CH'
#Include "PROTHEUS.CH"    
#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
//-------------------------------------------------------------------
/*/ PROGRAMA PARA GERAR PEDIDO DE TRANSFERÊNCIA PARA FILIAL
/*/
//-------------------------------------------------------------------
User Function GeraTransf()

//aPerg := {}
//cPerg := "MONROM"
Private oMark
Private aRotina := MenuDef()

//Pergunte(cPerg,.T.,"Selecao de Romaneio")

oMark := FWMarkBrowse():New()
oMark:SetAlias('SC5')
oMark:SetSemaphore(.T.)
oMark:AddFilter("Pedidos Abertos Filial",  "SC5->C5_FILIAL='02' .AND. SC5->C5_NOTA=''"  ,,.T.,,.T.)
oMark:SetDescription('Geração de Pedido de Transferência')
oMark:SetFieldMark( 'C5_OK' )
oMark:SetAllMark( { || oMark:AllMark() } )
//oMark:AddLegend( "!EMPTY(C5_NOTA)", "RED" , "Faturado" )
oMark:AddLegend( "EMPTY(C5_NOTA) .AND. EMPTY(C5_ROMANEI)", "GREEN", "Aberto" )
oMark:AddLegend( "EMPTY(C5_NOTA) .AND. !EMPTY(C5_ROMANEI)", "YELLOW" , "Em Romaneio" )

oMark:Activate()

Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina TITLE 'Gera Pedido Transf.' ACTION 'U_juntaped()' OPERATION 2 ACCESS 0
//ADD OPTION aRotina TITLE 'Parâmetros' ACTION 'U_ParamTransf()' OPERATION 2 ACCESS 0
//ADD OPTION aRotina TITLE 'Imprimir Romaneio' ACTION 'u_ROMAN()' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.COMP025_MVC' OPERATION 2 ACCESS 0

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
User Function JuntaPed()

    Local aArea := GetArea()
    Local cMarca := oMark:Mark()
    Local lInverte := oMark:IsInvert()

  //  Local nCt := 0
  //  Local nPesoTot := 0
  //  Local nCapacid := 0  //DA3_CAPACN
  //  Local cVeiculo := "" //Z1_VEICULO


   // Local nSeconds    := 0 // Segundos que iniciou a
    Local nX          := 0 // Contador de Repeticoes
    Local nTotal      := 0

  //  aPerg := {}
 //   cPerg := "MONRON"

//	Pergunte(cPerg,.F.)

  //  Public _cRomanei := MV_PAR01
 //   Public _cItRom   := MV_PAR02
    cDataHora :=  Dtoc(date())+" "+time()
    cNumProx := ""
	
	cQuery:= "SELECT MAX(C5_NUM) MAXCOD FROM SC5010"
	cQuery+= " WHERE  D_E_L_E_T_=''  AND C5_NUM < '200000' " 
			
	TCQuery cQuery Alias ULTPED New
	cNumProx := strzero(val(ULTPED->MAXCOD)+1,6)
    ULTPED->(DbCloseArea())
	

   // DBUseArea(.F., 'TOPCONN', SC5, (SC5), .F., .T.)
  //  (SC5)->(DbSetFilter({|| SC5->C5_FILIAL='02' .AND. SC5->C5_NOTA='' }, "SC5->C5_FILIAL=02")

/*
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
  */        
          
	
			ItPed := 0
	//******************************************
    //*****  JUNTA ITENS DOS PEDIDOS    ********
	//******************************************
    		If Select("ITENSPED") > 0
					dbSelectArea("ITENSPED")
					dbCloseArea()
			EndIf

            cQuery := " SELECT B1_GRUPO,C6_PRODUTO, B1_DESC, ISNULL(DA1_PRCVEN,0) PRCTABELA,C6_UM, MAX(C6_PRCVEN) MAX_PRCVEN, SUM(C6_QTDVEN) QTDVEN "
            cQuery += " FROM ((SRVPP01.DADOS12.dbo.SC6010 A INNER JOIN SRVPP01.DADOS12.dbo.SC5010 B ON A.C6_NUM = B.C5_NUM) "
            cQuery += " left join DA1010  C ON C.DA1_CODTAB = '007' AND C.DA1_FILIAL='01' AND C.DA1_CODPRO=A.C6_PRODUTO) "
            cQuery += "  INNER JOIN SB1010 D ON A.C6_PRODUTO = D.B1_COD "
			cQuery += "  WHERE A.D_E_L_E_T_ = '' AND  B.D_E_L_E_T_ = '' AND (C.D_E_L_E_T_ ='' OR C.DA1_CODPRO IS NULL) AND C5_OK  = '"+ cMarca +"'
            cQuery += " GROUP BY B1_GRUPO,C6_PRODUTO, B1_DESC,  ISNULL(DA1_PRCVEN,0), C6_UM " 
			cQuery += " ORDER BY B1_GRUPO,B1_DESC"
			//conout(cQuery)
			TCQuery cQuery Alias ITENSPED New
			//conout("Consulta de dados concluida -"+time())
			
			dbSelectArea("ITENSPED")
			
			While ! ITENSPED->(Eof()) 

			//	conout("gravação item "+ITENSPED->C6_ITEM+"-"+time())
			//	dbSelectArea("SC6")
			//	dbsetorder(1)
			//	dbseek(xfilial("SC6")+ITENSPED->C6_NUM+ITENSPED->C6_ITEM)
	/*			
				If ! SC6->(found())
		*/
					ItPed += 1	
					RecLock("SC6",.t.)
					SC6->C6_NUM:=cNumProx
					SC6->C6_ITEM:=STRZERO(ItPed,2)        
					SC6->C6_FILIAL:= '01'
					SC6->C6_PRODUTO:=ITENSPED->C6_PRODUTO
					SC6->C6_DESCRI:=ITENSPED->B1_DESC
					SC6->C6_UM:=ITENSPED->C6_UM
					SC6->C6_QTDVEN:=ITENSPED->QTDVEN
					IF ITENSPED->PRCTABELA > 0
                        SC6->C6_PRCVEN:= ITENSPED->PRCTABELA
                        SC6->C6_PRUNIT := ITENSPED->PRCTABELA
                        SC6->C6_VALOR:= ITENSPED->PRCTABELA * ITENSPED->QTDVEN
                    ELSE
                        SC6->C6_PRCVEN:= ITENSPED->MAX_PRCVEN
                        SC6->C6_VALOR:= ITENSPED->MAX_PRCVEN * ITENSPED->QTDVEN
                         SC6->C6_PRUNIT := ITENSPED->MAX_PRCVEN
                    ENDIF 
				//	SC6->C6_SEGUM:=ITENSPED->C6_SEGUM
					SC6->C6_TES:='503' //ITENSPED->C6_TES
				//	SC6->C6_UNSVEN:=ITENSPED->C6_UNSVEN
					SC6->C6_LOCAL:='01' //ITENSPED->C6_LOCAL
					SC6->C6_CF:= '6101' //ITENSPED->C6_CF
					SC6->C6_CLI:= '200264' //ITENSPED->C6_CLI
					//SC6->C6_DESCONT:=ITENSPED->C6_DESCONT
					SC6->C6_ENTREG:= ddatabase //STOD(ITENSPED->C6_ENTREG)
					SC6->C6_LOJA:= '01' //ITENSPED->C6_LOJA
					//SC6->C6_COMIS1:=ITENSPED->C6_COMIS1
					SC6->C6_CLASFIS:= '010' //ITENSPED->C6_CLASFIS
					SC6->C6_DTCRIA := cDataHora
							
				
					SC6->(MsUnlock())
				//	conout("Item gravado-"+time())
					
                    nTotal += ITENSPED->QTDVEN
//				EndIf

				dbSelectArea("ITENSPED")
				ITENSPED->(dbskip())
			EndDo

            //*****************
            
            dbSelectArea("SC5")
            dbSetOrder(2)
            SC5->(dbSeek(xFilial("SC5")+cNumProx,.T.)) 
            
        If ! SC5->(found())
		
			RecLock("SC5",.t.)
		    SC5->C5_NUM:=cNumProx
			SC5->C5_FILIAL := '01'
            SC5->C5_CLIENTE:='200264'
			SC5->C5_LOJACLI:='01'
			SC5->C5_CLIENT:='200264'
			SC5->C5_LOJAENT:='01'
			SC5->C5_VEND1:='000009'
			SC5->C5_TIPO:='N'
			SC5->C5_TIPOCLI:='S'
			SC5->C5_CONDPAG:='001'
			SC5->C5_EMISSAO:= ddatabase //STOD(dDatabase)
			SC5->C5_VOLUME1:= nTotal
			SC5->C5_TXMOEDA:=1
			SC5->C5_TPCARGA:="1"
			SC5->C5_DTSAIDA:= ddatabase
			SC5->C5_TPFRETE:=  "C"
			SC5->C5_ESPECI1:='UN'
			//SC5->C5_VOLUME1:= 
			SC5->C5_TABELA := '007'
			SC5->C5_DTCRIA := cDataHora

			SC5->(MsUnlock())
		
        EndIf

        ApMsgInfo( 'Gerado pedido de transferência número ' + cNumProx +" com total de "+ str(nTotal) + " unidades.")
RestArea( aArea )

Return NIL

/*
User Function ParamRom()

aPerg := {}
cPerg := "MONROM"

Pergunte(cPerg,.T.,"Seleção de Romaneio")

//Public _cRomanei := MV_PAR01
//Public _cItRom   := MV_PAR02

Return
*/
