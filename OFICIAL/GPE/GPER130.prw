#Include "PROTHEUS.ch" 
#Include "GPER130.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GPER130  � Autor � R.H.-Mauro - 12.1.25  � Data � 26.04.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Recibo de Ferias                                           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GPER130(void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS  �  Motivo da Alteracao                    ���
�������������������������������������������������������������������������Ĵ��
���Carlos E. O.�11/11/13�M12RH01� Retirada da funcao AjustaSx1 para       ���
���            �        �196704 � inclusao do fonte na P12.               ���
���Sidney O.   �27/08/14�TPZPWZ � Criada validacao para as datas do grupo ���
���            �        �       � de perguntas GPR130.                    ���
���Flavio Corr �16/06/15�TSPUL3 � Corre��o busca de ferias na SRF para    ���
���            �        �       � aviso ferias calculadas                 ���
���Renan Borges�30/12/15�TUCPPB � Ajuste para imprimir recibo de abono de ���
���            �        �       � f�rias corretamente independentemente   ���
���            �        �       � do filtro utilizado nos parametros.     ���
���            �        �       � aviso ferias calculadas                 ���
���Gustavo M.  �01/03/16�TUOZGY � Ajuste para posicionar corretamente ao  ���
���            �        �       � dar o loop da SRA.					  ���
���P. Pompeu   �04/04/16�TUUDL2 � Corre��o Valid. Pergunte Data Final     ���
���Gabriel A.  �21/09/16�TVYMFC � Ajuste para gerar as verbas de          ���
���            �        �       � periculosidade no recibo de abono.      ���
��|Claudinei S.|28/04/17|MRH-482|Ajustada FImprAvi() para considerar corre|��
��|            |        |       |tamente as faltas dos funcion�rios com   |��
��|            |        |       |Regime de Tempo Parcial quando elas forem|��
��|            |        |       |inferiores a 8 faltas.                   |��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xGPER130()
//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Basicas)                            �
//����������������������������������������������������������������
Local cString  := "SRA"                // ALIAS DO ARQUIVO PRINCIPAL (BASE)
Local aOrd     := {STR0001,STR0002,STR0010,STR0009} 	//" Matricula "###" C.Custo + Matric" ### "C.Custo + Nome" ### "Nome"
Local nTotregs,nMult,nPosAnt,nPosAtu,nPosCnt,cSav20,cSav7 // REGUA
Local cDesc1   := STR0003	//"Aviso / Recibo de F�rias "
Local cDesc2   := STR0004	//"Ser� impresso de acordo com os parametros solicitados pelo"
Local cDesc3   := STR0005	//"usu�rio."
Local cSavAlias,nSavRec,nSavOrdem    
Local lPnm070TamPE := ExistBlock( "PNM070TAM" )

//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Basicas)                            �
//����������������������������������������������������������������
Private aReturn := {STR0006, 1,STR0007, 1, 2, 1, "",1 }	// "Zebrado"###"Administra��o"
Private nomeprog:="GPER130"
Private anLinha := { },nLastKey := 0
Private cPerg   :="GPR130"
Private aStruSRF	:= {}   
//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Programa)                           �
//����������������������������������������������������������������
Private cPd13o := Space(3)
Private aCodFol := {}     // Matriz com Codigo da folha
   
//��������������������������������������������������������������Ŀ
//� Variaveis UtinLizadas na funcao IMPR                         �
//����������������������������������������������������������������
Private Titulo  := STR0008		//"RECIBO E AVISO DE FERIAS"
Private AT_PRG  := "GPER130"
Private wCabec0 := 3
Private wCabec1 := ""
Private wCabec2 := ""
Private wCabec3 := ""
Private CONTFL  := 1
Private nLi     := 0
Private nTamanho:= "P"

SetMnemonicos(xFilial("RCA"),NIL,.T.,"P_REGPARCI")
P_REGPARCI	:= If( Type("P_REGPARCI") == "U", .F. , P_REGPARCI)

cSavAlias := Alias()
nSavRec   := RecNo()
nSavOrdem := IndexOrd()   

If lPnm070TamPE
 	IF ( ValType( uRetBlock := ExecBlock("PNM070TAM",.F.,.F.))  == "C" )
   	   nTamanho := uRetBlock
	Endif
EndIf

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte("GPR130",.F.)
   
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="GPER130"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

If nLastKey = 27
	Return
Endif

If IsBlind()
	aReturn[5] := 1
	aReturn[6] := "GPER130"
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
Endif
   
RptStatus({|lEnd| GP130Imp(@lEnd,wnRel,cString)},Titulo)

dbselectarea(cSavAlias)
dbsetorder(nSavOrdem)
dbgoto(nSavrec)
    
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GP130imp � Autor � R.H. - Mauro          � Data � 26.04.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Recibo de Ferias                                           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GPER130(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function GP130IMP(lEnd,WnRel,cString)
//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Programa)                           �
//����������������������������������������������������������������

//Arrays
Local aPeriodos  := {}

//Logicas
Local lTemCpoProg
Local lUltSemana

//Numericas
Local nImprVias
Local nCnt
Local i
Local nPosSem
Local nPosTbFer		:= 0 
Local nTempoParc	:= 0

//Strings
Local cRot 			:= ""
Local cTipoRot 		:= ""
Local cPeriodo		:= ""
Local cSemana       := ""
Local cAnoMes       := ""

/*
��������������������������������������������������������������Ŀ
� Variaveis de Acesso do Usuario                               �
����������������������������������������������������������������*/
Local cAcessaSRA	:= &( " { || " + ChkRH( "GPER130" , "SRA" , "2" ) + " } " )

Private nSol13,nSolAb,nRecib,nRecAb,nRec13,cFilDe,cFilAte
Private cMatDe,cMatAte,cCcDe,cCcAte,cNomDe,cNomAte,cDtSt13
Private nFaltas	:= Val_Salmin:=0
Private Salario	:= SalHora := SalDia := SalMes := nSalPg := 0.00
Private lAchou		:= .F.
Private aInfo		:= {}
Private aTabFer		:= {}    			// Tabela para calculo dos dias de ferias
Private aTabFer2	:= {}				// Tabela para calculo dos dias de ferias para regime de tempo parcial
Private aCodBenef	:= {}
Private nAviso,lImpAv,dDtfDe,dDtfAte,nImprDem

Private DaAuxI		:= Ctod("//")
Private DaAuxF		:= Ctod("//")
Private cAboAnt	:= If(GetMv("MV_ABOPEC")=="S","1","2") //-- Abono antes ferias
Private cAboPec	:= ""

Private aVerbsAbo		:= {}
Private aVerbs13Abo	:= {}

//��������������������������������������������������������������Ŀ
//� Variaveis Utilizadas para Parametros                         �
//����������������������������������������������������������������
nOrdem  := aReturn[8]
nSol13  := mv_par01     //  SoLic. 1o. Parc. 13o.
nSolAb  := mv_par02     //  SoLic. Abono Pecun.
nAviso  := mv_par03     //  Aviso de Ferias
nRecib  := mv_par04     //  Recibo de Ferias
nRecAb  := mv_par05     //  Recibo de Abono
nRec13  := mv_par06     //  Recibo 1� parc. 13o.
nDtRec  := mv_par07     //  Imprime Periodo de Ferias
dDtfDe  := mv_par08     //  Periodo de Ferias De
dDtfAte := mv_par09     //  Periodo de Ferias Ate
cFilDe  := mv_par10     //  FiLial De
cFilAte := mv_par11     //  FiLial Ate
cMatDe  := mv_par12     //  Matricula De
cMatAte := mv_par13     //  Matricula Ate
cCcDe   := mv_par14     //  Centro De Custo De
cCcAte  := mv_par15     //  Centro De Custo Ate
cNomDe  := mv_par16     //  Nome De
cNomAte := mv_par17     //  Nome Ate
dDtSt13 := mv_par18     //  Data SoLic. 13o.
nVias   := mv_par19     //  No. de Vias
dDtPgDe := mv_par20	    //  Data de Pagamento De
dDtPgAte:= mv_par21	    //  Data de Pagamento Ate

//�������������������������������������������������������������Ŀ
//� Verifica a base instalada, se for Brasil utiliza o param,	�
//� caso contrario, fixa o param como 2 (Nao Imprime Demitidos)	�
//���������������������������������������������������������������
nImprDem:= Iif( cPaisLoc == "BRA", mv_par22, 2 )
nDAbnPec:= IiF (cPaisLoc == "BRA", mv_par23, 15)
//��������������������������������������������������������������Ŀ
//� Verifica a existencia dos campos de programacao ferias no SRF�
//����������������������������������������������������������������
lTemCpoProg := fTCpoProg()

//��������������������������������������������������������������Ŀ
//� Pocisiona No Primeiro Registro Selecionado                   �
//����������������������������������������������������������������
dbSelectArea("SRA")
   
If nOrdem == 1
	dbSetOrder(1)
ElseIf nOrdem == 2
	dbSetOrder(2)
ElseIf nOrdem == 3
	dbSetOrder(8)
ElseIf nOrdem == 4
	dbSetOrder(3)
Endif
   
If nOrdem == 1
	dbSeek( cFilDe + cMatDe,.T. )
	cInicio  := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim     := cFilAte + cMatAte
ElseIf nOrdem == 2
	dbSeek( cFilDe + cCcDe + cMatDe,.T. )
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim     := cFilAte + cCcAte + cMatAte
ElseIf nOrdem = 3
	dbSeek(cFilDe + cCcDe + cNomDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME"
	cFim     := cFilAte + cCcAte + cNomAte
ElseIf nOrdem = 4
	dbSeek(cFilDe + cNomDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim     := cFilAte + cNomAte + cMatAte
Endif

//--Setar impressora                     
@ 0,0 psay Avalimp(080) 

//��������������������������������������������������������������Ŀ
//� Carrega Regua de Processamento                               �
//����������������������������������������������������������������
SetRegua(RecCount())
   
While !Eof() .And. &cInicio <= cFim

    nLi:= 0

	//��������������������������������������������������������������Ŀ
	//� Movimenta Regua de Processamento                             �
	//����������������������������������������������������������������
	IncRegua()

	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	Endif	 

	//��������������������������������������������������������������Ŀ
	//� Consiste Parametrizacao do Intervalo de Impressao            �
	//����������������������������������������������������������������
	If (SRA->RA_MAT < cMatDe) .Or. (SRA->RA_MAT > cMatAte) .Or. ;
		(SRA->RA_CC  < cCcDe ) .Or. (SRA->RA_CC  > cCcAte) .Or.;
		(SRA->RA_NOME < cNomDe) .Or. (SRA->RA_NOME > cNomAte) 
		SRA->(dbSkip(1))
		Loop
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Consiste Situacao do Funcionario                             �
	//� Inclusao do tratamento para Imprime Demitidos S/N no Brasil. �
	//� Se nao for Brasil considera-se o param como 2 (Nao imprime)	 �
	//����������������������������������������������������������������	
   	If SRA->RA_SITFOLH $ "D" .AND. nImprDem <> 1	// 1 - Imprime Demitido = Sim
		SRA->(dbSkip(1))
		Loop
	Endif
		                                                                    
	/*
	�����������������������������������������������������������������������Ŀ
	�Consiste Filiais e Acessos                                             �
	�������������������������������������������������������������������������*/
    If !( SRA->RA_FILIAL $ fValidFil() ) .Or. !Eval( cAcessaSRA )
		dbSelectArea("SRA")
      	dbSkip()
       	Loop
	EndIF

	//��������������������������������������������������������������Ŀ
	//| Carrega tabela para apuracao dos dias de ferias - aTabFer    |
	//| 1-Meses Periodo    2-Nro Periodos   3-Dias do Mes    4-Fator |
	//����������������������������������������������������������������
	
	cProcesso 	:= SRA->RA_PROCES
	cTipoRot	:= "3"
	cRot 		:= fGetCalcRot(cTipoRot)

	//��������������������������������������������������������������Ŀ
	//� Carrega o periodo atual de calculo (aberto)                  �
	//����������������������������������������������������������������
	fGetLastPer( @cPeriodo,@cSemana , cProcesso, cRot , .T., .F., @cAnoMes )
	
	aPeriodo    := {}
	aVerbsAbo   := {}
	aVerbs13Abo := {}
	
	//Carrega todos os dados do periodo
	fCarPeriodo( cPeriodo , cRot , @aPeriodo, @lUltSemana, @nPosSem)
		    
	If Len(aPeriodo) == 0
		dbSelectArea("SRA")		    
		SRA->(dbSkip(1))
		Loop		
	Else
    	dDataDe := aPeriodo[nPosSem,3]
    	dDataAte := aPeriodo[nPosSem,4]		
	EndIf

	fTab_Fer(@aTabFer,,@aTabFer2)

	//Se as horas semanais forem inferiores a 26, e o Mnemonico P_REGPARCI estiver ativo,
	//utiliza os dias de f�rias da tabela S065 - Tabela de f�rias tempo parcial (Artigo 130A da CLT)
	If cPaisLoc == "BRA"
		nTempoParc := SRA->RA_HRSEMAN
		If SRA->RA_HOPARC == "1" .And. nTempoParc <= 25 .And. nTempoParc  > 0 .And. Len(aTabFer2) > 0	.And. P_REGPARCI
			nPosTbFer := Ascan(aTabFer2, { |X|  nTempoParc <= X[6] .And. nTempoParc > X[5] })
			If nPosTbFer > 0
				aTabFer := aClone(aTabFer2[nPosTbFer])
			Endif
		Endif
	EndIf

	lAchou := .F.      
	lImpAv := If(nAviso==1 .or. nSolAb==1 .or. nSol13==1,.T.,.F.)   // Imprime Aviso e/ou So.Abono e/ou Sol.1.Parc.13. s/Calcular

	//��������������������������������������������������������������Ŀ
	//� Procura No Arquivo de Ferias o Periodo a Ser Listado         �
	//����������������������������������������������������������������
	dbSelectArea("SRH" )
   	If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
   		aPeriodos := {}
		While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT == SRH->RH_FILIAL + SRH->RH_MAT
			If ( !(cPaisLoc $ "ANG") .And. (SRH->RH_DATAINI >= dDtfDe .And. SRH->RH_DATAINI <= dDtfAte) .And.;
			   (SRH->RH_DTRECIB >= dDtPgDe .And. SRH->RH_DTRECIB <= dDtPgAte) ) .OR. ;
			   ( (cPaisLoc $ "ANG") .And. (SRH->RH_DTRECIB >= dDtPgDe .And. SRH->RH_DTRECIB <= dDtPgAte) )
				AAdd(aPeriodos, Recno() )
			EndIf
			dbSkip()
		Enddo

		//��������������������������������������������������������������Ŀ
		//� Imprime Aviso de Ferias Caso nao tenha calculado             �
		//����������������������������������������������������������������
		If Len(aPeriodos) == 0
			dbSelectArea( "SRA" )
			If lImpAv
			   FImprAvi(lTemCpoProg)
			Endif		
			dbSelectArea( "SRA" )
			dbSkip()
			Loop
		Endif
		
		For nCnt := 1 To Len(aPeriodos)
			dbSelectArea( "SRH" )
			dbGoTo(aPeriodos[nCnt])

			//��������������������������������������������������������������Ŀ
			//� Carrega Matriz Com Dados da Empresa                          �
			//����������������������������������������������������������������
			fInfo(@aInfo,SRA->RA_FILIAL)
         
			//��������������������������������������������������������������Ŀ
			//� Carrega Variaveis Codigos da Folha                           �
			//����������������������������������������������������������������
			If !FP_CODFOL(@aCodFol,SRA->RA_FILIAL)
				Return
			Endif
         
			DaAuxI := SRH->RH_DATAINI
			DaAuxF := SRH->RH_DATAFIM

			If nRec13 == 1
				//��������������������������������������������������������������Ŀ
				//� Monta a Variavel na Lista Para Nao Aparecer Recibo de Ferias �
				//� e Sim No Recibo De Abono e 13o.                              �
				//����������������������������������������������������������������
				cPd13o := aCodFol[22,1]
				//��������������������������������������������������������������Ŀ
				//� Busca os codigos de pensao definidos no cadastro beneficiario�
				//����������������������������������������������������������������
				fBusCadBenef(@aCodBenef, "131", {aCodfol[172,1]})
			Endif

			If nRecAb == 1
			
				//Verbas encontradas no GPEXIDC.PRX com 'abono' na descricao
				//			
				aAdd(aVerbsAbo, aCodFol[74,1])
				aAdd(aVerbsAbo, aCodFol[205,1])
				aAdd(aVerbsAbo, aCodFol[617,1])
				aAdd(aVerbsAbo, aCodFol[622,1])												
				aAdd(aVerbsAbo, aCodFol[623,1])
				
				For i := 632 To 635
					aAdd(aVerbsAbo, aCodFol[i,1])
				Next				
																				
				//Verbas encontradas no GPEXIDC1.PRX com 'abono' na descricao
				//				
				For i := 1312 To 1327
					aAdd(aVerbsAbo, aCodFol[i,1])
				Next

				aAdd(aVerbsAbo, aCodFol[1330,1])				
				aAdd(aVerbsAbo, aCodFol[1331,1])								
				
				aAdd(aVerbsAbo, aCodFol[1407,1])
				aAdd(aVerbsAbo, aCodFol[1408,1])
				aAdd(aVerbsAbo, aCodFol[1409,1])
				aAdd(aVerbsAbo, aCodFol[1410,1])
								
				aAdd(aVerbs13Abo, aCodFol[79,1])
				aAdd(aVerbs13Abo, aCodFol[206,1])				
								
			Endif			
						
	       lAchou := .T.   
			For nImprVias := 1 to nVias
				 ExecBlock("IMPFER",.F.,.F.)
			Next nImprVias
			lImpAv := .F.
	    Next nCnt
    EndIf
	//��������������������������������������������������������������Ŀ
	//� Imprime Aviso de Ferias Caso nao tenha calculado             �
	//����������������������������������������������������������������	
	If lImpAv
	   FImprAvi(lTemCpoProg)
	Endif

	dbSelectArea("SRA")
	dbSkip()
Enddo
   
//��������������������������������������������������������������Ŀ
//� Termino do relatorio                                         �
//����������������������������������������������������������������
dbSelectArea("SRA")
Set Filter to 
dbsetorder(1)
   
Set Device To Screen
If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif
MS_FLUSH()

*-----------------------------
Static Function FImprAvi(lTemCpoProg)
*-----------------------------
Local dDtIniProg,nDiasAbono,nDiasFePro,nDiasDedFer
Local nImprVias
Local cQry		:= ""
Local cData		:= dtos(dDtfDe)
Local cData1	:= dTos(dDtfAte)
Local nX		:= 1

lMetadeFal := If( Type("lMetadeFal") == "U", .F. , lMetadeFal)
lTempoParc := If( Type("lTempoParc") == "U", .F. , lTempoParc)

If nAviso==1 .or. nSolAb==1 .or. nSol13==1 // Imprimi Aviso e/ou Sol.Abono e/ou Sol1.Parc.13. sem calcular

	aStruSRF  := If(Empty(aStruSRF),SRF->(dbStruct()),aStruSRF)	
	
	cQry := GetNextAlias()
	BEGINSQL ALIAS cQry
			SELECT *
			FROM %table:SRF% SRF
			WHERE SRF.%notDel% 
			AND RF_FILIAL= %exp:SRA->RA_FILIAL%
			AND RF_MAT=%exp:SRA->RA_MAT%
			AND RF_STATUS=%exp:'1'%
			AND ( (RF_DATAINI BETWEEN %exp:cData% AND %exp:cData1%) OR (RF_DATINI2 BETWEEN %exp:cData% AND %exp:cData1%)  OR (RF_DATINI3 BETWEEN %exp:cData% AND %exp:cData1%))
			ORDER BY RF_DATABAS 
	ENDSQL
	For nX := 1 To Len(aStruSRF)
		If ( aStruSRF[nX][2] <> "C" )
			TcSetField(cQry,aStruSRF[nX][1],aStruSRF[nX][2],aStruSRF[nX][3],aStruSRF[nX][4])
		EndIf
	Next nX
	
	//-- Verifica se no Arquivo SRF Existe Periodo de Ferias
	If !(cQry)->(Eof())
		dDtIniProg := CTOD("")
		nDiasFePro := 0
		nDiasAbono := 0
		If (cQry)->RF_DATAINI >= dDtfDe .And. (cQry)->RF_DATAINI <= dDtfAte
			dDtIniProg := (cQry)->RF_DATAINI                    
			nDiasFePro := If(lTemCpoProg, (cQry)->RF_DFEPRO1, 0)
			nDiasAbono := If(lTemCpoProg, (cQry)->RF_DABPRO1, 0)
		ElseIf lTemCpoProg
			If (cQry)->RF_DATINI2 >= dDtfDe .And. (cQry)->RF_DATINI2 <= dDtfAte
				dDtIniProg := (cQry)->RF_DATINI2
				nDiasFePro := (cQry)->RF_DFEPRO2
				nDiasAbono := (cQry)->RF_DABPRO2
			ElseIf (cQry)->RF_DATINI3 >= dDtfDe .And. (cQry)->RF_DATINI3 <= dDtfAte
				dDtIniProg := (cQry)->RF_DATINI3
				nDiasFePro := (cQry)->RF_DFEPRO3
				nDiasAbono := (cQry)->RF_DABPRO3
			EndIf
		EndIf
		If !Empty(dDtIniProg)
			//��������������������������������������������������������������Ŀ
			//� Carrega Matriz Com Dados da Empresa                          �
			//����������������������������������������������������������������				
			fInfo(@aInfo,SRA->RA_FILIAL)
			nDferven := nDferave := 0
			If (cQry)->RF_DVENPEN > 0 .And. !Empty((cQry)->RF_IVENPEN)
		 		M->RH_DATABAS := (cQry)->RF_IVENPEN
				M->RH_DBASEAT := (cQry)->RF_FVENPEN
				nDferven       := (cQry)->RF_DVENPEN
			Else
		  		M->RH_DATABAS := (cQry)->RF_DATABAS
				M->RH_DBASEAT := fCalcFimAq((cQry)->RF_DATABAS)
				If nDiasFePro > 0
					nDferven := nDiasFePro
				Else
					//Calc_Fer(SRF->RF_DATABAS,dDatabase,@nDferven,@nDferave)
					nDferven := (cQry)->RF_DFERVAT
					nDferven := If (nDferVen <= 0,nDferave,nDferven)
				EndIf
			EndIf
			
			nDiasAviso 		:= GetNewPar("MV_AVISFER",aTabFer[3])  // Dias Aviso Ferias
			
			If !empty((cQry)->RF_ABOPEC)
				cAboPec := (cQry)->RF_ABOPEC
			Else	          
				cAboPec := cAboAnt		//-- cAboPec = 1 -> considera abono antes do periodo de gozo de ferias 
			EndIf

			M->RH_DTAVISO  := fVerData(dDtIniProg - (If (nDiasAviso > 0, nDiasAviso,aTabFer[3]))) 
			M->RH_DFERIAS  := If( nDFerven > aTabFer[3] , aTabFer[3] , nDFerven )
			M->RH_DTRECIB  := If(cAboPec=="1" .and. nDiasAbono > 0,DataValida(DataValida((dDtIniProg-nDiasAbono)-1,.F.)-1,.F.), DataValida(DataValida(dDtIniProg-1,.F.)-1,.F.))
			M->RF_TEMABPE  := (cQry)->RF_TEMABPE
	
			If (cQry)->RF_TEMABPE == "S" .And. !lTemCpoProg
				M->RH_DFERIAS -= If(nDiasAbono > 0, nDiasAbono, 10)
			Endif

			//--Abater dias de ferias Antecipadas
			If (cQry)->RF_DFERANT > 0
				M->RH_DFERIAS := Min(M->RH_DFERIAS, aTabFer[3]-(cQry)->RF_DFERANT)
			Endif

			// Abate Faltas  do cad. Provisoes 
			If (cQry)->RF_DFALVAT > 5
				nDFaltaV:= (cQry)->RF_DFALVAT
				TabFaltas(@nDFaltaV)                                                    

				If (nDFaltaV > 0 .and. nDiasAbono > 0 ) 
				            
				//�����������������������������������������������������������������������������������Ŀ
				//�  Se tiver faltas e abono, calcular os dias de ferias\abono proporcional as faltas.|
				//�	 Exemplo: 20 dias ferias                                                          |
		   	    //�	          10 dias de abono e                                                      |
				//� 		  10 Faltas = deduzir 6 dias das ferias. 		 					      |
				//�           Regra do abono: 1/3 dos dias de ferias.                                 |
				//�			  Como funcionario teve 10 faltas, ele tem direito a apenas 24 dias de    |
				//�           ferias, e nao 30. Os dias de feria e abono devem ser proporcionais aos  |
				//�           dias de direito de ferias.                                              |
				//�           Dias de Direito = 24													  |
   		        //�           Dias de Abono   =  8 (24 / 3 = 1/3 dos dias de direito )                |
   	    	    //�           Dias de Ferias  = 16 (24 - 8 dias de abono) 							  |
   	    	    //�           Total de Ferias + Abono  = 24 Dias 									  |
				//�������������������������������������������������������������������������������������

					nDiasDedFer   := ( nDiasFePro - ( If(!lMetadeFal, If(!lTempoParc, nDFaltaV, 0), nDiasFePro / 2) - nDiasAbono ) )
					
					If nDiasDedFer > 0  
						M->RH_DFERIAS := nDiasDedFer - NoRound( ( ( nDiasFePro + nDiasAbono ) - If(!lMetadeFal, If(!lTempoParc, nDFaltaV, 0), nDiasFePro / 2) ) / 3 )
					Else	
						M->RH_DFERIAS -= (If(!lMetadeFal, If(!lTempoParc, nDFaltaV, 0), nDiasFePro / 2))				
					EndIf	
	
				Else	
					M->RH_DFERIAS -= (If(!lMetadeFal, If(!lTempoParc, nDFaltaV, 0), nDiasFePro / 2))
				EndIf	
			Endif			
	
			M->RH_PERC13S := (cQry)->RF_PERC13S
	
			DaAuxI := dDtIniProg
			DaAuxF := dDtIniProg + M->RH_DFERIAS - 1
	
			If M->RH_DFERIAS > 0
				For nImprVias := 1 to nVias
					ExecBlock("IMPFER",.F.,.F.)
				Next
			Endif
		EndIf
	Endif
	(cQry)->(dbCloseArea())
Endif	

Return

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FAbPecun	�Autor  �Gustavo M.			 � Data �  22/06/2012 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ajuste de  perguntas.                                       ���
���          �                                                            ���                                                k
�������������������������������������������������������������������������͹��
���Uso       � GPER130                                                    ���
�������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������� /*/ 

Function FAbPecun()
      
IF MV_PAR23 < 15      
	MsgInfo( OemToAnsi(STR0012) )
	MV_PAR23 := 15
Endif	     

Return

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �G130ValData�Autor  �Equipe RH           � Data �  25/07/2014 ���
��������������������������������������������������������������������������͹��
���Desc.     �Compara datas                                                ���
���          �                                                             ���                                                k
��������������������������������������������������������������������������͹��
���Uso       � GPER130                                                     ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������ /*/ 

Static Function G130ValD(dDataIni, dDataFim)
	Local lRet

	If !Empty(dDataFim)
		lRet := dDataFim >= dDataIni
	
		If !lRet      
			MsgInfo( STR0013 )
		Endif
	EndIf

Return lRet