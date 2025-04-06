//
//  ContextModalView.swift
//  Immersive Bible App
//
//  Created by Miguelangelo Montemurro on 4/6/25.
//

import SwiftUI

// --- Data Structures (Copy from Step 1 if not in a separate file) ---
// struct ContextItem...
// struct ContextCategory...
// struct ChapterContext...
// ---------------------------------------------------------------------

struct ContextModalView: View {
    let contextData: ChapterContext
    @Binding var isPresented: Bool // To allow dismissing from within
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Header with Title and Close Button
                HStack {
                    Text(contextData.referenceTitle)
                        .font(.headline)
                        .padding(.leading)
                    
                    Spacer()
                    
                    Button {
                        withAnimation { isPresented = false }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing)
                }
                .padding(.vertical, 12)
                .background(.ultraThinMaterial) // Subtle header background
                
                Divider()
                
                // Scrollable Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        ForEach(contextData.categories) { category in
                            VStack(alignment: .leading, spacing: 8) {
                                // Category Header
                                HStack(spacing: 8) {
                                    Text(category.icon)
                                        .font(.title2)
                                    Text(category.title)
                                        .font(.title3.weight(.semibold))
                                }
                                
                                // Category Items
                                ForEach(category.items) {
                                    item in
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(item.name)
                                            .font(.headline.weight(.regular))
                                        Text(item.description)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.leading, 35) // Indent items under header
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            // Apply modal height and styling
            .frame(height: geometry.size.height) // Changed from 0.9 to 1.0 * height
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 10)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

// --- Preview Setup --- 
#Preview {
    // Need a wrapper to provide the binding
    struct PreviewWrapper: View {
        @State var showModal = true
        // sampleMatthew1Context is now globally available
        
        var body: some View {
            ZStack {
                Color.blue
                ContextModalView(contextData: sampleMatthew1Context, isPresented: $showModal)
            }
        }
    }
    return PreviewWrapper()
} 