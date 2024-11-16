import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                // Logo or Title
                Text("Lumino")
                    .font(.custom("IM FELL DW Pica", size: 30))
                    .foregroundColor(.white)
                    .padding(.bottom, 40)
                
                // Custom Loading Animation
                Circle()
                    .stroke(lineWidth: 2)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    .overlay(
                        Circle()
                            .trim(from: 0, to: 0.7)
                            .stroke(Color.white, lineWidth: 2)
                            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                            .animation(
                                Animation.linear(duration: 1)
                                    .repeatForever(autoreverses: false),
                                value: isAnimating
                            )
                    )
                
                Text("Loading...")
                    .font(.custom("IM FELL DW Pica", size: 16))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 20)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    LoadingView()
}

