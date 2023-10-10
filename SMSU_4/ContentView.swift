//
//  ContentView.swift
//  SMSU_4
//
//  Created by Andrei Kovryzhenko on 10.10.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack(alignment: .center) {
            VStack {
                AnimatedButton(size: 50, duration: 0.22, scale: 0.86)
                Text("duration: 0.22")
                Text("scale: 0.86")
            }
            .padding(.horizontal)
            VStack {
                AnimatedButton(size: 50, duration: 1.0, scale: 0.0)
                Text("duration: 1.0")
                Text("scale: 0.0")
            }
            .padding(.horizontal)
        }
        .padding()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct CircleBackgroundStyle: PrimitiveButtonStyle {
    @State private var pressing = false
    
    let duration: TimeInterval
    let scale: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .scaleEffect(pressing ? 0.55 : 0.7)
                .opacity(pressing ? 0.3 : 0)
            
            configuration.label
                .scaleEffect(pressing ? scale : 1)
        }
        .scaleEffect(pressing ? scale : 1)

        .foregroundColor(.blue)
        .onTapGesture {
            configuration.trigger()
            withAnimation(
                .interpolatingSpring(stiffness: 80, damping: 12)) {
                pressing.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                pressing.toggle()
            }
        }
        .animation(.easeInOut(duration: 0.4), value: pressing)
    }
}


struct AnimatedButton: View {
    @State private var buttonIsOn = false
    
    let size: CGFloat
    let duration: TimeInterval
    let scale: CGFloat
    
    var body: some View {
        Button {
            guard !buttonIsOn else { return }
            buttonIsOn.toggle()
            withAnimation(
                .interpolatingSpring(stiffness: 80, damping: 12)) {
                buttonIsOn.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                buttonIsOn = false
            }
        } label: {
            ZStack {
                HStack() {
                    Image(systemName: "play.fill")
                        .font(.system(size: size))
                        .scaleEffect(
                            x: buttonIsOn ? 0 : 1,
                            y: buttonIsOn ? 0 : 1,
                            anchor: .trailing
                        )
                        .offset(x: buttonIsOn ? size * -1.12 : size * -0.37)
                        .opacity(buttonIsOn ? 0 : 1)
                }
                
                HStack(spacing: size * -0.13) {
                    Image(systemName: "play.fill")
                        .font(.system(size: size))
                        .offset(x: buttonIsOn ? 0 : size * 0.75 )
                        
                    Image(systemName: "play.fill")
                        .font(.system(size: size))
                        .opacity(buttonIsOn ? 1 : 0)
                        .scaleEffect(buttonIsOn ? 1 : 0)
                        .offset(x: buttonIsOn ? 0 : size * 0.42 )
                }
            }
            .padding(.horizontal)
        }
        .clipped()
        .disabled(buttonIsOn)
        .buttonStyle(CircleBackgroundStyle(duration: duration, scale: scale))
    }
}


