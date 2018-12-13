//
//  Extensions.swift
//  piPiano
//
//  Created by superw on 07/12/2018.
//  Copyright © 2018 superw. All rights reserved.
//

//import Foundation
// El import que nos va a hacer falta es el de UIKit
import UIKit

// Creamos una clase diseñable de los UIButton
// Podría cambiar por código estas variables desde el ViewController pero hago esta extensión de UIButton aquí para luego poder configurar los botones desde el Interface Builder de xcode y me aparezcan en el StoryBoard y sea más fácil congigurar los botones
@IBDesignable extension UIButton {
    // creamos una varibale computada (propiedad de la clase)
    // como es computable tenemos que crear un getter y un setter para configurar
    @IBInspectable var borderWith : CGFloat{
        //creo un setter y un getter para una variable ficticia que me acabo de inventar que he llamado borderWith que identifico con una variable de la capa visible del botón (no es una variable del botón, sino de la capa adicional del botón)
        set{
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat {
        set{
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor : UIColor? {
        set{
            //como el color del borde es opcional, el set lo tenemos que hacer con un guard: intenta crear uiColor a partir del nuevo valor que han configurado al borderColor, sino puedes olvidaló.
            guard let uiColor = newValue else {return}
            //como está el guard, si llegamos a esta línea es que el borderColor existe, entonces lo asignamos
            layer.borderColor = uiColor.cgColor
        }
        get {
            //en el get estoy obligado a devolver algo, así que return nil
            guard let color = layer.borderColor else {return nil}
            //si he llegado a esta línea es que no he devuelto nil y devuelvo el valor asignado
            return UIColor(cgColor: color)
        }
    }
    
}

