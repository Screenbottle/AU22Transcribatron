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
        ZStack {
            Rectangle()
                .fill(Color("Background"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
            VStack {
                Image("icon")
                    .resizable()
                    .scaledToFit()
                
                Spacer()
                
                Text("Transcribatron")
                    .font(.largeTitle)
                
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                    .backgroundStyle(.white)
                    .border(.gray)
                SecureField("Password", text: $password)
                    .textContentType(.password)
                    .keyboardType(.default)
                    .backgroundStyle(.white)
                    .border(.gray)
                    Button(action: { authModel.signIn(email: email, password: password) }) {
                    Text("Sign in")
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.automatic)
                
                Button(action: { authModel.signUp( email: email, password: password) }) {
                    Text("Sign up")
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.automatic)
                
                Spacer()
            }
            .padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
