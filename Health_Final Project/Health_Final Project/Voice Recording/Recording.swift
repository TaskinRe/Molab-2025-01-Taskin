//
//  Recording.swift
//  Health_Final Project
//
//  Created by Rehnuma Taskin on 15/04/2025.
//


import Foundation

struct Recording: Identifiable, Codable {
    let id: UUID
    var date: Date
    var filename: String
    var transcription: String

    static let example = Recording(id: UUID(), date: .now, filename: "example.m4a", transcription: "Example transcription here.")
}
