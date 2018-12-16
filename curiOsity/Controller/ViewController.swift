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
    //iremos cambiando la imagen del logo y jugando con su transparencia según acierte o falle las preguntas el jugador
    @IBOutlet weak var imageViewLogoApp: UIImageView!
    
    
    //estas son variable para el juego, también se asignarán en StartGame()
    var currentScore : Int = 0
    var currentQuestionID : Int = 0
    var correctQuestionAnswered : Int = 0
    var QuicklyMode : Bool = false //esto es para pasárselo como parámetro :interaction a ProgressHUD
    
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
        //por defecto el usuario deberá esperar a que se muestre la alerta para poder responder la siguente pregunta
        QuicklyMode = true //si lo establecemos en true el juego es mas rápido ya que el usuario no tiene que esperar a que desaparezca la alerta (con ProgressHUD) para volver a pulsar el botón
 
        // ALERTA de inicio de partida (retirada porque no es necesaria y tapa por uno instantes el logo de la aplicación al inicio que es justo cuando interesa que se muestre para darle continuidad al logo del launch screen, se deja comentada.
        /*
        ProgressHUD.showSuccess("""
            \(NSLocalizedString("start.game.shuffle.questions", comment: "MessageWelcome"))
            """, interaction: QuicklyMode)
        */
        //Antes de nada barajamos o mezclamos el array de preguntas para que cada juego se hagan preguntas en distinto orden, no siempre tendrás el mismo orden las preguntas, en cada partida el orden cambiará
        self.factory.questionsBank.questions.shuffle()

        //Genero la primera pregunta
        askNextQuestion()

        //Llamamos a updateUIElement para poner a cero las etiquetas
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
            gameOver()
        }
    }
    
    func updateUIElements() {
        //se actualizan las etiquetas y la barra de progreso
        self.labelScore.text = "\(NSLocalizedString("label.score", comment: "LabelScore")): \(self.currentScore)"
        self.labelQuestionNumber.text = "\(self.currentQuestionID)\\\(self.factory.questionsBank.questions.count)"
        
        //Actualización: modificamos el ancho de la vista barra de estado definiendo un identificador para su constraint width en el story board llamada y la llamamos progressBarWidth, así podemos acceder a esta constraint desde el código
        //recorremos las constraint de la vista hasta dar con la que queremos
        for c in self.viewProgressBar.constraints {
            if c.identifier == "progressBarWidth" {
                //ahora en lugar de modificar el ancho de todo el frame de la vista simplimente asigno un valor constante al constraints del ancho de la vista
                c.constant = (self.view.frame.size.width/CGFloat(self.factory.questionsBank.questions.count))*CGFloat(self.currentQuestionID)
            }
        }
    }
    
    func analyzeResult (isCorrect : Bool) {
        
        //comprobamos si el usuario ha contestado correctamente
        if (isCorrect) { // EL JUGADOR HA ACERTADO
            
            self.correctQuestionAnswered += 1 //incrementamos el valor de la propiedad que lleva la cuenta del número de preguntas acertadas
            self.currentScore += 100*self.correctQuestionAnswered //si la respuesta es correcta sumamos puntos al Score del usuario, cuantas más preguntas correctas haya acertado más puntos conseguirá
 
            //imprimimos por consola el resultado
            print("""
                \(NSLocalizedString("analyze.result.isCorrect.true", comment: "MessageIsCorrectTrue"))
                \(self.currentQuestion.explanation)
                """)

            // ALERTA cuando ACIERTA "analyze.result.isCorrect.true"
            //mostramos alerta que desaparecerá en unos instantes, si el usuario pulsa algún botón y QucklyMode es true desaparece inmediatamente, si es false tendrá que esperar a que desaparezca para contestar a la siguiente pregunta
            ProgressHUD.showSuccess("""
                \(NSLocalizedString("analyze.result.isCorrect.true", comment: "MessageIsCorrectTrue"))
                \(self.currentQuestion.explanation)
                """, interaction: QuicklyMode)

        } else { // EL JUGADOR HA FALLADO

            //imprimimos por consola el resultado
            print("""
            \(NSLocalizedString("analyze.result.isCorrect.false", comment: "MessageIsCorrectFalse"))
            \(self.currentQuestion.explanation)
            """)
            
            // ALERTA cuando FALLA
            ProgressHUD.showError("""
                \(NSLocalizedString("analyze.result.isCorrect.false", comment: "MessageIsCorrectFalse"))
                \(self.currentQuestion.explanation)
                """, interaction: QuicklyMode)
        }
        
        //independientemente de si acierta o falla
        self.askNextQuestion() //generamos la siguiente pregunta
        self.updateUIElements() //actualizamo la info de las etiquetas
    }

    func gameOver() {
        //se llama cuando no hay mas preguntas, entonces el juego ha terminado
        //ALERTA de tipo ProgressHUD
        let alerta = UIAlertController(title: NSLocalizedString("game.over.alert.title", comment: "AlertTitle"), message: "\(NSLocalizedString("game.over.alert.message.1", comment: "Message1")) \(self.correctQuestionAnswered) \(NSLocalizedString("game.over.alert.message.2", comment: "Message2")) \(self.currentQuestionID) \(NSLocalizedString("game.over.alert.message.3", comment: "Message3")). \(NSLocalizedString("game.over.alert.message.4", comment: "Message4")) \(self.currentScore) \(NSLocalizedString("game.over.alert.message.5", comment: "Message5")).\n\(NSLocalizedString("game.over.alert.message.6", comment: "Message6"))", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("game.over.alert.button", comment: "ButtonTitle"), style: .default) { (_) in
            self.startGame()
        }
        
        alerta.addAction(okAction) //vinculamos la alerta con la acción
        present(alerta, animated: true, completion: nil) //mostramos el viewcontroller en pantalla
    }
    
    // MARK: - BOTONES DE ACCIÓN
    //ya definimos en el inspector de atributos tag=1 para el botón verdadero y tag=2 para falso y a continuación creamos la acción invocable por cualquier botón UIButton. conectamos los dos botones a este método arrastrando con ctrl pulsado y soltando dentro de la función
    @IBAction func buttonPressed(_ sender: UIButton) {
        //cuando se pulsa cualquiera de los botones Verdad o Mentira se hace esto
        //comprobamos si la pregunta actual coincide o no con lo que ha contestado el jugador
        var isCorrect : Bool
        if sender.tag == 1 { //el jugador ha pulsado VERDAD (ya asignamos previamente en los atributos del botón el Verdad el tag = 1)
            isCorrect = (self.currentQuestion.answer == true) //si esta comparación es verdadera (true) entonces que se la respuesta correcta era true y el usuario pulsó Verdad y si es falsa (false) entonces es que la respuesta era false y el usaurio pulsó Mentira
        } else { //el jugador NO ha pulsado VERDAD y asumimos que ha pulsado MENTIRA (ya asignamos previamente en los atributos del botón el Verdad el tag = 2)
            isCorrect = (self.currentQuestion.answer == false) //si esta comparación es verdadera (true) entonces que se la respuesta correcta era false y el usuario pulsó Mentira y si es falsa (false) entonces es que la respuesta era true y el usaurio pulsó Verdad
        }
        
        //Ahora que sabemos si ha acertado o no la pregunta, llamamos a analyzeResult pasándole isCorrect
        analyzeResult(isCorrect: isCorrect)
    }
    
    // MARK: - BARRA DE ESTADO DE LA APLICACIÓN
    //si definimos en info.plist la clave "View controller-based status bar appearance" con valor "YES" podremos modificar por código el stilo de la barra de estado (Status bar style)
    //por otro lado, en la pestaña general de los ajustes del proyecto podemos definir Status Bar Style en Light y Hide Status Bar deseleccionado para que durante la carga inicial de la aplicación (launch screen tiene definido un fondo negro) se muestre también la barra de stado con tonos claros, así se verá mejor durante la carga
    //variable autocomputada con la que podemos sobreescribir el stilo de barra de estado queremos (default o lightContent)
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent //en la aplicación Main Story board tenemos un fondo oscuro y nos interesa mostrar la barra de estado con colores claros para que se vea
    }
    
}

