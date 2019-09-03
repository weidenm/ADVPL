#include "rwmake.ch"

/*
+----------+-----------+----------+-------------------------+------+-----------+
|Programa  |FISTRFNFE  | Autor    |Renata Alves             |Data  |27.08.2010 |
+----------+-----------+----------+-------------------------+------+-----------+
|Descricao | Ponto de Entrada para incluir bot�o com a fun��o do Boleto Banc�- |
|          | rio na rotina SPEDNFE.                                            |        
+----------+-------------------------------------------------------------------+
| USO      | Faturamento/OMS                                                   |
+----------+-------------------------------------------------------------------+
|                    ALTERACOES FEITAS DESDE A CRIACAO                         |
+----------+-----------+-------------------------------------------------------+
|Autor     | Data      | Descri��o                                             |
+----------+-----------+-------------------------------------------------------+
|          |           |                                                       |
+----------+-----------+-------------------------------------------------------+
*/  

User Function FISTRFNFE()

	aadd(aRotina,{'Boleto Banc�rio','U_BLTCDBB',0,3,0,NIL})

Return Nil