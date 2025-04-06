//
//  VerseActionFooter.swift
//  Immersive Bible App
//
//  Created by Miguelangelo Montemurro on 4/5/25.
//

import SwiftUI

struct VerseActionFooter: View {
    let selectedCount: Int
    let actionHandler: (VerseActionType) -> Void
    let deselectAllAction: () -> Void
    
    private let buttonSize: CGFloat = 40
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                // Display selected count
                Text("\(selectedCount) Selected")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                
                // Deselect Button
                Button(action: deselectAllAction) {
                    Text("Deselect")
                        .font(.system(size: 14, weight: .medium))
                        .underline()
                        .foregroundColor(.primary)
                }
                
                // Action Buttons
                ForEach(VerseActionType.allCases) { actionType in
                    Button {
                        actionHandler(actionType)
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: actionType.iconName)
                                .font(.system(size: 18))
                            Text(actionType.rawValue)
                                .font(.system(size: 10))
                        }
                        .frame(width: buttonSize + 15, height: buttonSize)
                        .foregroundColor(.primary)
                    }
                }
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 35)
        }
        .frame(height: 80)
        .background(.thinMaterial)
        .cornerRadius(15, corners: [.topLeft, .topRight])
        .shadow(radius: 3)
    }
}

// Helper for specific corner rounding
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    VStack {
        Spacer()
        VerseActionFooter(selectedCount: 3, actionHandler: { action in
            print("Preview action: \(action)")
        }, deselectAllAction: { 
            print("Preview deselect all")
        })
    }
    .background(Color.blue)
} 