//
//  QuestionsFactory.swift
//  curiOsity
//
//  Created by superw on 13/12/2018.
//  Copyright © 2018 superw. All rights reserved.
//

// FACTORÍA DE PREGUNTAS

import Foundation

// Esta clase de la factoría no hereda.

class QuestionsFactory {
    
    //Ahora que usamos el protocolo Codable y hemos teneido que crear una estructura utilizamos una variable de tipo QuestionBank (que es una estructura
    var questionsBank : QuestionsBank! //esta variable la inicializaremos en el constructor Init() de la clase cuando carguemos las preguntas de un fichero plist y la tenemos que hacer requerida ! porque como la inicializamos dentro de un do-catch-error en el caso de que dé error no se incializaría
    
    //Inicializador de la clase para arrancar la batería de preguntas, no tiene parámetros, no necesito parámetros porque será la propia clase que va a saber la lista de contenidos que hay que fabricar
    init() {
        
        // MARK: - PROCESADO AUTOMÁTICO DEL FICHERO PLIST
        // UTLIZANDO EL PROTOCOLO CODABLE ENCODABLE/DECODABLE

        //Ahora vamos a leer los datos del fichero, no el contenido. Es decir, vamos a leer el dato como binario.
        //En lugar de cargar un path vamos a usar una url y tendremos que protegerlo con la clausula do catch y utlizar try en las llamadas porque pueden generar un error
        do {
            if let url = Bundle.main.url(forResource: "QuestionsBank", withExtension: "plist") {
            //Aquí cargamos los datos en binario con un try delante porque puede dar erro indicandole la url
            let data = try Data(contentsOf: url) //si no tuvieramos esto dentro de un if let deberíamos pasar la url como un parámetro requerido con url! (por el error, podría fallar la extracción de datos binarios de un fichero porque el fichero esté corrupo, o porque esté protegido, etc..)
            //Como es un binario, si imprimos en consola data devolverá el núemro de bytes que ocupa
            print("Extracción de datos bienarios OK \(data)") //esto imprime 2623 bytes con el fichero plist que se está utlizando en las pruebas
            print("url leída:\n \(url)")

            //Aquí tenemos que convertir el fichero data primero en un objeto (una estructura) que es el array QuestionsBank y automáticamente solo con procesarla como QuestionsBank voy a obetener un array de questions (porque estamos utilizando Codable)
            //Vamos directamente a intentar extraer un objeto questionsBank desde data, utlizaremos el PropertyListDecoder
            //Como la descodificación puede dar error lo protegemos con un try
            self.questionsBank = try PropertyListDecoder().decode(QuestionsBank.self, from: data)
            //Si esto ha funcionado entonces tendremos un campo llamado questions que son las preguntas que van a ir en la factoría
            }
        } catch {
            print(error)
        }
        
        //Si entra aquí la apilcación peta (por ejemplo, no encuentra o no existe archivo QuestionsBank.plist
        if self.questionsBank == nil {
            //justo antes del error en tiempo de ejecución imprimiríamos este mensaje por consola
            print(">>> ERROR FATAL! <<< \n>>> NO SE HA PODIDO INICIALIZAR la variable questionBank de tipo estructura QuestionBank <<<")
        }

    }
    
    //Esta función devolverá la pregunta que se encuentre en el índice que recibe y si el índice está fuera de rango devuelve nil, por eso el parámetro de retorno Question? es opcional
    func getQuestionAt (index : Int) -> Question? {
        print(">>> VALOR DE index es \(index) y el valor de COUNT es \(self.questionsBank.questions.count)")
        if index<0 || index>self.questionsBank.questions.count - 1 { //comprobamos que el índice recibido no esté fuera de rango y si lo está devolvemos nil
            return nil
        } else {
            //Si el índice está dentro del rago de elementos del array devolvermos el valor del elemento en esa posición que será un objeto de tipo Question
            return self.questionsBank.questions[index]
        }
    }
    
    //Esta función devolverá una pregunta aleatoria y no recibe ningún parámetro
    //Actualización: Se deja como referencia, se utilizó durante el desarrollo
    func getRandomQuestion () -> Question {
        //Creamos una constante local al que asignamos un valor aleatorio de tipo entero utilizando la función arc4random_.. y haciendo los casting necesarios ya que requiere de un tipo entero sin signo de 32bit (UInt32) y nuestro índice debe ser entero (Int)
        let index = Int(arc4random_uniform(UInt32(self.questionsBank.questions.count)))
        return self.questionsBank.questions[index]
    }
}
