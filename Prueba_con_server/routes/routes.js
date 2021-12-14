const EXPRESS = require("express");
const ROUTER = EXPRESS.Router();
import * as CONSULTAS from '../controllers/consultas'
const path = require("path");
const fs = require("fs");

const dirPath = path.join(__dirname, "../public/downloads");
const files = fs.readdirSync(dirPath).map(name => {
    return {
        name: path.basename(name, ".pdf"),
        url: '/downloads/${name}'
    };
});

ROUTER.get("/", (req, res) => {
    res.render("Vmain");
});

//Ruta de prueba servicios
ROUTER.get("/propuesta", (req, res) => {
    res.render("lector");
});

ROUTER.get("/sobre-nosotros", (req, res) => {
    res.render("about");
});

//Ruta para la consulta 1
ROUTER.get("/consulta1", CONSULTAS.CONSULTA1);

//Ruta para consulta 2
ROUTER.get("/consulta2", CONSULTAS.CONSULTA2);

//Ruta para consulta 3
ROUTER.get("/consulta3", CONSULTAS.CONSULTA3);

//Ruta para consulta 4
ROUTER.get("/consulta4", CONSULTAS.CONSULTA4);

//Ruta para consulta 5
ROUTER.get("/consulta5", CONSULTAS.CONSULTA5);

//Ruta para consulta 6
ROUTER.get("/consulta6", CONSULTAS.CONSULTA6);

//Ruta para consulta 7
ROUTER.get("/consulta7", CONSULTAS.CONSULTA7);

//Ruta para consulta 8
ROUTER.get("/consulta8", CONSULTAS.CONSULTA8);

//Ruta para consulta 9
ROUTER.get("/consulta9", CONSULTAS.CONSULTA9);

module.exports = ROUTER;
