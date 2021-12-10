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
