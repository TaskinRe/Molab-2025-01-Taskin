

import SwiftUI

struct ContentView: View {
    // State to store notes data
    @StateObject private var notesManager = NotesManager()
    // State for the new note being created
    @State private var newNoteText = ""
    @State private var searchText = ""
    @State private var showingAddNote = false
    @State private var selectedCategory: NoteCategory = .personal
    
    // Computed property for filtered notes
    private var filteredNotes: [Note] {
        if searchText.isEmpty {
            return notesManager.notes
        } else {
            return notesManager.notes.filter {
                $0.text.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // App header with logo and title
                HStack {
                    Image(systemName: "note.text")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                    
                    Text("NotesKeeper")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddNote.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search notes", text: $searchText)
                        .submitLabel(.search)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Notes list with section headers
                List {
                    ForEach(NoteCategory.allCases, id: \.self) { category in
                        Section(header: Text(category.displayName)) {
                            ForEach(filteredNotes.filter { $0.category == category }) { note in
                                NavigationLink(destination: NoteDetailView(note: note, onSave: updateNote)) {
                                    NoteRow(note: note)
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        if let index = notesManager.notes.firstIndex(where: { $0.id == note.id }) {
                                            notesManager.notes.remove(at: index)
                                            saveNotes()
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .sheet(isPresented: $showingAddNote) {
                AddNoteView(isPresented: $showingAddNote, notesManager: notesManager, saveNotes: saveNotes)
            }
            .navigationBarHidden(true)
            .onAppear {
                // Attempt to load saved notes when the view appears
                loadNotes()
            }
        }
    }
    
    // MARK: - Functions for managing notes
    
    // Update an existing note
    private func updateNote(updatedNote: Note) {
        if let index = notesManager.notes.firstIndex(where: { $0.id == updatedNote.id }) {
            notesManager.notes[index] = updatedNote
            saveNotes()
        }
    }
    
    // Save notes to persistent storage
    private func saveNotes() {
        do {
            try SaveLoadJSON.save(notesManager, to: "notes_data")
            print("Notes saved successfully")
        } catch {
            print("Error saving notes: \(error.localizedDescription)")
        }
    }
    
    // Load notes from persistent storage
    private func loadNotes() {
        do {
            let loadedNotesManager = try SaveLoadJSON.load(NotesManager.self, from: "notes_data")
            notesManager.notes = loadedNotesManager.notes
            print("Notes loaded successfully")
        } catch {
            print("Error loading notes or no saved notes found: \(error.localizedDescription)")
        }
    }
}

// MARK: - Supporting Views

// Individual note row in the list
struct NoteRow: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(note.text)
                    .font(.body)
                    .lineLimit(2)
                
                Spacer()
                
                Image(systemName: note.category.systemImage)
                    .foregroundColor(note.category.color)
            }
            
            HStack {
                Text(note.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                if note.isPinned {
                    Image(systemName: "pin.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                }
            }
        }
        .padding(.vertical, 5)
    }
}

// Add note view
struct AddNoteView: View {
    @Binding var isPresented: Bool
    @ObservedObject var notesManager: NotesManager
    var saveNotes: () -> Void
    
    @State private var noteText = ""
    @State private var selectedCategory: NoteCategory = .personal
    @State private var isPinned = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Note Content")) {
                    TextEditor(text: $noteText)
                        .frame(minHeight: 100)
                }
                
                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(NoteCategory.allCases, id: \.self) { category in
                            Label(
                                category.displayName,
                                systemImage: category.systemImage
                            )
                            .foregroundColor(category.color)
                            .tag(category)
                        }
                    }
                }
                
                Section {
                    Toggle("Pin Note", isOn: $isPinned)
                }
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if !noteText.isEmpty {
                            let newNote = Note(
                                text: noteText,
                                category: selectedCategory,
                                isPinned: isPinned
                            )
                            notesManager.notes.append(newNote)
                            saveNotes()
                            isPresented = false
                        }
                    }
                    .disabled(noteText.isEmpty)
                }
            }
        }
    }
}

// Note detail view
struct NoteDetailView: View {
    @State private var editedNote: Note
    let onSave: (Note) -> Void
    @State private var isEditing = false
    @Environment(\.presentationMode) var presentationMode
    
    init(note: Note, onSave: @escaping (Note) -> Void) {
        _editedNote = State(initialValue: note)
        self.onSave = onSave
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if isEditing {
                    TextEditor(text: $editedNote.text)
                        .frame(minHeight: 200)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    Picker("Category", selection: $editedNote.category) {
                        ForEach(NoteCategory.allCases, id: \.self) { category in
                            Label(
                                category.displayName,
                                systemImage: category.systemImage
                            )
                            .foregroundColor(category.color)
                            .tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    
                    Toggle("Pin Note", isOn: $editedNote.isPinned)
                        .padding(.horizontal)
                } else {
                    HStack {
                        Text(editedNote.text)
                            .padding()
                        
                        Spacer()
                    }
                    
                    HStack {
                        Label(
                            editedNote.category.displayName,
                            systemImage: editedNote.category.systemImage
                        )
                        .foregroundColor(editedNote.category.color)
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        if editedNote.isPinned {
                            Label("Pinned", systemImage: "pin.fill")
                                .foregroundColor(.yellow)
                                .padding(.horizontal)
                        }
                    }
                }
                
                Text("Created: \(editedNote.timestamp.formatted(date: .long, time: .shortened))")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
        }
        .navigationTitle(isEditing ? "Edit Note" : "Note Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Save" : "Edit") {
                    if isEditing {
                        onSave(editedNote)
                        isEditing = false
                    } else {
                        isEditing = true
                    }
                }
            }
        }
    }
}

// MARK: - Preview Provider for SwiftUI Canvas
#Preview {
    let notesManager = NotesManager()
    notesManager.notes = [
        Note(text: "Buy groceries for dinner", category: .shopping, isPinned: true),
        Note(text: "Finish SwiftUI homework", category: .work),
        Note(text: "Call mom on her birthday", category: .personal),
        Note(text: "App idea: Travel journal with photo integration", category: .ideas),
        Note(text: "Pay rent by Friday", category: .important)
    ]
    
    return ContentView()
}
#Preview {
    ContentView()
}
