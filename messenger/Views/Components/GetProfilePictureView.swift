//
//  GetProfilePictureView.swift
//  messenger
//
//  Created by NGUELE Steve  on 08/02/2025.
//

import SwiftUI
import PhotosUI

struct GetProfilePictureView: View {
    
    //pour prendre la photo avec la camera
    @State private var showCamera = false
    
    //l'image
    @Binding var profilePicture: UIImage?
    
    
    //pour la selectionner depuis la librarie
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    
    
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
                    showCamera = true
                }label: {
                    Text("Take a picture")
                        .bold()
                        .font(.system(size: 18))
                }
                Spacer()
                PhotosPicker("Add from library", selection: $pickerItem)
                    .bold()
                    .font(.system(size: 18))
            }
            .padding()
        }
        .sheet(isPresented: $showCamera, content: {
            CameraView { pickedImage in
                if let uiImage = pickedImage {
                    profilePicture = uiImage
                }
                showCamera = false 
            }
        })
        .onChange(of: pickerItem) {
            Task {
                self.selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
                if let uiImage = selectedImage?.toUIImage() {
                   //conversion réussie
                    profilePicture = uiImage
                }
            }
        }
    }
}

#Preview {
    GetProfilePictureView(profilePicture: .constant(nil))
}
