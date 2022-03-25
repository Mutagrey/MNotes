//
//  ShareView2.swift
//  LoLInfo
//
//  Created by Sergey Petrov on 25.12.2021.
//

import SwiftUI

struct ShareButton<Label: View>: View {

    var items: [Any]
    let label: Label
    
    init(items: [Any] = [], @ViewBuilder label: () -> Label ) {
        self.items = items
        self.label = label()
    }
    
    var body: some View {
        Button {
            shareButton()
        } label: {
            label
        }
    }
    
    func shareButton() {
        let av = UIActivityViewController(activityItems: items, applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}

struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        ShareButton(items: ["Text to share"]) {
            Image(systemName: "square.and.arrow.up")
                .font(.title2)
                .padding()
        }
    }
}
