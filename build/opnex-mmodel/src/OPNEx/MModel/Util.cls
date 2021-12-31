Class OPNEx.MModel.Util Extends %RegisteredObject
{

ClassMethod Limpia(pAll As %Boolean = 0)
{
	do ##class(OPNEx.MModel.Proveedor).%KillExtent()
	
	if pAll
	{
		&SQL(drop table OPNEx_MModel.Proveedor)
	}

	return
}

}
