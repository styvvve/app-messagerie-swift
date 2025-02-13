//
//  onBoardingView.swift
//  messenger
//
//  Created by NGUELE Steve  on 08/02/2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

enum OnBoardingPage: Int, CaseIterable {
    case getNameAndSurname
    case getProfilePicture
    
    var title: String {
        switch self {
        case .getNameAndSurname:
            return "Tell us about yourself 👨🏾‍🦲"
        case .getProfilePicture:
            return "Show us your best smile 😁"
        }
    }
}

struct onBoardingView: View {
    
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    //infos qu'on va recuperer
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var profilePicture: UIImage? = nil
    
    //a la fin redirection vers la page principale
    @State private var isLogin = false
    
    @Binding var navigationPath: NavigationPath
    
    //on va sauvegarder dans le modèle de User
    @ObservedObject private var newUser = UserModel(firstName: "", lastname: "", profilePicture: nil, contacts: [])
    
    //instance de repo
    let firebaseRepo = FirebaseRepository()
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(OnBoardingPage.allCases, id: \.rawValue) { page in
                    getPageView(for: page)
                        .tag(page.rawValue)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.spring(), value: currentPage)
            
            HStack(spacing: 12) {
                ForEach(0..<OnBoardingPage.allCases.count, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? .accent : Color.gray.opacity(0.5))
                        .frame(width: currentPage == index ? 12 : 8, height: currentPage == index ? 12 : 8)
                        .animation(.spring(), value: currentPage)
                }
            }
            
            continueButton
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                withAnimation {
                    isAnimating = true
                }
            })
        }
        .fullScreenCover(isPresented: $isLogin) {
            HomeView()
        }
    }
    
    // MARK: Private subviews
    
    private var continueButton: some View {
        Button {
            withAnimation {
                if currentPage < OnBoardingPage.allCases.count - 1 {
                    currentPage += 1
                    
                    //reinitialise l'animation
                    isAnimating = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        withAnimation {
                            isAnimating = true
                        }
                    })
                }else {
                    //le processus est termine
                    isLogin = true
                    navigationPath.removeLast()
                }
            }
        }label: {
            Text(currentPage < OnBoardingPage.allCases.count - 1 ? "Continue" : "Get started")
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(gradient: Gradient(colors: [
                        Color.accent,
                        Color.accent.opacity(0.8)
                    ]), startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(Capsule())
                .shadow(color: Color.purple.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding()
        .padding(.bottom, 30)
    }
    
    // MARK: Private methods
    //sauvegarde des infos dans le modèle et passage de la fonction pour enregistrer dans Firebase
    private func saveUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        newUser.id = uid
        newUser.firstName = firstName
        newUser.lastname = lastName
        newUser.profilePicture = profilePicture
        
        //enregistrement dans firebase
        firebaseRepo.saveUserData(user: newUser)
    }
    @ViewBuilder //permet q'une fonction puisse renvoyer plusieurs vues sans stack
    private func getPageView(for page: OnBoardingPage) -> some View {
        VStack(spacing: 16) {
            Text(page.title)
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
                .foregroundStyle(.accent)
                .padding(.vertical)
                .multilineTextAlignment(.center)
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 20)
                .animation(.spring(dampingFraction: 0.8).delay(0.3), value: isAnimating)
            
            if page == .getNameAndSurname {
                GetNameAndSurnameView(firstName: $firstName, lastName: $lastName)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.spring(dampingFraction: 0.8).delay(0.3), value: isAnimating)
            }else {
                GetProfilePictureView(profilePicture: $profilePicture)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.spring(dampingFraction: 0.8).delay(0.3), value: isAnimating)
            }
        }
        .padding()
    }
}


#Preview {
    onBoardingView(navigationPath: .constant(NavigationPath()))
}
