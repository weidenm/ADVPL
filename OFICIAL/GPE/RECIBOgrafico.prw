#INCLUDE "recibo.ch"
#INCLUDE "RWMAKE.CH"
//#INCLUDE "INKEY.CH"

#IFNDEF CRLF
        #DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Recibo	� Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao de Recibos de Pagamento                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GPER030(void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
��� Mauro      �14/03/01�------� Colocado DbsetOrder Src,causava erro Top ���
��� J. Ricardo �16/02/01�------� Utilizacao da data base como parametro   ���
���            �        �      � para impressao.                          ���
��� Emerson    �27/04/01�------�Ajustes para tratar a pensao alimenticia a���
���            �--------�------�partir do cadastro de beneficiarios(novo) ���
��� Natie      �24/08/01�------� Inclusao PrnFlush()-Descarrega Spool     ���
��� Natie      �24/08/01�ver609�fSendDPagto()-Envio de E-mail Demont.Pagto���
��� Natie      �29/08/01�009963�PrnFlush-Descarrega spool impressao teste ���
��� Marinaldo  �20/09/01�Melhor�Geracao de Demonstrativo de Pagamento   pa���
���            �--------�------�ra o Terminal de Consulta.                ���
��� Marinaldo  �26/09/01�Melhor�Passagem de dDataRef para OpenSRC() por re���
���            �--------�------�ferencia.								  ���
��� Marinaldo  �08/10/01�Melhor�Inclusao de Regua de Processamento  Quando���
���            �--------�------�geracao de e-mail						  ���
��� Mauro      �05/11/01�010528�Verificar a Sit.de Demitido no mes de ref.���
���            �        �      �nao listava demitido posterior a dt.ref.  ���
��� Natie      �12/12/01�009963�Acerto na Impressao TEste                 ���
���            �11/12/01�011547�Quebra pag.qdo func. tem mais de 2 recibos���
��� Silvia     �20/02/02�013293�Acerto nos Dias Trabalhados para Paraguai ���
��� Natie      �05/04/02�------�Inicializa lTerminal                      ���
��� aEmerson    �06/01/03�------�Buscar o codigo CBO no cadastro de funcoes���
���            �        �------�de acordo com os novos codigos CBO/2002.  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function ReciboGrafico(lTerminal,cFilTerminal,cMatTerminal,cMesAnoRef,nRecTipo,cSemanaTerminal)
//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Basicas)                            �
//����������������������������������������������������������������

Local cString:="SRA"        // alias do arquivo principal (Base)
Local aOrd   := {STR0001,STR0002,STR0003,STR0004,STR0005} //"Matricula"###"C.Custo"###"Nome"###"Chapa"###"C.Custo + Nome"
Local cDesc1 := STR0006		//"Emiss�o de Recibos de Pagamento."
Local cDesc2 := STR0007		//"Ser� impresso de acordo com os parametros solicitados pelo"
Local cDesc3 := STR0008		//"usu�rio."             


//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Programa)                           �
//����������������������������������������������������������������
Local nExtra,cIndCond,cIndRc
Local Baseaux := "S", cDemit := "N"
Local cHtml := ""

//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Basicas)                            �
//����������������������������������������������������������������
Private aReturn  := {STR0009, 1,STR0010, 2, 2, 1, "",1 }	//"Zebrado"###"Administra��o"
Private nomeprog :="GPER030"
Private aLinha   := { },nLastKey := 0
Private cPerg    :="GPR030"
Private cSem_De  := "  /  /    "
Private cSem_Ate := "  /  /    "
Private nAteLim , nBaseFgts , nFgts , nBaseIr , nBaseIrFe

//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Programa)                           �
//����������������������������������������������������������������
Private aLanca := {}
Private aProve := {}
Private aDesco := {}
Private aBases := {}
Private aInfo  := {}
Private aCodFol:= {}
Private li     := 0
Private Titulo := STR0011		//"EMISS�O DE RECIBOS DE PAGAMENTOS"
Private lEnvioOk := .F.

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="GPER030"            //Nome Default do relatorio em Disco
li:=0  
wimp1box:=.t.
/*/
oFont      := TFont():New( "Arial",,nHeight,,lBold,,,,,lUnderLine )
oFont3     := TFont():New( "Arial",,12,,.t.,,,,,.f. )
oFont5     := TFont():New( "Arial",,10,,.f.,,,,,.f. )
oFont9     := TFont():New( "Arial",,8,,.f.,,,,,.f. )

oFont1     := TFont():New( "Times New Roman",,28,,.t.,,,,,.t. )
oFont2     := TFont():New( "Times New Roman",,14,,.t.,,,,,.f. )
oFont4     := TFont():New( "Times New Roman",,20,,.t.,,,,,.f. )
oFont7     := TFont():New( "Times New Roman",,18,,.t.,,,,,.f. )
oFont11    :=TFont():New( "Times New Roman",,18,,.t.,,,,,.t. )

oFont6     := TFont():New( "HAETTENSCHWEILLER",,10,,.t.,,,,,.f. )

oFont8     :=  TFont():New( "Free 3 of 9",,44,,.t.,,,,,.f. )
oFont10    := TFont():New( "Free 3 of 9",,38,,.t.,,,,,.f. )
/*/
//oFont      := TFont():New( "Arial",,nHeight,,lBold,,,,,lUnderLine )
//oFont1     := TFont():New( "Times New Roman",,14,,.t.,,,,,.F. )
oFont08    := TFont():New( "Arial",,08,,.t.,,,,,.F. )
oFont10    := TFont():New( "Arial",,10,,.t.,,,,,.F. )
oFont11    := TFont():New( "Arial",,11,,.f.,,,,,.F. )
oFont12    := TFont():New( "Arial",,12,,.t.,,,,,.F. )
oFont14    := TFont():New( "Arial",,14,,.t.,,,,,.F. )
oPrn       := TMSPrinter():New()
                                      
//��������������������������������������������������������������Ŀ
//� Verifica se o programa foi chamado do terminal - TCF         �
//����������������������������������������������������������������
lTerminal := If( lTerminal == Nil, .F., lTerminal )


IF !lTerminal
	wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)
EndIF	


//��������������������������������������������������������������Ŀ
//� Define a Ordem do Relatorio                                  �
//����������������������������������������������������������������
nOrdem := IF( !lTerminal, aReturn[8] , 1 )

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
Pergunte("GPR030",.F.)

//��������������������������������������������������������������Ŀ
//� Carregando variaveis mv_par?? para Variaveis do Sistema.     �
//����������������������������������������������������������������
cSemanaTerminal := IF( Empty( cSemanaTerminal ) , Space( Len( SRC->RC_SEMANA ) ) , cSemanaTerminal )
dDataRef   := IF( !lTerminal, mv_par01 , Stod(Substr(cMesAnoRef,-4)+SubStr(cMesAnoRef,1,2)+"01"))//Data de Referencia para a impressao
nTipRel    := IF( !lTerminal, mv_par02 , 3					)	//Tipo de Recibo (Pre/Zebrado/EMail)
Esc        := IF( !lTerminal, mv_par03 , nRecTipo			)	//Emitir Recibos(Adto/Folha/1�/2�/V.Extra)
Semana     := IF( !lTerminal, mv_par04 , cSemanaTerminal	)	//Numero da Semana
cFilDe     := IF( !lTerminal,mv_par05,cFilTerminal			)	//Filial De
cFilAte    := IF( !lTerminal,mv_par06,cFilTerminal			)	//Filial Ate
cCcDe      := IF( !lTerminal,mv_par07,SRA->RA_CC			)	//Centro de Custo De
cCcAte     := IF( !lTerminal,mv_par08,SRA->RA_CC			)	//Centro de Custo Ate
cMatDe     := IF( !lTerminal,mv_par09,cMatTerminal			)	//Matricula Des
cMatAte    := IF( !lTerminal,mv_par10,cMatTerminal			)	//Matricula Ate
cNomDe     := IF( !lTerminal,mv_par11,SRA->RA_NOME			)	//Nome De
cNomAte    := IF( !lTerminal,mv_par12,SRA->RA_NOME			)	//Nome Ate
ChapaDe    := IF( !lTerminal,mv_par13,SRA->RA_CHAPA 		)	//Chapa De
ChapaAte   := IF( !lTerminal,mv_par14,SRA->RA_CHAPA 		)	//Chapa Ate
Mensag1    := mv_par15										 	//Mensagem 1
Mensag2    := mv_par16											//Mensagem 2
Mensag3    := mv_par17											//Mensagem 3
cSituacao  := IF( !lTerminal,mv_par18, fSituacao( NIL , .F. ) )	//Situacoes a Imprimir
cCategoria := IF( !lTErminal,mv_par19, fCategoria( NIL , .F. ))	//Categorias a Imprimir
cBaseAux   := If(mv_par20 == 1,"S","N")							//Imprimir Bases

IF !lTerminal

	cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
	
	If LastKey() = 27 .Or. nLastKey = 27
		Return( NIL )
	Endif 

	If nTipRel# 3
		SetDefault(aReturn,cString)
	Endif

	If LastKey() = 27 .OR. nLastKey = 27
		Return( NIL )
	Endif

EndIF

IF nTipRel==3
	IF lTerminal
		cHtml := R030ImpCust(.F.,wnRel,cString,cMesAnoRef,lTerminal)
	Else
		ProcGPE({|lEnd| R030IMPCust(@lEnd,wnRel,cString,cMesAnoRef)},,,.T.)  // Chamada do Processamento
	EndIF
Else
	RptStatus({|lEnd| R030ImpCust(@lEnd,wnRel,cString,cMesAnoRef)},Titulo)  // Chamada do Relatorio
EndIF

Return( IF( lTerminal , cHtml, NIL  ) )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R030IMP  � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processamento Para emissao do Recibo                       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � R030Imp(lEnd,WnRel,cString,cMesAnoRef,lTerminal)			  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function R030ImpCust(lEnd,WnRel,cString,cMesAnoRef,lTerminal)
//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Basicas)                            �
//����������������������������������������������������������������
Local lIgual                 //Vari�vel de retorno na compara�ao do SRC
Local cArqNew                //Vari�vel de retorno caso SRC # SX3
Local tamanho     := "P"
Local limite      := 80
Local aOrdBag     := {}
Local cMesArqRef  := If(Esc == 4,"13"+Right(cMesAnoRef,4),cMesAnoRef)
Local cArqMov     := ""
Local aCodBenef   := {}
Local cAcessaSR1  := &("{ || " + ChkRH("GPER030","SR1","2") + "}")
Local cAcessaSRA  := &("{ || " + ChkRH("GPER030","SRA","2") + "}")
Local cAcessaSRC  := &("{ || " + ChkRH("GPER030","SRC","2") + "}")
Local cAcessaSRI  := &("{ || " + ChkRH("GPER030","SRI","2") + "}")
Local cHtml		  := ""	
Local nHoras      := 0
Private cAliasMov := ""

//��������������������������������������������������������������Ŀ
//| Verifica se existe o arquivo de fechamento do mes informado  |
//����������������������������������������������������������������
//If !OpenSrc( cMesArqRef, @cAliasMov, @aOrdBag, @cArqMov, @dDataRef , NIL ,lTerminal )
	//Return( IF( lTerminal , cHtml , NIL ) )
//Endif



//��������������������������������������������������������������Ŀ
//� Selecionando a Ordem de impressao escolhida no parametro.    �
//����������������������������������������������������������������
dbSelectArea( "SRA")
IF !lTerminal
	If nOrdem == 1
		dbSetOrder(1)
	ElseIf nOrdem == 2
		dbSetOrder(2)
	ElseIf nOrdem == 3
		dbSetOrder(3)
	Elseif nOrdem == 4
		cArqNtx  := CriaTrab(NIL,.f.)
		cIndCond :="RA_Filial + RA_Chapa + RA_Mat"
		IndRegua("SRA",cArqNtx,cIndCond,,,STR0012)		//"Selecionando Registros..."
	ElseIf nOrdem == 5
		dbSetOrder(8)
	Endif

	dbGoTop()
	
	If nTipRel == 2
		aDriver := LEDriver()
		cCompac := aDriver[1]
	    cNormal := aDriver[2]
		@ LI,00 PSAY &cCompac
	Endif	
EndIF
	
//��������������������������������������������������������������Ŀ
//� Selecionando o Primeiro Registro e montando Filtro.          �
//����������������������������������������������������������������
If nOrdem == 1 .or. lTerminal
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	IF !lTerminal
		dbSeek(cFilDe + cMatDe,.T.)
		cFim    := cFilAte + cMatAte
	Else
		cFim    := &(cInicio)
	EndIF	
ElseIf nOrdem == 2
	dbSeek(cFilDe + cCcDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim     := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 3
	dbSeek(cFilDe + cNomDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim    := cFilAte + cNomAte + cMatAte
ElseIf nOrdem == 4
	dbSeek(cFilDe + ChapaDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_CHAPA + SRA->RA_MAT"
	cFim    := cFilAte + ChapaAte + cMatAte
ElseIf nOrdem == 5
	dbSeek(cFilDe + cCcDe + cNomDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME"
	cFim     := cFilAte + cCcAte + cNomAte
Endif
                                   ``                                           
dbSelectArea("SRA")
//��������������������������������������������������������������Ŀ
//� Carrega Regua Processamento                                  �
//����������������������������������������������������������������
IF nTipRel # 3
	SetRegua(RecCount())	// Total de elementos da regua
Else
	IF !lTerminal
		GPProcRegua(RecCount())// Total de elementos da regua
	EndIF
EndIF



TOTVENC:= TOTDESC:= FLAG:= CHAVE := 0

Cnpjfil = 0
Desc_Fil := Desc_End := DESC_CC:= DESC_FUNC:= ""
DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
cFilialAnt := "  "
cFuncaoAnt := "    "
cCcAnt     := Space(9)
Vez        := 0
OrdemZ     := 0

While SRA->( !Eof() .And. &cInicio <= cFim )
	
	//��������������������������������������������������������������Ŀ
	//� Movimenta Regua Processamento                                �
	//����������������������������������������������������������������
	IF !lTerminal
	
		IF nTipRel # 3
			IncRegua()  // Anda a regua
		ElseIF !lTerminal
			GPIncProc(SRA->RA_FILIAL+" - "+SRA->RA_MAT+" - "+SRA->RA_NOME)
		EndIF
	
		If lEnd
			@Prow()+1,0 PSAY cCancel
			Exit
		Endif	 
	
		//��������������������������������������������������������������Ŀ
		//� Consiste Parametrizacao do Intervalo de Impressao            �
		//����������������������������������������������������������������
		If (SRA->RA_CHAPA < ChapaDe) .Or. (SRA->Ra_CHAPa > ChapaAte) .Or. ;
			(SRA->RA_NOME < cNomDe)    .Or. (SRA->Ra_NOME > cNomAte)    .Or. ;
			(SRA->RA_MAT < cMatDe)     .Or. (SRA->Ra_MAT > cMatAte)     .Or. ;
			(SRA->RA_CC < cCcDe)       .Or. (SRA->Ra_CC > cCcAte)
			SRA->(dbSkip(1))
			Loop
		EndIf
	
	EndIF
	
	aLanca:={}         // Zera Lancamentos
	aProve:={}         // Zera Lancamentos
	aDesco:={}         // Zera Lancamentos
	aBases:={}         // Zera Lancamentos
	nAteLim := nBaseFgts := nFgts := nBaseIr := nBaseIrFe := 0.00
	
	Ordem_rel := 1     // Ordem dos Recibos

	//��������������������������������Ŀ
	//� Verifica Data Demissao         �
	//����������������������������������
	cSitFunc := SRA->RA_SITFOLH
	dDtPesqAf:= CTOD("01/" + Left(cMesAnoRef,2) + "/" + Right(cMesAnoRef,4),"DDMMYY")
	If cSitFunc == "D" .And. (!Empty(SRA->RA_DEMISSA) .And. MesAno(SRA->RA_DEMISSA) > MesAno(dDtPesqAf))
		cSitFunc := " "
	Endif	

    IF !lTerminal

		//��������������������������������������������������������������Ŀ
		//� Consiste situacao e categoria dos funcionarios			     |
		//����������������������������������������������������������������
		If !( cSitFunc $ cSituacao ) .OR.  ! ( SRA->RA_CATFUNC $ cCategoria )
			dbSkip()
			Loop
		Endif
		If cSitFunc $ "D" .And. Mesano(SRA->RA_DEMISSA) # Mesano(dDataRef)
			dbSkip()
			Loop
		Endif
		
		//��������������������������������������������������������������Ŀ
		//� Consiste controle de acessos e filiais validas				 |
		//����������������������������������������������������������������
	    If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
    	   dbSkip()
	       Loop
    	EndIf
    
    EndIF	
	
	If SRA->RA_CODFUNC # cFuncaoAnt           // Descricao da Funcao
		DescFun(Sra->Ra_Codfunc,Sra->Ra_Filial)
		cFuncaoAnt:= Sra->Ra_CodFunc
	Endif
	
	If SRA->RA_CC # cCcAnt                   // Centro de Custo
		DescCC(Sra->Ra_Cc,Sra->Ra_Filial)
		cCcAnt:=SRA->RA_CC
	Endif
	
	If SRA->RA_Filial # cFilialAnt
		If ! Fp_CodFol(@aCodFol,Sra->Ra_Filial) .Or. ! fInfo(@aInfo,Sra->Ra_Filial)
			Exit
		Endif
		Desc_Fil := aInfo[3]
		Desc_End := aInfo[4]                // Dados da Filial
		Desc_CGC := aInfo[8]
		DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)

		// MENSAGENS
		If MENSAG1 # SPACE(1)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG1)
				DESC_MSG1 := Left(SRX->RX_TXT,30)
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG1)
				DESC_MSG1 := Left(SRX->RX_TXT,30)
			Endif
		Endif

		If MENSAG2 # SPACE(1)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG2)
				DESC_MSG2 := Left(SRX->RX_TXT,30)
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG2)
				DESC_MSG2 := Left(SRX->RX_TXT,30)
			Endif
		Endif

		If MENSAG3 # SPACE(1)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG3)
				DESC_MSG3 := Left(SRX->RX_TXT,30)
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG3)
				DESC_MSG3 := Left(SRX->RX_TXT,30)
			Endif
		Endif
	
	
		
		dbSelectArea("SRA")
		cFilialAnt := SRA->RA_FILIAL
	Endif
	
		
	Totvenc := Totdesc := 0
	
	DESC_MSG1 :=""	
	//Mensagem provis�ria
	IF SRA->RA_MAT $ "000837/001541/001466/001716/000850/000014/001695/000454/001436/000118/001718/001295/000770" 
	//SRA->RA_MAT = "000837" .or. SRA->RA_CODFUNC $ "031/014/025/079/099/012"  
		DESC_MSG1 := "A partir de 08/2018 o adicional de insalubridade ser� incorporado ao sal�rio."
	EndIf
	
	//DESC_MSG2 := "MSG 2"
	//DESC_MSG3 := "MSG 3"
	
	If Esc == 1 .OR. Esc == 2
		dbSelectArea("SRC")
		dbSetOrder(1)
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
		//Alert(SRA->RA_MAT )
			While !Eof() .And. SRC->RC_FILIAL+SRC->RC_MAT == SRA->RA_FILIAL+SRA->RA_MAT
			//Alert("Entrou "+SRA->RA_MAT)
				
			/*	If SRC->RC_SEMANA # Semana
					 Alert("saiu")
					dbSkip()
					Loop
				Endif  */
			    If !Eval(cAcessaSRC)
			      // Alert("saiu 2")
			       dbSkip()
			       Loop
			    EndIf
				If (Esc == 1) .And. (Src->Rc_Pd == aCodFol[7,1])      // Desconto de Adto
					fSomaPd("P",aCodFol[6,1],SRC->RC_HORAS,SRC->RC_VALOR)
					TOTVENC += Src->Rc_Valor
				Elseif (Esc == 1) .And. (Src->Rc_Pd == aCodFol[12,1])
					fSomaPd("D",aCodFol[9,1],SRC->RC_HORAS,SRC->RC_VALOR)
					TOTDESC += SRC->RC_VALOR
				Elseif (Esc == 1) .And. (Src->Rc_Pd == aCodFol[8,1])
					fSomaPd("P",aCodFol[8,1],SRC->RC_HORAS,SRC->RC_VALOR)
					TOTVENC += SRC->RC_VALOR
				Else
					//alert("entrou else")
					If PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
						If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
							If cPaisLoc == "PAR" .and. SRC->RC_HORAS == 30
						       LocGHabRea(Ctod("01/"+SubStr(DTOC(dDataRef),4)), Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Strzero(Month(dDataRef),2)+"/"+right(str(Year(dDataRef)),2),"ddmmyy"),@nHoras)
							Else
							   nHoras := SRC->RC_HORAS
							Endif
							fSomaPd("P",SRC->RC_PD,nHoras,SRC->RC_VALOR)
							TOTVENC += Src->Rc_Valor
						Endif
					Elseif SRV->RV_TIPOCOD == "2"
						If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
							fSomaPd("D",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR)
							TOTDESC += Src->Rc_Valor
						Endif
					Elseif SRV->RV_TIPOCOD == "3"
						If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
							fSomaPd("B",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR)
						Endif
					Endif
				Endif
				//Alert(SRA->RA_MAT = "-"+ SRC->RC_PD)
				If ESC = 1
					If SRC->RC_PD == aCodFol[10,1]
						nBaseIr := SRC->RC_VALOR
					Endif
				ElseIf SRC->RC_PD == aCodFol[13,1]
					nAteLim += SRC->RC_VALOR
				Elseif SRC->RC_PD$ aCodFol[108,1]+'*'+aCodFol[17,1]
					nBaseFgts += SRC->RC_VALOR
				Elseif SRC->RC_PD$ aCodFol[109,1]+'*'+aCodFol[18,1]
					nFgts += SRC->RC_VALOR
				Elseif SRC->RC_PD == aCodFol[15,1]
					nBaseIr += SRC->RC_VALOR
				Elseif SRC->RC_PD == aCodFol[16,1]
					nBaseIrFe += SRC->RC_VALOR
				Endif
				
				dbSelectArea("SRC")
				dbSkip()
			Enddo
		Endif
	Elseif Esc == 3
		//��������������������������������������������������������������Ŀ
		//� Busca os codigos de pensao definidos no cadastro beneficiario�
		//����������������������������������������������������������������
//		fBusCadBenef(@aCodBenef, "131",{aCodfol[172,1]})
		dbSelectArea("SRC")
		dbSetOrder(1)
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT == SRC->RC_FILIAL + SRC->RC_MAT
			    If !Eval(cAcessaSRC)
			       dbSkip()
			       Loop
			    EndIf
				If SRC->RC_PD == aCodFol[22,1]
					fSomaPd("P",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR)
					TOTVENC += SRC->RC_VALOR
				Elseif Ascan(aCodBenef, { |x| x[1] == SRC->RC_PD }) > 0
					fSomaPd("D",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR)
					TOTDESC += SRC->RC_VALOR
				Elseif SRC->RC_PD == aCodFol[108,1] .Or. SRC->RC_PD == aCodFol[109,1] .Or. SRC->RC_PD == aCodFol[173,1] 
					fSomaPd("B",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR)
				Endif
				
				If SRC->RC_PD == aCodFol[108,1]
					nBaseFgts := SRC->RC_VALOR
				Elseif SRC->RC_PD == aCodFol[109,1]
					nFgts     := SRC->RC_VALOR
				Endif
				dbSelectArea("SRC")
				dbSkip()
			Enddo
		Endif
	Elseif Esc == 4
		dbSelectArea("SRI")
		dbSetOrder(2)
		If dbSeek(SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT)
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT == SRI->RI_FILIAL + SRI->RI_CC + SRI->RI_MAT
			    If !Eval(cAcessaSRI)
			       dbSkip()
			       Loop
			    EndIf
				If PosSrv( SRI->RI_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPd("P",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR)
					TOTVENC = TOTVENC + SRI->RI_VALOR
				Elseif SRV->RV_TIPOCOD == "2"
					fSomaPd("D",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR)
					TOTDESC = TOTDESC + SRI->RI_VALOR
				Elseif SRV->RV_TIPOCOD == "3"
					fSomaPd("B",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR)
				Endif

				If SRI->RI_PD == aCodFol[19,1]
					nAteLim += SRI->RI_VALOR
				Elseif SRI->RI_PD$ aCodFol[108,1]
					nBaseFgts += SRI->RI_VALOR
				Elseif SRI->RI_PD$ aCodFol[109,1]
					nFgts += SRI->RI_VALOR
				Elseif SRI->RI_PD == aCodFol[27,1]
					nBaseIr += SRI->RI_VALOR
				Endif
				dbSkip()
			Enddo
		Endif
	Elseif Esc == 5
		dbSelectArea("SR1")
		dbSetOrder(1)
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT ==	SR1->R1_FILIAL + SR1->R1_MAT
				If Semana # "99"			
					If SR1->R1_SEMANA # Semana
						dbSkip()
						Loop
					Endif
				Endif					
			    If !Eval(cAcessaSR1)
			       dbSkip()
			       Loop
			    EndIf
				If PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPd("P",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
					TOTVENC = TOTVENC + SR1->R1_VALOR
				Elseif SRV->RV_TIPOCOD == "2"
					fSomaPd("D",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
					TOTDESC = TOTDESC + SR1->R1_VALOR
				Elseif SRV->RV_TIPOCOD == "3"
					fSomaPd("B",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
				Endif
				dbskip()
			Enddo
		Endif
	Endif
	
	dbSelectArea("SRA")
	
	If TOTVENC = 0 .And. TOTDESC = 0
		dbSkip()
		Loop
	Endif
	
	If Vez == 0  .And.  Esc == 2 //--> Verifica se for FOLHA.
		PerSemana() // Carrega Datas referentes a Semana.
	EndIf
	
	If nTipRel == 1 .and. !lTerminal
		fImpressao()   // Impressao do Recibo de Pagamento
		//��������������������������������������������������������������Ŀ
		//� Efetua Teste de Impressao                                    �
		//����������������������������������������������������������������
		If Vez = 0 .and. aReturn[5] # 1  
			//��������������������������������������������������������������Ŀ
			//� Testa impressao                                              �
			//����������������������������������������������������������������
			fImpTeste(cString,nTipRel)
			TotDesc := TotVenc := 0
			If mv_par01 = 2
				Loop
			Endif	
		EndIf
	ElseIf nTipRel == 2 .and. !lTerminal 
		fImpreZebr()
	ElseIf nTipRel==3 .or. lTerminal 
		cHtml	:= fSendDPgto(lTerminal)		//Monta o corpo do e-mail e envia-o		
	Endif
		
	dbSelectArea("SRA")
	SRA->( dbSkip() )
	TOTDESC := TOTVENC := 0
EndDo

//��������������������������������������������������������������Ŀ
//� Seleciona arq. defaut do Siga caso Imp. Mov. Anteriores      �
//����������������������������������������������������������������
If !Empty( cAliasMov )
	fFimArqMov( cAliasMov , aOrdBag , cArqMov )
EndIf

IF !lTerminal

	//��������������������������������������������������������������Ŀ
	//� Termino do relatorio                                         �
	//����������������������������������������������������������������
	dbSelectArea("SRC")
	dbSetOrder(1)          // Retorno a ordem 1
	dbSelectArea("SRI")
	dbSetOrder(1)          // Retorno a ordem 1
	dbSelectArea("SRA")
	SET FILTER TO
	RetIndex("SRA")
	
	If !(Type("cArqNtx") == "U")
		fErase(cArqNtx + OrdBagExt())
	Endif
	
	Set Device To Screen
	
	If lEnvioOK
		APMSGINFO(STR0042)	
	ElseIf nTipRel== 3
		APMSGINFO(STR0043)
	EndIf	      
	/*/                                                        
	If aReturn[5] = 1 .and. nTipRel # 3
		Set Printer To
		Commit
		ourspool(wnrel)
	Endif
	MS_FLUSH()
    /*/       
	oPrn:Setup() // para configurar impressora    
    oPrn:Preview()
EndIF	

Return( cHtml )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fImpressao� Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMRESSAO DO RECIBO FORMULARIO CONTINUO                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fImpressao()                                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fImpressao()

Local nConta  := nContr := nContrT:=0
Local aDriver := LEDriver()
Private nLinhas:=16              // Numero de Linhas do Miolo do Recibo

Private cCompac := aDriver[1]
Private cNormal := aDriver[2]

Ordem_Rel := 1

fCabec()

For nConta = 1 To Len(aLanca)
	fLanca(nConta)
	nContr ++
	nContrT ++
	If nContr = nLinhas .And. nContrT < Len(aLanca)
		nContr:=0
		Ordem_Rel ++
		fContinua()
		fCabec()
	Endif
Next

Li+=(nLinhas-nContr)
fRodape()
Li+=3

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fImpreZebr� Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMRESSAO DO RECIBO FORMULARIO ZEBRADO                      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fImpreZebr()                                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fImpreZebr()

Local nConta    := nContr := nContrT:=0
/*/
If li >= 60 
	li := 0
Endif
/*/
//wimp1box:=.t.
fCabecZ()
fLancaZ(nConta)

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fCabec    � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMRESSAO Cabe�alho Form Continuo                           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fCabec()                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fCabec()   // Cabecalho do Recibo

@ LI,01 PSAY &cNormal+DESC_Fil
LI ++
@ LI,01 PSAY DESC_END
LI ++
@ LI,01 PSAY DESC_CGC

If !Empty(Semana) .And. Semana # '99' .And.  Upper(SRA->RA_TIPOPGT) == 'S'
	@ Li,37 pSay STR0013 + Semana + ' (' + cSem_De + STR0014 + ;	//'Semana '###' a '
	cSem_Ate + ')'
Else
	@ LI,55 PSAY MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4)
EndIf	

LI +=3
@ LI,01 PSAY SRA->RA_Mat
@ LI,08 PSAY Left(SRA->RA_NOME,28)
@ LI,37 PSAY fCodCBO(SRA->RA_FILIAL,SRA->RA_CODFUNC,dDataRef)
@ LI,44 PSAY SRA->RA_Filial
@ LI,54 PSAY SRA->RA_CC
@ LI,65 PSAY ORDEM_REL PICTURE "9999"
LI ++

cDet := 'FUNCAO: '+ SRA->RA_CODFUNC + ' '	//STR0015 + SRA->RA_CODFUNC + ' '		//'FUNCAO: '
cDet += DescFun(SRA->RA_CODFUNC,SRA->RA_FILIAL) + ' '
cDet += DescCc(SRA->RA_CC,SRA->RA_FILIAL) + ' '
cDet += 'CHAPA: '+  SRA->RA_CHAPA			//STR0016 +		//'CHAPA: '
@ Li,01 pSay cDet

Li += 2
Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fCabecz   � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMRESSAO Cabe�alho Form ZEBRADO                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fCabecz()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fCabecZ()   // Cabecalho do Recibo Zebrado

cBitMap:= "logo.bmp"
wbkli := li
Li += 080                                            
oPrn:Say (li-80, 850, " ", ofont08,100)  
if wimp1box
	oPrn:Box(0010,030,0460,2320)
	oPrn:Box(0470,030,1220,2320)
	//oPrn:Box(1230,840,1500,0845)
	oPrn:Box(1230,030,1500,2320)
	wimp1box := .F.
endif
oPrn:Say (li, 850, "RECIBO DE PAGAMENTO  ", ofont10,100)
//                    Altura /comprimento
//oPrn:SayBitmap( li-50,1700,cBitMap,300,400 )
oPrn:SayBitmap( li-50,1900,cBitMap,350,400 )
li+=60
oPrn:Say (li, 050, "CNPJ   : "+Transform(Desc_CGC,"@R 99.999.999/9999-99"), ofont08,100)  
li+=60
oPrn:Say (li, 050, "Empresa: "+Desc_Fil, ofont08,100)  
oPrn:Say (li, 1600, "Local : "+SRA->RA_FILIAL, ofont08,100)  
li+=60
oPrn:Say (li, 050, "C Custo   : " + SRA->RA_CC + " - " + DescCc(SRA->RA_CC,SRA->RA_FILIAL), ofont08,100)  
If !Empty(Semana) .And. Semana # "99" .And.  Upper(SRA->RA_TIPOPGT) == "S"
	oPrn:Say (li, 1600, 'Sem.' + Semana + " (" + cSem_De + ' a ' + cSem_Ate + ")", ofont08,100)  
Else 
	oPrn:Say (li, 1600, MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4), ofont08,100)  
EndIf	
LI+= 60
ORDEMZ ++
oPrn:Say (li, 050, "Matricula : " + SRA->RA_MAT+" - "+ "Nome : "+SRA->RA_NOME, ofont08,100)  
//oPrn:Say (li, 1600, "Ordem : "+StrZero(ORDEMZ,4), ofont08,100)  
LI += 60
oPrn:Say (li, 050, "Funcao    : "+SRA->RA_CODFUNC+" - "+DescFun(SRA->RA_CODFUNC,SRA->RA_FILIAL), ofont08,100)  
LI += 100
oPrn:Say (li, 050, "P R O V E N T O S", ofont08,100)  
oPrn:Say (li, 1200, "D E S C O N T O S", ofont08,100)  
//oPrn:Say (li, 1600, "B A S E S", ofont12,100)  
LI += 100
/*/
oPrn:Preview()
li:=wbkli

LI ++
@ LI,00 PSAY "*"+REPLICATE("=",130)+"*"

LI ++
@ LI,00  PSAY  "|"
@ LI,46  PSAY STR0017		//"RECIBO DE PAGAMENTO  "
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"

LI ++
@ LI,00  PSAY STR0018 +  DESC_Fil		//"| Empresa   : "
@ LI,92  PSAY STR0019 + SRA->RA_FILIAL	//" Local : "
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY STR0020 + SRA->RA_CC + " - " + DescCc(SRA->RA_CC,SRA->RA_FILIAL)	//"| C Custo   : "
If !Empty(Semana) .And. Semana # "99" .And.  Upper(SRA->RA_TIPOPGT) == "S"
	@ Li,92 pSay STR0021 + Semana + " (" + cSem_De + STR0022 + ;   //'Sem.'###' a '
	cSem_Ate + ")"
Else
	@ LI,92 PSAY MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4)
EndIf	
@ LI,131 PSAY "|"	

LI ++
ORDEMZ ++
@ LI,00  PSAY STR0023 + SRA->RA_MAT		//"| Matricula : "
@ LI,30  PSAY STR0024 + SRA->RA_NOME	//"Nome  : "
@ LI,92  PSAY STR0025						//"Ordem : "
@ LI,100 PSAY StrZero(ORDEMZ,4) Picture "9999"
@ LI,131 PSAY "|"

LI ++
@ LI,00  PSAY STR0026+SRA->RA_CODFUNC+" - "+DescFun(SRA->RA_CODFUNC,SRA->RA_FILIAL)	//"| Funcao    : "
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"

LI ++
@ LI,000 PSAY STR0027		//"| P R O V E N T O S "
@ LI,044 PSAY STR0028		//"  D E S C O N T O S"
@ LI,088 PSAY STR0029		//"  B A S E S"
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
LI++
/*/

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fLanca    � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao das Verbas (Lancamentos) Form. Continuo          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fLanca()                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fLanca(nConta)   // Impressao dos Lancamentos

Local cString := Transform(aLanca[nConta,5],"@E 99,999,999.99")
Local nCol := If(aLanca[nConta,1]="P",43,If(aLanca[nConta,1]="D",57,27))

@ LI,01 PSAY aLanca[nConta,2]
@ LI,05 PSAY aLanca[nConta,3]
If aLanca[nConta,1] # "B"        // So Imprime se nao for base
    @ LI,36 PSAY TRANSFORM(aLanca[nConta,4],"999.99")
Endif
@ LI,nCol PSAY cString
Li ++

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fLancaZ   � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao das Verbas (Lancamentos) Zebrado                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fLancaZ()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fLancaZ(nConta)   // Impressao dos Lancamentos

Local nTermina  := 0
Local nCont     := 0
Local nCont1    := 0
Local nValidos  := 0

nTermina := Max(Max(LEN(aProve),LEN(aDesco)),0) //,LEN(aBases))

For nCont := 1 To nTermina

	IF nCont <= LEN(aProve)
		oPrn:Say (li, 050, aProve[nCont,1], ofont08,100)  	
		oPrn:Say (li, 655, TRANSFORM(aProve[nCont,2],'999.99'), ofont08,100)  			
		oPrn:Say (li, 815, TRANSFORM(aProve[nCont,3],"@E 999,999.99"), ofont08,100)  					
	ENDIF
	IF nCont <= LEN(aDesco)
		oPrn:Say (li, 1200, aDesco[nCont,1], ofont08,100)  	
		oPrn:Say (li, 1750, TRANSFORM(aDesco[nCont,2],'999.99'), ofont08,100)  			
		oPrn:Say (li, 1850, TRANSFORM(aDesco[nCont,3],"@E 999,999.99"), ofont08,100)  			
	ENDIF
	IF nCont <= LEN(aBases)
	/*/
		oPrn:Say (li, 1600, aBases[nCont,1], ofont10,100)  	
		oPrn:Say (li, 2050, TRANSFORM(aBases[nCont,2],'999.99'), ofont11,100)  			
		oPrn:Say (li, 2240, TRANSFORM(aBases[nCont,3],"@E 999,999.99"), ofont11,100)  			
	/*/	
	ENDIF
	//---- Soma 1 nos nValidos e Linha
	nValidos ++
	Li += 60
		
	If nValidos = 10
//		@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
//		LI ++           
		oPrn:Say (li, 050,"CONTINUA !!!", ofont08,100)  
/*			
//		@ LI,00 PSAY "|"
//		@ LI,05 PSAY STR0030			// continua
//		@ LI,76 PSAY "|"+&cCompac
//		LI ++
//      @ LI,00 PSAY "*"+REPLICATE("=",130)+"*"
//		LI += 60
*/

///********************************
/// INCLUIDO CUSTOMIZACAO
///********************************

		If li >= 2500
			li := 0   
			oPrn:EndPage()
			oPrn:StartPage()				
			wimp1box := .t.
		else
			li+=510
			oPrn:Box(1695,030,2145,2320)
			oPrn:Box(2155,030,2905,2320)
//			oPrn:Box(1230,840,1500,0845)                              
			oPrn:Box(2915,030,3185,2320)            
	                 
    	Endif
		fCabecZ()
		nValidos := 0
    ENDIF
Next

For nCont1 := nValidos+1 To 10
	Li+=60
Next                 
nValidos := 0

//@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
LI += 60
 	
oPrn:Say (li, 500,"TOTAL BRUTO     "+SPACE(5)+TRANS(TOTVENC,"@E 999,999,999.99"), ofont08,100)  	
oPrn:Say (li, 1200,"TOTAL DESCONTOS     "+SPACE(37)+TRANS(TOTDESC,"@E 999,999,999.99")	, ofont08,100)  	
LI += 60
//oPrn:Say (li, 1400,"LIQUIDO A RECEBER     "+SPACE(05)+TRANS((TOTVENC-TOTDESC),"@E 999,999,999.99"), ofont08,100)
oPrn:Say (li, 1200,"LIQUIDO A RECEBER     "+SPACE(36)+TRANS((TOTVENC-TOTDESC),"@E 999,999,999.99"), ofont08,100)
oPrn:Say (li, 050,"CREDITO: "+SRA->RA_BCDEPSAL+"-"+DescBco(SRA->RA_BCDEPSAL,SRA->RA_FILIAL), ofont08,100)  //li, 650  	
LI += 60
oPrn:Say (li, 050,"CONTA:" + SRA->RA_CTDEPSAL		, ofont08,100)  //li, 650
 	  	
LI += 60
oPrn:Say (li, 050,DESC_MSG1, ofont08,100) 
LI += 50
oPrn:Say (li, 050,DESC_MSG3, ofont08,100)  	
oPrn:Say (li, 1200,DESC_MSG2, ofont08,100)
//LI ++
//@ LI,000 PSAY "|"+REPLICATE("-",130)+"|"
li+=50                                                               
oPrn:Say (li, 050,"Sal.Contr.Inss: " + Transform(nAteLim,"@E 999,999,999.99")+space(30)+"Base Fgts: "+Transform(nBaseFgts,"@E 999,999,999.99")+space(30)+" Fgts Mes: "+Transform(nFgts,"@e 999,999.99"), ofont08,100)  	
LI += 080
oPrn:Say (li, 050,"Recebi o valor acima em       ___/___/___      " + Replicate("_",40), ofont08,100)  	
//LI ++
//@ LI,00 PSAY "*"+REPLICATE("=",130)+"*"
If li >= 2500
	li := 0   
	oPrn:EndPage()
	oPrn:StartPage()				
	wimp1box := .t.
else
	li+=100
	oPrn:Box(1695,030,2145,2320)
	oPrn:Box(2155,030,2905,2320)
//		oPrn:Box(1230,840,1500,0845)                              
	oPrn:Box(2915,030,3185,2320)                              
//	fCabecZ()
//	nValidos := 0	
Endif

ASize(AProve,0)
ASize(ADesco,0)
ASize(aBases,0)

//Li += 60

//Quebrar pagina
//If LI > 180
//	LI := 100           
//	oPrn:EndPage()
//	oPrn:StartPage()	
//EndIf
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fContinua � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressap da Continuacao do Recibo                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fContinua()                                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fContinua()    // Continuacao do Recibo

Li+=1
   @ LI,05 PSAY &cNormal + "CONTINUA !!!" //STR0037		//"CONTINUA !!!"
Li+=8
Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fRodape   � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao do Rodape                                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fRodape()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fRodape()    // Rodape do Recibo

Local cMesComp

@ LI,05 PSAY DESC_MSG1
LI ++
@ LI,05 PSAY DESC_MSG2
@ LI,42 PSAY TOTVENC PICTURE "@E 999,999,999.99"
@ LI,56 PSAY TOTDESC PICTURE "@E 999,999,999.99"
LI ++
@ LI,05 PSAY DESC_MSG3
LI ++
cMesComp := IIF(MONTH(dDataRef) + 1 > 12,01,MONTH(dDataRef))
IF cMesComp == MONTH(SRA->RA_NASC)
    @ LI, 02 PSAY STR0038		//"F E L I Z   A N I V E R S A R I O  ! !"
ENDIF
 
@ LI,56 PSAY TOTVENC - TOTDESC PICTURE "@E 999,999,999.99"
LI +=2

If !Empty( cAliasMov )
	nValSal := 0
	fBuscaSlr(@nValSal,MesAno(dDataRef))
	If nValSal ==0
		nValSal := SRA->RA_SALARIO
	EndIf
Else
	nValSal := SRA->RA_SALARIO
EndIf
@ LI,05 PSAY &cCompac+Transform(nValSal,"@E 99,999,999.99")

If Esc = 1  // Bases de Adiantamento
    If cBaseAux = "S" .And. nBaseIr # 0
        @ LI,89 PSAY nBaseIr PICTURE "@E 999,999,999.99"
    Endif
ElseIf Esc = 2 .Or. Esc = 4  // Bases de Folha e 13o. 2o.Parc.
	If cBaseAux = "S"
		@ LI,23 PSAY Transform(nAteLim,"@E 999,999,999.99")
		If nBaseFgts # 0
			@ LI,46 PSAY nBaseFgts PICTURE "@E 999,999,999.99"
		Endif
		If nFgts # 0
			@ LI,66 PSAY nFgts PICTURE "@E 99,999,999.99"
		Endif
		If nBaseIr # 0
			@ LI,89 PSAY nBaseIr PICTURE "@E 999,999,999.99"
		Endif
		@ LI,103 PSAY Transform(nBaseIrfE,"@E 999,999,999.99")
	Endif
ElseIf Esc = 3 // Bases de FGTS e FGTS Depositado da 1� Parcela 
	If cBaseAux = "S"
		If nBaseFgts # 0
			@ LI,46 PSAY nBaseFgts PICTURE "@E 999,999,999.99"
		Endif
		If nFgts # 0
			@ LI,66 PSAY nFgts PICTURE "@E 99,999,999.99"
		Endif
	Endif
Endif

@ LI,Pcol() Psay &cNormal

Li ++
IF SRA->RA_BCDEPSAL # SPACE(8)
	Desc_Bco := DescBco(Sra->Ra_BcDepSal,Sra->Ra_Filial)
    @ LI,01 PSAY STR0039	//"CRED:"
    @ LI,06 PSAY SRA->RA_BCDEPSAL
    @ LI,14 PSAY " "
    @ LI,15 PSAY DESC_BCO
    @ LI,60 PSAY "CONTA:" + SRA->RA_CTDEPSAL //	STR0040 + SRA->RA_CTDEPSAL	//"CONTA:"
ENDIF
Return Nil

********************
Static Function PerSemana() // Pesquisa datas referentes a semana.
********************

If !Empty(Semana) 
	cChaveSem := StrZero(Year(dDataRef),4)+StrZero(Month(dDataRef),2)+SRA->RA_TNOTRAB
	If !Srx->(dbSeek(If(cFilial=="  ","  ",SRA->RA_FILIAL) + "01" + cChaveSem + Semana , .T. )) .And. ;
		!Srx->(dbSeek(If(cFilial=="  ","  ",SRA->RA_FILIAL) + "01" + Subs(cChaveSem,3,9) + Semana , .T. )) .And. ;
		!Srx->(dbSeek(If(cFilial=="  ","  ",SRA->RA_FILIAL) + "01" + Left(cChaveSem,6)+"999"+ Semana , .T. )) .And. ;
		!Srx->(dbSeek(If(cFilial=="  ","  ",SRA->RA_FILIAL) + "01" + Subs(cChaveSem,3,4)+"999"+ Semana , .T. )) .And. ;
		HELP( " ",1,"SEMNAOCAD" )
		Return Nil
	Endif
	
	If Len(AllTrim(SRX->RX_COD)) == 9
		cSem_De  := Transforma(CtoD(Left(SRX->RX_TXT,8),"DDMMYY"))
		cSem_Ate := Transforma(CtoD(Subs(SRX->RX_TXT,10,8),"DDMMYY"))
	Else
	   cSem_De  := Transforma(If("/" $ SRX->RX_TXT , CtoD(SubStr( SRX->RX_TXT, 1,10),"DDMMYY") , StoD(SubStr( SRX->RX_TXT, 1,8 ))))
	   cSem_Ate := Transforma(If("/" $ SRX->RX_TXT , CtoD(SubStr( SRX->RX_TXT, 12,10),"DDMMYY"), StoD(SubStr( SRX->RX_TXT,12,8 ))))
	EndIf
EndIf	

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fSomaPd   � Autor � R.H. - Mauro          � Data � 24.09.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Somar as Verbas no Array                                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fSomaPd(Tipo,Verba,Horas,Valor)                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fSomaPd(cTipo,cPd,nHoras,nValor)

Local Desc_paga

Desc_paga := DescPd(cPd,Sra->Ra_Filial)  // mostra como pagto

If cTipo # 'B'
    //--Array para Recibo Pre-Impresso
    nPos := Ascan(aLanca,{ |X| X[2] = cPd })
    If nPos == 0
        Aadd(aLanca,{cTipo,cPd,Desc_Paga,nHoras,nValor})
    Else
       aLanca[nPos,4] += nHoras
       aLanca[nPos,5] += nValor
    Endif
Endif

//--Array para o Recibo Pre-Impresso
If cTipo = 'P'
   cArray := "aProve"
Elseif cTipo = 'D'
   cArray := "aDesco"
Elseif cTipo = 'B'
   cArray := "aBases"
Endif

nPos := Ascan(&cArray,{ |X| X[1] = cPd })
If nPos == 0
    Aadd(&cArray,{cPd+" "+Desc_Paga,nHoras,nValor })
Else
    &cArray[nPos,2] += nHoras
    &cArray[nPos,3] += nValor
Endif
Return

*-------------------------------------------------------
Static Function Transforma(dData) //Transforma as datas no formato DD/MM/AAAA
*-------------------------------------------------------
Return(StrZero(Day(dData),2) +"/"+ StrZero(Month(dData),2) +"/"+ Right(Str(Year(dData)),4))

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fSendDPgto| Autor � R.H.-Natie            � Data � 15.08.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Envio de E-mail -Demonstrativo de Pagamento                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico :Envio Demonstrativo de Pagto atraves de eMail  ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fSendDPgto(lTerminal)

Local aFiles  	:= {}
Local cEmail		:= If(SRA->RA_RECMAIL=="S",SRA->RA_EMAIL,"    ")  
Local cHtml		:= ""
Local cSubject	:= STR0044	//" DEMONSTRATIVO DE PAGAMENTO "
Local cAlias  	:= Alias()
Local cMesComp	:= IF( Month(dDataRef) + 1 > 12 , 01 , Month(dDataRef) )
Local cTipo		:= ""
Local nZebrado	:= 0.00
Local nResto	:= 0.00	

Private cMailConta	:= NIL
Private cMailServer	:= NIL
Private cMailSenha	:= NIL

lTerminal := IF( lTerminal == NIL .or. ValType( lTerminal ) != "L" , .F. , lTerminal )

IF Esc == 1
	cTipo := STR0060 // "Adiantamento"
ElseIF Esc == 2
	cTipo := STR0061	//"Folha"
ElseIF Esc == 3 
	cTipo := STR0062 //"1a. Parcela do 13o."
ElseIF Esc == 4
	cTipo := STR0063 //"2a. Parcela do 13o."
ElseIF Esc == 5
	cTipo := STR0064 //"Valores Extras"
EndIF				

IF !lTerminal
	
	//��������������������������������������������������������������Ŀ
	//� Busca parametros                                             �
	//����������������������������������������������������������������
	cMailConta	:=If(cMailConta == NIL,GETMV("MV_EMCONTA"),cMailConta)             //Conta utilizada p/envio do email
	cMailServer	:=If(cMailServer == NIL,GETMV("MV_RELSERV"),cMailServer)           //Server 
	cMailSenha	:=If(cMailSenha == NIL,GETMV("MV_EMSENHA"),cMailSenha)
	
	If Empty(cEmail)
		Return
	Endif	
	
	//��������������������������������������������������������������Ŀ
	//� Verifica se existe o SMTP Server                             �
	//����������������������������������������������������������������
	If 	Empty(cMailServer)
		Help(" ",1,"SEMSMTP")//"O Servidor de SMTP nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Verifica se existe a CONTA                                   �
	//����������������������������������������������������������������
	If 	Empty(cMailServer)
		Help(" ",1,"SEMCONTA")//"A Conta do email nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Verifica se existe a Senha                                   �
	//����������������������������������������������������������������
	If 	Empty(cMailServer)
		Help(" ",1,"SEMSENHA")	//"A Senha do email nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf                                              

EndIF

cHtml +=	'<html>'
cHtml +=	'<head>'
IF !lTerminal
	cHtml += 	'<title>DEMONSTRATIVO DE PAGAMENTO</title>'
	cHtml +=	'<style>'
	cHtml +=	'th { text-align:left; background-color:#4B87C2; line-height:01; line-width:400; border-left:0px solid  #FF9B06; border-right:0px solid #FF9B06; border-bottom:0px solid #FF9B06 ; border-top:0px solid #FF9B06 }'
	cHtml +=	'.tdPrinc { text-align:left; line-height:1; line-width:340 ; border-left:0px solid #FF9B06; border-right:0px solid #FF9B06; border-bottom:0px solid #FF9B06 ; border-top:0px solid #FF9B06 > }'
	cHtml +=	'.td18_94_AlignR { text-align:right ; line-height:1; line-width:94 }'
	cHtml +=	'.td18_95_AlignR { text-align:right ; line-height:1; line-width:95 }'
	cHtml +=	'.td26_94_AlignR { text-align:right ; line-height:1; line-width:94 }'
	cHtml +=	'.td26_95_AlignR { text-align:right ; line-height:1; line-width:95 }'
	cHtml += 	'.td26_18_AlignL { lext-align:left ; line-height:1; line:width:18 ; border-left:0px solid #FF9B06; border-right:0px solid #FF9B06; border-bottom:0px solid #FF9B06 ; border-top:0px solid #FF9B06 bgcolor=#6F9ECE" }'
	cHtml +=    '.pStyle1 { line-height:100% ; margin-top:15 ; margin-bottom:0 }'
	cHtml +=	'</style>'
	cHtml +=	'</head>'
	cHtml +=	'<body bgcolor="#FFFFFF"  topmargin="0" leftmargin="0">'
	cHtml +=	'<center>'
	cHtml +=	'<table  border="1" cellpadding="0" cellspacing="0" bordercolor="#FF9B06" bgcolor="#000082" width=598 height="637">'
	cHtml +=    '<td width="598" height="181" bgcolor="FFFFFF">'
	cHtml += 	'<center>'
	cHtml += 	'<font color="#000000">'
	cHtml +=	'<b>'
	cHtml += 	'<h4 size="03">'
	cHtml +=	'<br>'
	cHtml += 	STR0044 // " DEMONSTRATIVO DE PAGAMENTO "
	cHtml += 	'<br>'
Else
	cHtml += '<title>RH Online</title>' + CRLF
	cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">' + CRLF
	cHtml += '<link rel="stylesheet" href="../rhonline/css/rhonline.css" type="text/css">' + CRLF
	cHtml += '</head>' + CRLF
	cHtml += '<body bgcolor="#FFFFFF" text="#000000">' + CRLF
	cHtml += '<table width="515" border="0" cellspacing="0" cellpadding="0">' + CRLF
	cHtml += '<tr>' + CRLF
	cHtml += '<td class="titulo">' + CRLF
	cHtml += '<p><img src="../rhonline/imagens/icone_titulo.gif" width="7" height="9"> <span class="titulo_opcao">' + Capital( STR0044 ) + '</span><br>' + CRLF //DEMONSTRATIVO DE PAGAMENTO 
	cHtml += '<br>'	+ CRLF
	cHtml += '</p>'	+ CRLF
	cHtml += '</td>' + CRLF 
  	cHtml += '</tr>' + CRLF
  	cHtml += '<tr>' + CRLF
    cHtml += '<td>' + CRLF 
    cHtml += '<p><img src="../rhonline/imagens/tabela_conteudo.gif" width="515" height="12"></p>' + CRLF
    cHtml += '</td>' + CRLF
  	cHtml += '</tr>' + CRLF
  	cHtml += '<tr>' + CRLF 
    cHtml += '<td>' + CRLF
	cHtml += '<table width="515" border="0" cellspacing="0" cellpadding="0">' + CRLF
    cHtml += '<tr>' + CRLF
    cHtml += '<td background="../rhonline/imagens/tabela_conteudo_1.gif" width="10">&nbsp;</td>' + CRLF
    cHtml += '<td width="498">' + CRLF
    cHtml += '<table width="498" border="0" cellspacing="0" cellpadding="0">' + CRLF
    cHtml += '<tr>' + CRLF
EndIF    

If !Empty(Semana) .And. Semana # "99" .And.  Upper(SRA->RA_TIPOPGT) == "S" 
	//��������������������������������������������������������������Ŀ
	//� Carrega Datas Referente a semana                             �
	//����������������������������������������������������������������
    PerSemana()
	IF !lTerminal
		cHtml += STR0045 + Semana + " (" + cSem_De + STR0046 +	cSem_Ate + ")" //"Semana  "###" a " 
	Else
		cHtml += '<td><span class="dados">' + STR0045 + Semana + " (" + cSem_De + STR0046 +	cSem_Ate + ")" + '</span></td>' + CRLF
	EndIF	
Else
	IF !lTerminal
		cHtml += MesExtenso(Month(dDataRef))+"/"+STR(YEAR(dDataRef),4) + " - ( " + cTipo + " )"
	Else
		cHtml += '<td><span class="dados">' + MesExtenso(Month(dDataRef))+"/"+STR(YEAR(dDataRef),4) + " - ( " + cTipo + " )" + '</span></td>' + CRLF
	EndIF	
EndIf	                    

IF !lTerminal

	cHtml += '</b></h4></font></center>'
	cHtml += '<hr whidth = 100% align=right color="#FF812D">'
	//��������������������������������������������������������������Ŀ
	//� Dados do funcionario                                         �
	//����������������������������������������������������������������
	cHtml += '<!Dados do Funcionario>'
	cHtml += '<p align=left  style="margin-top: 0">'
	cHtml +=   '<font color="#000082" face="Courier New"><i><b>'
	cHtml +=  	'&nbsp;&nbsp;&nbsp' + SRA->RA_NOME + "-" + SRA->RA_MAT+'</i><br>'
	cHtml += 	'&nbsp;&nbsp;&nbsp' + STR0048 + SRA->RA_CODFUNC+ "  "+DescFun(SRA->RA_CODFUNC,SRA->RA_FILIAL)	+'<br>' //"Funcao    - "
	cHtml +=  	'&nbsp;&nbsp;&nbsp' + STR0047 + SRA->RA_CC + " - " + DescCc(SRA->RA_CC,SRA->RA_FILIAL) +'<br>' //"C.Custo   - "
	cHtml +=    '&nbsp;&nbsp;&nbsp' + STR0049 + SRA->RA_BCDEPSAL+"-"+DescBco(SRA->RA_BCDEPSAL,SRA->RA_FILIAL)+ '&nbsp;'+  SRA->RA_CTDEPSAL //"Bco/Conta - "
	cHtml += '</b></p></font>'
	cHtml += '<!Proventos e Desconto>'
	cHtml += '<div align="center">'
	cHtml += '<Center>'
	cHtml += '<Table bgcolor="#6F9ECE" border="0" cellpadding ="1" cellspacing="0" width="553" height="296">'
	cHtml += '<TBody><Tr>'
	cHtml +=	'<font face="Courier New" size="02" color="#000082"><b>'
	cHtml += 	'<th>' + STR0050 + '</th>' //"Cod  Descricao "
	cHtml += 	'<th>' + STR0051 + '</th>' //"Referencia"
	cHtml += 	'<th>' + STR0052 + '</th>' //"Valores"
	cHtml += 	'</b></font></tr>'
	cHtml += '<font color=#000082 face="Courier new"  size=2">'

	//��������������������������������������������������������������Ŀ
	//� Espacos Entre os Cabecalho e os Proventos/Descontos          �
	//����������������������������������������������������������������
    cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc"></td>'
	cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml += 	'</tr>'
Else
	cHtml += '</tr>' + CRLF
    cHtml += '<tr>' + CRLF
    cHtml += '<td>&nbsp;</td>' + CRLF
    cHtml += '</tr>' + CRLF
    cHtml += '<tr>' + CRLF
    cHtml += '<td>' + CRLF
    cHtml += '<table width="490" border="0" cellspacing="0" cellpadding="0">' + CRLF
    cHtml += '<tr align="center">' + CRLF
    cHtml += '<td width="45" height="16">' + CRLF
    cHtml += '<div align="Left"><span class="etiquetas">'+ STR0068 + '</span></div>' + CRLF //C&oacute;digo
    cHtml += '</td>' + CRLF
    cHtml += '<td width="219" valign="top">' + CRLF
    cHtml += '<div align="left"><span class="etiquetas">' + STR0069 + '</span></div>' + CRLF //Descri&ccedil;&atilde;o
    cHtml += '</td>' + CRLF
    cHtml += '<td width="127" valign="top">' + CRLF
    cHtml += '<div align="right"><span class="etiquetas">' + STR0070  + '</span></div>' + CRLF //Refer&ecirc;ncia
    cHtml += '</td>' + CRLF
    cHtml += '<td width="107" valign="top">' + CRLF
    cHtml += '<div align="right"><span class="etiquetas">' + STR0052 + '</span></div>' + CRLF //Valores
    cHtml += '<td width="107" valign="top">' + CRLF
    cHtml += '<div align="center"><span class="etiquetas"> (+/-) </span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '</tr>' + CRLF
EndIF

//��������������������������������������������������������������Ŀ
//� Proventos                                                    �
//����������������������������������������������������������������
For nProv:=1 to  LEN(aProve)
	nResto := ( ++nZebrado % 2 )
	IF !lTerminal
		cHtml += '<tr>'
		cHtml += 	'<td class="tdPrinc">' + aProve[nProv,1] + '</td>'
		cHtml += 	'<td class="td18_94_AlignR">' + Transform(aProve[nProv,2],'999.99')+'</td>'
		cHtml += 	'<td class="td18_95_AlignR">' + Transform(aProve[nProv,3],'@E 999,999.99') + '</td>'
		cHtml +=    '<td class="td18_18_AlignL"></td>'
		cHtml += '</tr>'
	Else
		cHtml += '<tr>' + CRLF
        IF nResto > 0.00 
        	cHtml += '<td width="45" align="center" height="19" bgcolor="#FAFBFC">' 
        Else
        	cHtml += '<td width="45" align="center" height="19">' + CRLF
        EndIF	
        cHtml += '<div align="left"><span class="dados">'  + Substr( aProve[nProv,1] , 1 , 3 ) + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
		IF nResto > 0.00         
        	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else	
        	cHtml += '<td valign="top">' + CRLF           
        EndIF	
        cHtml += '<div align="Left"><span class="dados">'  + Capital( AllTrim( Substr( aProve[nProv,1] , 4 ) ) ) + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
		IF nResto > 0.00         
        	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else	
        	cHtml += '<td valign="top">' + CRLF           
        EndIF	
        cHtml += '<div align="right"><span class="dados">' + Transform(aProve[nProv,2],'999.99') + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
		IF nResto > 0.00         
        	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else	
        	cHtml += '<td valign="top">' + CRLF           
        EndIF	
        cHtml += '<div align="right"><span class="dados">' + Transform(aProve[nProv,3],'@E 999,999.99') + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
		IF nResto > 0.00         
        	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else	
        	cHtml += '<td valign="top">' + CRLF           
        EndIF	
        cHtml += '<div align="center"><span class="dados"> (+) </span></div>' + CRLF
        cHtml += '</td>' + CRLF
        cHtml += '</tr>' + CRLF
	EndIF
Next nProv    		

//��������������������������������������������������������������Ŀ
//� Descontos                                                    �
//����������������������������������������������������������������
For nDesco:=1 to Len(aDesco)
	nResto := ( ++nZebrado % 2 )
	IF !lTerminal
		cHtml += '<tr>'
		cHtml += 	'<td class="tdPrinc">' + aDesco[nDesco,1] + '</td>'
		cHtml += 	'<td class="td18_94_AlignR">' + Transform(aDesco[nDesco,2],'999.99') + '</td>'
		cHtml += 	'<td class="td18_95_AlignR">' + Transform(aDesco[nDesco,3],'@E 999,999.99') + '</td>'
		cHtml += 	'<td class="td18_18_AlignL">-</td>'
		cHtml += '</tr>'
	Else
		cHtml += '<tr>' + CRLF
        IF nResto > 0.00 
        	cHtml += '<td width="45" align="center" height="19" bgcolor="#FAFBFC">' 
        Else
        	cHtml += '<td width="45" align="center" height="19">' + CRLF
        EndIF	
        cHtml += '<div align="left"><span class="dados">'  + Substr( aDesco[nDesco,1] , 1 , 3 ) + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
		IF nResto > 0.00         
        	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else	
        	cHtml += '<td valign="top">' + CRLF           
        EndIF	
        cHtml += '<div align="Left"><span class="dados">'  + Capital( AllTrim( Substr( aDesco[nDesco,1] , 4 ) ) ) + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
   		IF nResto > 0.00         
        	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else	
        	cHtml += '<td valign="top">' + CRLF           
        EndIF	
        cHtml += '<div align="right"><span class="dados">' + Transform(aDesco[nDesco,2],'999.99') + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
		IF nResto > 0.00         
        	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else	
        	cHtml += '<td valign="top">' + CRLF           
        EndIF	
        cHtml += '<div align="right"><span class="dados">' + Transform(aDesco[nDesco,3],'@E 999,999.99') + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
        IF nResto > 0.00         
        	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else	
        	cHtml += '<td valign="top">' + CRLF           
        EndIF	
        cHtml += '<div align="center"><span class="dados"> (-) </span></div>' + CRLF
        cHtml += '</td>' + CRLF
        cHtml += '</tr>' + CRLF
	EndIF	
Next nDesco	   

IF !lTerminal

	//��������������������������������������������������������������Ŀ
	//� Espacos Entre os Proventos e Descontos e os Totais           �
	//����������������������������������������������������������������
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc"></td>'
	cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml += 	'</tr>'
	
	//��������������������������������������������������������������Ŀ
	//� Totais                                                       �
	//����������������������������������������������������������������
	cHtml += '<!Totais >'
	cHtml +=	'<b><i>'
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc">' + STR0053 + '</td>' //"Total Bruto "
	cHtml += 		'<td class="td18_94_AlignR"></td>'
	cHtml += 		'<td class="td18_95_AlignR">' + Transform(TOTVENC,"@E 999,999.99") + '</td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml +=	'</tr>'
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc">' + STR0054 + '</td>' //"Total Descontos "
	cHtml += 		'<td class="td18_94_AlignR"></Td>'
	cHtml += 		'<td class="td18_95_AlignR">' + Transform(TOTDESC,"@E 999,999.99") + '</td>'
	cHtml += 		'<td class="td18_18_AlignL">-</td>'
	cHtml += 	'</tr>'
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc">' + STR0055 + '</td>' //"Liquido a Receber "
	cHtml += 		'<td class="td18_94_AlignR"></td>'
	cHtml += 		'<td align=right height="18" width="95" Style="border-left:0px solid #FF812D; border-right:0px solid #FF9B06; border-bottom:0px solid #FF9B06 ; border-top:1px solid #FF9B06 bgcolor=#4B87C2">'
	cHtml +=        Transform((TOTVENC-TOTDESC),"@E 999,999.99") +'</td>'
	cHtml += 	'</tr>'
	cHtml += '<!Bases>'
	cHtml += 	'<tr>'
Else
	cHtml += '</table><br>' + CRLF
    cHtml += '<table width="490" border="0" cellspacing="0" cellpadding="0">' + CRLF
    cHtml += '<tr align="center">' + CRLF 
    cHtml += '<td width="219" valign="top">' + CRLF 
    cHtml += '<div align="left"><span class="etiquetas"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td width="45" height="16">' + CRLF
    cHtml += '<div align="left"><span class="etiquetas"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td width="127" valign="top">' + CRLF
    cHtml += '<div align="left"><span class="etiquetas"></span></div>' + CRLF
	cHtml += '</td>'
	cHtml += '<td width="107" valign="top">'
	cHtml += '<div align="right"><span class="etiquetas"></span></div>' + CRLF
	cHtml += '</td>'
	cHtml += '<td width="107" valign="top">' 
	cHtml += '<div align="center"><span class="etiquetas"></span></div>' + CRLF
	cHtml += '</td>'
	cHtml += '</tr>'
	cHtml += '<tr>' + CRLF
   	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="left" class="etiquetas"> ' + STR0065 + '</div>' + CRLF //"Total Bruto: "
    cHtml += '</td>' + CRLF
   	cHtml += '<td width="45" align="center" height="19" bgcolor="#FAFBFC">' 
    cHtml += '<div align="left"><span class="dados"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
   	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="right"><span class="dados"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
   	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="right"><span class="dados">' + Transform(TOTVENC,"@E 999,999.99") + '</span></div>' + CRLF
    cHtml += '</td>' + CRLF
   	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="center"><span class="dados"> (+) </span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '</tr>' + CRLF
	
	cHtml += '<tr>' + CRLF
    cHtml += '<td valign="top">' + CRLF 
    cHtml += '<div align="left" class="etiquetas">' + STR0066 + '</div>' + CRLF //"Total de Descontos: "
    cHtml += '</td>' + CRLF
    cHtml += '<td width="45" align="center" height="19">' 
    cHtml += '<div align="left"><span class="dados"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td valign="top">' + CRLF 
    cHtml += '<div align="right"><span class="dados"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td valign="top">' + CRLF 
    cHtml += '<div align="right"><span class="dados">' + Transform(TOTDESC,"@E 999,999.99") + '</span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td valign="top">' + CRLF
    cHtml += '<div align="center"><span class="dados"> (-) </span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '</tr>' + CRLF
	
	cHtml += '<tr>' + CRLF
    cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="left" class="etiquetas">' + STR0067  + '</div>' + CRLF //"L&iacute;quido a Receber: "
    cHtml += '</td>' + CRLF
    cHtml += '<td width="45" align="center" height="19" bgcolor="#FAFBFC">' 
    cHtml += '<div align="left"><span class="dados"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="right"><span class="dados"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="right"><span class="dados">' + Transform((TOTVENC-TOTDESC),"@E 999,999.99") + '</span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="center"><span class="dados"> (=) </span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '</tr>' + CRLF
    cHtml += '</table>' + CRLF
    cHtml += '<br>' + CRLF
EndIF	

//��������������������������������������������������������������Ŀ
//� Espacos Entre os Totais e as Bases                           �
//����������������������������������������������������������������
IF !lTerminal
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc"></td>'
	cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml += 	'</tr>'
Else
	cHtml += '<table width="498" border="0" cellspacing="0" cellpadding="0">' + CRLF
EndIF	

//��������������������������������������������������������������Ŀ
//� Base de Adiantamento                                         �
//����������������������������������������������������������������
If Esc = 1  
	If cBaseAux = "S" .And. nBaseIr # 0
		IF !lTerminal
			cHtml +=	'<tr>'
			cHtml +=		'<td class="tdPrinc"><p class="pStyle1"><font color=#000082 face="Courier new" size=2><i>'+STR0058+'</i></p></td></font>' //"Base IR Adiantamento"
			cHtml +=		'<td class="td26_94_AlignR"><p></td>'
			cHtml +=		'<td class="td26_95_AlignR"><p>'+ Transform(nBaseIr,"@E 999,999,999.99")+'</td>'
			cHtml +=		'<td class="td26_18_AlignL"><p></td>'
			cHtml += 	'</tr>'
		Else
			cHtml += '<tr>'
			cHtml += '<td width="304" class="etiquetas">' + STR0058 + ' + </td>' + CRLF
            cHtml += '<td width="103" class="dados"><div align="center">' + Transform(nBaseIr,"@E 999,999.99") + '</div></td>' + CRLF
            cHtml += '<td width="91"  class="dados"><div align="center">' + Transform(0.00   ,"@E 999,999.99") + '</div></td>' + CRLF
            cHtml += '</tr>'
		EndIF	
    Endif
//��������������������������������������������������������������Ŀ
//� Base de Folha e de 13o 20 Parc.                              �
//����������������������������������������������������������������
ElseIf Esc = 2 .Or. Esc = 4  
	IF cBaseAux = "S"
		IF !lTerminal
			cHtml += '<tr>'
			cHtml +=	'<td class="tdPrinc">'
   	    	cHtml +=    '<p class="pStyle1">'+ STR0056 +'</p></td>'//"Base FGTS/Valor FGTS"
			cHtml +=	'<td class="td26_94_AlignR">' + Transform(nBaseFgts,"@E 999,999.99")+'</td>'
			cHtml +=	'<td class="td26_95_AlignR">' + Transform(nFgts    ,"@E 999,999.99")+'</td>'
			cHtml += '</tr>'
			cHtml += '<tr>'
			cHtml +=	'<td class="tdPrinc">'
   	    	cHtml +=    '<p class="pStyle1">'+ STR0057 +'</p></td>'//"Base IRRF Folha/Ferias"
			cHtml +=	'<td class="td26_94_AlignR">' + Transform(nBaseIr,"@E 999,999.99")+'</td>'
			cHtml +=	'<td class="td26_95_AlignR">' + Transform(nBaseIrfe,"@E 999,999.99")+'</td>'
			cHtml += '</tr>'
		Else
			cHtml += '<tr>'
			cHtml += '<td width="304" class="etiquetas">' + STR0056 + '</td>' + CRLF //"Base FGTS/Valor FGTS"
       	    cHtml += '<td width="103" class="dados"><div align="center">' + Transform(nBaseFgts,"@E 999,999.99") + '</div></td>' + CRLF
           	cHtml += '<td width="91"  class="dados"><div align="center">' + Transform(nFgts    ,"@E 999,999.99") + '</div></td>' + CRLF
            cHtml += '</tr>'
			cHtml += '<tr>'
			cHtml += '<td width="304" class="etiquetas">' + STR0057 + '</td>' + CRLF //"Base IRRF Folha/Ferias"
       	    cHtml += '<td width="103" class="dados"><div align="center">' + Transform(nBaseIr,"@E 999,999.99") + '</div></td>' + CRLF
           	cHtml += '<td width="91"  class="dados"><div align="center">' + Transform(nBaseIrFe,"@E 999,999.99") + '</div></td>' + CRLF
            cHtml += '</tr>'
		EndIF	
	EndIF
//��������������������������������������������������������������Ŀ
//� Bases de FGTS e FGTS Depositado da 1� Parcela                �
//����������������������������������������������������������������
ElseIf Esc = 3  
	If cBaseAux = "S"
		IF !lTerminal
			cHtml += 	'<tr>'
			cHtml += 		'<td class="tdPrinc">' 
			cHtml +=		'<p class="pStyle1">'+ STR0056 +'</td>' //"Base FGTS / Valor FGTS"
			cHtml += 		'<td class="td26_94_AlignL">' + Transform(nBaseFgts,"@E 999,999,999.99") +'</td>'
			cHtml += 		'<td class="td26_95_AlignL">' + Transform(nFgts,"@E 99,999,999.99")+'</td>'
			cHtml +=		'<td align=right height="26" width="95"  style="border-left: 0px solid #FF9B06; border-right:0px solid #FF9B06; border-bottom:1px solid #FF9B06 ; border-top: 0px solid #FF9B06 bgcolor=#6F9ECE"></td>'
			cHtml += 	'</tr>'
		Else
			cHtml += '<tr>'
			cHtml += '<td width="304" class="etiquetas">' + STR0056 + ' + </td>' + CRLF //"Base FGTS/Valor FGTS"
       	    cHtml += '<td width="103" class="dados"><div align="center">' + Transform(nBaseFgts,"@E 999,999.99") + '</div></td>' + CRLF
           	cHtml += '<td width="91"  class="dados"><div align="center">' + Transform(nFgts    ,"@E 999,999.99") + '</div></td>' + CRLF
            cHtml += '</tr>'
		EndIF
	Endif
Endif
	
IF !lTerminal
	cHtml += '</font></i></b>'
	cHtml += '</TBody>'
	cHtml += '</table>'
	cHtml += '</center>'
	cHtml += '</div>'
	cHtml += '<hr whidth = 100% align=right color="#FF812D">'
	//��������������������������������������������������������������Ŀ
	//� Espaco para Observacoes/mensagens                            �
	//����������������������������������������������������������������
	cHtml += '<!Mensagem>'
	cHtml += '<Table bgColor=#6F9ECE border=0 cellPadding=0 cellSpacing=0 height=100 width=598>'
	cHtml += 	'<TBody>'
	cHtml +=	'<tr>'
	cHtml +=	'<td align=left height=18 width=574 style="border-left:1px solid #FF9B06; border-right:1px solid #FF9B06; border-bottom: 0px solid #FF9B06 ; border-top:1px solid #FF9B06 bgcolor=#6F9ECE"><i><font face="Courier New" size="2" color="#000082">'+DESC_MSG1+ '</font></td></tr>'
	cHtml +=	'<tr>'
	cHtml +=	'<td align=left height=18 width=574 style="border-left:1px solid #FF9B06; border-right:1px solid #FF9B06; border-bottom: 0px solid #FF9B06 ; border-top: 0px solid #FF9B06 bgcolor=#6F9ECE"><i><font face="Courier New" size="2" color="#000082">'+DESC_MSG2+ '</font></td></tr>'
	cHtml +=	'<tr>'
	cHtml += 	'<td align=left height=18 width=574 style="border-left:1px solid #FF9B06; border-right:1px solid #FF9B06; border-bottom:1px solid #FF9B06 ; border-top: 0px solid #FF9B06 bgcolor=#6F9ECE"><i><font face="Courier New" size="2" color="#000082">'+DESC_MSG3+ '</font></td></tr>'
	IF cMesComp == Month(SRA->RA_NASC)
		cHtml += '<TD align=left height=18 width=574 bgcolor="#FFFFFF"><EM><B><CODE>      <font face="Courier New" size="4" color="#000082">'
		cHtml += '<MARQUEE align="middle" bgcolor="#FFFFFF">' + STR0059	+ '</marquee><code></b></font></td></tr>' //"F E L I Z &nbsp;&nbsp  A N I V E R S A R I O !!!! "
	EndIF
	cHtml += '</TBody>'
	cHtml += '</Table>'
	cHtml += '</table>'
	cHtml += '</body>'
	cHtml += '</html>'
Else
	cHtml += '</table>' + CRLF
	cHtml += '<p>&nbsp;</p>' + CRLF
	cHtml += '</td>' + CRLF
    cHtml += '</tr>' + CRLF
    cHtml += '</table>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td background="../rhonline/imagens/tabela_conteudo_2.gif" width="7">&nbsp;</td>' + CRLF
    cHtml += '</tr>' + CRLF
    cHtml += '</table>' + CRLF
    cHtml += '</td>' + CRLF
  	cHtml += '</tr>' + CRLF
  	cHtml += '<tr>' + CRLF  
    cHtml += '<td><img src="../rhonline/imagens/tabela_conteudo_3.gif" width="515" height="14"></td>' + CRLF
  	cHtml += '</tr>' + CRLF  
	cHtml += '</table>' + CRLF
	cHtml += '<p align="right"><a href="javascript:self.print()"><img src="../rhonline/imagens/imprimir.gif" width="90" height="28" hspace="20" border="0"></a></p>' + CRLF
	cHtml += '</body>' + CRLF
	cHtml += '</html>' + CRLF
EndIF

//��������������������������������������������������������������Ŀ
//� Envia e-mail p/funcionario                                   �
//����������������������������������������������������������������
IF !lTerminal
	GPEMail(cSubject,cHtml,cEMail)
EndIF	

Return( IF( lTerminal , cHtml , NIL ) ) 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fImpTeste �Autor  �R.H. - Natie        � Data �  11/29/01   ���
�������������������������������������������������������������������������͹��
���Desc.     �Testa impressao de Formulario Teste                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static function fImpTeste(cString,nTipoRel)

//��������������������������������������������������������������Ŀ
//� Descarrega teste de impressao                                � 
//����������������������������������������������������������������
MS_Flush()
fInicia(cString)               

If nTipoRel == 2
	cCompac := aDriver[1]
    cNormal := aDriver[2]
	@ LI,00 PSAY &cCompac
Endif	

Pergunte("GPR30A",.T.)
Vez := If(mv_par01 = 1,1,0)

Return Vez

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fInicia   �Autor  �Natie               � Data �  04/12/01   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inicializa parametros para impressao                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function  fInicia(cString)

//��������������������������������������������������������������Ŀ
//� Inicializa Impressao                                         �
//����������������������������������������������������������������
aDriver := LEDriver()
If LastKey() = 27 .Or. nLastKey = 27
	Return .F. 
Endif
SetDefault(aReturn,cString)
If LastKey() = 27 .Or. nLastKey = 27
	Return   .F.
Endif
Return .T. 

/*/
		if nPag<>1	&& Fim de Pagina
			oPrn:EndPage()
			oPrn:StartPage()
		endif
oPrn:Setup() // para configurar impressora

//oPrn:Print() // descomentar esta linha para imprimir

MS_FLUSH()
/*/
