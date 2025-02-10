//
//  GetNameAndSurnameView.swift
//  messenger
//
//  Created by NGUELE Steve  on 08/02/2025.
//

import SwiftUI

struct GetNameAndSurnameView: View {
    
    @Binding var firstName: String
    @Binding var lastName: String
    
    var body: some View {
        VStack {
            TextField("Your first name...", text: $firstName)
                .textFieldStyle(PersonalizedTextFieldStyle(icon: nil, erreur: false))
            TextField("Your last name...", text: $lastName)
                .textFieldStyle(PersonalizedTextFieldStyle(icon: nil, erreur: false))
        }
    }
}

#Preview {
    GetNameAndSurnameView(firstName: .constant(""), lastName: .constant(""))
}
