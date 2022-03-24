//
//  ColorTabView.swift
//  MNotes
//
//  Created by Sergey Petrov on 20.03.2022.
//

import SwiftUI

struct ColorTabView<Content: View>: View {
    
    let content: Content
    let colors: [Color]
    @State private var offset: CGFloat = 0
    
    init(colors: [Color] = [.red, .green, .blue, .purple], @ViewBuilder content: () -> Content) {
        self.colors = colors
        self.content = content()
    }
    var body: some View {
        ScrollView(.init()) {
            TabView{
//                ZStack {
//                    content
                    ForEach(colors.indices, id: \.self) { index in
                        
//                        if index == 0 {
                            colors[index]
                                .overlay(
                                    GeometryReader{ proxy -> Color in
                                        let minX = proxy.frame(in: .named("FIRST")).minX
                                        print(minX)
                                        
                                        DispatchQueue.main.async {
                                            withAnimation(.default) {
                                                self.offset = -minX
                                            }
                                        }
                                        
                                        return Color.clear
                                    }
                                        .frame(width: 0, height: 0)
                                    , alignment: .leading
                                )
//                                .coordinateSpace(name: "FIRST")
//                        } else {
//                            colors[index]
//                        }
 
                    }
//                    .coordinateSpace(name: "FIRST")
//                }
                
            }
            .coordinateSpace(name: "FIRST")
            .tabViewStyle(.page(indexDisplayMode: .never))
            .overlay(
                // Animated Indicators
                HStack(spacing: 15.0) {
                    ForEach(colors.indices, id: \.self) { index in
                        Capsule()
                            .fill(Color.white)
                            .frame(width: getIndex() == index ? 20 : 7, height: 7)
                    }
                }
                // Smooth sliding effect
                    .overlay(
                        Capsule()
                            .fill(Color.white)
                            .frame(width: 20, height: 7)
                            .offset(x: getOffset())
                        , alignment: .leading
                    )
                    .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                    .padding(.bottom, 10)
                , alignment: .bottom
            )
            .overlay(Text("\(offset)"))
            
        }
        .ignoresSafeArea()

    }
    
    func getIndex() -> Int {
        let index = Int(round(Double(offset / getWidth() )))
        return index
    }
    
    func getOffset() -> CGFloat {
        // spacing = 15
        // Circle width = 7
        // total = 22
        let progress = offset / getWidth()
        return 22 * progress
    }
}

struct ColorTabView_Previews: PreviewProvider {
    
    static let colors: [Color] = [.red, .green, .blue]
    static var previews: some View {
        ColorTabView {
            ForEach(colors.indices, id: \.self) { index in
                colors[index]
                    .tag(index)
            }
        }
    }
}


extension View {
    func getWidth() -> CGFloat {
        UIScreen.main.bounds.width
    }
}
