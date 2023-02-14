//
//  StartView.swift
//  AU22Transcribatron
//
//  Created by Arvid Rydh on 2023-02-09.
//

import SwiftUI

struct StartView: View {
    
    @EnvironmentObject private var authModel: AuthViewModel
    @EnvironmentObject private var fireStoreManager: FirestoreManager
    
    var body: some View {
        Group {
        if authModel.user != nil {
        ContentView()
        } else {
        LoginView()
        }
        }.onAppear {
        authModel.listenToAuthState()
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
