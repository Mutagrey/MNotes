//
//  CustomGridView.swift
//  MNotes
//
//  Created by Sergey Petrov on 18.03.2022.
//

import SwiftUI

struct CustomGridView<Content: View, T: Identifiable>: View where T: Hashable {
    //it will return each object in collection to build View
    var content: (T) -> Content
    
    var list: [T]
    //Columns
    var columns: Int
    //Properties
    var showsIndicators: Bool
    var spacing: CGFloat
    
    init(columns: Int = 1, showIndicators: Bool = false, spacing: CGFloat = 10, list: [T], @ViewBuilder content: @escaping (T) -> Content) {
        self.content = content
        self.list = list
        self.showsIndicators = showIndicators
        self.spacing = spacing
        self.columns = columns
    }
    
    func setUpList()-> [[T]] {
        var gridArray: [[T]] = Array(repeating: [], count: columns)
        var currentIndex = 0
        for item in list {
            gridArray[currentIndex].append(item)
            if currentIndex == (columns - 1) {
                currentIndex = 0
            } else {
                currentIndex += 1
            }
        }
        return gridArray
    }
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: showsIndicators) {
            HStack(alignment: .top){
                ForEach(setUpList(), id: \.self) { columnsData in
                    LazyVStack(spacing: spacing) {
                        ForEach(columnsData) { item in
                            content(item)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
    }
}
