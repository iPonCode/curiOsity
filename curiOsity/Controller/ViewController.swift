//
//  ViewController.swift
//  curiOsity
//
//  Created by superw on 10/12/2018.
//  Copyright © 2018 superw. All rights reserved.
//

//COMMENT TO INITIAL COMMIT :)

import UIKit

class ViewController: UIViewController {
    
    // MARK: - DEFINICION DE VARIABLES GLOBALES
    //aquí conectamos con la intrfaz los elementos que queremos modificar por código en tiempo de ejecución
    //la etiqueta con la pregunta va a ir cambiando
    @IBOutlet weak var labelQuestion: UILabel!
    //la etiqueta con el número de pregunta en la que estamos
    @IBOutlet weak var labelQuestionNumber: UILabel!
    //la etiqueta con la puntuación que actualizaremos con cada pregunta respondida
    @IBOutlet weak var labelScore: UILabel!
    //iremos modificando el tamaño de la vista con la barra de progreso a medida que avance el juego
    @IBOutlet weak var viewProgressBar: UIView!
    
    //estas son variable para el juego
    var currentScore = 0
    var currentQuestionID = 0
    var correctQuestionAnswered = 0
    
    var currentQuestion : Question! //la marcamos como requerida para no tener que hacer un constructor e inicializarla porque estamos seguros de que cuando arranque el juego directamente inicilizaré la primera pregunta
    let factory = QuestionsFactory()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startGame() //comenzo el juego
    }
    
    // MARK: - FUNCIONES DEL JUEGO
    
    func startGame() {
        //inicializamos variables de juego
        currentScore = 0
        currentQuestionID = 0
        correctQuestionAnswered = 0
        //antes de nada barajamos o mezclamos el array de preguntas para que cada juego se hagan preguntas en distinto orden, no siempre tendrás el mismo orden las preguntas, en cada partida el orden cambiará
        self.factory.questionsBank.questions.shuffle()
        //genero la primera pregunta
        askNextQuestion()
        //llamamos a updateUIElement para poner a cero las etiquetas
        updateUIElements()
    }
    
    func askNextQuestion () {
        //si me ha dejado crear newQuestion es que todavía quedan preguntas por hacer
        if let newQuestion = factory.getQuestionAt(index: currentQuestionID){
            self.currentQuestion = newQuestion
            self.labelQuestion.text = currentQuestion.questionText //mostramos la pregunta en la etiqueta correspondiente
            self.currentQuestionID += 1 //incrementamos el contador de preguntas
        } else { //si no me ha dejado crear una nueva pregunta
            //si newQuestion es nil entrará aquí y quiere decir que ya se han hecho todas las preguntas
            //así que sería Fin del Juego, habría que llamar a la función GameOver
            GameOver()
        }
    }
    
    func GameOver() {
        //se llama cuando no hay mas preguntas
        //ALERTA
        let alert = UIAlertController(title: "Fin de partida", message: "Has acertado \(self.correctQuestionAnswered) de \(self.currentQuestionID). Inténtalo de nuevo", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Vale", style: .default) { (_) in
            self.startGame()
        }
        alert.addAction(okAction) //vinculamos la alerta con la acción
        present(alert, animated: true, completion: nil) //mostramos el viewcontroller en pantalla
        
    }
    
    func updateUIElements() {
        //se actualizan las etiquetas y la barra de progreso
        self.labelScore.text = "Puntucación: \(self.currentScore)"
        self.labelQuestionNumber.text = "\(self.currentQuestionID)\\\(self.factory.questionsBank.questions.count)"
        
        /*
        //pregress bar: establecemos el ancho de la vista de la barra de progreso a lo siguiente:
        //primero dividimos el ancho total de la pantalla entre el número de preguntas que hay en el banco de preguntas
        //y luego lo multiplicamos por el numero de pregunta actual de tal forma que cuando la pregunta actual sea igual al número de preguntas total el ancho de la vista será igual al ancho de la pantalla
        //nota: recuerda que este ancho tiene una restricción muy fuerte en el storyboard que está definido en 30 puntos, por eso no funciona.
        self.viewProgressBar.frame.size.width = (self.view.frame.size.width/CGFloat(self.factory.questionsBank.questions.count))*CGFloat(self.currentQuestionID)
         */
        
        //Actualizació: modificamos el ancho de la vista barra de estado definiendo un identificador para su constraint width en el story board llamada y la llamamos progressBarWidth, así podemos acceder a esta constraint desde el código
        //recorremos las constraint de la vista hasta dar con la que queremos
        for c in self.viewProgressBar.constraints {
            if c.identifier == "progressBarWidth" {
                //ahora en lugar de modificar el ancho de todo el frame de la vista simplimente asigno un valor constante al constraints del ancho de la vista
                c.constant = (self.view.frame.size.width/CGFloat(self.factory.questionsBank.questions.count))*CGFloat(self.currentQuestionID)
            }
        }
    }

    // MARK: - BOTONES DE ACCIÓN
    //ya definimos en el inspector de atributos tag=1 para el botón verdadero y tag=2 para falso y a continuación creamos la acción invocable por cualquier botón UIButton. conectamos los dos botones a este método arrastrando con ctrl pulsado y soltando dentro de la función
    @IBAction func buttonPressed(_ sender: UIButton) {
        /*todo esto ya no es correcto, ya no se hace aquí. ahora cuando se pulsa alguno de los botones se hace otra cosa.
        // Generamos la batería de preguntas utlizando la factoría
        let factory = QuestionsFactory()
        // y le pedimos una pregunta aleatoria cualquiera
        let question = factory.getRandomQuestion()

        //como ya tenemos sobreescrita la variable description en la clase podemos hacer un print del objeto directamente y también
        //asignarle a la propiedad text del UILabel que espera un String la versión Stringuizada del objeto directamente
        print("_________________\n")
        print(question)
        
        
         //esto va a imprimir el objeto por consola (cuando no tenemos sobreescrita la variable description, tenemos que acceder a las propiedades del objeto para imprimir su valor
        print("_________________\n")
        print(question.questionText)
        print(question.answer)
        print(question.explanation)
        
        // escribimos la pregunta en el text de la etiqueta correspondiente para mostrarla en pantalla asignandole la versión stringuizazada del objeto
        // labelQuestion.text = "\(question)"

        // también podrímos pasar la versión stringuizada del objeto utilizando el casting a String con el constructor que tiene como parámetro String(describing: Subjet) de la siguiente forma, es decir, pasándole el objeto que tenga sobreescrita la variable computable description
        //labelQuestion.text = String(describing: question)
        
        //aunque todo lo anterior funciona pero ahora me interesa sólo mostrar la pregunta en la etiqueta y no la respuesta ni la explicación así que accederé directamete a la propiedad .text del objeto que es directamente de tipo String, así que no será necesario el casting
        labelQuestion.text = question.questionText
        */
        
        //cuando se pulsa cualquiera de los botones Verdad o Mentira se hace esto
        //comprobamos si la pregunta actual coincide o no con lo que ha contestado el jugador
        var isCorrect : Bool
        if sender.tag == 1 { //el jugados ha pulsado VERDAD (ya asignamos previamente en los atributos del botón el Verdad el tag = 1)
            isCorrect = (self.currentQuestion.answer == true) //si esta comparación es verdadera (true) entonces que se la respuesta correcta era true y el usuario pulsó Verdad y si es falsa (false) entonces es que la respuesta era false y el usaurio pulsó Mentira
        } else { //el jugador ha pulsado MENTIRA (ya asignamos previamente en los atributos del botón el Verdad el tag = 2)
            isCorrect = (self.currentQuestion.answer == false) //si esta comparación es verdadera (true) entonces que se la respuesta correcta era false y el usuario pulsó Mentira y si es falsa (false) entonces es que la respuesta era true y el usaurio pulsó Verdad
        }
        
        //esto es para la alerta que mostraremos más abajo
        var tituloAlerta = "Ohoo.. has fallado" //inicializamos por defecto el título de la alarta como si hubiera fallado y luego comprobamos si ha acertado sobreescribimos el valor del título por el mensaje cuando ha acertado

        //ahora comprobamos si el usuario ha contestado correctamente
        if (isCorrect) { // HA ACERTADO
            self.correctQuestionAnswered += 1 //incrementamos el valor de la propiedad que lleva la cuenta del número de preguntas acertadas
            tituloAlerta = "Enhorabuena, has acertado!"
            self.currentScore += 100*self.correctQuestionAnswered //si la respuesta es correcta sumamos puntos al Score del usuario, cuantas más preguntas correctas haya acertado más puntos conseguirá
        }
        
        //ALERTA
        let alert = UIAlertController(title: tituloAlerta, message: self.currentQuestion.explanation, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Vale", style: .default) {(_) in
            //en el completion handler del botón de la alerta metemos la llamada a la función askNextQuestion siendo necesario hacerlo de forma explícita con la palabra reservada self.
            //independientemente de si acierta o falla
            self.askNextQuestion() //generamos la siguiente pregunta
            self.updateUIElements() //actualizamo la info de las etiquetas
        }
        alert.addAction(okAction) //vinculamos la alerta con el botón
        present(alert, animated: true, completion: nil) //mostramos el viewcontroller por pantalla invocando al metodo present
        

    }
    
    // MARK: - BARRA DE ESTADO DE LA APLICACIÓN
    //si definimos en info.plist la clave "View controller-based status bar appearance" con valor "YES" podremos modificar por código el stilo de la barra de estado (Status bar style)
    //por otro lado, en la pestaña general de los ajustes del proyecto podemos definir Status Bar Style en Light y Hide Status Bar deseleccionado para que durante la carga inicial de la aplicación (launch screen tiene definido un fondo negro) se muestre también la barra de stado con tonos claros, así se verá mejor durante la carga
    
    //variable autocomputada con la que podemos sobreescribir el stilo de barra de estado queremos (default o lightContent)
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent //en la aplicación Main Story board tenemos un fondo oscuro y nos interesa mostrar la barra de estado con colores claros para que se vea
    }
    
    //variable autocomputada con la que podemos sobreescribir la preferencia de si se muestra o no la barra de estado devolviendo verdadero para ocultarla o falso para mostrarla
    /*override var prefersStatusBarHidden: Bool{
        return true //esto escondería la barra de estado
    }*/
}

