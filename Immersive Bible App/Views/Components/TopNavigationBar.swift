//
//  TopNavigationBar.swift
//  Immersive Bible App
//
//  Created by Miguelangelo Montemurro on 4/4/25.
//

import SwiftUI

struct TopNavigationBar: View {
    @Binding var selectedTranslation: String
    let translations = ["KJV", "ESV", "NLT", "AMP"]
    
    var body: some View {
        HStack {
            Menu {
                ForEach(translations, id: \.self) { translation in
                    Button(translation) {
                        selectedTranslation = translation
                    }
                }
            } label: {
                HStack {
                    Text(selectedTranslation)
                        .font(.headline)
                    Image(systemName: "chevron.down")
                }
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "book")
                    .font(.system(size: 20))
            }
            .padding(.horizontal, 8)
            
            Button(action: {}) {
                Image(systemName: "textformat.size")
                    .font(.system(size: 20))
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .shadow(radius: 2)
    }
}

#Preview {
    TopNavigationBar(selectedTranslation: .constant("KJV"))
} 