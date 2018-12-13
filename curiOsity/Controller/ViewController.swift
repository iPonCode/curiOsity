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
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK: - BOTONES DE ACCIÓN
    //ya definimos en el inspector de atributos tag=1 para el botón verdadero y tag=2 para falso y a continuación creamos la acción invocable por cualquier botón UIButton. conectamos los dos botones a este método arrastrando con ctrl pulsado y soltando dentro de la función
    @IBAction func buttonPressed(_ sender: UIButton) {
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

