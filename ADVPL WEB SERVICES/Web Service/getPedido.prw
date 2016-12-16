#INCLUDE 'COLORS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE "PROTHEUS.CH"
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

user function getPedido(_cFilial,_cNumped)
Local oWs
Local aWsRet := {}

//Pega o objeto no webservice
oWs := WSWS_PEDIDO_VENDA():New()
                                
//Chamada do metodo no webservice
oWs:GETPEDVEN(_cFilial,_cNumped)

//Retorno do método
aWsRet := aClone(oWs:oWSGETPEDVENRESULT:oWSAPEDVEN:oWSAPEDIDO)

//Trata a variável de retorno conforme o tipo
If len(aWsRet) > 0
	
	alert('CLIENTE: '+alltrim(oWs:oWSGETPEDVENRESULT:cCLIENTE)+' / LOJA: '+alltrim(oWs:oWSGETPEDVENRESULT:cLOJA)+' / TIPOCLI :'+alltrim(oWs:oWSGETPEDVENRESULT:cTIPOCLI))
	alert('NUM. PED: '+alltrim(oWs:oWSGETPEDVENRESULT:cNUMERO)+' / TIPOPV: '+alltrim(oWs:oWSGETPEDVENRESULT:cTIPOPV)+' / CONDPGTO: '+alltrim(oWs:oWSGETPEDVENRESULT:cCONDPGTO))
	
	for nX0 := 1 to len(aWsRet)
		//Atribui os retornos a variáveis locais do array de itens
		
		alert('ITEM: '+alltrim(aWsRet[nX0]:cITEM)+' / PRODUTO: '+alltrim(aWsRet[nX0]:cPRODUTO)+' / PRCVEN :'+alltrim(str(aWsRet[nX0]:nPRCVEN));
		+' / PRUNIT :'+alltrim(str(aWsRet[nX0]:nPRUNIT))+' / QTDVEN :'+alltrim(str(aWsRet[nX0]:nQTDVEN))+' / VALOR :'+alltrim(str(aWsRet[nX0]:nVALOR));
		+' / TES :'+alltrim(aWsRet[nX0]:cTES))
	next nX0
else
	alert('Pedido de venda não localizado!')
endif

return
