//
//  BottomControls.swift
//  Immersive Bible App
//
//  Created by Miguelangelo Montemurro on 4/4/25.
//

import SwiftUI

// MARK: - Data Structure
struct TabBarItemData: Identifiable {
    let id = UUID()
    let icon: String
    let selectedIcon: String
    let label: String
}

// MARK: - Custom Shape for Curved Background
struct CurvedTabBarShape: Shape {
    var curveDepth: CGFloat = 40 // Not directly used for semicircle radius, but kept for potential future use
    var curveRadius: CGFloat = 45 // This will now define the semicircle radius
    
    var animatableData: CGFloat { // Still animatable based on radius if needed
        get { curveRadius }
        set { curveRadius = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.minY))
        
        // Line to the start of the arc (left side of the semicircle)
        let arcStart = CGPoint(x: rect.midX - curveRadius, y: rect.minY)
        path.addLine(to: arcStart)
        
        // Add the semicircle arc dipping downwards
        path.addArc(center: CGPoint(x: rect.midX, y: rect.minY), // Center is on the top edge
                    radius: curveRadius,
                    startAngle: .degrees(180), // Start from the left
                    endAngle: .degrees(0),     // End at the right
                    clockwise: true)          // Draw clockwise to dip down
        
        // Line from the end of the arc to the top right
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Standard Tab Item View
struct TabBarItemView: View {
    let item: TabBarItemData
    let isSelected: Bool
    let action: () -> Void
    
    let selectedColor: Color = .black
    let unselectedColor: Color = .gray
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? item.selectedIcon : item.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22) // Slightly smaller icons
                
                Text(item.label)
                    .font(.system(size: 10, weight: isSelected ? .semibold : .regular))
            }
            .foregroundColor(isSelected ? selectedColor : unselectedColor)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Play Button (Center FAB)
struct PlayButton: View {
    @Binding var isPlaying: Bool
    let size: CGFloat = 55
    let action: () -> Void
    
    let buttonColor: Color = .black
    let iconColor: Color = .white
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(buttonColor)
                    .frame(width: size, height: size)
                    .shadow(color: .black.opacity(0.2), radius: 4, y: 4)
                
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size * 0.4, height: size * 0.4)
                    .foregroundColor(iconColor)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Main Bottom Controls View
struct BottomControls: View {
    @Binding var isAudioPlaying: Bool
    @Binding var showAmbientSoundPicker: Bool
    @State private var selectedIndex: Int = 0
    
    let items: [TabBarItemData] = [
        TabBarItemData(icon: "book.closed", selectedIcon: "book.closed.fill", label: "Bible"),
        TabBarItemData(icon: "speaker.wave.2", selectedIcon: "speaker.wave.2.fill", label: "Audio"),
        TabBarItemData(icon: "music.note", selectedIcon: "music.note.fill", label: "Songify"),
        TabBarItemData(icon: "book", selectedIcon: "book.fill", label: "Study")
    ]
    
    let barBackgroundColor: Color = Color(white: 0.98) // Slightly off-white
    let barHeight: CGFloat = 50 // Slightly shorter bar
    let fabSize: CGFloat = 55
    let curveDepth: CGFloat = 40
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background Shape Layer
            CurvedTabBarShape(curveDepth: curveDepth, curveRadius: fabSize / 2 + 15)
                .fill(barBackgroundColor)
                .frame(height: barHeight + curveDepth)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -3)
            
            // Tab Items Layer
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(items.indices, id: \.self) { index in
                    if index == items.count / 2 {
                        Spacer()
                            .frame(width: fabSize + 5)
                    }
                    
                    TabBarItemView(
                        item: items[index],
                        isSelected: selectedIndex == index,
                        action: {
                            selectedIndex = index
                            if index == 1 { // Audio tab
                                showAmbientSoundPicker.toggle()
                            }
                        }
                    )
                    .padding(.bottom, 12) // Increased bottom padding
                }
            }
            .frame(height: barHeight)
            .padding(.bottom, safeAreaBottomInset())
            
            // Play Button Layer
            PlayButton(isPlaying: $isAudioPlaying) {
                isAudioPlaying.toggle()
            }
            .offset(y: -(safeAreaBottomInset() + barHeight / 2))
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    private func safeAreaBottomInset() -> CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first(where: { $0.isKeyWindow })?
            .safeAreaInsets.bottom ?? 0
    }
}

#Preview {
    BottomControls(
        isAudioPlaying: .constant(false),
        showAmbientSoundPicker: .constant(false)
    )
    .preferredColorScheme(.light)
} 