////
////  ImageURL2.swift
////  LoLInfo
////
////  Created by Sergey Petrov on 04.12.2021.
////
//
//import SwiftUI
//import Combine
//
///// Async Image View
//struct ImageURL: View {
//    
//    @StateObject var vm: AsyncImageStore
//    
//    init(url: URL, saveQuality: CGFloat = 1.0) {
//        _vm = StateObject(wrappedValue: AsyncImageStore(url: url, saveQuality: saveQuality))
//    }
//
//    var body: some View {
//        ZStack{
//            if vm.isLoading {
//                Color(UIColor.secondarySystemFill)
//                    .aspectRatio(1/1, contentMode: .fill)
//            } else if let image = vm.image {
//                Image(uiImage: image)
//                    .resizable()
//                    .transition(.scale)
//            }
//        }
//    }
//}
//
///// This class handles image loading for a single image and its corresponding thumbnail. It loads images
///// asynchronously in the background and publishes to Combine when it finishes loading a file, or if it
///// encounters an error while loading.
//class AsyncImageStore: ObservableObject {
//    var url: URL
//    var saveQuality: CGFloat
//    /// When the store finishes loading the thumbnail, this property contains the thumbnail. If the store
//    /// hasn't finished loading the thumbnail, this property contains a placeholder image.
//    @Published var thumbnailImage: UIImage
//    
//    /// When the store is finished loading the full-size image, this property contains the full-size image. If
//    /// the store hasn't finished loading the full-size image, this property contains a placeholder image.
//    @Published var image: UIImage
//    
//    @Published var isLoading: Bool = false
//    
//    private var subscriptions: Set<AnyCancellable> = []
//    
//    private var cancellable: AnyCancellable?
//    
//    private let errorImage: UIImage
//    
//    /// This initializes a data store object that loads a specified image and its corresponding thumbnail.
//    /// When the store begins loading images, it publishes `loadingImage`. If the store fails to load
//    /// the thumbnail or image, it publishes `errorImage`. The store doesn't start loading an image
//    /// until the first time your code accesses one of the image properties.
//    init(url: URL, saveQuality: CGFloat = 1, loadingImage: UIImage = UIImage(systemName: "questionmark.circle")!,
//         errorImage: UIImage = UIImage(systemName: "questionmark")!) {
//        self.url = url
//        self.thumbnailImage = loadingImage
//        self.image = loadingImage
//        self.errorImage = errorImage
//        self.saveQuality = saveQuality
//        getImage()
//    }
//    
//    /// This method starts an asynchronous load of the image. If this method doesn't find an
//    /// image at the specified URL, it starts download if from URL and if cant find an image it publishes an error image.
//    func getImage() {
//        
//        /// Check existance of local filesystem Image
//        /// if Image doesnt exist, download image from url else load from local filesystem
//        guard let localURL = ImageLoader.getLocalURL(from: url),
//              FileManager.default.fileExists(atPath: localURL.path)
//        else {
//            self.download()
//            return
//        }
//        
//        /// Load Image from local filesystem
//        self.isLoading = true
//        ImageLoader.loadLocal(url: localURL)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .failure(let error):
//                    print("Error to load local Image: \(error)")
//                case .finished:
//                    break
//                }
//            }, receiveValue: { [weak self] image in
//                self?.image = image
//                self?.isLoading = false
//            })
//            .store(in: &subscriptions)
//    }
//        
//    func download() {
//        isLoading = true
//        ImageLoader.download(url: url)
//            .receive(on: DispatchQueue.main)
//            .replaceError(with: errorImage)
//            .sink{ [weak self] image in
//                guard let self = self else { return }
//                // Set Image
//                self.image = image
//                self.isLoading = false
//                // Save Image
//                ImageLoader.saveLocal(fromURL: self.url, uiImage: image, saveQuality: self.saveQuality)
//            }
//            .store(in: &subscriptions)
//    }
//    
////    /// This method starts an asynchronous load of the thumbnail image. If this method doesn't find an
////    /// image at the specified URL, it publishes an error image.
////    func loadThumbnail() {
////        ImageLoader.loadThumbnail(url: url)
////            .receive(on: DispatchQueue.main)
////            .replaceError(with: errorImage)
////            .assign(to: \.thumbnailImage, on: self)
////            .store(in: &subscriptions)
////    }
////
////    /// This method starts an asynchronous load of the full-size image. If it doesn't find an image at the
////    /// specified URL, it publishes an error image.
////    func loadImage() {
////        ImageLoader.loadImage(url: url)
////            .receive(on: DispatchQueue.main)
////            .replaceError(with: errorImage)
////            .assign(to: \.image, on: self)
////            .store(in: &subscriptions)
////    }
//    
//}
