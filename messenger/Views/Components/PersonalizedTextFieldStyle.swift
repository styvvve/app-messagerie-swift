import Foundation
import SwiftUI

struct PersonalizedTextFieldStyle: TextFieldStyle {
    
    let icon: Image? //libre de ne pas mettre d'icones
    let erreur: Bool //pour colorer en rouge au cas une erreur survient
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            if icon != nil {
                icon
                    .foregroundStyle(Color(UIColor.systemGray4))
            }
            configuration
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 50, style: .continuous)
                .stroke(erreur ? Color.red : Color(UIColor.systemGray4), lineWidth: 2)
        }
    }
}


