const EXPRESS = require('express');
const ROUTER = EXPRESS.Router();

//Ruta root
ROUTER.get('/', (req, res) => {
    res.render("index", {titulo : "Titulo dinamico"});
});

//Ruta de prueba servicios
ROUTER.get('/servicios', (req, res) => {
    res.render("servicios");
});

//Ruta para la consulta 1
ROUTER.get('/consulta1', (req, res) => {
    res.render("c1design");
});

module.exports=ROUTER;