//
//  MainView.swift
//  AU22Transcribatron
//
//  Created by Arvid Rydh on 2023-02-09.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    @EnvironmentObject private var firestoreManager: FirestoreManager
    
    @State private var selectedTab = 1
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            CalendarView()
                .environmentObject(authModel)
                .environmentObject(firestoreManager)
                .tabItem {
                    Image(systemName: "calendar.circle")
                    Text("Kalender")
                }
                .tag(0)
            
            ListView()
                .environmentObject(authModel)
                .environmentObject(firestoreManager)
                .tabItem {
                    Image(systemName: "house.circle")
                    Text("Start")
                }
                .tag(1)
            
            TestView()
                .environmentObject(authModel)
                .environmentObject(firestoreManager)
                .tabItem {
                    Image(systemName: "mic.circle")
                    Text("Inspelning")
                }
                .tag(2)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
