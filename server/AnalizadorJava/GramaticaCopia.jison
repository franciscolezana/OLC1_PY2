
/*------------------------------------------------IMPORTS----------------------------------------------*/
%{
    let CPrimitivo=require('../JavaAST/Expresiones/Primitivo');
    let CAritmetica=require('../JavaAST/Expresiones/Aritmetica');
    let CLExpresion=require('../JavaAST/Expresiones/LExpresion');
    let CErrores=require('../JavaAST/Errores');
    let CNodoError=require('../JavaAST/NodoError');


/*    var Obj = {              
        arrSimbolos: [], 
        arrErrores: [] 
    }; 
     let arrSimbolos=[];
    var Obj = {              
        no: "1", 
        lexema: "juan", 
        tkn: "tk_id", 
        fila: "1", 
        columna: "2", 
    }
    arrSimbolos.push(Obj);
    var Obj2 = {              
        no: "2", 
        lexema: "juan2", 
        tkn: "tk_id", 
        fila: "1", 
        columna: "9", 
    }
    arrSimbolos.push(Obj2);
    var Obj3 = {              
        no: "3", 
        lexema: "juan3", 
        tkn: "tk_id", 
        fila: "1", 
        columna: "3", 
    }
    arrSimbolos.push(Obj3);
    arrSimbolos.push("1","Geeks", "for", "0","0"); 
    arrSimbolos.push("2","Geeks", "for", "0","0");
    arrSimbolos.push("3","Geeks", "for", "0","0");*/
    var Obj1 = {              
        arrSimbolos: [], 
        arrErrores:[] 
    }; 
    let no=0;
    function add(num,lex,tk,fil,col){
        console.log("T->"+num+" "+lex+" "+tk+" "+fil+" "+col);
        var Obj = {              
        no: num,
        lexema: lex, 
        tkn: tk, 
        fila: fil, 
        columna: col, 
        }
        Obj1.arrSimbolos.push(Obj);
    }
    let no2=0;
    function addErr(num,tip,fil,col,descrip){
        console.log("T->"+num+" "+tip+" "+fil+" "+col+" "+descrip);
        var Obj3 = {              
        no: num,
        tipo: tip, 
        fila: fil, 
        columna: col, 
        descripcion: descrip, 
        }
        Obj1.arrErrores.push(Obj3);
    }

    //addErr("0","ERROR DE PRUEBA","0","0","No se esperaba el caracter: "+"ERROR");
    
    //NO LEXEMA TOKEN FILA COLUMNA
    /* Array to be inserted 
    var arraynew = ['Geeks', 'for', 'Geeks']; 
    // Push an array to object 
    Obj.arrayOne.push(arraynew); */
%}



/*------------------------------------------------LEXICO------------------------------------------------*/
%lex


%options case-sensitive


%%
\s+											// se ignoran espacios en blanco
("//".*\r\n)|("//".*\n)|("//".*\r) 		    // comentario simple línea
"/*""/"*([^*/]|[^*]"/"|"*"[^/])*"*"*"*/"	// comentario multiple líneas
\"[^\"]*\"				      { yytext = yytext.substr(1,yyleng-2); return 'tk_cadena'; }
[0-9]+("."[0-9]+)?           %{  return 'tk_decimal';  %}
[0-9]+                       %{  return 'tk_entero';  %}


"import"			return 'Rimport';
//---VISIBILIDAD
"public"			return 'Rpublic';
"protected"			return 'Rprotected';
"private"			return 'Rprivate';
"final"				return 'Rfinal';
//---CLASE
"class"				return 'Rclass';

//---TIPO 
"int"				return 'Rint';
"boolean"			return 'Rboolean';
"String"			return 'Rstring';
"char"			    return 'Rchar';
"double"			return 'Rdouble';
"Object"			return 'Robject';
"void"			    return 'Rvoid';
"main"			    return 'Rmain';
"true"              return 'Rtrue';
"false"             return 'Rfalse';

//OTRAS
"System"			return 'Rsystem';
"out"			    return 'Rout';
"print"			    return 'Rprint';
"println"			return 'Rprintln';

//---SENTENCIAS DE CONTROL
"if"			    return 'Rif';
"else"			    return 'Relse';
"for"			    return 'Rfor';
"while"			    return 'Rwhile';
"do"			    return 'Rdo';
"switch"			return 'Rswitch';
"case"			    return 'Rcase';
//---SALIDAS
"default"			return 'Rdefault';
"break"			    return 'Rbreak';
"continue"			return 'Rcontinue';
"return"			return 'Rreturn';

//---OPERADORES ARITMETICOS Relacionales, lógicos, incremento/decremento, agrupación.
//--Relacionales
"<="			    return 'MenorIgual';
">="			    return 'MayorIgual';
"<"		            return 'Menor';
">"			        return 'Mayor';
"!="			    return 'NotIgual';
"=="			    return 'IgualIgual';

//--Logicos
"&&"			    return 'And';
"||"			    return 'Or';
"!"			        return 'Not';

//--Incremento Decremento
"++"			    return 'MasMas';
"--"			    return 'MenosMenos';

//--Agrupacion
"["			    return 'CorcheteAbre';
"]"			    return 'CorcheteCierra';
"("			    return 'ParAbre';
")"			    return 'ParCierra';
"{"			    return 'LlaveAbre';
"}"			    return 'LlaveCierra';

//--Puntuacion
"."			    return 'Punto';
","			    return 'Coma';
":"			    return 'DosPuntos';
";"			    return 'PuntoComa';

//--Aritemeticos
"&"             return 'Amper';
"+"             return 'Mas';
"-"             return 'Menos';
"*"             return 'Por';
"/"             return 'Division';
"^"             return 'Potencia';
"%"             return 'Modulo';
"="             return 'Igual';
([a-zA-Z_])[a-zA-Z0-9_]*     	   return 'tk_id';
[A-Za-zÑn]                         return 'tk_letra';
"'"[^]"'"                          return 'tk_char';


[ \t\r\n\f] %{ /*se ignoran*/ %}

<<EOF>>     %{  return 'EOF';   %}

.           addErr(no2++,"Lexico",yylineno,yylloc.first_column,"No se esperaba el caracter: "+yytext);

/lex

/*--------------------------------------------------SINTACTICO-----------------------------------------------*/

/*-----ASOCIACION Y PRECEDENCIA-----*/
%left Or
%left And
%left Not
%left MasMas MenosMenos
%left NotIgual IgualIgual 
%left Mayor Menor
%left MayorIgual MenorIgual
%left Mas Menos
%left Por Division
%left Potencia Modulo
%left ParAbre ParCierra 


%start S
%% 

S:  INI EOF { 
    return Obj1;
};

INI: INI LISTA {}
    | LISTA {}
    | error {addErr(no2++,"Sintactico",@1.first_line,this._$.first_column,"No se esperaba el token: "+yytext);};

LISTA : IMPORT { }
    | CLASE{ };
//-----------------------------IMPORTS 
IMPORT : Rimport LI PuntoComa { add(no++,$1,"Rimport",@1.first_line,@1.first_column);add(no++,$3,"PuntoComa",@3.first_line,@3.first_column);
};

LI          : LI Punto TK {  add(no++,$2,"Punto",@2.first_line,@2.first_column);}
            | TK {};

TK          : tk_id { add(no++,$1,"tk_id",@1.first_line,@1.first_column);}
            | Por {add(no++,$1,"Por",@1.first_line,@1.first_column); }
            | error {addErr(no2++,"Sintactico",@1.first_line,this._$.first_column,"No se esperaba el token: "+yytext);};


//-----------------------------CLASE
CLASE : Rclass tk_id LlaveAbre CODIGO LlaveCierra { add(no++,$1,"Rclass",@1.first_line,@1.first_column); add(no++,$2,"tk_id",@2.first_line,@2.first_column); add(no++,$3,"LlaveAbre",@3.first_line,@3.first_column); 
 add(no++,$5,"LlaveCierra",@5.first_line,@5.first_column);
};

CODIGO: CODIGO SENTENCIAS {}
      | SENTENCIAS {};

SENTENCIAS :   DECLARACION  {} 
            |   ASIGNACION  {}
            |   METODO {} 
            |   RETURN{}
            |   IF {}
            |   FOR {}
            |   WHILE {}
            |   DO_WHILE {}
            |   SWITCH {}
            |   BREAK {}
            |   CONTINUE {}
            |   tk_id ParAbre VALOR_LLAMADA ParCierra PuntoComa{ add(no++,$1,"tk_id",@1.first_line,@1.first_column); add(no++,$2,"ParAbre",@2.first_line,@2.first_column);
 add(no++,$4,"ParCierra",@4.first_line,@4.first_column);  add(no++,$5,"PuntoComa",@5.first_line,@5.first_column);}
            |   PRINT{}
            | error {addErr(no2++,"Sintactico",@1.first_line,this._$.first_column,"No se esperaba el token: "+yytext);};

//----------------------- DECLARACION

DECLARACION : TIPO LISTA_ID PuntoComa {  add(no++,$3,"PuntoComa",@3.first_line,@3.first_column);}
            | TIPO LISTA_ID Igual EXPRESION PuntoComa {  add(no++,$3,"Igual",@3.first_line,@3.first_column); add(no++,$5,"PuntoComa",@5.first_line,@5.first_column);};

TIPO        :   Rint     { add(no++,$1,"Rint",@1.first_line,@1.first_column); }
            |   Rboolean { add(no++,$1,"Rboolean",@1.first_line,@1.first_column); }
            |   Rstring  { add(no++,$1,"Rstring",@1.first_line,@1.first_column); }
            |   Rchar    { add(no++,$1,"Rchar",@1.first_line,@1.first_column); }
            |   Rdouble  {  add(no++,$1,"Rdouble",@1.first_line,@1.first_column);}
            |   Rvoid  {  add(no++,$1,"Rvoid",@1.first_line,@1.first_column);};

LISTA_ID    : LISTA_ID Coma tk_id  { add(no++,$2,"Coma",@2.first_line,@2.first_column);add(no++,$3,"tk_id",@3.first_line,@3.first_column);  }
            |   tk_id { add(no++,$1,"tk_id",@1.first_line,@1.first_column); };

//----------------------------ASIGNACION
ASIGNACION  : LISTA_ID Igual EXPRESION PuntoComa { add(no++,$2,"Igual",@2.first_line,@2.first_column);  add(no++,$4,"PuntoComa",@4.first_line,@4.first_column);} ;

//----------------------------EXPRESION
                //--Logicos
EXPRESION   :   EXPRESION Mas EXPRESION { add(no++,$2,"Mas",@2.first_line,@2.first_column);} 
            |   EXPRESION Menos EXPRESION { add(no++,$2,"Menos",@2.first_line,@2.first_column);} 
            |   EXPRESION Por EXPRESION { add(no++,$2,"Por",@2.first_line,@2.first_column);}
            |   EXPRESION Division EXPRESION { add(no++,$2,"Division",@2.first_line,@2.first_column);}
            |   EXPRESION Potencia EXPRESION { add(no++,$2,"Potencia",@2.first_line,@2.first_column);}
            |   EXPRESION Modulo EXPRESION { add(no++,$2,"Modulo",@2.first_line,@2.first_column);}
            //--logicos
            |   EXPRESION Or EXPRESION { add(no++,$2,"Or",@2.first_line,@2.first_column);}
            |   EXPRESION And EXPRESION { add(no++,$2,"And",@2.first_line,@2.first_column);}
            |   Not EXPRESION { add(no++,$1,"Not",@1.first_line,@1.first_column);}
            |   EXPRESION MasMas{ add(no++,$2,"MasMas",@2.first_line,@2.first_column);}
            |   EXPRESION MenosMenos{ add(no++,$2,"MenosMenos",@2.first_line,@2.first_column);}
            |   Menos EXPRESION{ add(no++,$1,"Menos",@2.first_line,@1.first_column);}
            //relacionales
            |   EXPRESION Menor EXPRESION{ add(no++,$2,"Menor",@2.first_line,@2.first_column);}
            |   EXPRESION MenorIgual EXPRESION{ add(no++,$2,"MenorIgual",@2.first_line,@2.first_column);}
            |   EXPRESION Mayor EXPRESION{ add(no++,$2,"Mayor",@2.first_line,@2.first_column);}
            |   EXPRESION MayorIgual EXPRESION{ add(no++,$2,"MayorIgual",@2.first_line,@2.first_column);}
            |   EXPRESION IgualIgual EXPRESION{ add(no++,$2,"IgualIgual",@2.first_line,@2.first_column);}
            |   EXPRESION NotIgual EXPRESION{ add(no++,$2,"NotIgual",@2.first_line,@2.first_column);}
            |   ParAbre EXPRESION ParCierra { add(no++,$1,"ParAbre",@1.first_line,@1.first_column); add(no++,$3,"ParAbre",@3.first_line,@3.first_column);}
            |   tk_id ParAbre VALOR_LLAMADA ParCierra { add(no++,$1,"tk_id",@1.first_line,@1.first_column);  add(no++,$2,"ParAbre",@2.first_line,@2.first_column);  add(no++,$4,"ParCierra",@4.first_line,@4.first_column);}//Con parametros
            |   tk_id ParAbre ParCierra { add(no++,$1,"tk_id",@1.first_line,@1.first_column);  add(no++,$2,"ParAbre",@2.first_line,@2.first_column);  add(no++,$3,"ParCierra",@3.first_line,@3.first_column);}//sin parametros
            //--VALORES
            |   tk_char { add(no++,$1,"tk_char",@1.first_line,@1.first_column);  } 
            |   tk_id   { add(no++,$1,"tk_id",@1.first_line,@1.first_column);  }
            |   tk_cadena {  add(no++,$1,"tk_cadena",@1.first_line,@1.first_column); }
            |   tk_decimal { add(no++,$1,"tk_numero",@1.first_line,@1.first_column); }
            |   tk_entero {  add(no++,$1,"tk_numero",@1.first_line,@1.first_column); }
            |   Rtrue { add(no++,$1,"Rtrue",@1.first_line,@1.first_column); }
            |   Rfalse { add(no++,$1,"Rfalse",@1.first_line,@1.first_column); }
            | error {addErr(no2++,"Sintactico",@1.first_line,this._$.first_column,"No se esperaba el token: "+yytext);};

VALOR_LLAMADA: VALOR_LLAMADA Coma EXPRESION { add(no++,$2,"Coma",@2.first_line,@2.first_column); }
            |   EXPRESION {};

//----------------------------LLAMADAS


METODO : TIPO tk_id ParAbre LISTA_PARAMETROS ParCierra LlaveAbre CODIGO LlaveCierra { add(no++,$2,"tk_id",@2.first_line,@2.first_column);  add(no++,$3,"ParAbre",@3.first_line,@3.first_column); add(no++,$5,"ParCierra",@5.first_line,@5.first_column); add(no++,$6,"LlaveAbre",@6.first_line,@6.first_column);  add(no++,$8,"LlaveCierra",@8.first_line,@8.first_column);}
        | TIPO tk_id ParAbre ParCierra LlaveAbre CODIGO LlaveCierra   {  add(no++,$2,"tk_id",@2.first_line,@2.first_column);  add(no++,$3,"ParAbre",@3.first_line,@3.first_column); add(no++,$4,"ParCierra",@4.first_line,@4.first_column); add(no++,$5,"LlaveAbre",@5.first_line,@5.first_column);  add(no++,$7,"LlaveCierra",@1.first_line,@7.first_column);}
        | TIPO Rmain ParAbre ParCierra LlaveAbre CODIGO LlaveCierra {  add(no++,$2,"Rmain",@2.first_line,@2.first_column);  add(no++,$3,"ParAbre",@3.first_line,@3.first_column); add(no++,$4,"ParCierra",@4.first_line,@4.first_column); add(no++,$5,"LlaveAbre",@5.first_line,@5.first_column);  add(no++,$7,"LlaveCierra",@7.first_line,@7.first_column);};

LISTA_PARAMETROS :LISTA_PARAMETROS Coma  TIPO tk_id { add(no++,$2,"Coma",@2.first_line,@2.first_column); add(no++,$4,"tk_id",@4.first_line,@4.first_column);}
                |   TIPO tk_id { add(no++,$2,"tk_id",@2.first_line,@2.first_column);};

CONTINUE : Rcontinue PuntoComa{ add(no++,$1,"Rcontinue",@1.first_line,@1.first_column); add(no++,$2,"PuntoComa",@2.first_line,@2.first_column);};

RETURN      : Rreturn EXPRESION PuntoComa { add(no++,$1,"Rreturn",@1.first_line,@1.first_column); add(no++,$3,"PuntoComa",@3.first_line,@3.first_column);}}
            | Rreturn PuntoComa { add(no++,$1,"Rreturn",@1.first_line,@1.first_column); add(no++,$2,"PuntoComa",@2.first_line,@2.first_column);}};


//----------------------------IF
IF          : Rif ParAbre EXPRESION ParCierra LlaveAbre CODIGO LlaveCierra LISTA_EI Relse LlaveAbre CODIGO LlaveCierra {
     add(no++,$1,"Rif",@1.first_line,@1.first_column); add(no++,$2,"ParAbre",@2.first_line,@2.first_column);
     add(no++,$4,"ParCierra",@4.first_line,@4.first_column); add(no++,$5,"LlaveAbre",@5.first_line,@5.first_column);
     add(no++,$7,"LlaveCierra",@7.first_line,@7.first_column); add(no++,$9,"Relse",@9.first_line,@9.first_column);
     add(no++,$10,"LlaveAbre",@10.first_line,@10.first_column); add(no++,$12,"LlaveCierra",@12.first_line,@12.first_column); }
            | Rif ParAbre EXPRESION ParCierra LlaveAbre CODIGO LlaveCierra LISTA_EI {
                 add(no++,$1,"Rif",@1.first_line,@1.first_column); add(no++,$2,"ParAbre",@2.first_line,@2.first_column);
                 add(no++,$4,"ParCierra",@4.first_line,@4.first_column); add(no++,$5,"LlaveAbre",@5.first_line,@5.first_column);
                 add(no++,$7,"LlaveCierra",@7.first_line,@7.first_column);}

            | Rif ParAbre EXPRESION ParCierra LlaveAbre CODIGO LlaveCierra Relse LlaveAbre CODIGO LlaveCierra {
     add(no++,$1,"Rif",@1.first_line,@1.first_column); add(no++,$2,"ParAbre",@2.first_line,@2.first_column);
     add(no++,$4,"ParCierra",@4.first_line,@4.first_column); add(no++,$5,"LlaveAbre",@5.first_line,@5.first_column);
     add(no++,$7,"LlaveCierra",@7.first_line,@7.first_column); add(no++,$8,"Relse",@8.first_line,@8.first_column);
     add(no++,$9,"LlaveAbre",@9.first_line,@9.first_column); add(no++,$11,"LlaveCierra",@11.first_line,@11.first_column); }
            
            | Rif ParAbre EXPRESION ParCierra LlaveAbre CODIGO LlaveCierra{
                 add(no++,$1,"Rif",@1.first_line,@1.first_column); add(no++,$2,"ParAbre",@2.first_line,@2.first_column);
                 add(no++,$4,"ParCierra",@4.first_line,@4.first_column); add(no++,$5,"LlaveAbre",@5.first_line,@5.first_column);
                 add(no++,$7,"LlaveCierra",@7.first_line,@7.first_column);};


LISTA_EI    : LISTA_EI Relse Rif ParAbre EXPRESION ParCierra LlaveAbre CODIGO LlaveCierra {
                 add(no++,$2,"Relse",@2.first_line,@2.first_column); add(no++,$3,"Rif",@3.first_line,@3.first_column);
                 add(no++,$4,"ParAbre",@4.first_line,@4.first_column);
                 add(no++,$6,"ParCierra",@6.first_line,@6.first_column); add(no++,$7,"LlaveAbre",@7.first_line,@7.first_column);
                 add(no++,$9,"LlaveCierra",@9.first_line,@9.first_column);} 
            |   Relse Rif ParAbre EXPRESION ParCierra LlaveAbre CODIGO LlaveCierra {
                 add(no++,$1,"Relse",@1.first_line,@1.first_column); add(no++,$2,"Rif",@2.first_line,@2.first_column);
                 add(no++,$3,"ParAbre",@3.first_line,@3.first_column);
                 add(no++,$5,"ParCierra",@5.first_line,@5.first_column); add(no++,$6,"LlaveAbre",@6.first_line,@6.first_column);
                 add(no++,$8,"LlaveCierra",@8.first_line,@8.first_column);
            };

//----------------------------FOR
FOR         :  Rfor ParAbre TIPO tk_id Igual EXPRESION PuntoComa EXPRESION PuntoComa EXPRESION ParCierra LlaveAbre CODIGO LlaveCierra {
                 add(no++,$1,"Rfor",@1.first_line,@1.first_column); add(no++,$2,"ParAbre",@2.first_line,@2.first_column);
                 add(no++,$4,"tk_id",@4.first_line,@4.first_column);
                 add(no++,$5,"Igual",@5.first_line,@5.first_column); add(no++,$7,"PuntoComa",@7.first_line,@7.first_column);
                 add(no++,$9,"PuntoComa",@9.first_line,@9.first_column);
                 add(no++,$11,"ParCierra",@11.first_line,@11.first_column); add(no++,$12,"LlaveAbre",@12.first_line,@12.first_column);
                 add(no++,$14,"LlaveCierra",@14.first_line,@14.first_column);
};


//----------------------------DO WHILE
DO_WHILE    : Rdo LlaveAbre CODIGO LlaveCierra Rwhile ParAbre EXPRESION ParCierra PuntoComa {
     add(no++,$1,"Rdo",@1.first_line,@1.first_column); add(no++,$2,"LlaveAbre",@2.first_line,@2.first_column);
     add(no++,$4,"LlaveCierra",@4.first_line,@4.first_column);
     add(no++,$5,"Rwhile",@5.first_line,@5.first_column); add(no++,$6,"ParAbre",@6.first_line,@6.first_column);
     add(no++,$8,"ParCierra",@8.first_line,@8.first_column); add(no++,$9,"PuntoComa",@9.first_line,@9.first_column);
};

//----------------------------WHILE
WHILE       : Rwhile ParAbre EXPRESION ParCierra LlaveAbre CODIGO LlaveCierra{
       add(no++,$1,"Rwhile",@1.first_line,@1.first_column); add(no++,$2,"ParAbre",@2.first_line,@2.first_column);
     add(no++,$4,"ParCierra",@4.first_line,@4.first_column);
     add(no++,$5,"LlaveAbre",@5.first_line,@5.first_column); add(no++,$7,"LlaveCierra",@7.first_line,@7.first_column);
};


//----------------------------SWITCH
SWITCH      : Rswitch ParAbre EXPRESION ParCierra LlaveAbre LISTA_CASE Rdefault DosPuntos CODIGO LlaveCierra {
       add(no++,$1,"Rswitch",@1.first_line,@1.first_column); add(no++,$2,"ParAbre",@2.first_line,@2.first_column);
     add(no++,$4,"ParCierra",@4.first_line,@4.first_column);
     add(no++,$5,"LlaveAbre",@5.first_line,@5.first_column); add(no++,$7,"Rdefault",@7.first_line,@7.first_column);
     add(no++,$8,"DosPuntos",@8.first_line,@8.first_column); add(no++,$10,"LlaveCierra",@10.first_line,@10.first_column);
};

LISTA_CASE  : LISTA_CASE CASO{}
            |   CASO{};

CASO        : Rcase EXPRESION DosPuntos CODIGO { add(no++,$1,"Rcase",@1.first_line,@1.first_column); add(no++,$3,"DosPuntos",@3.first_line,@3.first_column);};          //CON CODIGO

BREAK       : Rbreak PuntoComa{ add(no++,$1,"Rbreak",@1.first_line,@1.first_column); add(no++,$2,"PuntoComa",@2.first_line,@2.first_column);};        

//----------------------------LLAMADAS
LLAMADAS    : tk_id ParAbre EXPRESION ParCierra PuntoComa {
     add(no++,$1,"tk_id",@1.first_line,@1.first_column); add(no++,$2,"ParAbre",@2.first_line,@2.first_column);
     add(no++,$4,"ParCierra",@4.first_line,@4.first_column); add(no++,$5,"PuntoComa",@5.first_line,@5.first_column);
}
            | tk_id ParAbre ParCierra PuntoComa{ add(no++,$1,"tk_id",@1.first_line,@1.first_column); add(no++,$2,"ParAbre",@2.first_line,@2.first_column);
             add(no++,$3,"ParCierra",@3.first_line,@3.first_column); add(no++,$4,"PuntoComa",@4.first_line,@4.first_column);
            };

//----------------------------LLAMADAS
PRINT       : Rsystem Punto Rout Punto Rprint ParAbre EXPRESION ParCierra PuntoComa{
     add(no++,$1,"Rsystem",@1.first_line,@1.first_column); add(no++,$2,"Punto",@2.first_line,@2.first_column);
     add(no++,$3,"Rout",@3.first_line,@3.first_column); add(no++,$4,"Punto",@4.first_line,@4.first_column);
     add(no++,$5,"Rprint",@5.first_line,@5.first_column); add(no++,$6,"ParAbre",@6.first_line,@6.first_column);
     add(no++,$8,"ParCierra",@8.first_line,@8.first_column); add(no++,$9,"PuntoComa",@9.first_line,@9.first_column);
}
            | Rsystem Punto Rout Punto Rprintln ParAbre EXPRESION ParCierra PuntoComa{
                 add(no++,$1,"Rsystem",@1.first_line,@1.first_column); add(no++,$2,"Punto",@2.first_line,@2.first_column);
     add(no++,$3,"Rout",@3.first_line,@3.first_column); add(no++,$4,"Punto",@4.first_line,@4.first_column);
     add(no++,$5,"Rprintln",@5.first_line,@5.first_column); add(no++,$6,"ParAbre",@6.first_line,@6.first_column);
     add(no++,$8,"ParCierra",@8.first_line,@8.first_column); add(no++,$9,"PuntoComa",@9.first_line,@9.first_column)
            };