//
//  Question.swift
//  curiOsity
//
//  Created by superw on 13/12/2018.
//  Copyright © 2018 superw. All rights reserved.
//

import Foundation

// MODELO DE DATOS PARA LA APP


// MARK: - DEFINICIÓN DE LA CLASE Question

// Esta clase Question no va a heredar de nada, simplemente es un objeto.
// Aquí declararemos todas las propiedades que necesitamos que tenga nuestra clase.
// Actualización: hacemos que la clase herede o se conforme al protocolo CustomStringConvertible para poder sobreescribir la variable autocomputada description y formatear el texto que devuelve el obeto por consola al utilizarlo en un print(). permite customizar la respresentación en formato texto de una clase.
// Actualización: Conformamos nuestra clase a Codable para poder automatizar la carga de datos a traves de un fichero plist, indicando que quiero que se genere el objeto pregunta a partir del fichero plist
class Question  : CustomStringConvertible, Codable {
    
    //como son constantes, necesitaremos un método inicializador
    let questionText : String
    let answer : Bool
    let explanation : String
    
    //Para utilizar el protocolo Codable y recuperar las propiedades del objeto Question del plist deberían coincidir los nombres de las propiedades del objeto y los campos del fichero (question, answer y explanation)
    //Como esto no es así para los tres parámetro (questionText no coincide con question) entonces utilizaremos el enumerado CodingKeys que se debe llamar exactamente así y que será un enumerado de tipo String y de tipo CodingKey, de esta forma creamos una relación entre el nombre de cada propiedad de la clase y de los nombres de las claves de los elecmentos diccionario que hay en el array de diccionarios del plist
    enum CodingKeys : String, CodingKey {
        case questionText = "question" // este es el único que es diferente
        case answer = "answer"
        case explanation = "explanation"
    }
    
    // esta es una variable autocomputada de tipo String que tienen todos los objetos, la vamos a utlizar para mostrar por pantalla o por consola las propiedades de las instancias de objetos Question correctamente.
    // una variable autocomputada es un híbrido entre variable y método, por eso tenemos llaves {}.
    // si la sobreescribimos tendremos la representación del objeto en formato string haciendo un return y decidir la estructura, para esto utilizamos un string multilínea que se introdujo en Swift 4 utilizando """
    var description : String {
        let valorRespuesta = (answer ? "Verdadero" : "Falso") //primero utilizamos una constante local para recoger el el valor de la respuesta que es de tipo Bool (true o false) y devolver un String en castellano "Verdadero" o "Falso", utilizamos el operador ternario ? que evalúa answer y devuevle lo primero en caso de true o lo segundo en caso de false
        return """
        PREGUNTA: \(questionText)
        RESPUESTA: \(valorRespuesta)
        EXPLICACIÓN: \(explanation)
        """
    }
    
    //inicializador de conveniencia que acepte por parámetros un String y un Bool para inicializar las dos propiedades constantes de la clase
    init(text: String, correctAnswer: Bool, explanationText : String) {
        self.questionText = text //inicializamos la constante de clase con el texto que llega por parámetro
        self.answer = correctAnswer //lo mismo
        self.explanation = explanationText //lo mismo
    }
} //fin de la definición de CLASE Question

// MARK: - DEFINICIÓN DE LA ESTRUCTURA QuestionBank

//necesitaremos también una estructura (que es como una clase muy muy vaga que prescinden de tener métodos ni constructores, se trata simplemente de tener datos :) y va muy bien para almacenar los datos que recuperamos de un plist
//swift buscará una variable questions dentro de la plist y fabricar preguntas con estas claves que le hemos suministrado
struct QuestionsBank : Codable {
    var questions : [Question]
    
    //esto no hace falta porque el campo de la property list y el de la variable de la estructura se llaman exactamente igual, pero si no fuese así tendríamos que sobreescribir el enumerado CodingKeys y hacer la asociación correspondiente
    enum CodingKeys : String, CodingKey {
        case questions = "questions"
    }
}

