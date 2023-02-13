//
//  TrailingIconLabelStyle.swift
//  AU22Transcribatron
//
//  Created by Arvid Rydh on 2023-01-26.
//
/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI

struct TrailingIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}

extension LabelStyle where Self == TrailingIconLabelStyle {
    static var trailingIcon: Self { Self() }
}
