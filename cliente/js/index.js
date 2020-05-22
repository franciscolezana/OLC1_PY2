function Conn() {

    var texto = document.getElementById("operacion").value;
    console.log(texto);

    var url = 'http://localhost:8080/Calcular/';

    $.post(url, { text: texto }, function (data, status) {
        if (status.toString() == "success") {
            alert("ANALISIS FINALIZADO");

            //GETTING REPORTE
            var h2c = document.getElementById("tab");
            let cadena = "<table class=\"minimalistBlack\">" +
                "<tr>" +
                "<th>No.</th>" +
                "<th>Lexema</th>" +
                "<th>Token</th>" +
                "<th>Fila</th>" +
                "<th>Columna</th>" +
                "</tr>";
            var i = 0;
            var n = 0;
            var k = 0;
            let datos = data.arrSimbolos;

            //por fila
            let datOrdenar = datos;
            let ordefila = [];
            ordefila = datOrdenar.sort(compare_fila);

            //por columna
            let datosOR = ordefila;
            let order1 = [];
            let order2 = [];
            let Orderfinal = [];

            for (n = 0; n < datosOR.length; n++) {
                let datosjson = JSON.stringify(datosOR[n]);
                let datosparse = JSON.parse(datosjson);
                let comparacion = datosparse.fila;
                if (order1[0] != null) {
                    //si es ultimo elemento
                    if (n == datosOR.length - 1) {
                        if (comparacion == order1[0].fila) {
                            order1.push(datosparse);
                            order2 = order1.sort(compare_qty);
                            for (k = 0; k < order2.length; k++) {
                                Orderfinal.push(order2[k]);
                            }
                        }
                        else{
                            order2 = order1.sort(compare_qty);
                            for (k = 0; k < order2.length; k++) {
                                Orderfinal.push(order2[k]);
                            }
                            Orderfinal.push(datosparse);
                        }
                        
                    }
                    else {
                        if (comparacion == order1[0].fila) {
                            order1.push(datosparse);
                        }
                        else {
                            n--;
                            order2 = order1.sort(compare_qty);
                            for (k = 0; k < order2.length; k++) {
                                Orderfinal.push(order2[k]);
                            }
                            order1 = [];
                            order2 = [];
                        }
                    }

                }
                else {
                    if (n == datosOR.length - 1) {
                        Orderfinal.push(datosparse);
                    }
                    else{
                        order1.push(datosparse);
                    }
                }
            }


            for (i = 0; i < Orderfinal.length; i++) {
                let user_json = JSON.stringify(Orderfinal[i]);
                let Real_user_json2 = JSON.parse(user_json);
                cadena += "<tr>" +
                    "<td>" + i + "</th>" +
                    "<td>" + Real_user_json2.lexema + "</th>" +
                    "<td>" + Real_user_json2.tkn + "</th>" +
                    "<td>" + Real_user_json2.fila + "</th>" +
                    "<td>" + Real_user_json2.columna + "</th>" +
                    "</tr>";
            }
            /* cadena+= "<tr>"+
                 "<td>"+user_json.no+"</th>"+
                 "<td>"+user_json.lexema+"</th>"+
                 "<td>"+user_json.tkn+"</th>"+
                 "<td>"+user_json.fila+"</th>"+
                 "<td>"+user_json.columna+"</th>"+
                 "</tr>";*/

            cadena += "</table>"
            h2c.innerHTML = cadena;


            //GETTING REPORTE ERRORES
            var h2cErr = document.getElementById("tab2");
            let cadena2 = "<table class=\"minimalistBlack\">" +
                "<tr>" +
                "<th>No.</th>" +
                "<th>Tipo Err</th>" +
                "<th>Fila</th>" +
                "<th>Columna</th>" +
                "<th>Descripcion</th>" +
                "</tr>";
            var j = 0;
            let datosErr = data.arrErrores;
            for (j = 0; j < datosErr.length; j++) {
                let userErr_json = JSON.stringify(datosErr[j]);
                let Real_userErr_json2 = JSON.parse(userErr_json);
                cadena2 += "<tr>" +
                    "<td>" + Real_userErr_json2.no + "</th>" +
                    "<td>" + Real_userErr_json2.tipo + "</th>" +
                    "<td>" + Real_userErr_json2.fila + "</th>" +
                    "<td>" + Real_userErr_json2.columna + "</th>" +
                    "<td>" + Real_userErr_json2.descripcion + "</th>" +
                    "</tr>";
            }/*
            cadena+= "<tr>"+
                "<td>"+user_json.no+"</th>"+
                "<td>"+user_json.lexema+"</th>"+
                "<td>"+user_json.tkn+"</th>"+
                "<td>"+user_json.fila+"</th>"+
                "<td>"+user_json.columna+"</th>"+
                "</tr>";*/

            cadena2 += "</table>"
            h2cErr.innerHTML = cadena2;

            console.log(data.arrErrores);
        } else {
            alert("Error estado de conexion:" + status);
        }
    });
}

//Comparing based on the property qty
function compare_fila(a, b) {
    // a should come before b in the sorted order
    if (a.fila < b.fila) {
        return -1;
        // a should come after b in the sorted order
    } else if (a.fila > b.fila) {
        return 1;   
        // a and b are the same
    } else {
        return 0;
    }
}

function openFileEvent() {
    var fileToLoad = document.getElementById("openFile").files[0];

    var fileReader = new FileReader();
    fileReader.onload = function (fileLoadedEvent) {
        var textFromFileLoaded = fileLoadedEvent.target.result;
            document.getElementById("operacion").value = "" + textFromFileLoaded;
    };
    fileReader.readAsText(fileToLoad, "UTF-8")
}

function saveEvent() {
    var textToSave = document.getElementById("operacion").value;
    var textToSaveAsBlob = new Blob([textToSave], { type: "text/plain" });
    //var textToSaveAsURL = window.URL.createObjectURL(textToSaveAsBlob);
    //var fileNameToSaveAs = "guardado.java";

    var a = document.getElementById("a");
    a.href = URL.createObjectURL(textToSaveAsBlob);
    a.download = "guardado.java";

}



function download(text, name, type) {
    var textToSave = document.getElementById("operacion").value;
    var a = document.getElementById("a");
    var file = new Blob([textToSave], {type: type});
    a.href = URL.createObjectURL(file);
    a.download = name;
  }

//Comparing based on the property qty
function compare_qty(a, b) {
    // a should come before b in the sorted order
    if (a.columna < b.columna) {
        return -1;
        // a should come after b in the sorted order
    } else if (a.columna > b.columna) {
        return 1;
        // a and b are the same
    } else {
        return 0;
    }
}

function Conn2() {

    var texto = document.getElementById("operacion2").value;
    console.log(texto);

    var url = 'http://localhost:8080/Calcular2/';

    $.post(url, { text: texto }, function (data, status) {
        if (status.toString() == "success") {
            alert("ANALISIS FINALIZADO");

            //GETTING REPORTE
            var h2c = document.getElementById("error");
            let cadena = "<table class=\"minimalistBlack\">" +
                "<tr>" +
                "<th>No.</th>" +
                "<th>Lexema</th>" +
                "<th>Token</th>" +
                "<th>Fila</th>" +
                "<th>Columna</th>" +
                "</tr>";
            var i = 0;
            var n = 0;
            var k = 0;
            let datos = data.arrSimbolos;

            //por fila
            let datOrdenar = datos;
            let ordefila = [];
            ordefila = datOrdenar.sort(compare_fila);

            //por columna
            let datosOR = ordefila;
            let order1 = [];
            let order2 = [];
            let Orderfinal = [];

            for (n = 0; n < datosOR.length; n++) {
                let datosjson = JSON.stringify(datosOR[n]);
                let datosparse = JSON.parse(datosjson);
                let comparacion = datosparse.fila;
                if (order1[0] != null) {
                    //si es ultimo elemento
                    if (n == datosOR.length - 1) {
                        if (comparacion == order1[0].fila) {
                            order1.push(datosparse);
                            order2 = order1.sort(compare_qty);
                            for (k = 0; k < order2.length; k++) {
                                Orderfinal.push(order2[k]);
                            }
                        }
                        else{
                            order2 = order1.sort(compare_qty);
                            for (k = 0; k < order2.length; k++) {
                                Orderfinal.push(order2[k]);
                            }
                            Orderfinal.push(datosparse);
                        }
                        
                    }
                    else {
                        if (comparacion == order1[0].fila) {
                            order1.push(datosparse);
                        }
                        else {
                            n--;
                            order2 = order1.sort(compare_qty);
                            for (k = 0; k < order2.length; k++) {
                                Orderfinal.push(order2[k]);
                            }
                            order1 = [];
                            order2 = [];
                        }
                    }

                }
                else {
                    if (n == datosOR.length - 1) {
                        Orderfinal.push(datosparse);
                    }
                    else{
                        order1.push(datosparse);
                    }
                }
            }


            for (i = 0; i < Orderfinal.length; i++) {
                let user_json = JSON.stringify(Orderfinal[i]);
                let Real_user_json2 = JSON.parse(user_json);
                cadena += "<tr>" +
                    "<td>" + i + "</th>" +
                    "<td>" + Real_user_json2.lexema + "</th>" +
                    "<td>" + Real_user_json2.tkn + "</th>" +
                    "<td>" + Real_user_json2.fila + "</th>" +
                    "<td>" + Real_user_json2.columna + "</th>" +
                    "</tr>";
            }
            /* cadena+= "<tr>"+
                 "<td>"+user_json.no+"</th>"+
                 "<td>"+user_json.lexema+"</th>"+
                 "<td>"+user_json.tkn+"</th>"+
                 "<td>"+user_json.fila+"</th>"+
                 "<td>"+user_json.columna+"</th>"+
                 "</tr>";*/

            cadena += "</table>"
            h2c.innerHTML = cadena;


            //GETTING REPORTE ERRORES
            var h2cErr = document.getElementById("error2");
            let cadena2 = "<table class=\"minimalistBlack\">" +
                "<tr>" +
                "<th>No.</th>" +
                "<th>Tipo Err</th>" +
                "<th>Fila</th>" +
                "<th>Columna</th>" +
                "<th>Descripcion</th>" +
                "</tr>";
            var j = 0;
            let datosErr = data.arrErrores;
            for (j = 0; j < datosErr.length; j++) {
                let userErr_json = JSON.stringify(datosErr[j]);
                let Real_userErr_json2 = JSON.parse(userErr_json);
                cadena2 += "<tr>" +
                    "<td>" + Real_userErr_json2.no + "</th>" +
                    "<td>" + Real_userErr_json2.tipo + "</th>" +
                    "<td>" + Real_userErr_json2.fila + "</th>" +
                    "<td>" + Real_userErr_json2.columna + "</th>" +
                    "<td>" + Real_userErr_json2.descripcion + "</th>" +
                    "</tr>";
            }/*
            cadena+= "<tr>"+
                "<td>"+user_json.no+"</th>"+
                "<td>"+user_json.lexema+"</th>"+
                "<td>"+user_json.tkn+"</th>"+
                "<td>"+user_json.fila+"</th>"+
                "<td>"+user_json.columna+"</th>"+
                "</tr>";*/

            cadena2 += "</table>"
            h2cErr.innerHTML = cadena2;

            console.log(data.arrErrores);
        } else {
            alert("Error estado de conexion:" + status);
        }
    });
}