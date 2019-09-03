#include "rwmake.ch"

User Function InventZero()

SetPrvt("NOPCA,")
//cPerg := "GERINV"

//*
//*
//*** Ajusta
//*
//* Programa para correcoes genericas com uso de arquivo externo ao Protheus

nOpca := 0

/*
	If !Pergunte (cPerg,.T.)
	   Return
	EndIf
  */

#IFDEF WINDOWS
	@ 96,42 TO 323,505 DIALOG oDlg TITLE "Rotina de Processamento"
	@ 8,10 TO 84,222
	@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()
	@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg)
	@ 23,14 SAY "Faz os lancamento de inventario com base no SB2 de quantidade zero."
	//@ 43,14 SAY "Para produtos do tipo 'PA' de acordo com a database."
	ACTIVATE DIALOG  oDlg
	
#ENDIF

Return

Static Function OkProc()
Close(oDlg)
Processa( {|| AjusRun() } )
Return

 //*
 //*** AjusRun
 //*
 //*

Static Function AjusRun()

dbSelectArea("SB2")
ProcRegua(RecCount())
dbGoTop()

While ! Eof()
	
	IncProc("Inventario Produto ... " + sb2->b2_cod)
	
//	_tmpGrupo := Posicione("SB1",1,xFilial("SB1") + sb2->b2_cod,"B1_GRUPO")
	
	/*      If ! (val(_tmpGrupo) >= 1000 .and. val(_tmpGrupo) <= 1999) .and.;
	! (val(_tmpGrupo) >= 3000 .and. val(_tmpGrupo) <= 3999) .and.;
	! (val(_tmpGrupo) >= 4300 .and. val(_tmpGrupo) <= 4399) */
	/*
	If (val(_tmpGrupo) < 1303 .OR. val(_tmpGrupo) = 1307) .and. SB2->B2_QATU < 0
		
		//	  If val(_tmpGrupo) < 2000   //PRODUTOS ACABADOS
		
		dbSkip()
		Loop
		
	EndIf
	  */
  //	_tmpTipo  := Posicione("SB1",1,Filial("SB1") + sb2->b2_cod,"B1_TIPO")
	//_tmpGrupo := Posicione("SB1",1,xFilial("SB1") + sb2->b2_cod,"B1_GRUPO")
	
//	ALERT(_tmpGrupo)
	
//	IF SB2->B2_TIPO = "PA"

		_b7_filial  := "01"
		_b7_cod     := sb2->b2_cod
		_b7_local   := sb2->b2_local
		_b7_tipo    := SB2->B2_TIPO
		_b7_doc     := dtos(dDataBase)	 //		"311210" // 000554 = grp 1000/3000/4300
		_b7_quant   := 0
		_b7_qtsegum := 0
		_b7_data    := dDataBase
		_b7_dtvalid := dDataBase

  /*
  		_b7_filial  := "01"
		_b7_cod     := sb1->b1_cod
		_b7_local   := sb1->b1_locpad
		_b7_tipo    := SB1->B1_TIPO
		_b7_doc     := dtos(dDataBase)	 
		_b7_quant   := 0
		_b7_qtsegum := 0
		_b7_data    := dDataBase
		_b7_dtvalid := dDataBase
  */
		dbSelectArea("SB7")
		
		Reclock("SB7",.T.)
		
		SB7->B7_FILIAL  := _b7_filial
		SB7->B7_COD     := _b7_cod
		SB7->B7_LOCAL   := _b7_local
		SB7->B7_TIPO    := _b7_tipo
		SB7->B7_DOC     := _b7_doc
		SB7->B7_QUANT   := _b7_quant
		SB7->B7_QTSEGUM := _b7_qtsegum
		SB7->B7_DATA    := _b7_data
		SB7->B7_DTVALID := _b7_dtvalid
		
		MsUnlock()
		
  //	Endif
	
	dbSelectArea("SB2")
	dbSkip()
	
End

Return
