//
//  ProfileView.swift
//  AU22Transcribatron
//
//  Created by Arvid Rydh on 2023-02-21.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject private var authModel: AuthViewModel
    @EnvironmentObject private var firestoreManager: FirestoreManager
    
    @State var teamName = ""
    @State var newTeamCreated = true
    
    var body: some View {
        VStack {
            Text("Skapa nytt team")
            TextField("Namn", text: $teamName)
            Button("Spara") {
                if let uid = authModel.user?.uid {
                    newTeamCreated = firestoreManager.createTeam(uid: uid, teamName: teamName)
                }
            }
            .border(newTeamCreated ? .black : .red)
            Text("Namnet är upptaget, försök igen")
                .font(.footnote)
                .opacity(newTeamCreated ? 0.0 : 1.0)
                .foregroundColor(.red)
            
            Spacer()
            
            Button("Logga ut") {
                authModel.signOut()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
