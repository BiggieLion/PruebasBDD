const EXPRESS = require("express");
const ROUTER = EXPRESS.Router();
import { CONSULTA1 } from "../controllers/consultas";
import { CONSULTA2 } from "../controllers/consultas";
import { CONSULTA3 } from "../controllers/consultas";

//Ruta root
ROUTER.get("/", (req, res) => {
    res.render("index", { titulo: "Titulo dinamico" });
});

//Ruta de prueba servicios
ROUTER.get("/servicios", (req, res) => {
    res.render("servicios");
});

//Ruta para la consulta 1
ROUTER.get("/consulta1", CONSULTA1);

//Ruta para consulta 2
ROUTER.get("/consulta2", CONSULTA2);

//Ruta para consulta 3
ROUTER.get("/consulta3", CONSULTA3);

module.exports = ROUTER;
