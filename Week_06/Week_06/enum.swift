//
//  enum.swift
//  Week_06
//
//  Created by Rehnuma Taskin on 18/03/2025.
//


//
//  NotesModel.swift
//  Week_06
//
//  Created by Rehnuma Taskin on 18/03/2025.
//

import Foundation
import SwiftUI

// Note categories enum
enum NoteCategory: String, Codable, CaseIterable {
    case personal
    case work
    case shopping
    case ideas
    case important
    
    var displayName: String {
        switch self {
        case .personal:
            return "Personal"
        case .work:
            return "Work"
        case .shopping:
            return "Shopping"
        case .ideas:
            return "Ideas"
        case .important:
            return "Important"
        }
    }
    
    var systemImage: String {
        switch self {
        case .personal:
            return "person.fill"
        case .work:
            return "briefcase.fill"
        case .shopping:
            return "cart.fill"
        case .ideas:
            return "lightbulb.fill"
        case .important:
            return "exclamationmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .personal:
            return .blue
        case .work:
            return .purple
        case .shopping:
            return .green
        case .ideas:
            return .orange
        case .important:
            return .red
        }
    }
}

// Note Model - Represents a single note
struct Note: Identifiable, Codable {
    var id = UUID()
    var text: String
    var timestamp = Date()
    var category: NoteCategory = .personal
    var isPinned: Bool = false
    
    init(text: String, category: NoteCategory = .personal, isPinned: Bool = false) {
        self.text = text
        self.category = category
        self.isPinned = isPinned
    }
}

// NotesManager - Manages a collection of notes
class NotesManager: ObservableObject, Codable {
    @Published var notes: [Note] = []
    
    // Custom encoding required because @Published properties don't automatically conform to Codable
    enum CodingKeys: String, CodingKey {
        case notes
    }
    
    // Encode notes data
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(notes, forKey: .notes)
    }
    
    // Initialize from decoded data
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        notes = try container.decode([Note].self, forKey: .notes)
    }
    
    // Default initializer
    init() {}
    
    // Sort notes with pinned first, then by date
    func sortedNotes() -> [Note] {
        return notes.sorted {
            if $0.isPinned && !$1.isPinned {
                return true
            } else if !$0.isPinned && $1.isPinned {
                return false
            } else {
                return $0.timestamp > $1.timestamp
            }
        }
    }
}