
	
User Function GCP02GRV()
/* Local lRet := .T.
If CO1->CO1_XLIBER <> "L"
lRet := .F.
MsgStop("Email enviado!!!","Atenção")
Endif 
*/ 
If SF1->F1_TIPO $'BD'
cNome := Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_NOME")
Else
cNome := Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME")
Endif

If RecLock("SF1",.f.)
SF1->F1_NFORNE := cNome
MsUnlock()
Endif
Return .t.

//PARA CAMPO VIRTUAL: "POSICIONE("SA1",1,XFILIAL("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_NOME")"