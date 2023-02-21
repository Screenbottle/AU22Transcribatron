//
//  Team.swift
//  AU22Transcribatron
//
//  Created by Arvid Rydh on 2023-02-21.
//

import SwiftUI

class Team: ObservableObject, Identifiable {
    
    let id = UUID()
    let teamName: String
    let teamOwner: String
    let members: [String]
    let memberCount: Int
    
    init(teamName: String, teamOwner: String, members: [String], memberCount: Int) {
        self.teamName = teamName
        self.teamOwner = teamOwner
        self.members = members
        self.memberCount = memberCount
    }
}
