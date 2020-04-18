#include "rwmake.ch"
#include "topconn.ch"

User Function TesInteligente

	cCF := "" //<TLM - 23/10/2010 - adicionado porque esta causando erro de variável não existente)
	cSitTrib := ""
	
	CodFi := Alltrim(SC6->C6_CF)
	tes := Alltrim(SC6->C6_TES)

	if   CodFi $ "5910,6910"  //CFOP´s de exceção para não corrigir TES
		Return
	EndIf

	if SC5->C5_TIPO = "N"  //Testar verificação

	//Verifica se cadastro tem TES PADRAO E GRUPO DE TRIBUTAÇÃO PREENCHIDO.
	//Se não tiver o programa é finalizado, pois não há informação para executa-lo.
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SC6->C6_PRODUTO)

		cOrigem := SUBS(SB1->B1_ORIGEM,1,1)
		cTes := ""

		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SC6->C6_CLI)

	
//PREENCHE AHEADER 
/*		aHeader := {}
		nUsado := 0
		DbSelectArea('SX3')
		dbSetOrder(1)
		DbSeek('SC6')
		While !EOF() .And. X3_ARQUIVO == 'SC6'
			If X3Uso(SX3->X3_USADO) .And. cNivel >= X3_NIVEL
				nUsado++
				AADD(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,;
					X3_TAMANHO, X3_DECIMAL, AllTrim(X3_VALID),;
					X3_USADO, X3_TIPO, X3_ARQUIVO } )
			EndIf
			DbSkip()
		EndDo
*/
	
		if trim(SB1->B1_GRTRIB) <> ""
				
//	   cTes := TesIntel(2,"01",SC6->C6_CLI,SC6->C6_LOJA,"C",SC6->C6_PRODUTO,"C6_TES")	

			if (Alltrim(SA1->A1_EST) $ "BA/ES/GO/PE/SE") .or. (Alltrim(SA1->A1_EST) $ ("DF/RJ/MG") .and. Alltrim(SA1->A1_GRPTRIB) $ "001/002") .or.;
					(Alltrim(SA1->A1_EST)="AL" .and.  Alltrim(SB1->B1_GRTRIB) $ ("008/020"))
				cTes := "501"
			Else
				IF (SA1->A1_EST="MG" .and. Alltrim(SA1->A1_GRPTRIB)="" .AND. Alltrim(SB1->B1_GRTRIB)<>"008")
					cTes := "503"
				Else
					IF (Alltrim(SA1->A1_EST)="MG" .and. Alltrim(SA1->A1_GRPTRIB="") .and. Alltrim(SB1->B1_GRTRIB)="008")
						cTes:="506"
					Else
						IF (Alltrim(SA1->A1_EST)="DF" .and. SC6->C6_FILIAL='02' .and. Alltrim(SA1->A1_GRPTRIB)="" .and. Alltrim(SB1->B1_GRTRIB)<>"008") .or.;
								(Alltrim(SA1->A1_EST)="RJ" .and. Alltrim(SA1->A1_GRPTRIB)="" .and. Alltrim(SB1->B1_GRTRIB)="020")
							
							cTes := "504"
						Else
							IF (Alltrim(SA1->A1_EST)="DF" .and. SC6->C6_FILIAL='02' .and. Alltrim(SA1->A1_GRPTRIB)="" .and. Alltrim(SB1->B1_GRTRIB)="008")
								cTes:="507"
							Else
								IF (Alltrim(SA1->A1_EST)="RJ" .and. Alltrim(SA1->A1_GRPTRIB)="" .and. Alltrim(SB1->B1_GRTRIB) <> "020")
									cTes:="508"
								Else
									IF (Alltrim(SA1->A1_EST)="AL" .and. Alltrim(SA1->A1_GRPTRIB)="" .and. Alltrim(SB1->B1_GRTRIB) $ "001/002/003/004/005/006/007")
										cTes:="509"
									Else
										IF (Alltrim(SA1->A1_EST)="DF" .and. SC6->C6_FILIAL='01')
											cTes:="630"
										EndIf
										//conout("Não encontrou nenhuma condição para o cliente")
									EndIf
								EndIf
							EndIf
						EndIf
					EndIF
				EndIf
			EndIf
			//conout("TES:"+cTes)	
		else
			if trim(SB1->B1_TS) <> ""
				alert("produto "+ SB1->B1_COD +" sem Grupo Trib.")
				cTes :=  SB1->B1_TS
			else
				alert("Produto "+ SB1->B1_COD +" sem TS Padrão e Grupo Trib.Não é possível preencher campo de TES.")
				Return
			EndIf
		EndIf
	
		if	Alltrim(cTes)<> ""
	
			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek(xFilial("SF4")+cTes)
	
			aDadosCfo := {}
			AAdd(aDadosCfo,{"OPERNF","S"})
			AAdd(aDadosCfo,{"TPCLIFOR",SA1->A1_TIPO })
			AAdd(aDadosCfo,{"UFDEST"  ,SA1->A1_EST  })
			AAdd(aDadosCfo,{"INSCR"   ,SA1->A1_INSCR})
			if SA1->A1_EST <> 'ES'
				cCF := MaFisCfo( ,SF4->F4_CF,aDadosCfo )
				cSitTrib := SF4->F4_SITTRIB
			else
				cCF := '6'+substring(SF4->F4_CF,2,3)
				cSitTrib := SF4->F4_SITTRIB
			EndIf
			
			//IF Alltrim(SC6->C6_TES) <> Alltrim(cTes)  
				RecLock("SC6",.F.)
				SC6->C6_TES := cTes
				SC6->C6_CF	:= cCF
				SC6->C6_CLASFIS := cOrigem+cSitTrib
				msunlock()
			//EndIf
		Else
			Alert("Não foi encontrado TES para preencher o pedido "+SC6->C6_NUM)
			//conout("Não foi encontrado TES para preencher o pedido "+SC6->C6_NUM)
		EndIf
	
	EndIf
		
Return
	
	//FUNÇÃO PARA PROCURAR CÓDIGO INTELIGENTE

Static Function TesIntel(nEntSai,cTpOper,cClieFor,cLoja,cTipoCF,cProduto,cCampo)
	
	Local aArea		:= GetArea()
	Local aAreaSA1	:= SA1->(GetArea())
	Local aAreaSA2	:= SA2->(GetArea())
	Local aAreaSB1	:= SB1->(GetArea())
	Local aTes 		:= {}
	Local aDadosCfo:= {}
	Local cTesRet	:= "   "
	Local cGrupo	:= ""
	Local cGruProd	:= ""
	Local cTesProd	:= ""
	Local cQuery	:= ""
	Local cProg     := "MT100"
	Local cNCM      := ""
	Local cEstado   := ""
	Local cAliasSFM:= "SFM"
	Local cTabela  := ""
	Local lQuery	:= .F.
	Local nPosCpo	:= 0
	Local nPosCfo  := 0
	
	/*Local cTpOper  := &(ReadVar())
	Local cClieFor := ""
	Local cProduto := ""
	Local nEntSai  := 0
	Local cTipoCF  := "C"
	Local cCampo	  := ""
	*/
	
	/*If !Empty(cCampo)
	nPosCpo	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim(cCampo) })
	cTabela  := "SC6" //aHeader[nPosCpo,9]
	EndIf
	*/
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o grupo de tributacao do cliente/fornecedor         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(IIf(cTipoCF == "C","SA1","SA2"))
	dbSetOrder(1)
	MsSeek(xFilial()+cClieFor+cLoja)
	If cTipoCF == "C"
		cGrupo  := SA1->A1_GRPTRIB
		cEstado := SA1->A1_EST
	Else
		cGrupo  := SA2->A2_GRPTRIB
		cEstado := SA2->A2_EST
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o grupo do produto                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	dbSetOrder(1)
	MsSeek(xFilial("SB1")+cProduto)
	cGruProd := SB1->B1_GRTRIB
	cNCM     := SB1->B1_POSIPI
	cTesProd := SB1->B1_TS
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pesquisa por todas as regras validas para este caso          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	
	
	//if trim(cGruProd) <> ""
	
	#IFDEF TOP
		lQuery := .T.
		cAliasSFM := GetNextAlias()
		cQuery += "SELECT * FROM " + RetSqlName("SFM") + " SFM "
		cQuery += "WHERE SFM.FM_FILIAL = '" + xFilial("SFM") + "'"
		cQuery += "AND SFM.FM_TIPO = '" + cTpOper + "'"
		cQuery += "AND SFM.D_E_L_E_T_=' ' "
		cQuery += "ORDER BY "+SqlOrder(SFM->(IndexKey()))
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSFM,.T.,.T.)
	#ELSE
		dbSelectArea("SFM")
		dbSetOrder(1)
		MsSeek(xFilial("SFM")+cTpOper)
	#ENDIF
	
	While !Eof() .And. (cAliasSFM)->FM_TIPO==cTpOper
		
		If cTipoCF == "C"
			If (Empty((cAliasSFM)->FM_PRODUTO+(cAliasSFM)->FM_CLIENTE+(cAliasSFM)->FM_LOJACLI+(cAliasSFM)->FM_GRTRIB+(cAliasSFM)->FM_GRPROD+IIf(SFM->(FieldPos("FM_POSIPI"))<>0,(cAliasSFM)->FM_POSIPI,"")+IIf(SFM->(FieldPos("FM_EST"))<>0,(cAliasSFM)->FM_EST,"")) .Or.;
					(((cAliasSFM)->FM_PRODUTO == cProduto .Or. Empty((cAliasSFM)->FM_PRODUTO)) .And.;
					(Alltrim(cGruProd) == Alltrim((cAliasSFM)->FM_GRPROD) .Or. Empty((cAliasSFM)->FM_GRPROD)) .And.;
					(cClieFor+cLoja == (cAliasSFM)->FM_CLIENTE+(cAliasSFM)->FM_LOJACLI .Or. Empty((cAliasSFM)->FM_CLIENTE+(cAliasSFM)->FM_LOJACLI)) .And.;
					(cGrupo == (cAliasSFM)->FM_GRTRIB .Or. Empty((cAliasSFM)->FM_GRTRIB)) .And.;
					(SFM->(FieldPos("FM_EST"))==0 .Or. cEstado == (cAliasSFM)->FM_EST .Or. Empty((cAliasSFM)->FM_EST)) .And.;
					(SFM->(FieldPos("FM_POSIPI"))==0 .Or. cNCM == (cAliasSFM)->FM_POSIPI .Or. Empty((cAliasSFM)->FM_POSIPI))))
				
				aadd(aTes, {(cAliasSFM)->FM_PRODUTO,;
					(cAliasSFM)->FM_GRPROD,;
					IIf(SFM->(FieldPos("FM_POSIPI"))<>0,(cAliasSFM)->FM_POSIPI,""),;
					(cAliasSFM)->FM_CLIENTE,;
					(cAliasSFM)->FM_LOJACLI,;
					(cAliasSFM)->FM_GRTRIB,;
					IIf(SFM->(FieldPos("FM_EST"))<>0,(cAliasSFM)->FM_EST,""),;
					(cAliasSFM)->FM_TE,;
					(cAliasSFM)->FM_TS})
				
			EndIf
		Else
			If (Empty((cAliasSFM)->FM_PRODUTO+(cAliasSFM)->FM_FORNECE+(cAliasSFM)->FM_LOJAFOR+(cAliasSFM)->FM_GRTRIB+(cAliasSFM)->FM_GRPROD+IIf(SFM->(FieldPos("FM_POSIPI"))<>0,(cAliasSFM)->FM_POSIPI,"")+IIf(SFM->(FieldPos("FM_EST"))<>0,(cAliasSFM)->FM_EST,"")) .Or.;
					(((cAliasSFM)->FM_PRODUTO == cProduto .Or. Empty((cAliasSFM)->FM_PRODUTO)) .And.;
					(Alltrim(cGruProd) == Alltrim((cAliasSFM)->FM_GRPROD) .Or. Empty((cAliasSFM)->FM_GRPROD)) .And.;
					(cClieFor+cLoja == (cAliasSFM)->FM_FORNECE+(cAliasSFM)->FM_LOJAFOR .Or. Empty((cAliasSFM)->FM_FORNECE+(cAliasSFM)->FM_LOJAFOR)) .And.;
					(cGrupo == (cAliasSFM)->FM_GRTRIB .Or. Empty((cAliasSFM)->FM_GRTRIB)) .And.;
					(SFM->(FieldPos("FM_EST"))==0 .Or. cEstado == (cAliasSFM)->FM_EST .Or. Empty((cAliasSFM)->FM_EST)) .And.;
					(SFM->(FieldPos("FM_POSIPI"))==0 .Or. cNCM == (cAliasSFM)->FM_POSIPI .Or. Empty((cAliasSFM)->FM_POSIPI))))
				
				aadd(aTes,{(cAliasSFM)->FM_PRODUTO,;
					(cAliasSFM)->FM_GRPROD,;
					IIf(SFM->(FieldPos("FM_POSIPI"))<>0,(cAliasSFM)->FM_POSIPI,""),;
					(cAliasSFM)->FM_FORNECE,;
					(cAliasSFM)->FM_LOJAFOR,;
					(cAliasSFM)->FM_GRTRIB,;
					IIf(SFM->(FieldPos("FM_EST"))<>0,(cAliasSFM)->FM_EST,""),;
					(cAliasSFM)->FM_TE,;
					(cAliasSFM)->FM_TS})
				
			EndIf
		EndIf
		dbSelectArea(cAliasSFM)
		dbSkip()
	EndDo
	If ( lQuery )
		dbSelectArea(cAliasSFM)
		dbCloseArea()
		dbSelectArea("SFM")
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pesquisa por todas as regras validas para este caso          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//aSort(aTES,,,{|x,y| x[1]+x[2]+x[3]+x[4]+x[5]+x[6]+x[7] > y[1]+y[2]+y[3]+y[4]+y[5]+x[6]+x[7]})
	
	
	//MELHORAR CÓDIGO PARA CONSIDERAR ALTERAÇÕES DE GRUPOS DE TRIBUTAÇÃO (ORDENS E FORMAS).	
	
	if len(aTes)<>0
		
	//	If cEstado = "MG"
		//	If aTes[1][7] = "MG"
		cTesRet := If(nEntSai==1,aTes[1][8],aTes[1][9])
		//	else
			//	If len(aTes) == 2 .and. aTes[2][7] = "MG"
			//		cTesRet := If(nEntSai==1,aTes[2][8],aTes[2][9])
			//	EndIf
		//	EndIf
	//	Else
		//	If trim(aTes[1][7]) == ""
			//	cTesRet := If(nEntSai==1,aTes[1][8],aTes[1][9])
		//	else
			//	If len(aTes) == 2 .and. trim(aTes[2][7]) == ""
				//	cTesRet := If(nEntSai==1,aTes[2][8],aTes[2][9])
			//	EndIf
		//	EndIf
	//	EndIf
	//else
	//	alert("pedido "+ SC6->C6_NUM +" nao encontrou TES inteligente.")
	//	cTesRet :=  cTesProd
	EndIf
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura a integridade da rotina                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RestArea(aAreaSA2)
	RestArea(aAreaSA1)
	RestArea(aAreaSB1)
	RestArea(aArea)
	
Return(cTesRet)
	

User Function corrigeTES()

cQuery :="SELECT C6_FILIAL, A1_EST, A1_GRPTRIB, A1_TIPO, C6_NUM, C6_ITEM, C6_PRODUTO, C6_TES, B1_GRTRIB "
cQuery += " FROM (SC6010 A INNER JOIN SA1010 B ON A.C6_CLI = B.A1_COD) inner join SB1010 C on A.C6_PRODUTO=C.B1_COD"
cQuery += " WHERE A.D_E_L_E_T_='' AND B.D_E_L_E_T_='' AND C6_NOTA=''"
cQuery += " AND (C6_TES = '510' OR C6_TES='' OR C6_TES='999') " 

	TCQuery cQuery Alias ATUTES New
	
	dbSelectArea("ATUTES")
	ATUTES->(dbGotop())
	ProcRegua(FCount())

	cIndexName := Criatrab(NIL,.F.)
	cIndexKey := "C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO"

	IndRegua("ATUTES", cIndexName, cIndexKey,,,"Aguarde,corrigindo TES no pedido "+ TRIM(ATUTES->C6_NUM)+ " ...")

	Do While (!ATUTES->(Eof()))

		dbSelectArea("SC6")
		dbsetorder(1)
		dbseek(xfilial("SC6")+ATUTES->C6_NUM+ATUTES->C6_ITEM+ATUTES->C6_PRODUTO)
	
		If SC6->(found())
			//conout("CorrigeTES:"+SC6->C6_NUM)
			u_tesinteligente()	
		EndIF
		dbSelectArea("ATUTES")
		ATUTES->(dbskip())
	EndDo
	
	dbCloseArea("ATUTES")
Return	
