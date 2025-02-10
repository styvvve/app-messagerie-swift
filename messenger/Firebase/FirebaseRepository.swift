//
//  FirebaseRepository.swift
//  messenger
//
//  Created by NGUELE Steve  on 08/02/2025.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

//creation d'une struct pour communiquer en cas de reussite ou echec d'operations avec Firebase

struct FirebaseDialog {
    var success: Bool = true
    var message: String = ""
}

//creation d'un enum d'erreur pour communiquer pour la sauvegarde de données
enum FirebaseImageError: Error {
    case invalidURL
    case imageUploadFailed
    case imageDownloadFailed
    case noData
    case unknownError
}

class FirebaseRepository {
    func signUp(email: String, password: String) -> FirebaseDialog {
        var dialog = FirebaseDialog(success: true, message: "")
        Task {
            do {
                let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
                dialog.message = "User \(authResult.user.email ?? " ") created successfully"
            }catch {
                dialog.message = error.localizedDescription
                dialog.success = false
            }
        }
        return dialog
    }
    
    func logIn(email: String, password: String) -> FirebaseDialog {
        var dialog = FirebaseDialog(success: true, message: "")
        Task {
            do {
                let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
                dialog.message = "Happy to see you \(authResult.user.email ?? "")"
            }catch {
                dialog.message = error.localizedDescription
                dialog.success = false
            }
        }
        return dialog
    }
    
    //méthode pour envoyer profilePicture dans le cloud
    func uploadProfilePicture(imageData: Data, userID: String, completion: @escaping (Result<URL, FirebaseImageError>) -> Void) {
        let storageRef = Storage.storage().reference()
        let profilePictureRef = storageRef.child("profile_pictures/\(userID).jpg")
        
        profilePictureRef.putData(imageData, metadata: nil) { metaData, error in
            if error != nil {
                completion(.failure(.imageUploadFailed))
                return
            }
            
            profilePictureRef.downloadURL { url, error in
                if error != nil {
                    completion(.failure(.unknownError))
                    return
                }
                
                guard let downloadURL = url else {
                    completion(.failure(.unknownError))
                    return
                }
                
                completion(.success(downloadURL))
            }
        }
    }
    
    func saveUserData(user: UserModel) {
        let reference = Database.database(url: "https://messenger-2fdfb-default-rtdb.europe-west1.firebasedatabase.app").reference()
        var dialog = FirebaseDialog(success: true, message: "")
        var profilePictureURL: URL?
        //pour l'image on la convertit d'abord en data
        if let image = user.profilePicture { //elle est pas nil
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                uploadProfilePicture(imageData: imageData, userID: user.id) { result in
                    switch result {
                    case .success(let url):
                        profilePictureURL = url
                    case .failure(let error):
                        switch error {
                        case .imageUploadFailed:
                            dialog.success = false
                            dialog.message = "Image download failed"
                        case .imageDownloadFailed:
                            dialog.success = false
                            dialog.message = "Image upload failed"
                        case .unknownError:
                            dialog.success = false
                            dialog.message = "An unknown error occurred"
                        case .noData:
                            break
                        case .invalidURL:
                            break
                        }
                    }
                }
            }
        }

        
        reference.child("users").child(user.id).setValue([
            "firstName": user.firstName,
            "lastName" : user.lastname,
            "profilePictureURL": profilePictureURL?.absoluteString ?? "",
            "contacts": [:]
        ])
    }
}
