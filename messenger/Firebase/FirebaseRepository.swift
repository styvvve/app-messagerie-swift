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
    
    //MARK: la reference qu'on va utiliser dans les codes à suivre
    let reference = Database.database(url: "https://messenger-2fdfb-default-rtdb.europe-west1.firebasedatabase.app").reference()
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
    
    func createConversation(userA: UserModel, userB: UserModel, completion: @escaping (String) -> Void) {
        let conversationId = UUID().uuidString
        let conversationData: [String:Any] = [
            "id": conversationId,
            "userAId": userA.id,
            "userBId": userB.id,
            "lastMessageTimestamp": Date().timeIntervalSince1970
        ]
        
        reference.child("conversations").child(conversationId).setValue(conversationData) { error, _ in
            if let error = error {
                //une erreur jsp ce que j'en fais
                print("\(error.localizedDescription)")
            }else {
                completion(conversationId)
            }
        }
    }
    
    func sendMessage(conversationId: String, sender: UserModel, text: String) {
        let messageId = UUID().uuidString
        let messageData: [String:Any] = [
            "id": messageId,
            "senderId": sender.id,
            "text": text,
            "timestamp": Date().timeIntervalSince1970,
            "delivranceState": "sending"
        ]
        
        reference.child("messages").child(conversationId).child(messageId).setValue(messageData) { error, _ in
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
            }else {
                self.reference.child("messages").child(conversationId).child(messageId).updateChildValues(["delivranceState": "sent"])
                
                self.reference.child("conversations").child(conversationId).updateChildValues(["lastMessageTimestamp": Date().timeIntervalSince1970])
            }
        }
    }
    
    //fonctions pour recuperer les messages
    func listenForMessages(conversationId: String, completion: @escaping ([MessageModel]) -> Void) {
        reference.child("messages").child(conversationId).observe(.value) { snapshot in
            var messages: [MessageModel] = []
            
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let data = snap.value as? [String: Any],
                    let senderId = data["senderId"] as? String,
                    let text = data["text"] as? String,
                    let timestamp = data["timestamp"] as? TimeInterval,
                   let delivranceStateRaw = data["delivranceState"] as? String {
                    let delivranceState: DelivranceState = {
                        switch delivranceStateRaw {
                        case "sending": return .sending
                        case "sent": return .sent
                        case "notTransmitted": return .notTransmitted
                        default: return .sent
                        }
                    }()
                    
                    let sender: Sender = senderId == conversationId ? .sender : .receiver
                    
                    let message = MessageModel(date: Date(timeIntervalSince1970: timestamp), whoSent: sender, text: text, delivranceState: delivranceState)
                    messages.append(message)
                }
            }
            
            messages.sort { $0.date < $1.date } //trier les messages
            completion(messages)
        }
    }
    
    //et enfin fonction pour recuperer les conversations d'un individu
    func getConversations(userId: String, completion: @escaping ([ConversationModel]) -> Void) {
        reference.child("conversations").observe(.value) { snapshot in
            var conversations: [ConversationModel] = []
            
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let data = snap.value as? [String: Any],
                    let id = data["id"] as? String,
                    let userAId = data["userAId"] as? String,
                    let userBId = data["userBId"] as? String,
                   let lastMessageTimestamp = data["lastMessageTimestamp"] as? TimeInterval {
                    if userAId == userId || userBId == userId {
                        let conversation = ConversationModel(id: id, userAid: userAId, userBid: userBId, lastMessageTimestamp: Date(timeIntervalSince1970: lastMessageTimestamp))
                        conversations.append(conversation)
                    }
                }
            }
            
            //on trie les conversations selon le dernier message envoyé
            conversations.sort { $0.lastMessageTimestamp! > $1.lastMessageTimestamp! }
            completion(conversations)
        }
    }
}
