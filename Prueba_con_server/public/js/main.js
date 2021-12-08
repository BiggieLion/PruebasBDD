//Definimos las constantes para la seleccion de las consultas
const SELECT=document.querySelector('#select');
const OPCIONES=document.querySelector('#opciones');
const CONTENIDO_SELECCIONADO=document.querySelector('#select .contenido-select');
const HIDDEN_INPUT=document.querySelector('#inputSelected');

//Variable para la ruta

//Funcion para imprimir el nombre de la seleccion
document.querySelectorAll('#opciones > .opcion').forEach((opcion => {
    opcion.addEventListener('click', (e) => {
        e.preventDefault();
        CONTENIDO_SELECCIONADO.innerHTML=e.currentTarget.innerHTML;
        SELECT.classList.toggle('active');
        OPCIONES.classList.toggle('active');
        HIDDEN_INPUT.value=e.currentTarget.querySelector('.titulo').innerHTML;
        switch(HIDDEN_INPUT.value) {
            case 'Seleccione la consulta.':
                document.getElementById("frameConsultas").style.display="none";
            break;
            
            case 'Obtener los 3 primeros empleados que han tenido las mayores ventas totales el año pasado.':
                document.getElementById("frameConsultas").style.display="block";
                document.getElementById("frameConsultas").src="/consulta1"; //Consulta 1
            break;

            case 'El vendedor que vendió más por territorio.':
                document.getElementById("frameConsultas").style.display="block";
                document.getElementById("frameConsultas").src="/consulta2";
            break;

            case 'Contar las órdenes de venta por tipo de envío.':
                document.getElementById("frameConsultas").style.display="block";
                document.getElementById("frameConsultas").src="/consulta3";
                break;
            
            case 'Añadir un método de envío.':
                document.getElementById("frameConsultas").style.display="block";
                document.getElementById("frameConsultas").src="/consulta4";
            break;

            case 'Listar a los clientes con respecto al método de envío que les llega la mercancía.':
                document.getElementById("frameConsultas").style.display="block";
                document.getElementById("frameConsultas").src="/consulta5";
            break;

            case 'Obtener la cantidad de órdenes de venta por territorio.':
                document.getElementById("frameConsultas").style.display="block";
                document.getElementById("frameConsultas").src="/consulta6";
            break;

            case 'Obtener los clientes que han comprado asociados a que están recibiendo publicidad por correo electrónico.':
                document.getElementById("frameConsultas").style.display="block";
                document.getElementById("frameConsultas").src="/consulta7";
            break;

            case 'Obtener los tipos de razones de ventas de los clientes suscritos a publicidad por correo electrónico.':
                document.getElementById("frameConsultas").style.display="block";
                document.getElementById("frameConsultas").src="/consulta8";
            break;

            case 'Obtener las razones de venta de los clientes no suscritos a publicidad por correo electrónico.':
                document.getElementById("frameConsultas").style.display="block";
                document.getElementById("frameConsultas").src="/consulta9";
            break;

            default:
                document.getElementById("frameConsulta").style.display="none";
            break;
        }
    });
}));

//Funcion para mostrar el selectbox
SELECT.addEventListener('click', () => { 
    SELECT.classList.toggle('active');
    OPCIONES.classList.toggle('active');
});
