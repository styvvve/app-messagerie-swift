//
//  CameraView.swift
//  messenger
//
//  Created by NGUELE Steve  on 12/02/2025.
//

import UIKit
import SwiftUI

struct CameraView: UIViewControllerRepresentable { //protocole qui cree un pont entre UIKit et SwiftUI
    //protocole qui passe deux methodes
    func makeUIViewController(context: Context) -> UIViewController {
        //pour creer l'interface
        let picker = UIImagePickerController() //objet UIKit pour la camera
        picker.sourceType = .camera //on specifie qu'on veut utiliser la camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: some UIViewController, context: Context) {
        //pour mettre a jour la vue
    }
    
    //creation d'un coordinateur pour gérer les evenements avec la camera
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var onImagePicked: (UIImage?) -> Void //complétion, fonction qui prend une image en optionnel
        
        init(onImagePicked: @escaping (UIImage?) -> Void) { //escaping indique c'est une complétion
            self.onImagePicked = onImagePicked
        }
        
        //fonction lorsqu'une photo est selectionnee
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as? UIImage
            onImagePicked(image)
            picker.dismiss(animated: true)
        }
        
        //fonction lorsque l'utilisateur quitte la camera
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            onImagePicked(nil)
            picker.dismiss(animated: true)
        }
    }
    
    //une fonction qui va se charger d'initialiser le coordinateur
    var onImagePicked: (UIImage?) -> Void //on recree la propriété ici car c'est elle qui nous permet de récup l'image de l'user
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(onImagePicked: onImagePicked)
    }
}
