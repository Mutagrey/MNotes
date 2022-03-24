//
//  ShareView2.swift
//  LoLInfo
//
//  Created by Sergey Petrov on 25.12.2021.
//

import SwiftUI

struct ShareButton<Label: View>: View {
//    @State private var showShare = false
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
//        withAnimation(.spring()) {
//            showShare.toggle()
//        }
        
        let av = UIActivityViewController(activityItems: items, applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)

//        if UIDevice.current.userInterfaceIdiom == .pad {
//            av.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
//            av.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2.1, y: UIScreen.main.bounds.height / 2.3, width: 300, height: 300 * 9 / 16)
//        }
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
