//
//  LoginView.swift
//  AU22Transcribatron
//
//  Created by Arvid Rydh on 2023-02-09.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    

    var body: some View {
        VStack {
            TextField("Email", text: $email)
            .textContentType(.emailAddress)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .keyboardType(.emailAddress)
            SecureField("Password", text: $password)
            .textContentType(.password)
            .keyboardType(.default)
            Button(action: { authModel.signIn(email: email, password: password) }) {
                Text("Sign in")
            }
            Button(action: { authModel.signUp( email: email, password: password) }) {
                Text("Sign up")
                
            }
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
