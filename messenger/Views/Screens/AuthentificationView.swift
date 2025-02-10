//
//  AuthenficationView.swift
//  messenger
//
//  Created by NGUELE Steve  on 08/02/2025.
//

import SwiftUI
import FirebaseAuth

enum AuthMode {
    case signUp
    case logIn
}

struct AuthentificationView: View {
    
    @State private var authMode: AuthMode = .signUp
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirmation = ""
    @State private var firebaseDialog =  FirebaseDialog()
    
    //instance de repos firebase
    let firebaseRepo = FirebaseRepository()
    
    //différentes navigations selon le cas signup ou login
    //navigationPath() pour signup pour d'abord rediriger vers l'écran d'onBoarding
    //directement fullScreen pour l'écran de login
    @State private var navigationPath = NavigationPath()
    @State private var isLogin: Bool = false
    
    var body: some View {
        NavigationStack(path: $navigationPath){
            VStack(spacing: 16) {
                
                greetings
                    .padding()
                
                authFields
                
                confirmationButton
                
                feedbackMessage
                
                switchButton
            }
            .padding()
            .navigationDestination(for: String.self) { value in
                if value == "onboarding" {
                    onBoardingView(navigationPath: $navigationPath)
                }
            }
        }
        .fullScreenCover(isPresented: $isLogin) {
            HomeView()
        }
    }
    
    // MARK: - Private subviews
    
    private var authFields: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(PersonalizedTextFieldStyle(icon: Image(systemName: "at"), erreur: false))
            
            SecureField("Password", text: $password)
                .textFieldStyle(PersonalizedTextFieldStyle(icon: Image(systemName: "lock"), erreur: firebaseDialog.success ? false : true))
            
            if authMode == .signUp {
                SecureField("Password confirmation", text: $passwordConfirmation)
                    .textFieldStyle(PersonalizedTextFieldStyle(icon: Image(systemName: "lock"), erreur: firebaseDialog.success ? false : true))
            }
        }
    }
    
    private var confirmationButton: some View {
        VStack {
            Button {
                Task {
                    switch self.authMode {
                    case .logIn:
                        await logIn()
                        //si reussite on se connecte directement
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            isLogin = true
                        })
                    case .signUp:
                        await signUp()
                        //si reussite on part vers l'onBoarding
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            navigationPath.append("onboarding")
                        })
                    }
                }
            }label: {
                Text(authMode == .logIn ? "Log In" : "Sign Up")
                    .bold()
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .clipShape(RoundedRectangle(cornerRadius: 50))
        }
    }
    
    private var feedbackMessage: some View {
        Text(firebaseDialog.message)
            .foregroundStyle(firebaseDialog.success ? .green : .red)
    }
    
    private var switchButton: some View {
        Button {
            switch authMode {
            case .logIn:
                self.authMode = .signUp
            case .signUp:
                self.authMode = .logIn
            }
        }label: {
            switch authMode {
            case .logIn:
                Text("Don't have an account ? Sign Up")
            case .signUp:
                Text("Already have an account ? Log In")
            }
        }
    }
    
    private var greetings: some View {
        switch authMode {
        case .logIn:
            Text("Glad to see you again 😊")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(.accent)
        case .signUp:
            Text("Connect to the world 🌍")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(.accent)
        }
    }
    
    // MARK: Private methods
    
    private func fieldsAreNotEmpty() -> Bool {
        if email == "" || password == "" {
            return false
        }
        if authMode == .signUp && passwordConfirmation == "" {
            return false
        }
        return true
    }
    
    private func signUp() async {
        
        //teste d'abord si tous les champs sont remplies
        guard fieldsAreNotEmpty() else {
            firebaseDialog.success = false
            firebaseDialog.message = "All fields are required"
            return
        }
        
        guard password == passwordConfirmation else {
            firebaseDialog.success = false
            firebaseDialog.message = "Passwords must match"
            return
        }
        
        firebaseDialog = firebaseRepo.signUp(email: email, password: password)
        
    }
    
    private func logIn() async {
        
        guard fieldsAreNotEmpty() else {
            firebaseDialog.success = false
            firebaseDialog.message = "All fields are required"
            return
        }
        
        firebaseDialog = firebaseRepo.logIn(email: email, password: password)
    }
}

#Preview {
    AuthentificationView()
}
