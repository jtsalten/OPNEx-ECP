Class OPNEx.MModel.RESTserver Extends %CSP.REST
{

Parameter CHARSET = "iso-8859-1";

Parameter CONTENTTYPE = "application/json";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/registro/:desc/:cif" Method="PUT" Call="Registro" Cors="true"/>
<Route Url="/registro/:desc/:cif/:ciudad" Method="PUT" Call="Registro" Cors="true"/>
<Route Url="/registro/:desc/:cif/:ciudad/:codpostal" Method="PUT" Call="Registro" Cors="true"/>
<Route Url="/registro/:desc/:cif/:ciudad/:codpostal/:pais" Method="PUT" Call="Registro" Cors="true"/>
<Route Url="/registro" Method="POST" Call="RegistroPOST" Cors="true"/>
<Route Url="/modifica" Method="PATCH" Call="ModificaPOST" Cors="true"/>
<Route Url="/busca/id/:id" Method="GET" Call="BuscaID" Cors="true"/>
<Route Url="/elimina/id/:id" Method="DELETE" Call="EliminaID" Cors="true"/>
<Route Url="/genera" Method="GET" Call="GeneraRegistros" Cors="true"/>
<Route Url="/genera/:num" Method="GET" Call="GeneraRegistros" Cors="true"/>
<Route Url="/cuenta" Method="GET" Call="CuentaTodos" Cors="true"/>
<Route Url="/echo" Method="GET" Call="GetEcho" Cors="true"/>
<!--
	<Map Prefix="/docserver" Forward="OTRA.CLASE.DE.APIs.REST"/>
-->
</Routes>
}

/// Registra un nuevo proveedor según datos recibidos en la URL REST
ClassMethod Registro(pDesc As %String = "", pCIF As %String = "", pCiudad As %String = "", pCodPostal As %String = "", pPais As %String = "") As %Status
{
	#dim tID as %Integer=0
	// Utiliza los datos recibidos en la URL REST para registrar un nuevo proveedor 
	set tID = ##class(OPNEx.MModel.Proveedor).Registro(pDesc,pCIF,pCiudad,pCodPostal,pPais)
	// o directo a global...
	//set tID = ##class(OPNEx.MModel.IOglobals).InsGlb(pDesc,pCIF,pCiudad,pCodPostal,pPais)

	// Devuelve el ID del nuevo proveedor
	#dim tResult as %DynamicObject = {"ID":(tID)}
	do tResult.%ToJSON()
	
	return $$$OK
}

/// Recibe los datos del nuevo proveedor recibido como documento JSON (para llamadas POST)
ClassMethod RegistroPOST() As %Status
{
	// Lee el documento JSON incluido en el body de la peticion REST y genera un %DynamicObject
	#dim tBulkJSON as %String = %request.Content.Read()	
	#dim tDatos as %DynamicObject = {}.%FromJSON(tBulkJSON)

	// Registra el nuevo proveedor
	#dim tID as %Integer = ##class(OPNEx.MModel.Proveedor).RegistroJSON(tDatos)
	
	// Devuelve el ID del nuevo proveedor 
	#dim tResult as %DynamicObject = {"ID":(tID)}
	do tResult.%ToJSON()

	return $$$OK
}

ClassMethod ModificaPOST() As %Status
{
	#dim tSC as %Status = 0
	#dim tResult as %DynamicObject
	
	// Lee el documento JSON incluido en el body de la peticion REST y genera un %DynamicObject
	#dim tBulkJSON as %String = %request.Content.Read()	
	#dim tDatos as %DynamicObject = {}.%FromJSON(tBulkJSON)

	if $IsObject(tDatos)&&(tDatos.Codigo>0)
	{
		// Modifica el proveedor
		set tSC = ##class(OPNEx.MModel.Proveedor).ActualizaJSON(tDatos)
		// Devuelve estado e ID del proveedor 
		set tResult = {"ESTADO":(tSC),"ID":(tDatos.Codigo)}
		write tResult.%ToJSON()
	}
	else
	{
		// Devuelve el código de estado 0  
		set tResult = {"ESTADO":(tSC),"ID":"","DESC":"Algo ha ido mal"}
		do tResult.%ToJSON()
	}
	return $$$OK
}

/// Busca por ID
ClassMethod BuscaID(pID As %Integer = "") As %Status
{
	// Abre el proveedor cuyo ID nos han pasado por parámetro
	set tProv = ##class(OPNEx.MModel.Proveedor).%OpenId(pID)

	// Si existe, devuelve sus datos en formato JSON, si no, un JSON con info del error
	if $IsObject(tProv)
	{
		do tProv.%JSONExport()
	}
	else
	{
		set tResult = {"ESTADO":"ERROR - ID indicado no existe"}
		do tResult.%ToJSON()
	}

	return $$$OK
}

/// Elimina por ID
ClassMethod EliminaID(pID As %Integer = "") As %Status
{
	// Elimina el proveedor cuyo ID nos han pasado por parámetro
	set tSC = ##class(OPNEx.MModel.Proveedor).%DeleteId(pID)

	set tResult = {"ESTADO":(tSC),"ID":(pID)}
	do tResult.%ToJSON()
	return $$$OK
}

/// Generar Registros Aleatorios
ClassMethod GeneraRegistros(pNum As %Integer = 1000) As %Status
{
	#dim tDuracion as %DynamicObject = ##class(OPNEx.MModel.IOglobals).InsercionMasiva(pNum,0)
	do tDuracion.%ToJSON()

	return $$$OK
}

/// Select Count de Proveedores
ClassMethod CuentaTodos() As %Status
{
	&SQL(select JSON_OBJECT('Proveedores':count(*)) into :tCount from OPNEx_MModel.Proveedor)
	write:SQLCODE=0 tCount
	return $$$OK
}

/// Metodo de test
ClassMethod GetEcho() As %Status
{
	write "Echotest  -  Servidor: "_$SYSTEM.INetInfo.LocalHostName()
	return $$$OK
}

}
