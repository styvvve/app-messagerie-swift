//
//  UserModel.swift
//  messenger
//
//  Created by NGUELE Steve  on 09/02/2025.
//

import Foundation
import SwiftUI

class UserModel: ObservableObject {
    @Published var id: String
    @Published var firstName: String
    @Published var lastname: String
    @Published var profilePicture: UIImage?
    @Published var contacts: [UserModel]
    
    init(id: String, firstName: String, lastname: String, profilePicture: UIImage? = nil, contacts: [UserModel]) {
        self.id = id
        self.firstName = firstName
        self.lastname = lastname
        self.profilePicture = profilePicture
        self.contacts = contacts
    }
}
