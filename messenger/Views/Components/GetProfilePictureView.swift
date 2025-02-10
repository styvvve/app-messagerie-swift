//
//  GetProfilePictureView.swift
//  messenger
//
//  Created by NGUELE Steve  on 08/02/2025.
//

import SwiftUI

struct GetProfilePictureView: View {
    
    @Binding var profilePicture: UIImage?
    
    var body: some View {
        VStack {
            if let profilePicture = profilePicture {
                Image(uiImage: profilePicture)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 200, height: 200)
            }else {
                Image("default-pp")
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 200, height: 200)
            }
            
            HStack {
                Button {
                    
                }label: {
                    Text("Take a picture")
                        .bold()
                        .font(.system(size: 18))
                }
                Spacer()
                Button {
                    
                }label: {
                    Text("Add from library")
                        .bold()
                        .font(.system(size: 18))
                }
            }
            .padding()
        }
    }
}

#Preview {
    GetProfilePictureView(profilePicture: .constant(nil))
}
