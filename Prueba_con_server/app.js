const EXPRESS = require('express');
const APP = EXPRESS();

let puerto = process.env.PORT || 3000;

APP.set('view engine', 'ejs'); //Configuramos el motor de plantillas
APP.set('views', __dirname+'/views');//Configuramos donde estaran las vistas
APP.use(EXPRESS.static(__dirname + '/public')); //Configuramos el middleware para el inicio

APP.listen(puerto, () => { //Se levanta el servidor
    console.log('Servidor levantado en el puerto', puerto);
});


APP.use('/', require('./routes/routes')); //Se mueven las rutas a un archivo routes y se configura middleware

APP.use((req, res, next) => {       
    res.status(404).render("404", {
        titulo : "404", 
        descripcion : "Error, no se encuentra la pagina solicitada"
    })//Middleware para el 404 SIEMPRE VA AL FINAL DE LAS RUTAS
});