//
//  UserModel.swift
//  messenger
//
//  Created by NGUELE Steve  on 09/02/2025.
//

import Foundation
import SwiftUI

class UserModel: ObservableObject, Identifiable {
    @Published var id = UUID().uuidString
    @Published var firstName: String
    @Published var lastname: String
    @Published var profilePicture: UIImage?
    @Published var contacts: [UserModel]
    
    init(firstName: String, lastname: String, profilePicture: UIImage? = nil, contacts: [UserModel]) {
        self.firstName = firstName
        self.lastname = lastname
        self.profilePicture = profilePicture
        self.contacts = contacts
    }
}


//pour la preview
extension UserModel {
    static var sampleUsers: [UserModel] {
        let user1 = UserModel(firstName: "Alice", lastname: "Dupont", contacts: [])
        let user2 = UserModel(firstName: "Bob", lastname: "Martin", contacts: [])
        let user3 = UserModel(firstName: "Charlie", lastname: "Durand", contacts: [])
        let user4 = UserModel(firstName: "David", lastname: "Lemoine", contacts: [])
        let user5 = UserModel(firstName: "Emma", lastname: "Morel", contacts: [])
        
        user1.contacts = [user2, user3, user4, user5]
        user2.contacts = [user1, user3, user4, user5]
        user3.contacts = [user1, user2, user4, user5]
        user4.contacts = [user1, user2, user3, user5]
        user5.contacts = [user1, user2, user3, user4]
        
        return [user1, user2, user3, user4, user5]
    }
}
