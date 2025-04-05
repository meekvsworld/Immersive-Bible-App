//
//  BottomControls.swift (Settings Button)
//  Immersive Bible App
//
//  Created by Miguelangelo Montemurro on 4/4/25.
//

import SwiftUI

// MARK: - Settings Button View
struct SettingsButton: View {
    let size: CGFloat = 55
    let action: () -> Void // Action to perform on tap
    
    // Keep styling consistent for now
    let buttonColor: Color = .black 
    let iconColor: Color = .white
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(buttonColor)
                    .frame(width: size, height: size)
                    .shadow(color: .black.opacity(0.2), radius: 4, y: 4)
                
                Image(systemName: "gearshape.fill") // Gear icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: size * 0.5, height: size * 0.5) // Adjust scale if needed
                    .foregroundColor(iconColor)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Main Bottom Controls View (Now wraps SettingsButton)
struct BottomControls: View {
    let settingsAction: () -> Void // Pass action from parent
    
    var body: some View {
        SettingsButton(action: settingsAction)
        // Positioning handled by parent
    }
}

// Preview needs adjustment
#Preview {
    BottomControls(settingsAction: { print("Settings Tapped!") })
        .padding()
        .background(Color.gray.opacity(0.2))
} 