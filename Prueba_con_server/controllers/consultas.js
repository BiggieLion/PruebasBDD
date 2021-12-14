import { ConexionBDD } from "../databases/conexion";

export const CONSULTA1 = async (req, res) => {
    const conexion = await ConexionBDD();
    const resultado = await conexion.request().query("EXEC Top3_vendedores_mayores_ventas_LastYear");
    res.render("c1design", {vendedores : resultado});
};

export const CONSULTA2 = async (req, res) => {
    const conexion = await ConexionBDD();
    const resultado = await conexion.request().query("EXEC Total_ventas_por_territorio");
    res.render("c2design", {territorios: resultado});
};

export const CONSULTA3 = async (req, res) => {
    const conexion = await ConexionBDD();
    const resultado = await conexion.request().query("EXEC Total_ventas_por_metodo_envio");
    res.render("c3design", {envio: resultado});
}

export const CONSULTA4 = async (req, res) => {
    const conexion = await ConexionBDD();
    const resultado = await conexion.request().query("EXEC Eliminacion_ultima_orden_venta");
    res.render("c4design", {envio:resultado});
}

export const CONSULTA5 = async (req, res) => {
    const conexion = await ConexionBDD();
    const resultado = await conexion.request().query("EXEC Lista_Tiendas_Vendedores");
    res.render("c5design", {envio: resultado});
}

export const CONSULTA6 = async (req, res) => {
    const conexion = await ConexionBDD();
    const resultado = await conexion.request().query("EXEC Total_ventas_por_vendedor");
    res.render("c6design", {envio: resultado});
}

export const CONSULTA7 = async (req, res) => {
    const conexion = await ConexionBDD();
    const resultado = await conexion.request().query("SELECT P.FirstName, P.MiddleName, P.LastName, COUNT(*) AS Cliente FROM [ConnectionFragmeto2a1].Fragmento1AW.dbo.SalesOrderHeader SOH JOIN [ConnectionFragmeto2a1].Fragmento1AW.dbo.Customer C ON SOH.CustomerID = C.CustomerID JOIN [ConnectionFragmeto2a1].Fragmento1AW.dbo.Person P on C.PersonID = P.BusinessEntityID GROUP BY P.FirstName, P.MiddleName, P.LastName");
    res.render("c7design", {envio: resultado});
}

export const CONSULTA8 = async (req, res) => {
    const conexion = await ConexionBDD();
    const resultado = await conexion.request().query("select ReasonType, count(*) as Cliente from [ConnectionFragmeto2a1].Fragmento1AW.dbo.SalesReason SR join [ConnectionFragmeto2a1].Fragmento1AW.dbo.SalesOrderHeaderSalesReason SOHSR on SR.SalesReasonID = SOHSR.SalesReasonID group by ReasonType");
    res.render("c8design", {envio: resultado});
}

export const CONSULTA9 = async (req, res) => {
    const conexion = await ConexionBDD();
    const resultado = await conexion.request().query("select [name], count(*) as Cliente from [ConnectionFragmeto1a2].Fragmento2AW.dbo.SalesReason SR join [ConnectionFragmeto1a2].Fragmento2AW.dbo.SalesOrderHeaderSalesReason SOHSR on SR.SalesReasonID = SOHSR.SalesReasonID group by [name]");
    res.render("c9design", {envio: resultado});
}