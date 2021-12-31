Class OPNEx.MModel.Direccion Extends (%SerialObject, %Populate, %XML.Adaptor, %JSON.Adaptor, Form.Adaptor)
{

Property Ciudad As %String(DISPLAYNAME = "Ciudad", POPSPEC = "City()");

Property Pais As %String(DISPLAYNAME = "Pais") [ InitialExpression = "España" ];

Property CodPostal As %String(DISPLAYNAME = "Codigo Postal", POPSPEC = "USZip()");

Storage Default
{
<Data name="DireccionState">
<Value name="1">
<Value>Ciudad</Value>
</Value>
<Value name="2">
<Value>Pais</Value>
</Value>
<Value name="3">
<Value>CodPostal</Value>
</Value>
</Data>
<State>DireccionState</State>
<StreamLocation>^OPNEx.MModel.DireccionS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
