const SELECT=document.querySelector('#select');
const OPCIONES=document.querySelector('#opciones');
const CONTENIDO_SELECCIONADO=document.querySelector('#select .contenido-select');
const HIDDEN_INPUT=document.querySelector('#inputSelected');

document.querySelectorAll('#opciones > .opcion').forEach((opcion => {
    opcion.addEventListener('click', (e) => {
        e.preventDefault();
        CONTENIDO_SELECCIONADO.innerHTML=e.currentTarget.innerHTML;
        SELECT.classList.toggle('active');
        OPCIONES.classList.toggle('active');
        HIDDEN_INPUT.value=e.currentTarget.querySelector('.titulo').innerHTML;
    });
}));

SELECT.addEventListener('click', () => {
    SELECT.classList.toggle('active');
    OPCIONES.classList.toggle('active');
});