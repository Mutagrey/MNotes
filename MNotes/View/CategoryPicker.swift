//
//  CategoryMenuView.swift
//  MNotes
//
//  Created by Sergey Petrov on 19.03.2022.
//

import SwiftUI

enum CategoryPosition {
    case vertical
    case horizontal
}

struct CategoryPicker: View {

    @Binding var show: Bool
    @Binding var category: NoteCategory?
    let size: CGFloat
    let position: CategoryPosition
    let transition: Edge
    
    init(show: Binding<Bool>, category: Binding<NoteCategory?>, size: CGFloat = 25, position: CategoryPosition = .vertical, transition: Edge = .top) {
        self._show = show
        self._category = category
        self.size = size
        self.position = position
        self.transition = transition
    }
    var body: some View {
        ZStack{
            if position == .vertical {
                if show {
//                    ScrollView(.vertical){
                        VStack(spacing: 15){
                            content
                        }
//                    }
                    .transition(.move(edge: transition))

                }
            } else {
                if show {
//                    ScrollView(.horizontal) {
                        HStack(spacing: 15){
                            content
                        }
//                    }
                    .transition(.move(edge: .trailing))
                }
            }
        }
        .padding(size / 2)
        .opacity(show ? 1 : 0)

    }
    
    private var content: some View{
        ForEach(NoteCategory.allCases, id:\.self) { category in
            Button {
                withAnimation(.spring()){
                    self.category = category
                    self.show.toggle()
                }
                print(category.rawValue)
            } label: {
                Circle()
                    .fill(category.color)
                    .frame(width: size, height: size)
                    .padding(size / 2)
            }
        }
    }
}

struct CategoryMenuView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryPicker(show: .constant(true), category: .constant(.orange))
    }
}

// MARK: - CategoryPickerSelector - with circle button and custom animation
struct CategoryPickerSelector: View {
    
    enum AppearanceSide {
        case top
        case bottom
        case left
        case right
    }
    
    @AppStorage("cornerRadius") var cornerRadius: Double = 12
    
    @EnvironmentObject var vm: NotesViewModel

    @Binding var show: Bool
    @Binding var category: NoteCategory?
    let size: CGFloat
    let autoCloseTime: CGFloat
    
    let categoryPosition: CategoryPosition
    
    @State private var showButtonAnimation: Bool = false
    
    
    init(show: Binding<Bool>, category: Binding<NoteCategory?>, size: CGFloat = 25, autoCloseTime: CGFloat = 2, categoryPosition: CategoryPosition = .vertical) {
        self._show = show
        self._category = category
        self.size = size
        self.autoCloseTime = autoCloseTime
        self.categoryPosition = categoryPosition
    }
    
    var body: some View {
        Group{
            if categoryPosition == .vertical {
                VStack(spacing: 0.0){
                    selectorButton
                        .background(Color(UIColor.secondarySystemBackground).opacity(0.5))
                        .cornerRadius(10)
                        .zIndex(1)
                    pickerView
                }
            } else {
                HStack(spacing: 0.0){
                    pickerView
                    selectorButton
                        .background(Color(UIColor.secondarySystemBackground).opacity(0.5))
                        .cornerRadius(10)
                        .zIndex(1)
                }
            }
        }
        .background(show ? Color(UIColor.secondarySystemBackground).opacity(0.5) : Color.clear)
        .cornerRadius(10)
        .clipped()

    }
}
// MARK: - CategoryPickerSelector - buttons
extension CategoryPickerSelector {
    private var selectorButton: some View{
        Button {
            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
                show.toggle()
                showButtonAnimation.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring()){
                    showButtonAnimation.toggle()
                }
            }
            // Close Picker
            DispatchQueue.main.asyncAfter(deadline: .now() + autoCloseTime) {
                if show {
                    withAnimation(.spring()){
                        show.toggle()
                    }
                }
            }
        } label: {
            Circle()
                .fill(self.category?.color ??  Color(UIColor.secondarySystemFill))
                .frame(width: size, height: size)
                .overlay(Circle().stroke(Color.primary, lineWidth: 1).opacity(show ? 1 : 0))
                .padding(size / 2)
        }
        .scaleEffect(showButtonAnimation ? 1.1 : 1)
        .padding(size / 2)
    }
    
    private var pickerView: some View{
        Group{
            if categoryPosition == .vertical {
                Divider()
                    .frame(width: size * 2, height: 1)
                    .opacity(show ? 1 : 0)
                CategoryPicker(show: $show, category: $category, size: size, position: categoryPosition)
                    .zIndex(0)
                    .clipped()
            } else {
                CategoryPicker(show: $show, category: $category, size: size, position: categoryPosition)
                    .zIndex(0)
                    .clipped()
                Divider()
                    .frame(width: 1, height: size * 2)
                    .opacity(show ? 1 : 0)
            }
        }
    }

    
}
