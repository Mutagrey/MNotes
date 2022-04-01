//
//  ImagePicker.swift
//  MNotes
//
//  Created by Sergey Petrov on 30.03.2022.
//

import SwiftUI
import Photos
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var results: [UIImage]
    @Binding var attributedString: NSMutableAttributedString
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let imgPicker = PHPickerViewController(configuration: defaultConfing())
        
        imgPicker.delegate = context.coordinator
        
        return imgPicker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        //
    }
    
    private func defaultConfing() -> PHPickerConfiguration {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 20
        config.filter = .images
        return config
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true, completion: nil)
            let group = DispatchGroup()

            var images: [UIImage] = []
            let atrString: NSMutableAttributedString = .init(string: "")
            results.forEach { result in
                group.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    defer {
                        group.leave()
                    }
                    guard let image = image as? UIImage, error == nil else { return }
                    // Add UIImage
                    images.append(image)
                    // Add Image to NSAttributedString
                    let attachment = NSTextAttachment()
                    attachment.image = image.withRoundedCorners(toWidth: UIScreen.main.bounds.width * 0.9, radius: 15)
                    let attributedString = NSAttributedString(attachment: attachment)
                    atrString.append(attributedString)
                }
            }
            group.notify(queue: .main) {
                self.parent.results = images
                self.parent.attributedString.append(atrString)
            }
        }
        
    }
}

struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImagePicker(results: .constant([]), attributedString: .constant(.init(string: "")))
    }
}
