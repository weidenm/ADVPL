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

User Function CADCLIFOR()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cPerg   := "SZ5"

Private cString := "SZ5"

dbSelectArea("SZ5")
dbSetOrder(1)

cPerg   := "SZ5"

Pergunte(cPerg,.F.)
SetKey(123,{|| Pergunte(cPerg,.f.)}) // Seta a tecla F12 para acionamento dos parametros

AxCadastro(cString,"Amarra��o Cliente x Fornecedor Importa��o",".t.",".t.")


Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros


Return




/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADROM    � Autor � Weiden M. Mendes   � Data �  30/10/10   ���
�������������������������������������������������������������������������͹��
���Descricao � TELA DE NOTAS IMPORTADAS PARA PEQUENAS CORRE��ES           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CADNFIMP()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cPerg   := "SDT"

Private cString := "SDT"

dbSelectArea("SDT")
dbSetOrder(1)

cPerg   := "SDT"

Pergunte(cPerg,.F.)
SetKey(123,{|| Pergunte(cPerg,.f.)}) // Seta a tecla F12 para acionamento dos parametros

AxCadastro(cString,"Notas Entradas importadas XML",".t.",".t.")


Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros


Return


