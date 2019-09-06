#INCLUDE "RWMAKE.CH"
#include "topconn.ch"
#include "tbiconn.ch"

/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMP 5.0   ºAutor  ³ 					º Data ³  15/04/16    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ IMPORTA DADOS DO OFICIAL PARA TOTVS	                     º±±
±±ºPROGRAMA  ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Considera todos os registros,mesmo os já atualizados e     º±±
±±º versão   ³ com LOG                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                     c   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IMP3()

	cPerg  :="PIMP"
		
	If !Pergunte (cPerg,.T.)
		Return
	EndIf

	Public cPedIni := MV_PAR01
	Public cPedFim := MV_PAR02
	Public cDataIni := MV_PAR03
	Public cDataFim := MV_PAR04
	//	Public cAtualizProd := MV_PAR05
//		Public cAtualizaCli := MV_PAR06

     
	conexao()

Return Nil
 
 
 
Static Function conexao()


	cData := Dtoc(date())

	cHora := time()
	Public DataHora := cData + " " + cHora
  
	conout("iniciando importacao "+DataHora)
Processa({|| gravaPedido()},"Aguarde...","Separando Pedidos...")	
Processa({||AtualizaPedido()},"Aguarde...","Atualizando Pedidos...")

		
If MV_PAR05 == 1
	Processa({|| gravaProduto()},"Aguarde...","Separando Produtos...")
	Processa({|| gravaMotorista()},"Aguarde...","Separando Motoristas...")

	Processa({||AtualizaVeiculo()},"Aguarde...","Atualizando Veiculos...") //- Alterado para TOTVS2
	Processa({||AtualizaMotorista()},"Aguarde...","Atualizando Motoristas...") //- Alterado para TOTVS2
	Processa({||AtualizaProduto()},"Aguarde...","Atualizando Produtos...") //- Alterado para TOTVS2
EndIf
	
	If MV_PAR06 == 1
		Processa({|| gravaCliente()},"Aguarde...","Separando Clientes...")
		Processa({||AtualizaCliente()},"Aguarde...","Atualizando Clientes...")
		//Processa({||AtualizaRoman()},"Aguarde...","Atualizando num. romaneio...") 
	EndIf

Return



Static Function gravaPedido()

	QryAtualiza := ""

	cPedIni  := MV_PAR01
	cPedFim  := MV_PAR02
	cDataIni := dtos(MV_PAR03)
	cDataFim := dtos(MV_PAR04)
	cData := Dtoc(date())
	cHora := time()
	Public DataHora := cData + " " + cHora


//PEDIDOS NÃO EXCLUÍDOS, MENORES QUE 900000 OU JÁ HOUVER SIDO IMPORTADO.   
	If Select("CABPED") > 0
		dbSelectArea("CABPED")
		dbCloseArea()
	EndIf
	
	cQuery := "SELECT C5_FILIAL,C5_NUM,C5_TIPO,C5_CLIENTE,C5_LOJACLI,C5_CLIENT,C5_LOJAENT,C5_TIPOCLI,C5_CONDPAG,C5_TABELA,C5_VEND1,C5_COMIS1,"
	cQuery += " C5_DESC1,C5_EMISSAO,C5_VOLUME1,C5_PBRUTO,C5_PESOL,C5_ESPECI1,C5_OBS, C5_MENNOTA,C5_MENPAD,C5_TIPLIB,C5_DESCONT,C5_TXMOEDA,C5_TPCARGA,C5_NUMLDX,"
	cQuery += " C5_ROMANEI, C5_ROMIT,C5_DTSAIDA,C5_TPFRETE,C5_IMPRESS FROM SRVPP01.DADOS12.dbo.SC5010 WHERE D_E_L_E_T_ = '' AND C5_NUM < '900000'  "
	cQuery += "  AND C5_EMISSAO >= '"+ cDataIni +"' and C5_EMISSAO <= '"+ cDataFim +"' "
	cQuery += "  AND C5_NUM >= '"+ cPedIni +"' and C5_NUM <= '"+ cPedFim +"' "
	cQuery += " AND C5_EMISSAO >'"+ dtos(ddatabase-30) +"'"
	cQuery += " 	AND C5_CLIENTE IN (SELECT A1_COD FROM SRVPP03.DADOSTOTVS11.dbo.SA1010 WHERE D_E_L_E_T_ ='' )"
	cQuery += " ORDER BY C5_NUM "
	
	//conout(cQuery)
	TCQuery cQuery Alias CABPED New
	
/*
	If Select("ITENSPED") > 0
		dbSelectArea("ITENSPED")
		dbCloseArea()
	EndIf


cQuery := "  SELECT VLR_TABELA AS C6_PRUNIT, ISNULL(PER_DESCACRES,C6_DESCONT) AS C6_DESCONT,C6_FILIAL,C6_NUM,C6_ITEM,C6_PRODUTO,C6_UM,C6_QTDVEN, ISNULL(LI.VLR_VENDA, C6_PRCVEN) AS  C6_PRCVEN, "
cQuery += " C6_VALOR,C6_SEGUM,C6_TES,C6_UNSVEN, C6_LOCAL,C6_CF,C6_QTDENT,C6_QTDENT2,C6_CLI,C6_VALDESC,C6_ENTREG,C6_LOJA,C6_COMIS1,C6_DESCRI, C5_TABELA, "
cQuery += " C6_CLASFIS, C6_NUMLDX, C6_SUGENTR FROM (SRVPP01.DADOS12.dbo.SC6010 A INNER JOIN SRVPP01.DADOS12.dbo.SC5010 B ON A.C6_NUM = B.C5_NUM) "
cQuery += " LEFT OUTER JOIN  SRVPP01.LANDIX_FLX.dbo.TAFCAB LC ON str(A.C6_NUMLDX)+A.C6_CLI+A.C6_LOJA = str(LC.NUM_PEDIDO)+LC.COD_CLIENTE COLLATE Latin1_General_BIN "
cQuery += " LEFT OUTER JOIN  SRVPP01.LANDIX_FLX.dbo.TAFITE LI ON LC.NUM_PEDIDO = LI.NUM_PEDIDO AND A.C6_PRODUTO = LI.COD_PRODUTO COLLATE Latin1_General_BIN "
cQuery += " WHERE A.D_E_L_E_T_ = '' AND  B.D_E_L_E_T_ = ''" // AND TAB.D_E_L_E_T_='' "
cQuery += " AND C6_NUM < '900000' AND B.C5_EMISSAO >= '"+ cDataIni +"' and B.C5_EMISSAO <=  '"+ cDataFim +"' "
cQuery += " AND B.C5_NUM >= '"+ cPedIni +"' and B.C5_NUM <=  '"+ cPedFim +"' AND C5_EMISSAO >'"+ dtos(ddatabase-30)  +"'"
cQuery += " ORDER BY C6_NUM "	

conout(cQuery)
	TCQuery cQuery Alias ITENSPED New
*/

Return
    
Static Function gravaFornecedor()
	If Select("FORNECE") > 0
		dbSelectArea("FORNECE")
		dbCloseArea()
	EndIf

	cQuery := " SELECT A2_FILIAL,A2_COD,A2_LOJA,A2_NOME,A2_NREDUZ,A2_END,A2_NR_END,A2_BAIRRO,A2_EST,A2_ESTADO,A2_COD_MUN,A2_MUN,A2_CEP,A2_CX_POST,A2_TIPO,A2_CGC,A2_PFISICA,A2_DDD,"
	cQuery +=" A2_TEL,A2_FAX,A2_INSCR,A2_INSCRM,A2_CONTATO,A2_NATUREZ,A2_PRIOR,A2_RISCO,A2_COND,A2_DESVIO,A2_CONTA,A2_RECISS,A2_PAIS,A2_STATUS,A2_VINCULA,A2_EMAIL,  "
	cQuery +=" A2_HPAGE,A2_CODMUN,A2_DTAVA,A2_DTVAL,A2_OK,A2_RECINSS,A2_GRPTRIB,A2_CONTAB,A2_CLIQF,A2_CODBLO,A2_PAISORI,A2_B2B,A2_PLCRRES,A2_DATBLO,A2_CBO,A2_CNAE,A2_PAGAMEN,"
	cQuery +=" A2_MSBLQL,A2_LOGRADO FROM SRVPP01.DADOS12.dbo.SA2010 WHERE D_E_L_E_T_ = '' AND A2_IMP = 'S'"

	TCQuery cQuery Alias FORNECE New

Return


Static Function gravaCliente()
	If Select("CLIENTES") > 0
		dbSelectArea("CLIENTES")
		dbCloseArea()
	EndIf

//Importa ou atualiza clientes não excluídos
	cQuery := "SELECT A1_FILIAL,A1_COD,A1_LOJA,A1_NOME,A1_PESSOA,A1_TPJ, A1_IENCONT, A1_CONTRIB, A1_NREDUZ,A1_TIPO,A1_EST,A1_COD_MUN,A1_MUN,A1_NATUREZ,A1_END,A1_COND,"
	cQuery += " A1_BAIRRO,A1_CEP, A1_DDD, A1_TEL,A1_PAIS,A1_CGC,A1_INSCR, A1_INSCRM,A1_VEND,A1_COMIS, A1_RISCO, A1_CNAE,A1_CONDPAG, "
	cQuery +=" A1_MSBLQL,A1_DTINIV, A1_COMPLEM, A1_LOGRADO, A1_NR_END,A1_EMAIL, A1_HPAGE,A1_CONTA,A1_CEL,A1_CODPAIS, A1_OBS, A1_OBSVEND FROM SRVPP01.DADOS12.dbo.SA1010"
	cQuery += " WHERE D_E_L_E_T_ = '' AND A1_CGC <> '' AND A1_CGC NOT LIKE '000000%' AND A1_MSBLQL<>'1'"

	TCQuery cQuery Alias CLIENTES New

Return


Static Function gravaProduto()

	If Select("PRODUTOS") > 0
		dbSelectArea("PRODUTOS")
		dbCloseArea()
	EndIf

//IMPORTA ou atualiza PRODUTOS NÃO EXCLUIDOS E COM O CAMPO B1_IMPOR igual a SIM.
	cQuery := "SELECT B1_FILIAL,B1_COD,B1_DESC,B1_TIPO,B1_UM,B1_LOCPAD,B1_GRUPO,B1_POSIPI,B1_TS,B1_PICMRET,B1_PICMENT,B1_SEGUM,  "
	cQuery += " B1_CONV,B1_TIPCONV,B1_GRTRIB,B1_CC, B1_ORIGEM, B1_CONTA, B1_CODBAR FROM SRVPP01.DADOS12.dbo.SB1010 "
	cQuery += " WHERE D_E_L_E_T_ = '' "
	//cQuery += " AND B1_COD NOT IN (SELECT B1_COD FROM SRVPP03.DADOSTOTVS11.dbo.SB1010 WHERE D_E_L_E_T_='')"

//Grava dados da base 2
	TCQuery cQuery Alias PRODUTOS New

Return


Static Function gravaMotorista()

	If Select("MOTORISTA") > 0
		dbSelectArea("MOTORISTA")
		dbCloseArea()
	EndIf

	cQuery := "SELECT DA4_COD, DA4_NOME, DA4_NREDUZ,  DA4_CGC, DA4_TEL, DA4_NUMCNH,DA4_REGCNH, DA4_DTVCNH"
	cQuery += ", DA4_MUNCNH, DA4_ESTCNH, DA4_CATCNH, DA4_DATNAS, DA4_BLQMOT, DA4_VNCART, DA4_ADMISS"
//cQuery += ", DA4_END, DA4_BAIRRO, DA4_MUN, DA4_EST, DA4_CEP"
	cQuery += " FROM SRVPP01.DADOS12.dbo.DA4010 WHERE D_E_L_E_T_=''"
	
	TCQuery cQuery Alias MOTORISTA New
	
	If Select("VEICULO") > 0
		dbSelectArea("VEICULO")
		dbCloseArea()
	EndIf
	
	cQuery := "SELECT DA3_COD, DA3_DESC, DA3_PLACA, DA3_MUNPLA, DA3_ESTPLA, DA3_CAPACN, "
	cQuery += " DA3_CAPACM, DA3_VOLMAX, DA3_MOTORI, DA3_ATIVO,DA3_CODFOR, DA3_LOJFOR  "
	cQuery += " FROM SRVPP01.DADOS12.dbo.DA3010 WHERE D_E_L_E_T_=''  "

	TCQuery cQuery Alias VEICULO New

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ InsereReg   ºAutor  ³			  º Data ³  09/28/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Importa registros                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//Insere registros não existentes
Static Function AtualizaPedido()

	dbSelectArea("SB1") //PARA NAO GERAR ERRO DE WORK AREA
	
	cData := Dtoc(date())
	cHora := time()
	contItPed := 0
	Pedido := ""
	Public DataHora := cData + " " + cHora


//INCLUI CABEÇALHO PEDIDOS NÃO IMPOTADOS


	dbSelectArea("CABPED")
	CABPED->(dbGotop())
	//ProcRegua(FCount())

	//cIndexName := Criatrab(NIL,.F.)
	//cIndexKey := "C5_FILIAL+C5_NUM"

	//IndRegua("CABPED", cIndexName, cIndexKey,,,"Aguarde,incluindo pedido "+ TRIM(CABPED->C5_NUM)+ " ...")

	Do While (!CABPED->(Eof()))
		conout("While "+CABPED->C5_NUM+" - "+ time())
		dbSelectArea("SC5")
		dbsetorder(1)
		dbseek(xfilial("SC5")+CABPED->C5_NUM)
	
		If ! SC5->(found())
		//	conout("Gravando " + Pedido + ":"+time())
			RecLock("SC5",.t.)
			SC5->C5_NUM:=CABPED->C5_NUM
			SC5->C5_FILIAL:='01'
			//SC5->C5_INDPRES := "0"
			SC5->C5_TIPO:=CABPED->C5_TIPO
			SC5->C5_CLIENTE:=CABPED->C5_CLIENTE
			SC5->C5_LOJACLI:=CABPED->C5_LOJACLI
			SC5->C5_CLIENT:=CABPED->C5_CLIENT
			SC5->C5_LOJAENT:=CABPED->C5_LOJAENT
			SC5->C5_TIPOCLI:=CABPED->C5_TIPOCLI
			SC5->C5_CONDPAG:=CABPED->C5_CONDPAG
			SC5->C5_VEND1:=CABPED->C5_VEND1
			SC5->C5_COMIS1:=CABPED->C5_COMIS1
			SC5->C5_DESC1:=CABPED->C5_DESC1
			SC5->C5_EMISSAO:=STOD(CABPED->C5_EMISSAO)
			SC5->C5_VOLUME1:=CABPED->C5_VOLUME1
			IF CABPED->C5_CONDPAG = "001"
				SC5->C5_MENNOTA:=  "A VISTA - "+SC5->C5_MENNOTA
			ELSE
				SC5->C5_MENNOTA:= SC5->C5_MENNOTA
			ENDIF
   			SC5->C5_OBS:=  CABPED->C5_OBS
   			SC5->C5_MENPAD:=CABPED->C5_MENPAD
			SC5->C5_LIBEROK:= ""
			SC5->C5_TIPLIB:=CABPED->C5_TIPLIB
		//SC5->C5_DESCONT:=CABPED->C5_DESCONT
			SC5->C5_TXMOEDA:=CABPED->C5_TXMOEDA
			SC5->C5_TPCARGA:=CABPED->C5_TPCARGA
			SC5->C5_ROMANEI :=CABPED->C5_ROMANEI
			SC5->C5_ROMIT:=CABPED->C5_ROMIT
			SC5->C5_DTSAIDA:=STOD(CABPED->C5_DTSAIDA)
			SC5->C5_TPFRETE:=  "C"
			SC5->C5_IMPRESS:=CABPED->C5_IMPRESS
	  		SC5->C5_PBRUTO	:=CABPED->C5_PBRUTO
 			SC5->C5_PESOL	:=CABPED->C5_PESOL
			SC5->C5_ESPECI1:=CABPED->C5_ESPECI1
			SC5->C5_VOLUME1:=CABPED->C5_VOLUME1
			SC5->C5_HORIMP := cData := Dtoc(date())+" "+time()
			SC5->C5_NUMLDX := CABPED->C5_NUMLDX
			SC5->C5_TABELA := CABPED->C5_TABELA

		
			SC5->(MsUnlock())
			
		//	conout("Cabeçalho incluido "+time())
		
		//INCLUI ITENS DE PEDIDOS NÃO IMPORTADOS
			Pedido := CABPED->C5_NUM
			contItPed := 0
	//**********************************************************
	//***** BUSCA ITENS DO PEDIDO ATUAL PARA IMPORTAR   ********
	//**********************************************************
If Select("ITENSPED") > 0
		dbSelectArea("ITENSPED")
		dbCloseArea()
	EndIf

cQuery := "  SELECT VLR_TABELA AS C6_PRUNIT, ISNULL(PER_DESCACRES,C6_DESCONT) AS C6_DESCONT,C6_FILIAL,C6_NUM,C6_ITEM,C6_PRODUTO,C6_UM,C6_QTDVEN, ISNULL(LI.VLR_VENDA, C6_PRCVEN) AS  C6_PRCVEN, "
cQuery += " C6_VALOR,C6_SEGUM,C6_TES,C6_UNSVEN, C6_LOCAL,C6_CF,C6_QTDENT,C6_QTDENT2,C6_CLI,C6_VALDESC,C6_ENTREG,C6_LOJA,C6_COMIS1,C6_DESCRI, C5_TABELA, "
cQuery += " C6_CLASFIS, C6_NUMLDX, C6_SUGENTR FROM (SRVPP01.DADOS12.dbo.SC6010 A INNER JOIN SRVPP01.DADOS12.dbo.SC5010 B ON A.C6_NUM = B.C5_NUM) "
cQuery += " LEFT OUTER JOIN  SRVPP01.LANDIX_FLX.dbo.TAFCAB LC ON str(A.C6_NUMLDX)+A.C6_CLI+A.C6_LOJA = str(LC.NUM_PEDIDO)+LC.COD_CLIENTE COLLATE Latin1_General_BIN "
cQuery += " LEFT OUTER JOIN  SRVPP01.LANDIX_FLX.dbo.TAFITE LI ON LC.NUM_PEDIDO = LI.NUM_PEDIDO AND A.C6_PRODUTO = LI.COD_PRODUTO COLLATE Latin1_General_BIN "
cQuery += " WHERE A.D_E_L_E_T_ = '' AND  B.D_E_L_E_T_ = '' AND C6_NUM = '"+ Pedido +"'

//conout(cQuery)
TCQuery cQuery Alias ITENSPED New
conout("Consulta de dados concluida -"+time())

			
			dbSelectArea("ITENSPED")
		//		ITENSPED->(dbGotop())
		//FILTRA SOMENTE ITENS DO PEDIDO QUE ESTA SENDO INSERIDO  //PODE ESTAR FAZENDO O PROGRAMA DEMORAR MUITO
/*			ITENSPED->(DbSetFilter({|| ITENSPED->C6_NUM == CABPED->C5_NUM}, "ITENSPED->C6_NUM == '" + CABPED->C5_NUM + "'"))
			DbSelectArea("ITENSPED")
			ITENSPED->(dbgotop())
*/
				
			While ! ITENSPED->(Eof()) .and. ITENSPED->C6_NUM == CABPED->C5_NUM
	
			//	conout("gravação item "+ITENSPED->C6_ITEM+"-"+time())
				dbSelectArea("SC6")
	/*			dbsetorder(1)
				dbseek(xfilial("SC6")+ITENSPED->C6_NUM+ITENSPED->C6_ITEM)

				If ! SC6->(found())
		//			dbSelectArea("DA1")
			//		dbsetorder(1)
				//	dbseek(xfilial("DA1")+SA1->A1_TABELA+ITENSPED->C6_PRODUTO)
		*/				
					RecLock("SC6",.t.)
					SC6->C6_NUM:=ITENSPED->C6_NUM
					SC6->C6_ITEM:=ITENSPED->C6_ITEM
					SC6->C6_FILIAL:='01'
					SC6->C6_PRODUTO:=ITENSPED->C6_PRODUTO
					SC6->C6_UM:=ITENSPED->C6_UM
					SC6->C6_QTDVEN:=ITENSPED->C6_QTDVEN
					SC6->C6_PRCVEN:=ITENSPED->C6_PRCVEN
					SC6->C6_VALOR:=ITENSPED->C6_VALOR
					SC6->C6_PRUNIT := ITENSPED->C6_PRUNIT
					SC6->C6_SEGUM:=ITENSPED->C6_SEGUM
					SC6->C6_TES:=ITENSPED->C6_TES
					SC6->C6_UNSVEN:=ITENSPED->C6_UNSVEN
					SC6->C6_LOCAL:=ITENSPED->C6_LOCAL
					SC6->C6_CF:=ITENSPED->C6_CF
					SC6->C6_CLI:=ITENSPED->C6_CLI
					SC6->C6_DESCONT:=ITENSPED->C6_DESCONT
					SC6->C6_ENTREG:=STOD(ITENSPED->C6_ENTREG)
					SC6->C6_LOJA:=ITENSPED->C6_LOJA
					SC6->C6_COMIS1:=ITENSPED->C6_COMIS1
					SC6->C6_DESCRI:=ITENSPED->C6_DESCRI
					SC6->C6_CLASFIS:=ITENSPED->C6_CLASFIS
					SC6->C6_NUMLDX := VAL(ITENSPED->C6_NUMLDX)		
					SC6->C6_HORIMP := Dtoc(date())+" "+time()
							
				
					SC6->(MsUnlock())
				//	conout("Item gravado-"+time())
					contItPed += 1
//				EndIf
				dbSelectArea("ITENSPED")
				ITENSPED->(dbskip())
			EndDo
			conout("Importado " + Pedido + ":" + STR(contItPed) + " itens")
//		conout(CABPED->C5_NUM)
		EndIf
		CABPED->(dbskip())
	
	EndDo
	dbCloseArea("CABPED")
	dbCloseArea("ITENSPED")

Return

//CADASTRO DE PRODUTOS

Static Function AtualizaProduto()

	dbSelectArea("SB1") //PARA NAO GERAR ERRO DE WORK AREA
	
	dbSelectArea("PRODUTOS")

	Do While (! PRODUTOS->(Eof()))
	
		dbSelectArea("SB1")
		DbSetOrder(1)
		dbseek(xfilial("SB1")+PRODUTOS->B1_COD)
	
		If ! SB1->(found())
			RecLock("SB1",.t.)
			SB1->B1_COD		:=PRODUTOS->B1_COD
			SB1->B1_FILIAL	:=PRODUTOS->B1_FILIAL
			SB1->B1_DESC	:=PRODUTOS->B1_DESC
			SB1->B1_TIPO	:=PRODUTOS->B1_TIPO
			SB1->B1_UM 		:=PRODUTOS->B1_UM
			SB1->B1_LOCPAD	:=PRODUTOS->B1_LOCPAD
			SB1->B1_GRUPO	:=PRODUTOS->B1_GRUPO
			SB1->B1_POSIPI	:=PRODUTOS->B1_POSIPI
			SB1->B1_TS		:=PRODUTOS->B1_TS
			SB1->B1_PICMRET	:=PRODUTOS->B1_PICMRET
			SB1->B1_PICMENT	:=PRODUTOS->B1_PICMENT
			SB1->B1_SEGUM	:=PRODUTOS->B1_SEGUM
			SB1->B1_CONV	:=PRODUTOS->B1_CONV
			SB1->B1_TIPCONV	:=PRODUTOS->B1_TIPCONV
			SB1->B1_GRTRIB	:=PRODUTOS->B1_GRTRIB
			SB1->B1_CC		:=PRODUTOS->B1_CC
			SB1->B1_ORIGEM	:=PRODUTOS->B1_ORIGEM
			SB1->B1_CONTA	:=PRODUTOS->B1_CONTA
			SB1->B1_CC		:=PRODUTOS->B1_CC
			SB1->B1_CODBAR	:=PRODUTOS->B1_CODBAR
			SB1->B1_GARANT	:='2'
	//		SB1->B1_DTCRIA := DataHora
			SB1->(MsUnlock())
		EndIf
		
	//	conout("Importado produto " + Alltrim(SB1->B1_COD) + ".")
		PRODUTOS->(dbskip())
	EndDo
	dbCloseArea("PRODUTOS")
Return

Static Function AtualizaMotorista()
		
	dbSelectArea("MOTORISTA")

	Do While (! MOTORISTA->(Eof()))
		
		dbSelectArea("DA4")
		DbSetOrder(1)
		dbseek(xfilial("DA4")+MOTORISTA->DA4_COD)
	
		if DA4->(found())
			IF !MsRLock(Recno()) .or. MOTORISTA->DA4_BLQMOT=='1'   //verifica se o cadastro está travado para alteração.
				//	conout("Motorista "+ CLIENTES->A1_COD +" em uso. Nao sera atualizado.")
				MOTORISTA->(dbskip())
				Loop
			else
				RecLock("DA4",.F.)
			EndIf
		Else
			RecLock("DA4",.T.)
			DA4->DA4_FILIAL := xFilial("DA4")
			DA4->DA4_COD := MOTORISTA->DA4_COD
		EndIf
		DA4->DA4_NOME := MOTORISTA->DA4_NOME
		DA4->DA4_NREDUZ := MOTORISTA->DA4_NREDUZ
		DA4->DA4_CGC := MOTORISTA->DA4_CGC
		DA4->DA4_TEL := MOTORISTA->DA4_TEL
		DA4->DA4_NUMCNH := MOTORISTA->DA4_NUMCNH
		DA4->DA4_REGCNH := MOTORISTA->DA4_REGCNH
		DA4->DA4_DTVCNH := STOD(MOTORISTA->DA4_DTVCNH)
		DA4->DA4_MUNCNH := MOTORISTA->DA4_MUNCNH
		DA4->DA4_ESTCNH := MOTORISTA->DA4_ESTCNH
		DA4->DA4_CATCNH := MOTORISTA->DA4_CATCNH
		DA4->DA4_DATNAS := STOD(MOTORISTA->DA4_DATNAS)
		DA4->DA4_BLQMOT := MOTORISTA->DA4_BLQMOT
		DA4->DA4_VNCART := STOD(MOTORISTA->DA4_VNCART)
		DA4->DA4_ADMISS := STOD(MOTORISTA->DA4_ADMISS)
				
			DA4->(MsUnlock())
			MOTORISTA->(dbskip())
		//	conout("atualizado motorista "+DA4->DA4_COD)
		EndDo
		dbCloseArea("MOTORISTA")
	//	conout("Importado e atualizado todos os motoristas.")

Return


Static Function AtualizaVeiculo()
		
	dbSelectArea("VEICULO")

	Do While (! VEICULO->(Eof()))
		
		dbSelectArea("DA3")
		DbSetOrder(1)
		dbseek(xfilial("DA3")+VEICULO->DA3_COD)
	
		if DA3->(found())
			IF !MsRLock(Recno()) .or. VEICULO->DA3_ATIVO<>'1'   //verifica se o cadastro está Ativo
				VEICULO->(dbskip())
				Loop
			else
				RecLock("DA3",.F.)
			EndIf
		Else
			RecLock("DA3",.T.)
			DA3->DA3_FILIAL := xFilial("DA3")
			DA3->DA3_COD := VEICULO->DA3_COD
		EndIf
			
		DA3->DA3_DESC 	:=  VEICULO->DA3_DESC
		DA3->DA3_PLACA	:=  VEICULO->DA3_PLACA
		DA3->DA3_MUNPLA	:=  VEICULO->DA3_MUNPLA
		DA3->DA3_ESTPLA	:=  VEICULO->DA3_ESTPLA
		DA3->DA3_CAPACN	:=  VEICULO->DA3_CAPACN
		DA3->DA3_CAPACM	:=  VEICULO->DA3_CAPACM
		DA3->DA3_VOLMAX	:=  VEICULO->DA3_VOLMAX
		DA3->DA3_MOTORI	:=  VEICULO->DA3_MOTORI
		DA3->DA3_ATIVO	:=  VEICULO->DA3_ATIVO
		DA3->DA3_CODFOR	:=  VEICULO->DA3_CODFOR
		DA3->DA3_LOJFOR	:=  VEICULO->DA3_LOJFOR
				
		DA3->(MsUnlock())
		VEICULO->(dbskip())
	EndDo
	dbCloseArea("VEICULO")
	//conout("Importado e atualizado todos os veiculos.")

Return
*/

//Cliente
Static Function AtualizaCliente()

	dbSelectArea("CLIENTES")

	Do While (! CLIENTES->(Eof()))
		dbSelectArea("SA1")
		dbseek(xfilial("SA1")+CLIENTES->A1_COD+CLIENTES->A1_LOJA)
	
		if SA1->(found()) //CASO CLIENTE FOR ENCONTRADO
			IF !MsRLock(Recno())   //verifica se o cadastro está travado para alteração.
			
				conout("Cliente "+ CLIENTES->A1_COD +" em uso. Nao sera atualizado.")
				CLIENTES->(dbskip())
				Loop
			else
				If SA1->A1_CGC == CLIENTES->A1_CGC //se CNPJ dos clientes forem iguais
					RecLock("SA1",.F.)
				Else
					conout("Cliente " + CLIENTES->A1_COD + " já está cadastrado para outro CNPJ e não será atualizado.")
					CLIENTES->(dbskip())
					Loop
				
				EndIf
			EndIf
		
		
		Else
			RecLock("SA1",.t.)
			SA1->A1_COD := CLIENTES->A1_COD
			SA1->A1_LOJA:= CLIENTES->A1_LOJA
            //PREENCHE CAMPO A1_RISCO NA PRIMEIRA IMPORTAÇÃO
			//If CLIENTES->A1_VEND  $ ("000012/000040")
	///			SA1->A1_RISCO	:= "D" //ALTERADO PARA ENVIRONMENT>TOTVS
	//		ELSE
	//			SA1->A1_RISCO	:= "C"
	//		ENDIF
			SA1->A1_RISCO	:=CLIENTES->A1_RISCO 
			SA1->A1_TPJ		:=CLIENTES->A1_TPJ 
			SA1->A1_IENCONT	:=CLIENTES->A1_IENCONT  
			SA1->A1_CONTRIB	:=CLIENTES->A1_CONTRIB
		EndIf
		SA1->A1_FILIAL	:= CLIENTES->A1_FILIAL
		SA1->A1_NOME	:= CLIENTES->A1_NOME
		SA1->A1_PESSOA	:= CLIENTES->A1_PESSOA
		SA1->A1_NREDUZ	:= CLIENTES->A1_NREDUZ
		SA1->A1_TIPO	:= CLIENTES->A1_TIPO
		SA1->A1_EST		:= CLIENTES->A1_EST
		SA1->A1_COD_MUN	:= CLIENTES->A1_COD_MUN
		SA1->A1_MUN 	:= CLIENTES->A1_MUN
		SA1->A1_NATUREZ	:= CLIENTES->A1_NATUREZ
		SA1->A1_BAIRRO	:= CLIENTES->A1_BAIRRO
		SA1->A1_CEP		:= CLIENTES->A1_CEP
		SA1->A1_DDD		:= CLIENTES->A1_DDD
		SA1->A1_TEL		:= CLIENTES->A1_TEL
		SA1->A1_PAIS	:= CLIENTES->A1_PAIS
		SA1->A1_CODPAIS	:= CLIENTES->A1_CODPAIS
		SA1->A1_CGC		:= CLIENTES->A1_CGC
		SA1->A1_INSCR	:= CLIENTES->A1_INSCR
		SA1->A1_INSCRM	:= CLIENTES->A1_INSCRM
		SA1->A1_VEND	:= CLIENTES->A1_VEND
		SA1->A1_COMIS	:= CLIENTES->A1_COMIS
		SA1->A1_CNAE	:= CLIENTES->A1_CNAE
		SA1->A1_CONDPAG	:= CLIENTES->A1_CONDPAG
		SA1->A1_MSBLQL	:= CLIENTES->A1_MSBLQL
		SA1->A1_DTINIV	:= STOD(CLIENTES->A1_DTINIV)
		SA1->A1_COMPLEM	:= CLIENTES->A1_COMPLEM
		SA1->A1_LOGRADO	:= CLIENTES->A1_LOGRADO
		SA1->A1_NR_END	:= CLIENTES-> A1_NR_END
		SA1->A1_EMAIL	:=CLIENTES->A1_EMAIL
		SA1->A1_HPAGE	:=CLIENTES->A1_HPAGE
		SA1->A1_CEL		:=CLIENTES->A1_CEL
		SA1->A1_END  	:=CLIENTES->A1_END
		SA1->A1_COND	:=CLIENTES->A1_COND
		SA1->A1_CONTA	:=CLIENTES->A1_CONTA
		SA1->A1_OBS		:= CLIENTES->A1_OBS
		SA1->A1_OBSVEND	:=CLIENTES->A1_OBSVEND
		
//	SA1->A1_DTCRIA  := DataHora
	
		SA1->(MsUnlock())
		CLIENTES->(dbskip())
	EndDo
	dbCloseArea("CLIENTES")
	conout("Importado e atualizado todos os clientes.")
		
Return

    
    //FORNECEDORES
Static Function AtualizaFornece()

	dbSelectArea("FORNECE")

	Do While (! FORNECE->(Eof()))
		dbSelectArea("SA2")
		dbseek(xfilial("SA2")+FORNECE->A2_COD+FORNECE->A2_LOJA)
	
		if SA2->(found()) //CASO FORNECEDOR FOR ENCONTRADO
			IF !MsRLock(Recno())   //verifica se o cadastro está travado para alteração.
			
				conout("Fornecedor "+ FORNECE->A2_COD +" em uso. Nao sera atualizado.")
				FORNECE->(dbskip())
				Loop
			else
				If SA2->A2_CGC == FORNECE->A2_CGC //se CNPJ dos clientes forem iguais
					RecLock("SA2",.F.)
				Else
					conout("Fornecedor " + FORNECE->A2_COD + " já está cadastrado para outro CNPJ e não será atualizado.")
					FORNECE->(dbskip())
					Loop
				
				EndIf
			EndIf
		
		
		Else
			RecLock("SA2",.T.)
			SA2->A2_FILIAL:= FORNECE->A2_FILIAL
			SA2->A2_COD:= FORNECE->A2_COD
			SA2->A2_LOJA:= FORNECE->A2_LOJA
		EndIf
	
		SA2->A2_NOME:= FORNECE->A2_NOME
		SA2->A2_NREDUZ:= FORNECE->A2_NREDUZ
		SA2->A2_END:= FORNECE->A2_END
		SA2->A2_NR_END:= FORNECE->A2_NR_END
		SA2->A2_BAIRRO:= FORNECE->A2_BAIRRO
		SA2->A2_EST:= FORNECE->A2_EST
		SA2->A2_ESTADO:= FORNECE->A2_ESTADO
		SA2->A2_COD_MUN:= FORNECE->A2_COD_MUN
		SA2->A2_MUN:= FORNECE->A2_MUN
		SA2->A2_CEP:= FORNECE->A2_CEP
		SA2->A2_CX_POST:= FORNECE->A2_CX_POST
		SA2->A2_TIPO:= FORNECE->A2_TIPO
		SA2->A2_CGC:= FORNECE->A2_CGC
		SA2->A2_PFISICA:= FORNECE->A2_PFISICA
		SA2->A2_DDD:= FORNECE->A2_DDD
		SA2->A2_TEL:= FORNECE->A2_TEL
		SA2->A2_FAX:= FORNECE->A2_FAX
		SA2->A2_INSCR:= FORNECE->A2_INSCR
		SA2->A2_INSCRM:= FORNECE->A2_INSCRM
		SA2->A2_CONTATO:= FORNECE->A2_CONTATO
		SA2->A2_NATUREZ:= FORNECE->A2_NATUREZ
		SA2->A2_PRIOR:= FORNECE->A2_PRIOR
		SA2->A2_RISCO:= FORNECE->A2_RISCO
		SA2->A2_COND:= FORNECE->A2_COND
		SA2->A2_DESVIO:= FORNECE->A2_DESVIO
		SA2->A2_CONTA:= FORNECE->A2_CONTA
		SA2->A2_RECISS:= FORNECE->A2_RECISS
		SA2->A2_PAIS:= FORNECE->A2_PAIS
		SA2->A2_STATUS:= FORNECE->A2_STATUS
		SA2->A2_VINCULA:= FORNECE->A2_VINCULA
		SA2->A2_EMAIL:= FORNECE->A2_EMAIL
		SA2->A2_HPAGE:= FORNECE->A2_HPAGE
		SA2->A2_CODMUN:= FORNECE->A2_CODMUN
		SA2->A2_DTAVA:= STOD(FORNECE->A2_DTAVA)
		SA2->A2_DTVAL:= STOD(FORNECE->A2_DTVAL)
		SA2->A2_OK:= FORNECE->A2_OK
		SA2->A2_RECINSS:= FORNECE->A2_RECINSS
		SA2->A2_GRPTRIB:= FORNECE->A2_GRPTRIB
		SA2->A2_CONTAB:= FORNECE->A2_CONTAB
		SA2->A2_CLIQF:= FORNECE->A2_CLIQF
		SA2->A2_CODBLO:= FORNECE->A2_CODBLO
		SA2->A2_PAISORI:= FORNECE->A2_PAISORI
		SA2->A2_B2B:= FORNECE->A2_B2B
		SA2->A2_PLCRRES:= FORNECE->A2_PLCRRES
		SA2->A2_DATBLO:= STOD(FORNECE->A2_DATBLO)
		SA2->A2_CBO:= FORNECE->A2_CBO
		SA2->A2_CNAE:= FORNECE->A2_CNAE
		SA2->A2_PAGAMEN:= FORNECE->A2_PAGAMEN
		SA2->A2_MSBLQL:= FORNECE->A2_MSBLQL
		SA2->A2_LOGRADO:= FORNECE->A2_LOGRADO
	//SA2->A2_HORIMP := DataHora
	
          
		SA2->(MsUnlock())
		FORNECE->(dbskip())
	EndDo
	dbCloseArea("FORNECE")
	conout("Importado e atualizado dos fornecedores.")

Return


Static Function AtualizaRoman()

cQuery := " UPDATE SRVPP01.DADOS12.dbo.SC5010 SET C5_ROMANEI=B.C5_ROMANEI, C5_ROMIT=B.C5_ROMIT "
cQuery += " FROM SRVPP01.DADOS12.dbo.SC5010 A INNER JOIN SRVPP03.DADOSTOTVS11.dbo.SC5010 B "
cQuery += " ON A.C5_NUM = B.C5_NUM WHERE A.C5_EMISSAO >= '20190701' AND B.C5_ROMANEI<>''  and A.C5_ROMANEI='' "
cQuery += " AND B.C5_ROMANEI IN (SELECT Z1_NUM  FROM SRVPP01.DADOS12.dbo.SZ1010 WHERE Z1_ITEM='01' AND Z1_DTFECH='' AND D_E_L_E_T_='')"
TCSQLexec(cQuery)

	
Return