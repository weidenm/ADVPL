///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | PEDCOMPL.prw       | AUTOR | Weiden Mendes  | DATA | 29/04/2013 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_MarkBrw()                                            |//
//|           | Utiliza função MarkBrow para criar tela de alteração e          |//
//|           | complemento de pedidos.                                         |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

/*
+----------------------------------------------------------------------------
| Parâmetros do MarkBrow()
+----------------------------------------------------------------------------
| MarckBrow( cAlias, cCampo, cCpo, aCampos, lInverte, cMarca, cCtrlM, uPar, 
|            cExpIni, cExpFim, cAval )
+----------------------------------------------------------------------------
| cAlias...: Alias do arquivo a ser exibido no browse 
| cCampo...: Campo do arquivo onde será feito o controle (gravação) da marca
| cCpo.....: Campo onde será feita a validação para marcação e exibição do bitmap de status
| aCampos..: Colunas a serem exibidas
| lInverte.: Inverte a marcação
| cMarca...: String a ser gravada no campo especificado para marcação
| cCtrlM...: Função a ser executada caso deseje marcar todos elementos
| uPar.....: Parâmetro reservado
| cExpIni..: Função que retorna o conteúdo inicial do filtro baseada na chave de índice selecionada
| cExpFim..: Função que retorna o conteúdo final do filtro baseada na chave de índice selecionada
| cAval....: Função a ser executada no duplo clique em um elemento no browse
+----------------------------------------------------------------------------
*/

#Include "Protheus.Ch"

User Function PEDCOMPL()
//+----------------------------------------------------------------------------
//| Atribuicao de variaveis
//+----------------------------------------------------------------------------
Local aArea   := {}
Local cFiltro := ""
Local cKey    := ""
Local cArq    := ""
Local nIndex  := 0
Local aSay    := {}
Local aButton := {}
Local nOpcao  := 0
Local cDesc1  := "Este programa tem o objetivo de alterar dados do pedido de venda."
Local cDesc2  := ""
Local cDesc3  := ""
Local aCpos   := {}
Local aCampos := {}
Local cMsg    := ""

Private aRotina     := {}
Private cMarca      := ""
Private cCadastro   := OemToAnsi("Dados Complementares de Pedidos")
Public  cPerg       := "PDCOMP"
Private nTotal      := 0
Private cArquivo    := ""

Public cRomaneio := ""
Public cromit := ""

//+----------------------------------------------------------------------------
//| Monta tela de interacao com usuario
//+----------------------------------------------------------------------------
aAdd(aSay,cDesc1)
aAdd(aSay,cDesc2)
aAdd(aSay,cDesc3)

aAdd(aButton, { 1,.T.,{|| nOpcao := 1, FechaBatch() }})
aAdd(aButton, { 2,.T.,{|| FechaBatch()              }})

//FormBatch(<cTitulo>,<aMensagem>,<aBotoes>,<bValid>,nAltura,nLargura)
FormBatch(cCadastro,aSay,aButton)

//+----------------------------------------------------------------------------
//| Se cancelar sair
//+----------------------------------------------------------------------------
If nOpcao <> 1
   Return Nil
Endif

//+--------------------------------------------------------+
//| Parametros utilizado no programa                       |
//+--------------------------------------------------------+
//| mv_par01 - Data Emissao de    ? 99/99/99               |
//| mv_par02 - Data Emissao ate   ? 99/99/99               |
//| mv_par03 - Romaneio           ? 999999                 |
//| mv_par04 - Item Romaneio      ? 999999                 |
//| mv_par05 - Data de Saida								   |
//| mv_par06 - Mostra romaneios ja preenchidos?    		   |									
//+--------------------------------------------------------+
//+----------------------------------------------------------------------------
//| Cria as perguntas em SX1
//+----------------------------------------------------------------------------
//CriaSX1()

//+----------------------------------------------------------------------------
//| Monta tela de paramentos para usuario, se cancelar sair
//+----------------------------------------------------------------------------
If !Pergunte(cPerg,.T.)
   Return Nil
Endif


//+----------------------------------------------------------------------------
//| Atribui as variaveis de funcionalidades
//+----------------------------------------------------------------------------
aAdd( aRotina ,{"Pesquisar" ,"AxPesqui()"   ,0,1})
aAdd( aRotina ,{"Executar" ,"u_Transfere()",0,3})
aAdd( aRotina ,{"Legenda"   ,"u_Legenda()"  ,0,4})
             
//+----------------------------------------------------------------------------
//| Atribui as variaveis os campos que aparecerao no mBrowse()
//+----------------------------------------------------------------------------
aCpos := {"C5_OK","C5_NUM","C5_CLIENTE","C5_EMISSAO","C5_VEND1","C5_ROMANEI","C5_ROMIT"}

dbSelectArea("SX3")
dbSetOrder(2)
For nI := 1 To Len(aCpos)
   dbSeek(aCpos[nI])
   aAdd(aCampos,{X3_CAMPO,"",Iif(nI==1,"",Trim(X3_TITULO)),Trim(X3_PICTURE)})
Next

//+----------------------------------------------------------------------------
//| Monta o filtro especifico para MarkBrow()
//+----------------------------------------------------------------------------
dbSelectArea("SC5")
aArea := GetArea()
cKey  := IndexKey()
cFiltro := "Dtos(C5_EMISSAO) >= '"+Dtos(mv_par01)+"' .And. "
cFiltro += "Dtos(C5_EMISSAO) <= '"+Dtos(mv_par02)+"' .And. "
 cFiltro += " Empty(C5_NOTA)"
//cFiltro += "F1_FORNECE >= '"+mv_par03+"' .And. "
//cFiltro += "F1_FORNECE <= '"+mv_par04+"' "
If mv_par06 == 1
   cFiltro += ".And. Empty(C5_ROMANEI)"
Endif
cArq := CriaTrab( Nil, .F. )
IndRegua("SC5",cArq,cKey,,cFiltro)
nIndex := RetIndex("SC5")
nIndex := nIndex + 1
dbSelectArea("SC5")
#IFNDEF TOP
   dbSetIndex(cArq+OrdBagExt())
#ENDIF
dbSetOrder(nIndex)
dbGoTop()

//+----------------------------------------------------------------------------
//| Apresenta o MarkBrowse para o usuario
//+----------------------------------------------------------------------------
cMarca := GetMark()
MarkBrow("SC5","C5_OK",,aCampos,,cMarca,,,,,"u_MarcaBox()") //"C5_ROMANEI"

//+----------------------------------------------------------------------------
//| Desfaz o indice e filtro temporario
//+----------------------------------------------------------------------------
dbSelectArea("SC5")
RetIndex("SC5")
Set Filter To
cArq += OrdBagExt()
FErase( cArq )
RestArea( aArea )
Return Nil

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MarkBrowse.prw       | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_MarcaBox()                                           |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Marca ou desmarca o registro para processamento                 |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function MarcaBox()
If IsMark("C5_OK",cMarca )
   RecLock("SC5",.F.)
   SC5->C5_OK := Space(2)
   MsUnLock()
Else
  // If Empty(SC5->C5_ROMANEI)
      RecLock("SC5",.F.)
      SC5->C5_OK := cMarca
      MsUnLock()
   //Endif
Endif
Return .T.

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MarkBrowse.prw       | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Transfere()                                          |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Transfere os registros marcados                                 |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Transfere()

dbSelectArea("SC5")
dbSelectArea("SC5")
aArea := GetArea()
cKey  := IndexKey()
cFiltro := "Dtos(C5_EMISSAO) >= '"+Dtos(mv_par01)+"' .And. "
cFiltro += "Dtos(C5_EMISSAO) <= '"+Dtos(mv_par02)+"' .And. "
 cFiltro += " Empty(C5_NOTA)"
//cFiltro += "F1_FORNECE >= '"+mv_par03+"' .And. "
//cFiltro += "F1_FORNECE <= '"+mv_par04+"' "
If mv_par06 == 1
   cFiltro += ".And. Empty(C5_ROMANEI)"
Endif
cArq := CriaTrab( Nil, .F. )
IndRegua("SC5",cArq,cKey,,cFiltro)
nIndex := RetIndex("SC5")
nIndex := nIndex + 1
dbSelectArea("SC5")
#IFNDEF TOP
   dbSetIndex(cArq+OrdBagExt())
#ENDIF
dbSetOrder(nIndex)
dbGoTop()

While !Eof()
   If SC5->C5_OK <> cMarca
      dbSkip()
      Loop
   Endif

   RecLock("SC5",.F.)
      	SC5->C5_ROMANEI := MV_PAR03
		SC5->C5_ROMIT :=  MV_PAR04
   MsUnLock()
   
   dbSkip()
End

If !Pergunte(cPerg,.T.)
   Return Nil
Endif

Return 

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MarkBrowse.prw       | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Legenda()                                            |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Cria legenda para usuario identificar os registros              |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Legenda()
Local aCor := {}

aAdd(aCor,{"BR_VERDE"   ,"NF sem romaneio"})
aAdd(aCor,{"BR_VERMELHO","NF com romaneio"    })

BrwLegenda(cCadastro,OemToAnsi("Registros"),aCor)

Return


///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MarkBrowse.prw       | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - CriaSX1()                                              |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Cria o grupo de perguntas se caso nao existir                   |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function CriaSx1()
Local nX := 0
Local nY := 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aReg := {}

aAdd(aReg,{cPerg,"01","Emissao de ?        ","mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"02","Emissao ate ?       ","mv_ch2","D", 8,0,0,"G","(mv_par02>=mv_par01)","mv_par02","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"03","Codigo de ?         ","mv_ch3","C", 6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","SA2"})
aAdd(aReg,{cPerg,"04","Codigo ate ?        ","mv_ch4","C", 6,0,0,"G","(mv_par04>=mv_par03)","mv_par04","","","","","","","","","","","","","","","SA2"})
aAdd(aReg,{cPerg,"05","Mostrar Todos ?     ","mv_ch5","N", 1,0,0,"C","","mv_par05","Sim","","","Nao","","","","","","","","","","",""})
aAdd(aReg,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_CNT01","X1_VAR02","X1_DEF02","X1_CNT02","X1_VAR03","X1_DEF03","X1_CNT03","X1_VAR04","X1_DEF04","X1_CNT04","X1_VAR05","X1_DEF05","X1_CNT05","X1_F3"})

dbSelectArea("SX1")
dbSetOrder(1)
For ny:=1 to Len(aReg)-1
	If !dbSeek(aReg[ny,1]+aReg[ny,2])
		RecLock("SX1",.T.)
		For j:=1 to Len(aReg[ny])
			FieldPut(FieldPos(aReg[Len(aReg)][j]),aReg[ny,j])
		Next j
		MsUnlock()
	EndIf
Next ny
RestArea(aAreaSX1)
RestArea(aAreaAnt)
Return Nil