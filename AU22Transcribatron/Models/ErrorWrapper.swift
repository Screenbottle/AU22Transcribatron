//
//  ErrorWrapper.swift
//  AU22Transcribatron
//
//  Created by Arvid Rydh on 2023-01-26.
//

/*
See LICENSE folder for this sample’s licensing information.
*/

import Foundation

struct ErrorWrapper: Identifiable {
    let id: UUID
    let error: Error
    let guidance: String

    init(id: UUID = UUID(), error: Error, guidance: String) {
        self.id = id
        self.error = error
        self.guidance = guidance
    }
}
