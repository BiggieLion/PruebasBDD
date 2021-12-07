const EXPRESS = require('express');
const APP = EXPRESS();
const PORT = 3000;

APP.set('view engine', 'ejs'); //Configuramos el motor de plantillas
APP.set('views', __dirname+'/views');//Configuramos donde estaran las vistas

APP.use(EXPRESS.static(__dirname + '/public')); //Configuramos el middleware para el inicio


APP.listen(PORT, () => {
    console.log('Servidor levantado en el puerto', PORT);
});

APP.get('/', (req, res) => {
    res.render("index", {titulo : "Titulo dinamico"});
});

APP.get('/servicios', (req, res) => {
    res.render("servicios", {mensaje : "Mensaje dinamico de servicio"});
});

APP.use((req, res, next) => {
    res.status(404).render("404", {
        titulo : "404", 
        descripcion : "Error, no se encuentra la pagina solicitada"
    })//Middleware para el 404 SIEMPRE VA AL FINAL DE LAS RUTAS
});