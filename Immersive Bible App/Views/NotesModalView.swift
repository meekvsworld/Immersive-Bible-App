//
//  NotesModalView.swift
//  Immersive Bible App
//
//  Created by Miguelangelo Montemurro on 4/6/25.
//

import SwiftUI

struct NotesModalView: View {
    // Data passed in
    let bookName: String
    let chapterNumber: Int // Assuming chapter 1 for now
    let selectedIndices: [Int] // Sorted indices
    let allVerses: [String] // Full text of the chapter
    
    @Binding var isPresented: Bool
    
    // State for notes (simple dictionary for demo)
    @State private var notes: [Int: String] = [:]
    
    // Focus state for text editors
    @FocusState private var focusedEditorIndex: Int?
    
    var body: some View {
        NavigationView { // Use NavigationView for easy title/buttons
            ScrollView { // Make the entire content scrollable
                LazyVStack(alignment: .leading, spacing: 0) { // Use LazyVStack
                    ForEach(selectedIndices, id: \.self) { index in
                        if index < allVerses.count {
                            let verseNumber = index + 1
                            let verseText = allVerses[index]
                            
                            VStack(alignment: .leading, spacing: 8) {
                                // Verse Text Display
                                Text("\(bookName) \(chapterNumber):\(verseNumber)")
                                    .font(.caption.weight(.semibold))
                                    .foregroundColor(.secondary)
                                Text(verseText)
                                    .font(.body) // Regular readable font
                                    
                                // Note Input Area
                                TextEditor(text: Binding(
                                    get: { notes[index] ?? "" },
                                    set: { notes[index] = $0 }
                                ))
                                .font(.custom("Menlo-Regular", size: 16))
                                .frame(minHeight: 80) // Give some initial height
                                .border(Color.gray.opacity(0.3)) // Subtle border
                                .padding(.bottom, 50) // Space below note area
                                .focused($focusedEditorIndex, equals: index)
                                .id(index) // ID for focus management
                            }
                            .padding(.vertical) // Padding around each verse/note block
                        }
                    }
                }
                .padding() // Padding for the overall VStack content
            }
            .navigationTitle("Notes for \(bookName) \(chapterNumber)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { // Add close button using toolbar
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { // Using Done instead of X for clarity
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    // Need a wrapper for the binding
    struct PreviewWrapper: View {
        @State var showModal = true
        // Sample data for preview
        let sampleIndices = [0, 1, 5]
        let book = "Matthew"
        let chapter = 1
        let verses = matthew1KJV // Use global sample
        
        var body: some View {
            NotesModalView(
                bookName: book,
                chapterNumber: chapter,
                selectedIndices: sampleIndices,
                allVerses: verses,
                isPresented: $showModal
            )
        }
    }
    return PreviewWrapper()
} 