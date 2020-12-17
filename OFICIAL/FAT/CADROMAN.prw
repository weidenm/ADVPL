#Include "PROTHEUS.CH"    
#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#INCLUDE "stdwin.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADROM    � Autor � Weiden M. Mendes   � Data �  30/10/10   ���
�������������������������������������������������������������������������͹��
���Descricao � TELA DE CADASTROS DE ROMANEIOS.                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� 12.1.25  �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CADROM()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cFunAlt := "U_AltRom()"
//Local cFunExc := "U_ExcRom()"
Private cPerg   := "SZ1"
Private cString := "SZ1"



dbSelectArea("SZ1")
dbSetOrder(1)

cPerg   := "SZ1"

Pergunte(cPerg,.F.)
SetKey(123,{|| Pergunte(cPerg,.f.)}) // Seta a tecla F12 para acionamento dos parametros

AxCadastro(cString,"Cadastro de Romaneios",.t.,cFunAlt)


Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros


Return


User Function CADFAR()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cPerg   := "SZ3"

Private cString := "SZ3"

dbSelectArea("SZ3")
dbSetOrder(1)

cPerg   := "SZ3"

Pergunte(cPerg,.F.)
SetKey(123,{|| Pergunte(cPerg,.f.)}) // Seta a tecla F12 para acionamento dos parametros

AxCadastro(cString,"Cadastro de Fardos",".t.",".t.")


Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros


Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NUMROM    � Autor � Weiden Mendes  � Data �  29/10/10      ���
�������������������������������������������������������������������������͹��
���Descricao � Programa que gera a autonumera��o dos campos                ��
���            Z1_NUM E Z1_ITEM.                                    	  ���
�������������������������������������������������������������������������͹��
��� Retorno  � .T. ou .F.,Caso .T. grava Registro sen�o retorna a Inclus�o���
���          � altera��o do Produto.					  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/



User Function NUMROM()

	Private cNumRom := ""

	cQuery := "SELECT MAX(Z1_NUM) AS Z1_NUM FROM " +  RetSqlName("SZ1") + " "
	cQuery += "WHERE  D_E_L_E_T_ = ''"

	TCQuery cQuery Alias ULTNUMZ1 New


	dbSelectArea("ULTNUMZ1")
	ULTNUMZ1->(dbGoTop())
	if ULTNUMZ1->Z1_NUM <> ""
		cNumRom := StrZero(Val(ULTNUMZ1->Z1_NUM),6)                             
	end if                                           
	


	dbCloseArea("ULTNUMZ1")	


return(cNumRom)  				


User Function ITEMROM()

	Private cItem   := "01"
	Private cNumRom := M->Z1_NUM


	cQuery := "SELECT MAX(Z1_ITEM) AS ITEM FROM " +  RetSqlName("SZ1") + " "
	cQuery += "WHERE Z1_NUM='" + cNumRom + "'  AND D_E_L_E_T_ = ''"

	TCQuery cQuery Alias ULTVAL New


	dbSelectArea("ULTVAL")
	ULTVAL->(dbGoTop())
	if ULTVAL->ITEM <> ""
		cItem := StrZero(Val(ULTVAL->ITEM)+1,2)                             
	end if

	dbCloseArea("ULTVAL")	

return(cItem)  
                    

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RERPA02   �Autor  � Vin�cius Moreira   � Data � 17/03/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Aprendendo a utilizar fun��o AxCadastro.                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AltRom()

Local lRet := .F.
Local cMsg := ""

//ALERT(M->Z1_NUM)

If INCLUI
	//cMsg := "Confirma a inclus�o do registro?"
	
		dbSelectArea("SZ1")
		DbSetOrder(1)
		dbseek(xfilial("SZ1")+M->Z1_NUM+M->Z1_ITEM)
	
		If  SZ1->(found())
			MSGSTOP("Esse romaneio j� existe.")
		else
			lRet := .t.
		EndIf
else
	lRet := .t.
EndIf

Return lRet
	