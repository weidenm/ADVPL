#INCLUDE "TOTVS.CH"
//#INCLUDE "ATUESOC.CH"

/*/
�������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������Ŀ��
���Fun��o    	� ATUESOC    � Autor � Marcia Moura - 12.1.25 	      � Data �05/09/2013���
���������������������������������������������������������������������������������������Ĵ��
���Descri��o 	� Atualiza��o dos campos SRA                                  			���
���������������������������������������������������������������������������������������Ĵ��
���Sintaxe   	� ATUESOC( )                                                   			���
���������������������������������������������������������������������������������������Ĵ��
��� Uso      	� Generico                                                   			���
���������������������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.               			���
���������������������������������������������������������������������������������������Ĵ��
���Programador  � Data     � FNC			�  Motivo da Alteracao                      ���
���������������������������������������������������������������������������������������Ĵ��
���Glaucia M.   �29/01/14  �                �Preparacao fase2 com novos campos          ���  
���Marcia Moura �31/01/14  �TIHG12          �Inclus�o do campo cargo, carga automatica  ���  
���             �          �                �pois passa a ser obrigatorio sera carrega  ���  
���             �          �                �do a partir da fun��o                      ���  
���Glaucia M.   �21/02/2014�TIIL14          �Inclusao de nova pergunta no conversor     ���
���             �          �00000004960/2014�eSocial.                                   ���
���Mariana M.   �23/06/14  �TII100          �Ajuste para que o campo RA_CATEFD seja pre-���  
���             �          �                �enchido corretamente                       ��� 
��|Claudinei S. |04/09/2017|DRHESOCP-876    |Disponibilizado o fonte para a vers�o 12.  |��  
����������������������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������*/
User Function ATUESOC()

	Local aSays			:= {}
	Local aButtons		:= {}

	Local bProcesso		:= { |oSelf| GPMProcessa(oSelf)}

	Local cPerg
	Local cCadastro		:= OemToAnsi("Convers�o de novos campos SRA - eSocial")	//"Convers�o de novos campos SRA - eSocial"
	Local cDescricao	:= OemToAnsi("Este Programa efetuar� a convers�o dos novos campos criados para o eSocial" )	//"Este Programa efetuar� a convers�o dos novos campos criados para o eSocial"

	Local nOpca			:= 0

	Private aLog		:= {}
	Private aRoteiro 	:= {}
	Private aTitle		:= {}

	Private lAbortPrint := .F.

	Static     aEfd                      := If( cPaisLoc == 'BRA', If(Findfunction("fEFDSocial"), fEFDSocial(), {.F.,.F.,.F.}), {.F.,.F.,.F.} )

 //	// Var utilizada para forcar a Carga da Tabela a cada processamento. Eh necessaria para
 //	// que aTab_Fol seja atualizada conforme as tabelas de cada empresa na funcao fPosTab.
 //	Private lCarTabFol := .T.

	//�������������������������������������������������������������������������Ŀ
	//� Verifica existencia dos novos campos na SRA                      		�
	//���������������������������������������������������������������������������
	If (cPaisLoc == 'BRA' .AND.  aEfd[1])

		If Empty( RetTableName( "RFX" ) )
			Aviso( "Aten��o", "Execute a op��o do compatibilizador referente ao eSocial. Para maiores informa��es, verifique respectivo Boletim T�cnico.", { "OK" } ) // "Aten��o"## "Execute a op��o do compatibilizador referente ao eSocial. Para maiores informa��es, verifique respectivo Boletim T�cnico." ## "OK"
			Return
		EndIf

		cPerg 	:= "GPESOC"

		ValidPerg(cPerg)
		
		Pergunte(cPerg,.F.)

		tNewProcess():New( "ATUESOC", "Atualiza��o dos novos campos eSocial - SRA", bProcesso, "    Esta rotina tem por objetivo alimentar automaticamente os campos novos do Cadastro de Funcion�rios, criados para o eSocial  ", cPerg, , , , , .T., .T. )
	EndIf
Return

/*
�����������������������������������������������������������������������Ŀ
�Fun��o    � GPMProcessa	�Autor�  Marcia Moura      Data �05/09/2013�
�����������������������������������������������������������������������Ĵ
�Descri��o �Rotina de Processamento.                                    �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �< Vide Parametros Formais >									�
�����������������������������������������������������������������������Ĵ
� Uso      �ATUESOC                                                    �
�����������������������������������������������������������������������Ĵ
� Retorno  �aRotina														�
�����������������������������������������������������������������������Ĵ
�Parametros�< Vide Parametros Formais >									�
�������������������������������������������������������������������������*/
Static Function GPMProcessa(oSelf)

	Local cFilDe
	Local cFilAte
	Local cMatrDe
	Local cMatrAte
	Local cSituacao
	Local aLogr := {}
	Local _aArea	:= GetArea()
	Local cAcessaSRA	:= &( " { || " + IF( Empty( cAcessaSRA := ChkRH( "ATUESOC" , "SRA" , "2" ) ) , ".T." , cAcessaSRA ) + " } " )
	Local cAliasSRA		:= "SRA"
	Local lRet
	Local lHasDep

	cFilDe		:=	mv_par01	//	Filial De
	cFilAte 	:=	mv_par02	//	Filial Ate
	cMatrDe 	:=	mv_par03	//	Matricula De
	cMatrAte	:=	mv_par04	//	Matricula Ate
	cSituacao	:=  mv_par05	//  Situacoes a serem calculadas
	nLogrTp		:=  mv_par06	//  1-So preenche RA_LOGRTP vazio / 2-Altera o campo RA_LOGRTP vazio ou n�o

	oSelf:SetRegua1(SRA->(RecCount()))
	oSelf:SaveLog( "Convers�o do SRA - eSocial" + " - " + "Inicio do processamento") //"Convers�o do SRA - eSocial"##"Inicio do processamento"

	// Filtrar os funcionarios que serao processados //
	dbSelectArea( "SRA" )
	dbSetOrder( 1 )
	dbSeek( cFilDe + cMatrDe , .T. )

	While (cAliasSRA)->( !Eof() )

		If oSelf:lEnd
			Break
		EndIf

		If Eof() .Or. ( (cAliasSRA)->RA_FILIAL + (cAliasSRA)->RA_MAT > cFilAte + cMatrAte )
			Exit
		Endif

   		If ( (cAliasSRA)->RA_MAT < cMatrDe .or. (cAliasSRA)->RA_MAT > cMatrAte ) .or. !( (cAliasSRA)->RA_SITFOLH $ cSituacao )
				dbSelectArea(cAliasSRA)
				dbSkip()
				Loop
		EndIf

		oSelf:IncRegua1(OemToAnsi("Convertendo Dados") + "  " + (cAliasSRA)->RA_FILIAL + " - " + (cAliasSRA)->RA_MAT + " - " + SRA->RA_NOME) //

		Begin Transaction
		       //Categoria eSocial
		    RecLock("SRA",.F.)

			If FieldPos( "RA_CATEFD" ) # 0  .AND. EMPTY((cAliasSRA)->RA_CATEFD)
			   if (cAliasSRA)->RA_CATFUNC == "E" .OR.(cAliasSRA)->RA_CATFUNC == "G"
			   		(cAliasSRA)->RA_CATEFD := "901"
			   Else
			   		if (cAliasSRA)->RA_CATEG == "  "
			   			(cAliasSRA)->RA_CATEFD := "101"
			   		Else
				   		(cAliasSRA)->RA_CATEFD := fDescRCC('S049',(cAliasSRA)->(RA_CATEG),4,2,1,3)
			   		endif
			   Endif
			Endif
			
			//se deficiencia Fisica eSocial estiver vazio
			If FieldPos( "RA_PORTDEF" ) # 0 .AND. EMPTY((cAliasSRA)->RA_PORTDEF)
				If TAMSX3("RA_PORTDEF")[1] == 4
					If (cAliasSRA)->RA_TPDEFFI == "1"
						(cAliasSRA)->RA_PORTDEF := "1***"
					elseif (cAliasSRA)->RA_TPDEFFI == "2"
						(cAliasSRA)->RA_PORTDEF := "*2**"
					elseif (cAliasSRA)->RA_TPDEFFI == "3"
						(cAliasSRA)->RA_PORTDEF := "**3*"
					elseif (cAliasSRA)->RA_TPDEFFI == "6"
						(cAliasSRA)->RA_PORTDEF := "***4"
					endif
				ElseIf TAMSX3("RA_PORTDEF")[1] == 6
					If (cAliasSRA)->RA_TPDEFFI == "1"
						(cAliasSRA)->RA_PORTDEF := "1*****"
					elseif (cAliasSRA)->RA_TPDEFFI == "2"
						(cAliasSRA)->RA_PORTDEF := "*2****"
					elseif (cAliasSRA)->RA_TPDEFFI == "3"
						(cAliasSRA)->RA_PORTDEF := "**3***"
					elseif (cAliasSRA)->RA_TPDEFFI == "6"
						(cAliasSRA)->RA_PORTDEF := "*****6"
					endif
				EndIf
	        Endif
	        
	       	//tipo de conta, so sera preenchido se os campos banco e conta estiverem preenchidos
   			If !Empty((cAliasSRA)->RA_BCDEPSA) .AND. !Empty((cAliasSRA)->RA_CTDEPSA)
   				If FieldPos( "RA_TPCTSAL" ) # 0 .AND. Empty((cAliasSRA)->RA_TPCTSAL)  
               		(cAliasSRA)->RA_TPCTSAL := "1"
	       		ElseIf FieldPos( "RA_TPCTDEP" ) # 0 .AND. Empty((cAliasSRA)->RA_TPCTDEP)
					(cAliasSRA)->RA_TPCTDEP := "1"
				EndIf
   			EndIf

           //tipo de previdencia
   			If FieldPos( "RA_TPPREVI" ) # 0 .AND. Empty((cAliasSRA)->RA_TPPREVI)
				(cAliasSRA)->RA_TPPREVI := "1"
			EndIf

			//Informa��o de aposentadoria
   			If FieldPos( "RA_EAPOSEN" ) # 0 .AND. Empty((cAliasSRA)->RA_EAPOSEN)
				(cAliasSRA)->RA_EAPOSEN := "2"
			EndIf
			
           //Emissor do RG
   			If FieldPos( "RA_RGEXP" ) # 0
           	If empty((cAliasSRA)->RA_RGEXP)
              		If !(empty((cAliasSRA)->RA_RGORG))
	          			(cAliasSRA)->RA_RGEXP := (cAliasSRA)->RA_RGORG
	          		Else
	          			(cAliasSRA)->RA_RGEXP := (cAliasSRA)->RA_ORGEMRG
	          		Endif
	          	Endif
	        endif
	        

			dbSelectArea(cAliasSRA)

            
            //Cargo
   			If FieldPos( "RA_CARGO" ) # 0
	           	If empty((cAliasSRA)->RA_CARGO)
        	   		dbSelectArea("SRJ")
   	  				If dbSeek(fwxFilial("SRJ") + (cAliasSRA)->RA_CODFUNC)
   						(cAliasSRA)->RA_CARGO := SRJ->RJ_CARGO
   					Endif
					dbSelectArea(cAliasSRA)
				Endif
	        Endif


			// Nacionalidade
			If FieldPos( "RA_NACIONC" ) # 0 .AND. Empty((cAliasSRA)->RA_NACIONC)
               If (cAliasSRA)->RA_NACIONA == "10" .OR.(cAliasSRA)->RA_NACIONA == "20"
               		(cAliasSRA)->RA_NACIONC := "01058"
               Elseif (cAliasSRA)->RA_NACIONA == "21"
               		(cAliasSRA)->RA_NACIONC := "00639"
               Elseif (cAliasSRA)->RA_NACIONA == "22"
               		(cAliasSRA)->RA_NACIONC := "00973"
               Elseif (cAliasSRA)->RA_NACIONA == "23"
               		(cAliasSRA)->RA_NACIONC := "01589"
               Elseif (cAliasSRA)->RA_NACIONA == "24"
               		(cAliasSRA)->RA_NACIONC := "05860"
               Elseif (cAliasSRA)->RA_NACIONA == "25"
               		(cAliasSRA)->RA_NACIONC := "08451"
               Elseif (cAliasSRA)->RA_NACIONA == "26"
               		(cAliasSRA)->RA_NACIONC := "06475"
               Elseif (cAliasSRA)->RA_NACIONA == "27"
               		(cAliasSRA)->RA_NACIONC := "04936"
               Elseif (cAliasSRA)->RA_NACIONA == "28"
               		(cAliasSRA)->RA_NACIONC := "05894"
               Elseif (cAliasSRA)->RA_NACIONA == "29"
               		(cAliasSRA)->RA_NACIONC := "02399"
               Elseif (cAliasSRA)->RA_NACIONA == "30"
               		(cAliasSRA)->RA_NACIONC := "00230"
               Elseif (cAliasSRA)->RA_NACIONA == "31"
               		(cAliasSRA)->RA_NACIONC := "00876"
               Elseif (cAliasSRA)->RA_NACIONA == "32"
               		(cAliasSRA)->RA_NACIONC := "06289"
               Elseif (cAliasSRA)->RA_NACIONA == "34"
               		(cAliasSRA)->RA_NACIONC := "01490"
               Elseif (cAliasSRA)->RA_NACIONA == "35"
               		(cAliasSRA)->RA_NACIONC := "02453"
               Elseif (cAliasSRA)->RA_NACIONA == "36"
               		(cAliasSRA)->RA_NACIONC := "02496"
               Elseif (cAliasSRA)->RA_NACIONA == "37"
               		(cAliasSRA)->RA_NACIONC := "02755"
               Elseif (cAliasSRA)->RA_NACIONA == "38"
               		(cAliasSRA)->RA_NACIONC := "07676"
               Elseif (cAliasSRA)->RA_NACIONA == "39"
               		(cAliasSRA)->RA_NACIONC := "03867"
               Elseif (cAliasSRA)->RA_NACIONA == "40"
               		(cAliasSRA)->RA_NACIONC := "03417"
               Elseif (cAliasSRA)->RA_NACIONA == "41"
               		(cAliasSRA)->RA_NACIONC := "03999"
               Elseif (cAliasSRA)->RA_NACIONA == "42"
               		(cAliasSRA)->RA_NACIONC := "01600"
               Elseif (cAliasSRA)->RA_NACIONA == "43"
               		(cAliasSRA)->RA_NACIONC := "01872"
               Elseif (cAliasSRA)->RA_NACIONA == "44"
               		(cAliasSRA)->RA_NACIONC := "06769"
               Elseif (cAliasSRA)->RA_NACIONA == "45"
               		(cAliasSRA)->RA_NACIONC := "06076"
               Elseif (cAliasSRA)->RA_NACIONA == "46"
               		(cAliasSRA)->RA_NACIONC := "05762"
               Elseif (cAliasSRA)->RA_NACIONA == "47"
               		(cAliasSRA)->RA_NACIONC := "03611"
               Elseif (cAliasSRA)->RA_NACIONA == "60"
               		(cAliasSRA)->RA_NACIONC := "00400"
               Elseif (cAliasSRA)->RA_NACIONA == "61"
               		(cAliasSRA)->RA_NACIONC := "01775"
               Elseif (cAliasSRA)->RA_NACIONA == "62"
               		(cAliasSRA)->RA_NACIONC := "07560"
               Elseif (cAliasSRA)->RA_NACIONA == "96"
               		(cAliasSRA)->RA_NACIONC := "08508"
               Elseif (cAliasSRA)->RA_NACIONA == "97"
               		(cAliasSRA)->RA_NACIONC := "01694"
			   Endif
			Endif
			
			//Tipo de Logradouro, logradouro e Numero
			If FieldPos( "RA_LOGRTP" ) # 0 
				If (nLogrTp == 1 .AND. EMPTY((cAliasSRA)->RA_LOGRTP)) .OR. (nLogrTp == 2)
					aLogr := {}
					aLogr := fCargaLogr((cAliasSRA)->RA_ENDEREC,(cAliasSRA)->RA_NUMENDE)
					(cAliasSRA)->RA_LOGRTP := aLogr[1]
					(cAliasSRA)->RA_LOGRDSC := aLogr[2]
					(cAliasSRA)->RA_LOGRNUM := aLogr[3]
				EndIf
			endif

			//Municipio Endereco
			DbSelectArea( "CC2" )
			DbSetOrder(2)
			MsSeek(fwxFilial("CC2")+ (cAliasSRA)->RA_MUNICIP)
			While CC2->(!Eof())
				if CC2->CC2_EST == (cAliasSRA)->RA_ESTADO
					(cAliasSRA)->RA_CODMUN := CC2->CC2_CODMUN
					exit
				else
					DbSelectArea( "CC2" )
					CC2->(dbSkip())
				Endif
			end
				
			//Municipio Nascimento
			DbSelectArea( "CC2" )
			DbSetOrder(2)
			MsSeek(fwxFilial("CC2")+ (cAliasSRA)->RA_MUNNASC)
			While CC2->(!Eof())
				if CC2->CC2_EST == (cAliasSRA)->RA_NATURAL
					(cAliasSRA)->RA_CODMUNN := CC2->CC2_CODMUN
					exit
				else
					DbSelectArea( "CC2" )
					CC2->(dbSkip())	
				Endif
			end

			dbSelectArea(cAliasSRA)
			MsUnLock()

		End Transaction
       
       dbSelectArea(cAliasSRA)
		(cAliasSRA)->(DbSkip())
	EndDo

	/*
	���������������������������������������������������������Ŀ
	� Apresenta com Log de erros                              �
	�����������������������������������������������������������*/
	fMakeLog(aLog,aTitle,,.T.,"ATUESOC","LOG de Atualiza��o registros SRA" ,"M","P",,.F.)  //

Return


/*
�����������������������������������������������������������������������Ŀ
�Fun��o    �ValidPerg � Autor �Equipe RH              � Data �02/04/2012�
�����������������������������������������������������������������������Ĵ
�Descri��o �Ajusta Perguntas 											�
�������������������������������������������������������������������������*/
Static Function ValidPerg(cPerg)
Local _aArea	:= GetArea()
Local aRegs		:= {}
Local i, j		:= 0

cPerg			:= "GPESOC    "
cPerg			:= PADR(cPerg, 6)
aHelpPor:= {"1-Sim: Somente se o campo RA_LOGRTP ",;
			"estiver vazio, o mesmo ser� ",;
			"preenchido baseado no campo ",;
			"RA_ENDEREC.                     ",;
			" /                               ",;
			"2-N�o: O campo RA_LOGRTP ser� ",;
			"preenchido ou substitu�do com base",;
			" no conte�do do campo RA_ENDEREC"}
			
aHelpEng:= {"Sim - Somente se o campo RA_LOGRTP ",;
			"estiver vazio, o mesmo ser� ",;
			"preenchido baseado no campo ",;
			"'RA_ENDEREC' ",;
			"N�o - O campo RA_LOGRTP ser� ",;
			"preenchido ou substitu�do com base",;
			" no conte�do do campo RA_ENDEREC"}

aHelpSpa:= {"Sim - Somente se o campo RA_LOGRTP ",;
			"estiver vazio, o mesmo ser� ",;
			"preenchido baseado no campo ",;
			"'RA_ENDEREC' ",;
			"N�o - O campo RA_LOGRTP ser� ",;
			"preenchido ou substitu�do com base",;
			" no conte�do do campo RA_ENDEREC"}						
		
PutSX1Help("P"+".GPESOC06.",aHelpPor,aHelpEng,aHelpSpa, .T.)


SX1->(dbSetOrder(1))

// Grupo/Ordem/Pergunta/Perg.SPA/Perg.ENG/Variavel/Tipo/Tamanho/Decimal/Presel														/GSC/Valid				/ Var01		/Def01/Def1.SPA/Def1.ENG	/Cnt01/ Var02/Def02/Def1.SPA/Def1.ENG/Cnt02/ Var03/Def03/Def1.SPA/Def1.ENG/Cnt03/ Var04/Def04/Def1.SPA/Def1.ENG/Cnt04/ Var05/Def05/Def1.SPA/Def1.ENG/Cnt05/ F3/PYME/GRPSXG/HELP/PICTURE/IDFIL
cHelp := ".RHFILDE."
aAdd(aRegs, {cPerg, "01", "Filial De                ", "Filial De                		", ".", "mv_ch1", "C", FWGETTAMFILIAL, 0, 0, "G", ""				, "mv_par01", "", "", "", "01"			, ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "XM0"	, "S", "033", cHelp, "", ""})
cHelp := ".RHFILAT."
aAdd(aRegs, {cPerg, "02", "Filial Ate               ", "Filial Ate               		", ".", "mv_ch2", "C", FWGETTAMFILIAL, 0, 0, "G", "NaoVazio()"		, "mv_par02", "", "", "", "01"			, ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "XM0"	, "S", "033", cHelp, "", ""})
cHelp := ".RHMATD."
aAdd(aRegs, {cPerg, "03", "Matricula De             ", "Matricula De             		", ".", "mv_ch3"			, "C", 06, 0, 0, "G", ""				, "mv_par03", "", "", "", "0"			, ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SRA"	, "S", ""	, cHelp, "", ""})
cHelp := ".RHMATA."
aAdd(aRegs, {cPerg, "04", "Matricula Ate            ", "Matricula Ate            		", ".", "mv_ch4"			, "C", 06, 0, 0, "G", "NaoVazio()"		, "mv_par04", "", "", "", "Z"			, ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SRA"	, "S", ""	, cHelp, "", ""})

aAdd(aRegs, {cPerg, "05", "Situa��o 	            ", "Situa��o                  		", ".", "mv_ch5"			, "C", 15, 0, 0, "G", "fSituacao()"		, "mv_par05", "", "", "", " "			, ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, ".RHSITUA.", "", ""})
aAdd(aRegs, {cPerg, "06", "Preenche apenas TpLogr vazio?", "Converte apenas TpLogr vazio?", ".", "mv_ch6"			, "C", 01, 0, 0, "C", ""				, "mv_par06", "1-Sim", "1-Sim", "1-Sim", " "	, ""	, "2-N�o", "2-N�o", "2-N�o", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, ".GPESOC06.", "", ""})

dbSelectArea("SX1")
SX1->( DbSetorder(1) )

If !SX1->(dbSeek(cPerg))
	For i := 1 to Len(aRegs)
		If	!SX1->(dbSeek(cPerg + aRegs[i, 2]))
			RecLock("SX1", .T.)
			For j := 1 to FCount()
				FieldPut(j, aRegs[i, j])
			Next
			MsUnlock("SX1")
		endif
	Next
EndIf
	
If	!SX1->(dbSeek("GPESOC    06"))
	RecLock("SX1", .T.)
	For j := 1 to FCount()
		FieldPut(j, aRegs[6, j])
	Next
	MsUnlock("SX1")
EndIf

RestArea (_aArea)
Return Nil
