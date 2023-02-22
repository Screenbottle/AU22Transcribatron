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
    
    @State var joinTeamName = ""
    @State var teamJoined = true
    
    var body: some View {
        Form {
            Section(header: Text("Skapa nytt team")) {
                TextField("Namn", text: $teamName)
                Button("Spara") {
                    if let uid = authModel.user?.uid {
                        newTeamCreated = firestoreManager.createTeam(uid: uid, teamName: teamName)
                    }
                }
                .buttonStyle(.bordered)
                .border(newTeamCreated ? .gray : .red)
                .buttonBorderShape(.roundedRectangle)
                Text("Namnet är upptaget, försök igen")
                    .font(.footnote)
                    .opacity(newTeamCreated ? 0.0 : 1.0)
                    .foregroundColor(.red)
            }
            
            Section(header: Text("Gå med i ett team")) {
                TextField("Namn", text: $joinTeamName)
                Button("Bekräfta") {
                    if let uid = authModel.user?.uid {
                        teamJoined = firestoreManager.joinTeam(uid: uid, teamName: joinTeamName)
                    }
                }
                .buttonStyle(.bordered)
                .border(teamJoined ? .gray : .red)
                .buttonBorderShape(.roundedRectangle)
                
                Text("Det finns inget team med det namnet, försök igen")
                    .font(.footnote)
                    .opacity(teamJoined ? 0.0 : 1.0)
                    .foregroundColor(.red)
            }
            
            Section {
                Button("Logga ut") {
                    authModel.signOut()
                }
            }
        }
        .backgroundStyle(Color("Background"))
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
