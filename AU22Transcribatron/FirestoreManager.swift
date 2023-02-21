//
//  FireStoreManager.swift
//  AU22Transcribatron
//
//  Created by Arvid Rydh on 2023-02-09.
//

import Foundation
import Firebase

class FirestoreManager: ObservableObject {

    @Published var transcriptions: [Transcription]?
    @Published var sharedTranscriptions: [TranscriptionRow]?
    @Published var dateSortedTranscriptions: [TranscriptionRow]?
    @Published var teams: [String]?
    
    func fetchTranscriptions(uid: String) {
        let db = Firestore.firestore()
        
        db.collection("users").document("\(uid)").collection("personal").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                
            } else {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "E, d MM, yyyy HH:mm"
                
                self.transcriptions = []
                for document in querySnapshot!.documents {

                    let data = document.data()
                    
                    let text = data["transcription"] as? String ?? ""
                    let startTime = data["startTime"] as? String ?? ""
                    let endTime = data["endTime"] as? String ?? ""
                    let duration = data["duration"] as? String ?? ""
                    let dayMonthYear = data["dayMonthYear"] as? String ?? ""
                    
                    let fullDateString = dayMonthYear + " " + startTime
                    
                    if let date = dateFormatter.date(from: fullDateString) {
                        
                        let transcription = Transcription(transcription: text, startTime: startTime, endTime: endTime, duration: duration, dayMonthYear: dayMonthYear, date: date)
                        
                        self.transcriptions?.append(transcription)
                    }
                }
                
                self.sortByDate()
            }
        }
    }
    
    func fetchSharedTranscriptions(uid: String) {
        fetchTeams(uid: uid)
        
        if let teams = self.teams {
            if !teams.isEmpty {
                self.sharedTranscriptions = []
                
                let db = Firestore.firestore()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "E, d MM, yyyy HH:mm"
                
                for team in teams {
                    db.collection("teams").document(team).collection("transcriptions").getDocuments() {
                        (querySnapshot, error) in
                            if let error = error {
                                print("Error getting documents: \(error.localizedDescription)")
                                
                            } else {
                                
                                let row = TranscriptionRow()
                                row.teamName = team
                                
                                for document in querySnapshot!.documents {

                                    let data = document.data()
                                    
                                    let text = data["transcription"] as? String ?? ""
                                    let startTime = data["startTime"] as? String ?? ""
                                    let endTime = data["endTime"] as? String ?? ""
                                    let duration = data["duration"] as? String ?? ""
                                    let dayMonthYear = data["dayMonthYear"] as? String ?? ""
                                    
                                    let fullDateString = dayMonthYear + " " + startTime
                                    
                                    if let date = dateFormatter.date(from: fullDateString) {
                                        
                                        let transcription = Transcription(transcription: text, startTime: startTime, endTime: endTime, duration: duration, dayMonthYear: dayMonthYear, date: date)
                                        
                                        row.row.append(transcription)
                                    }
                                }
                                self.sharedTranscriptions?.append(row)
                            }
                    }
                }
            }
        }
    }
    
    func updateTranscription(uid: String, name: String, editedText: String) {
        let db = Firestore.firestore()
        
        let docRef = db.collection("users").document(uid).collection("personal").document(name)
        
        docRef.updateData(["transcription": editedText]) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
            }
            else {
                print("Document successfully updated!")
            }
        }
    }
    
    func uploadTranscription(uid: String, name: String, transcription: Transcription) {
        let db = Firestore.firestore()
        let docData: [String:Any] = ["transcription": transcription.transcription, "startTime": transcription.startTime, "endTime": transcription.endTime, "duration": transcription.duration, "dayMonthYear": transcription.dayMonthYear]
        
        let docRef = db.collection("users").document(uid).collection("personal").document(name)
        
        docRef.setData(docData) { error in
            if let error = error {
                print("Error writing data: \(error.localizedDescription)")
            }
            else {
                print("Data successfully written")
            }
        }
    }
    
    func uploadSharedTranscription(uid: String, teamName: String, name: String, transcription: Transcription) {
        if isMemberOfTeam(uid: uid, teamName: teamName) {
            let db = Firestore.firestore()
            let docData: [String:Any] = ["transcription": transcription.transcription, "startTime": transcription.startTime, "endTime": transcription.endTime, "duration": transcription.duration, "dayMonthYear": transcription.dayMonthYear, "uploader": uid]
            
            let docRef = db.collection("teams").document(teamName).collection("transcriptions").document(name)
            
            docRef.setData(docData) { error in
                if let error = error {
                    print("Error writing data: \(error.localizedDescription)")
                }
                else {
                    print("Data successfully written")
                }
            }
        }
    }
    
    func createTeam(uid: String, teamName: String) -> Bool {
        if teamName.isEmpty {
            return false
        }
        else if teamNameTaken(teamName: teamName) {
            return false
        }
        else {
            let db = Firestore.firestore()
            
            let userDocRef = db.collection("users").document(uid).collection("teams").document(teamName)
            let teamDocRef = db.collection("teams").document(teamName)
            let memberDocRef = db.collection("teams").document(teamName).collection("members").document(uid)
            
            let teamDocData: [String: Any] = ["teamName": teamName, "teamOwner": uid, "members": 1]
            
            let memberDocData: [String: Any] = ["uid": uid]
            
            userDocRef.setData(teamDocData) { error in
                if let error = error {
                    print("Error writing data: \(error.localizedDescription)")
                }
                else {
                    print("Data successfully written")
                }
            }
            
            teamDocRef.setData(teamDocData) { error in
                if let error = error {
                    print("Error writing data: \(error.localizedDescription)")
                }
                else {
                    print("Data successfully written")
                }
            }
            
            memberDocRef.setData(memberDocData) { error in
                if let error = error {
                    print("Error writing data: \(error.localizedDescription)")
                }
                else {
                    print("Data successfully written")
                }
            }
            
            return true
        }
    }
    
    func joinTeam(uid: String, teamName: String) -> Bool{
        if teamNameTaken(teamName: teamName) {
            return false
        }
        else {
            let db = Firestore.firestore()
            
            let userDocRef = db.collection("users").document(uid).collection("teams").document(teamName)

            let memberDocRef = db.collection("teams").document(teamName).collection("members").document(uid)
            
            let userDocData: [String: Any] = ["teamName": teamName]
            let memberDocData: [String: Any] = ["uid": uid]
            
            userDocRef.setData(userDocData) { error in
                if let error = error {
                    print("Error writing data: \(error.localizedDescription)")
                }
                else {
                    print("Data successfully written")
                }
            }
            
            memberDocRef.setData(memberDocData) { error in
                if let error = error {
                    print("Error writing data: \(error.localizedDescription)")
                }
                else {
                    print("Data successfully written")
                }
            }
            
            return true
        }
    }
    
    func fetchTeams(uid: String) {
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).collection("teams").getDocuments() {
            (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                
            } else {
                
                self.teams = []
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    
                    let teamName = data["teamName"] as? String ?? ""
                    
                    if !teamName.isEmpty {
                        self.teams?.append(teamName)
                    }
                    
                }
            }
        }
    }
    
    func teamNameTaken(teamName: String) -> Bool {
        let db = Firestore.firestore()
        var result = false
        db.collection("teams").getDocuments() {
            (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                
            } else {
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    
                    let name = data["teamName"] as? String ?? ""
                    
                    if name == teamName {
                        result = true
                    }
                }
            }
        }
        
        return result
    }
    
    func isMemberOfTeam(uid: String, teamName: String) -> Bool {
        let db = Firestore.firestore()
        var result = false
        
        db.collection("teams").document(teamName).collection("members").getDocuments() {
            (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                
            } else {
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    
                    let memberUID = data["uid"] as? String ?? ""
                    
                    if memberUID == uid {
                        result = true
                    }
                }
            }
        }
        
        return result
    }
    
    func sortByDate() {
        if let transcriptions = self.transcriptions {
            
            self.dateSortedTranscriptions = []
            
            var row = TranscriptionRow()
            
            for transcription in transcriptions {
                if transcription.dayMonthYear == row.row.last?.dayMonthYear || row.row.isEmpty {
                    row.row.append(transcription)
                    
                    print(row.row as Any)
                }
                else {
                    self.dateSortedTranscriptions?.append(row)
                    row = TranscriptionRow()
                    row.row.append(transcription)
                    
                    
                }
            }
            
            self.dateSortedTranscriptions?.append(row)
        }
        
    }
    
}
