//Segmento de codigo para proyectar las diferentes consultas dependiendo lo seleccionado por el user
function opcionSeleccionada () {
    let opcion=document.getElementById("menuConsultas");
    let texto=opcion.options[opcion.selectedIndex].text;
    alert("Has seleccionado la opcion"+texto);
}