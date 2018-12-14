//
//  QuestionsFactory.swift
//  curiOsity
//
//  Created by superw on 13/12/2018.
//  Copyright © 2018 superw. All rights reserved.
//

import Foundation

// FACTORÍA DE PREGUNTAS

// esta clase de la factoría no hereda.

class QuestionsFactory {
    
    // esta variable será la lista de las preguntas y lo voy a inicializar como un Array de Question vacío (clase definidad en Question.swift)
    //var questions = [Question]()
    //estas preguntas que inicialmente eran objetos de un array, ahora que usamos el protocolo Codable y hemos teneido que crear una estructura de modo que podemos sustituilo por una variable de tipo QuestionBank (que es una estructura, ya no es una clase) :
    var questionsBank : QuestionsBank! //esta variable la inicializaremos en el constructor Init() de la clase cuando carguemos las preguntas de un fichero plist y la tenemos que hacer requerida ! porque como la inicializamos dentro de un do-catch-error en el caso de que dé error no se incializaría
    
    // inicializador de la clase para arrancar la batería de preguntas, no tiene parámetros, no necesito parámetros porque será la propia clase que va a saber la lista de contenidos que hay que fabricar
    init() {
        /*
        //inicializamos el array de preguntas apendizandolas al final del mismo con el método append al que pasamos una instancia de tipo Question
        questions.append(Question(text: "El Vaticano tiene dinero suficiente como para acabar con la pobreza en el mundo", correctAnswer: true, explanationText: "En efecto, disponen de tanto dinero que podrían erradicar la pobreza mundial dos veces!"))
        questions.append(Question(text: "El caballito de mar es tan fiel a su pareja, que cuando uno muere, el otro también lo hace al poco tiempo", correctAnswer: true, explanationText: "Uno no puede vivir sin el otro"))
        questions.append(Question(text: "Los humanos son los únicos seres vivos que practican el sexo por placer", correctAnswer: false, explanationText: ""))
        questions.append(Question(text: "La semilla de la manzana contiene cianuro y es tóxica", correctAnswer: true, explanationText: "Se estima que unas 30-40 semillas podrían matarnos"))
        */
        
        // MARK: - PROCESADO MANUAL DEL FICHERO PLIST
        //ahora queremos dejar de hardcodear metiendo datos en el código que no es una práctica muy correcta y pasar a utilizar un archivo en disco con estos datos así que utilizaremos QuestionBank.plist que contiene un diccionario con todas las preguntas
        //vamos a procesar este archivo property list y transformarlo en un diccionario
        //dentro del método Init() tenemos que inicializar un path donde existe el fichero y asegurarnos de que existe
        //si se puede recuperar el path del fichero indicado entonces leemos el diccionario que resulta del fichero
        /*if let path = Bundle.main.path(forResource: "QuestionsBank", ofType: "plist") {
            //NSDictionary crea un diccionario de conveniencia, el término diccionario se refiere a cualquier instancia de una de estas clases sin especificar su membresía de clase exacta
            if let plist = NSDictionary(contentsOfFile: path){
                //lo metemos en un if para quitarno sel valor opcional que devuelve así si por lo que sea no lo puede devolver pues no se ejecutará la sentencia let.
                //ahora que sabemos que hemos podido recuperar ese diccionario con una sola clave llamada questions y que el objeto que resulta de las preguntas es un array
                //entonces podemos crear una constante
                let questionData = plist["Questions"] as! [AnyObject] //en este punto de la property list sacamos el primer nivel de objetos que estamos seguros que será un array de objetos
                print(questionData)
                
                //para cada pregunta del array de Questions lo que quiero es recuperar cada pregunta, respuesta y explicación
                for quest in questionData {
                    //si podemos recuperar las 3 entonces estamos en disposición de
                    if let text = quest["question"], let ans = quest["answer"], let expl = quest["explanation"] {
                        //crear la pregunta forzando un castion al tipo de dato que esperamos que tengan los parámetros ya que si hemos llegado hasta aquí se entiende que el fichero de datos tiene la estructura que esperamos
                        let q = Question(text: text as! String, correctAnswer: ans as! Bool, explanationText: expl as! String)
                        //y apendizarla al array, también se podría hacer en un solo paso sin utilizar la constate temporal q:
                        //questions.append(Question(text: text as! String, correctAnswer: ans as! Bool, explanationText: expl as! String))
                        questions.append(q) 
                    }
                    
                }
            }
        }*/
        
        // MARK: - PROCESADO AUTOMÁTICO DEL FICHERO PLIST UTLIZANDO EL PROTOCOLO CODABLE ENCODABLE/DECODABLE
        //Ahora vamos a leer los datos del fichero, no el contenido. Es decir, vamos a leer el dato como binario.
        //en lugar de cargar un path vamos a usar una url y tendremos que protegerlo con la clausula do catch y utlizar try en las llamadas porque pueden generar un error
        do {
            if let url = Bundle.main.url(forResource: "QuestionsBank", withExtension: "plist") {
            //aquí cargamos los datos en binario con un try delante
            let data = try Data(contentsOf: url) //si no tuvieramos esto dentro de un if let deberíamos pasar la url como un parámetro requerido con url! (por el error, podría fallar la extracción de datos binarios de un fichero porque el fichero esté corrupo, o porque esté protegido, etc..)
            //como es un binario, si imprimos en consola data devolverá el núemro de bytes que ocupa
            print(data) //esto imprime 2623 bytes con el fichero plist que se está utlizando en las pruebas
                
            //aquí tenemos que convertir el fichero data primero en un objeto (una estructura) que es el array QuestionsBank y automáticamente solo con procesarla como QuestionsBank voy a obetener un array de questions (porque estamos utilizando Codable
            //vamos directamente a intentar extraer un objeto questionsBank desde data, utlizaremos el PropertyListDecoder
            //como la descodificación puede dar error lo protegemos con un try
                self.questionsBank = try PropertyListDecoder().decode(QuestionsBank.self, from: data)
                //si esto ha funcionado entonces tendremos un campo llamado questions que son las preguntas que van a ir en la factoría
                //self.questions = questionBank.questions //cargamos las preguntas
                //Actualización: me cargo la línea anterior porque ahora trabajamos con la variable de tipo estructura QuestionsBank y no con la variable questions que era un array de objetos de tipo Question
            }
        } catch {
            print(error)
        }
        
        if self.questionsBank == nil { //si entra aquí la apilcación peta (por ejemplo, no encuentra o no existe archivo QuestionsBank.plist
            //justo antes del error en tiempo de ejecución imprimiríamos este mensaje por consola
            print(">>> NO SE HA PODIDO INICIALIZAR questionBank <<<")
        }

    }
    
    // esta función devolverá la pregunta que se encuentre en el índice que recibe y el índice está fuera de rango devuelve nil, por eso el parámetro de retorno Question? es opcional
    func getQuestionAt (index : Int) -> Question? {
        if index<0 || index>self.questionsBank.questions.count { //comprobamos que el índice recibido no esté fuera de rango y si lo está devolvemos nil
            return nil
        } else {
            // si el índice está dentro del rago de elementos del array devolvermos el valor del elemento en esa posición que será un objeto de tipo Question
            return self.questionsBank.questions[index]
        }
    }
    
    // esta función devolverá una pregunta aleatoria y no recibe ningún parámetro
    func getRandomQuestion () -> Question {
        // creamos una constante local al que asignamos un valor aleatorio de tipo entero utilizando la función arc4random_.. y haciendo los casting necesarios ya que requiere de un tipo entero sin signo de 32bit (UInt32) y nuestro índice debe ser entero (Int)
        let index = Int(arc4random_uniform(UInt32(self.questionsBank.questions.count)))
        return self.questionsBank.questions[index]
    }
}
