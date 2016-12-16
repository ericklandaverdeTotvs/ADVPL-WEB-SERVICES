#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'APWEBSRV.CH'
#Include "Topconn.ch"

/************************************************************************************************************
* WebService....:	WS_PEDIDO
* Objetivo......: 	WebService para consultas ao pedido de venda customizado
* Autor.........:   Emanuel Bezerra
* Data..........:   agosto/2016
* Alterado......:                                                                                            
*/

WSSTRUCT listaPVret
	WSDATA Numero AS STRING
	WSDATA tipoPV  AS STRING
	WSDATA Cliente  AS STRING
	WSDATA Loja  AS STRING
	WSDATA condPgto  AS STRING
	WSDATA tipoCli  AS STRING
	
	WSDATA aPedVen  As Array of aPedido Optional
ENDWSSTRUCT

WSSTRUCT aPedido
	WSDATA ITEM 	As String
	WSDATA PRODUTO 	As String
	WSDATA QTDVEN 	As float
	WSDATA PRCVEN 	As float
	WSDATA PRUNIT 	As float
	WSDATA VALOR 	As float
	WSDATA TES 		As String
ENDWSSTRUCT

WSSERVICE ws_Pedido_Venda Description "Servico de consulta aos pedidos de venda do sistema"
// Propriedades

	WSDATA Filial AS STRING
	WSDATA Numero AS STRING

	WSDATA dadosRet AS listaPVret Optional

// Metodos
	WSMETHOD getPedVen  Description "<b> Metodo de retorno de pedidos</b><br> <u>Retorno</u><br> Cabeçalho do pediso<br>Array de itens do pedido" // ou nome."
EndWSSERVICE
pesqPv
//--------------------------------------------------------------------------------------------
WSMETHOD getPedVen WSRECEIVE Filial,Numero WSSEND dadosRet WSSERVICE ws_Pedido_Venda
	Local aPV := {}
	Local aCabAux := {}
	Local aIteAux := {}
	
	//PREPARE ENVIRONMENT EMPRESA "99" FILIAL _Filial MODULO "FAT" TABLES "SC5"
	RPCSetType(3) //Não Consome licença
	RpcSetEnv("99",::Filial,,,,GetEnvServer(),{ "SC5","SC6" })
	sleep( 5000 )

	aPV := u_pesqPv(::Filial,::Numero)
		
	if (len(aPV)) > 0
	
		aCabAux := aPV[1] //Cabeçalho do pedido
		aIteAux := aPV[2] //Itens do pedido de venda
	
		if (len(aCabAux)) > 0
			::dadosRet:Numero := aCabAux[1]
			::dadosRet:tipoPV := aCabAux[2]
			::dadosRet:Cliente := aCabAux[3]
			::dadosRet:Loja := aCabAux[4]
			::dadosRet:condPgto := aCabAux[5]
			::dadosRet:tipoCli := aCabAux[6]
		endif
	
		if (len(aIteAux)) > 0
			for nX0 := 1 to len(aIteAux)
				AAdd( ::dadosRet:aPedVen , WSClassNew( "aPedido" )) //TODO: Examinar essa lógica.
				oTemp := aTail(  ::dadosRet:aPedVen )
	
				oTemp:ITEM := aIteAux[nX0][1]
				oTemp:PRODUTO := aIteAux[nX0][2]
				oTemp:QTDVEN := aIteAux[nX0][3]
				oTemp:PRCVEN := aIteAux[nX0][4]
				oTemp:PRUNIT := aIteAux[nX0][5]
				oTemp:VALOR := aIteAux[nX0][6]
				oTemp:TES := aIteAux[nX0][7]
			next nX0
		endif
	else
		::dadosRet:Numero := ""
		::dadosRet:tipoPV := ""
		::dadosRet:Cliente := ""
		::dadosRet:Loja := ""
		::dadosRet:condPgto := ""
		::dadosRet:tipoCli := ""
	
		AAdd( ::dadosRet:aPedVen , WSClassNew( "aPedido" )) //TODO: Examinar essa lógica.
		oTemp := aTail(  ::dadosRet:aPedVen )
	
		oTemp:ITEM := ""
		oTemp:PRODUTO := ""
		oTemp:QTDVEN := 0
		oTemp:PRCVEN := 0
		oTemp:PRUNIT := 0
		oTemp:VALOR := 0
		oTemp:TES := ""
	Endif
	
	//RPCClearEnv()

Return .T.

//Funçao de pesquisa de pedido de venda
user function pesqPv(_Filial,_Num)
	Local aRet := {}
	Local aCab := {}
	Local aItem := {}

	cAliasSC := GetNextAlias()

	dbSelectArea("SC5")
	SC5->(dbSetOrder(1))
	IF SC5->(dbSeek(_Filial + _Num))     // Filial: 01 / Numero: 000001
		aadd(aCab,SC5->C5_NUM)
		aadd(aCab,SC5->C5_TIPO)
		aadd(aCab,SC5->C5_CLIENTE)
		aadd(aCab,SC5->C5_LOJACLI)
		aadd(aCab,SC5->C5_CONDPAG)
		aadd(aCab,SC5->C5_TIPOCLI)
	ENDIF
 
	If len(aCab) > 0
 		//C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO, R_E_C_N_O_, D_E_L_E_T_
		cQuery := "SELECT * "
		cQuery += "FROM "+RetSqlName("SC6")+" SC6 "
		cQuery += "WHERE SC6.C6_FILIAL='"+_Filial+"' AND "
		cQuery += "SC6.C6_NUM='"+_Num+"' AND "
		cQuery += "SC6.D_E_L_E_T_=' ' "
		
		memowrite("C:\Users\emano_000\Desktop\query.sql",cQuery)
		
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC,.T.,.T.)
		
		dbSelectArea(cAliasSC)
		(cAliasSC)->(dbGotop())
		
		While !(cAliasSC)->(Eof())
			aadd(aItem,{(cAliasSC)->C6_ITEM,(cAliasSC)->C6_PRODUTO,(cAliasSC)->C6_QTDVEN,;
				(cAliasSC)->C6_PRCVEN,(cAliasSC)->C6_PRUNIT,(cAliasSC)->C6_VALOR,(cAliasSC)->C6_TES})
			(cAliasSC)->(DBSKIP())
		ENDDO
	endif
	
	conout("nCab: "+alltrim(str(len(aCab))))
	conout("nItens: "+alltrim(str(len(aItem))))
	
	aadd(aRet,aCab) //aRet[1] = aCab
	aadd(aRet,aItem) //aRet[2] = aItem
	
	dbCloseArea("SC5")
	dbCloseArea(cAliasSC)
	
return aRet