Class OPNEx.MModel.Proveedor Extends (%Persistent, %Populate, %XML.Adaptor, %JSON.Adaptor, Form.Adaptor)
{

Parameter FORMNAME = "Proveedor";

Parameter OBJPERMISSIONS = "CRUD";

Parameter DISPLAYPROPERTY = "Descripcion";

Property Codigo As %Integer(%JSONINCLUDE = "OUTPUTONLY", DISPLAYNAME = "Codigo") [ Identity ];

Property Descripcion As %String(DISPLAYNAME = "Descripcion", MAXLEN = 100, POPSPEC = "Company()");

Property CIF As %String(DISPLAYNAME = "CIF", PATTERN = "1A8N") [ InitialExpression = {"B"_($random(9999)*10000+$random(9999))} ];

Property Facturacion As %Integer(%JSONINCLUDE = "OUTPUTONLY", DISPLAYNAME = "Facturacion") [ Calculated, SqlComputeCode = {set {*}=..FacturacionGlobal({ID})}, SqlComputed ];

Property Direccion As OPNEx.MModel.Direccion(DISPLAYNAME = "Direccion");

ClassMethod Registro(pDesc As %String = "", pCIF As %String = "", pCiudad As %String = "", pCodPostal As %String = "", pPais As %String = "España") As %Integer
{
	#dim obj as OPNEx.MModel.Proveedor = ..%New() 

	set obj.Descripcion = pDesc
	set obj.CIF = pCIF
	set obj.Direccion.Ciudad = pCiudad
	set obj.Direccion.Pais = pPais
	set obj.Direccion.CodPostal = pCodPostal

	do obj.%Save()
	
	return obj.%Id()
}

ClassMethod RegistroSQL(pDesc As %String = "", pCIF As %String = "", pCiudad As %String = "", pCodPostal As %String = "", pPais As %String = "España") As %Integer
{
	&SQL(
			insert into OPNEx_MModel.Proveedor (Descripcion,CIF,Direccion_Ciudad,Direccion_CodPostal,Direccion_Pais) 
			                            values (:pDesc,:pCIF,:pCiudad,:pCodPostal,:pPais)
		)
	
	if SQLCODE = 0
	{
		&SQL(select LAST_IDENTITY() into :tID from OPNEx_MModel.Proveedor)
		return tID
	}

	return SQLCODE
}

ClassMethod RegistroJSON(pDatos As %DynamicObject) As %Integer
{
	return:('$IsObject(pDatos)||(pDatos.%ClassName()'="%DynamicObject")) 0

	#dim obj as OPNEx.MModel.Proveedor = ..%New()	
	do obj.%JSONImport(pDatos)
	do obj.%Save()
	
	return obj.%Id()
}

ClassMethod ActualizaJSON(pDatos As %DynamicObject) As %Status
{
	return:('$IsObject(pDatos)||(pDatos.%ClassName()'="%DynamicObject")||(pDatos.Codigo<1)) 0

	#dim tSC as %Status = 0
	#dim tProv as OPNEx.MModel.Proveedor = ..%OpenId(pDatos.Codigo)

	if $IsObject(tProv)
	{
		do tProv.%JSONImport(pDatos)
		set tSC = tProv.%Save()
	}

	return tSC
}

ClassMethod FacturacionGlobal(pID As %Integer) As %Integer [ SqlName = FAC_GLOBAL, SqlProc ]
{
	// Calcularía una información X
	return $random(999)*$random(999)
}

Storage Default
{
<Data name="ProveedorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Descripcion</Value>
</Value>
<Value name="3">
<Value>CIF</Value>
</Value>
<Value name="4">
<Value>Direccion</Value>
</Value>
</Data>
<DataLocation>^OPNEx.MModel.ProveedorD</DataLocation>
<DefaultData>ProveedorDefaultData</DefaultData>
<ExtentSize>8</ExtentSize>
<IdLocation>^OPNEx.MModel.ProveedorD</IdLocation>
<IndexLocation>^OPNEx.MModel.ProveedorI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="CIF">
<AverageFieldSize>11</AverageFieldSize>
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="Codigo">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Descripcion">
<AverageFieldSize>21.38</AverageFieldSize>
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="Direccion">
<AverageFieldSize>23.25,Ciudad:9,CodPostal:4.25,Pais:8</AverageFieldSize>
<Selectivity>12.5000%,Ciudad:14.2857%,CodPostal:12.5000%,Pais:100.0000%</Selectivity>
</Property>
<Property name="Facturacion">
<AverageFieldSize>4.88</AverageFieldSize>
<Selectivity>12.5000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^OPNEx.MModel.ProveedorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
