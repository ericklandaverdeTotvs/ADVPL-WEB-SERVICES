#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:8085/WS_PEDIDO_VENDA.apw?WSDL
Gerado em        10/02/16 14:21:33
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function cliPedido() ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSWS_PEDIDO_VENDA
------------------------------------------------------------------------------- */

WSCLIENT WSWS_PEDIDO_VENDA

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD GETPEDVEN

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cFILIAL                   AS string
	WSDATA   cNUMERO                   AS string
	WSDATA   oWSGETPEDVENRESULT        AS WS_PEDIDO_VENDA_LISTAPVRET

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSWS_PEDIDO_VENDA
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20151103] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSWS_PEDIDO_VENDA
	::oWSGETPEDVENRESULT := WS_PEDIDO_VENDA_LISTAPVRET():New()
Return

WSMETHOD RESET WSCLIENT WSWS_PEDIDO_VENDA
	::cFILIAL            := NIL 
	::cNUMERO            := NIL 
	::oWSGETPEDVENRESULT := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSWS_PEDIDO_VENDA
Local oClone := WSWS_PEDIDO_VENDA():New()
	oClone:_URL          := ::_URL 
	oClone:cFILIAL       := ::cFILIAL
	oClone:cNUMERO       := ::cNUMERO
	oClone:oWSGETPEDVENRESULT :=  IIF(::oWSGETPEDVENRESULT = NIL , NIL ,::oWSGETPEDVENRESULT:Clone() )
Return oClone

// WSDL Method GETPEDVEN of Service WSWS_PEDIDO_VENDA

WSMETHOD GETPEDVEN WSSEND cFILIAL,cNUMERO WSRECEIVE oWSGETPEDVENRESULT WSCLIENT WSWS_PEDIDO_VENDA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETPEDVEN xmlns="http://localhost:8085/">'
cSoap += WSSoapValue("FILIAL", ::cFILIAL, cFILIAL , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("NUMERO", ::cNUMERO, cNUMERO , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</GETPEDVEN>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:8085/GETPEDVEN",; 
	"DOCUMENT","http://localhost:8085/",,"1.031217",; 
	"http://localhost:8085/web/ws/WS_PEDIDO_VENDA.apw")

::Init()
::oWSGETPEDVENRESULT:SoapRecv( WSAdvValue( oXmlRet,"_GETPEDVENRESPONSE:_GETPEDVENRESULT","LISTAPVRET",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure LISTAPVRET

WSSTRUCT WS_PEDIDO_VENDA_LISTAPVRET
	WSDATA   oWSAPEDVEN                AS WS_PEDIDO_VENDA_ARRAYOFAPEDIDO OPTIONAL
	WSDATA   cCLIENTE                  AS string
	WSDATA   cCONDPGTO                 AS string
	WSDATA   cLOJA                     AS string
	WSDATA   cNUMERO                   AS string
	WSDATA   cTIPOCLI                  AS string
	WSDATA   cTIPOPV                   AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WS_PEDIDO_VENDA_LISTAPVRET
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WS_PEDIDO_VENDA_LISTAPVRET
Return

WSMETHOD CLONE WSCLIENT WS_PEDIDO_VENDA_LISTAPVRET
	Local oClone := WS_PEDIDO_VENDA_LISTAPVRET():NEW()
	oClone:oWSAPEDVEN           := IIF(::oWSAPEDVEN = NIL , NIL , ::oWSAPEDVEN:Clone() )
	oClone:cCLIENTE             := ::cCLIENTE
	oClone:cCONDPGTO            := ::cCONDPGTO
	oClone:cLOJA                := ::cLOJA
	oClone:cNUMERO              := ::cNUMERO
	oClone:cTIPOCLI             := ::cTIPOCLI
	oClone:cTIPOPV              := ::cTIPOPV
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WS_PEDIDO_VENDA_LISTAPVRET
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_APEDVEN","ARRAYOFAPEDIDO",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSAPEDVEN := WS_PEDIDO_VENDA_ARRAYOFAPEDIDO():New()
		::oWSAPEDVEN:SoapRecv(oNode1)
	EndIf
	::cCLIENTE           :=  WSAdvValue( oResponse,"_CLIENTE","string",NIL,"Property cCLIENTE as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCONDPGTO          :=  WSAdvValue( oResponse,"_CONDPGTO","string",NIL,"Property cCONDPGTO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cLOJA              :=  WSAdvValue( oResponse,"_LOJA","string",NIL,"Property cLOJA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cNUMERO            :=  WSAdvValue( oResponse,"_NUMERO","string",NIL,"Property cNUMERO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cTIPOCLI           :=  WSAdvValue( oResponse,"_TIPOCLI","string",NIL,"Property cTIPOCLI as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cTIPOPV            :=  WSAdvValue( oResponse,"_TIPOPV","string",NIL,"Property cTIPOPV as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ARRAYOFAPEDIDO

WSSTRUCT WS_PEDIDO_VENDA_ARRAYOFAPEDIDO
	WSDATA   oWSAPEDIDO                AS WS_PEDIDO_VENDA_APEDIDO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WS_PEDIDO_VENDA_ARRAYOFAPEDIDO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WS_PEDIDO_VENDA_ARRAYOFAPEDIDO
	::oWSAPEDIDO           := {} // Array Of  WS_PEDIDO_VENDA_APEDIDO():New()
Return

WSMETHOD CLONE WSCLIENT WS_PEDIDO_VENDA_ARRAYOFAPEDIDO
	Local oClone := WS_PEDIDO_VENDA_ARRAYOFAPEDIDO():NEW()
	oClone:oWSAPEDIDO := NIL
	If ::oWSAPEDIDO <> NIL 
		oClone:oWSAPEDIDO := {}
		aEval( ::oWSAPEDIDO , { |x| aadd( oClone:oWSAPEDIDO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WS_PEDIDO_VENDA_ARRAYOFAPEDIDO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_APEDIDO","APEDIDO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSAPEDIDO , WS_PEDIDO_VENDA_APEDIDO():New() )
			::oWSAPEDIDO[len(::oWSAPEDIDO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure APEDIDO

WSSTRUCT WS_PEDIDO_VENDA_APEDIDO
	WSDATA   cITEM                     AS string
	WSDATA   nPRCVEN                   AS float
	WSDATA   cPRODUTO                  AS string
	WSDATA   nPRUNIT                   AS float
	WSDATA   nQTDVEN                   AS float
	WSDATA   cTES                      AS string
	WSDATA   nVALOR                    AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WS_PEDIDO_VENDA_APEDIDO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WS_PEDIDO_VENDA_APEDIDO
Return

WSMETHOD CLONE WSCLIENT WS_PEDIDO_VENDA_APEDIDO
	Local oClone := WS_PEDIDO_VENDA_APEDIDO():NEW()
	oClone:cITEM                := ::cITEM
	oClone:nPRCVEN              := ::nPRCVEN
	oClone:cPRODUTO             := ::cPRODUTO
	oClone:nPRUNIT              := ::nPRUNIT
	oClone:nQTDVEN              := ::nQTDVEN
	oClone:cTES                 := ::cTES
	oClone:nVALOR               := ::nVALOR
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WS_PEDIDO_VENDA_APEDIDO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cITEM              :=  WSAdvValue( oResponse,"_ITEM","string",NIL,"Property cITEM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nPRCVEN            :=  WSAdvValue( oResponse,"_PRCVEN","float",NIL,"Property nPRCVEN as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cPRODUTO           :=  WSAdvValue( oResponse,"_PRODUTO","string",NIL,"Property cPRODUTO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nPRUNIT            :=  WSAdvValue( oResponse,"_PRUNIT","float",NIL,"Property nPRUNIT as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nQTDVEN            :=  WSAdvValue( oResponse,"_QTDVEN","float",NIL,"Property nQTDVEN as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cTES               :=  WSAdvValue( oResponse,"_TES","string",NIL,"Property cTES as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nVALOR             :=  WSAdvValue( oResponse,"_VALOR","float",NIL,"Property nVALOR as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return


