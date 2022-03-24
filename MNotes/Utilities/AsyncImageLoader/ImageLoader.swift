///*
//See LICENSE folder for this sample’s licensing information.
//
//Abstract:
//Asynchronous image-loading helper class.
//*/
//import Combine
//import CoreGraphics
//import CoreImage
//import Dispatch
//import Foundation
//import UIKit
//
//import QuickLook
//import QuickLookThumbnailing
//
//import os
//
//private let logger = Logger(subsystem: "com.mutagrey.LoLInfo",
//                            category: "ImageLoader")
//
///// This helper class asynchronously loads thumbnails and full-size images from a file URL.
//class ImageLoader {
//    private static let loaderQueue =
//        DispatchQueue(label: "com.mutagrey.LoLInfo.AsyncImageLoader.Load",
//                      qos: .userInitiated, attributes: .concurrent)
//    private static let saverQueue =
//        DispatchQueue(label: "com.mutagrey.LoLInfo.AsyncImageLoader.Save",
//                      qos: .userInitiated, attributes: .concurrent)
//    
//    private static let folderName = "downloaded_images"
//    
//    enum Error: Swift.Error {
//        case noSuchUrl
//        case noThumbnail
//        case noImage
//        case unknownError(Swift.Error)
//    }
//    
//    // MARK: - URL Converter
//    ///Converts URL between local and net
//    static func getLocalURL(from url: URL) -> URL? {
//        // 1. Get last 2 components of url //then use it to save on local filesystem
//        let folderName = url.deletingLastPathComponent().lastPathComponent
//        let imageName = url.lastPathComponent
//        
//        // Create base local filesystem folder if it doesnt exist
//        ImageLoader.createFolderIfNeeded()
//        
//        // Create new URL Folder.
//        guard let localFolderURL = ImageLoader.getFolder()?.appendingPathComponent(folderName) else { return nil }
//        if !FileManager.default.fileExists(atPath: localFolderURL.path) {
//            do {
//                try FileManager.default.createDirectory(at: localFolderURL, withIntermediateDirectories: true, attributes: nil)
//                print("Created folder for images: \(localFolderURL.path)")
//            } catch let error {
//                print("Error creating folder: \(error.localizedDescription)")
//            }
//        }
//        
//        // Get Local URL
//        let localURL = localFolderURL.appendingPathComponent(imageName)
//        return localURL
//    }
//    
//    // MARK: - Download from URL
//    static func download(url: URL) -> AnyPublisher<UIImage, URLError> {
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .subscribe(on: loaderQueue)
//            .map { UIImage(data: $0.data) }
//            .replaceNil(with: UIImage(systemName: "questionmark.app")!)
////            .replaceError(with: nil)
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
//    // MARK: - load and save Local Image
//    /// Load Local Image
//    static func loadLocal(url: URL) -> Future<UIImage, ImageLoader.Error> {
//        let future = Future<UIImage, ImageLoader.Error> { promise in
//            loaderQueue.async {
//                guard let newURL = ImageLoader.getLocalURL(from: url),
//                      FileManager.default.fileExists(atPath: newURL.path)
//                else {
//                    return promise(.failure(ImageLoader.Error.noSuchUrl))
//                }
//                guard let image = UIImage(contentsOfFile: newURL.path) else {
//                    return promise(.failure(ImageLoader.Error.noImage))
//                }
//                promise(.success(image))
//            }
//        }
//        return future
//    }
//    /// Save  Image
//    @discardableResult
//    static func saveLocal(fromURL: URL, uiImage: UIImage, saveQuality: CGFloat = 1) -> Future<Bool, ImageLoader.Error> {
//        let future = Future<Bool, ImageLoader.Error> { promise in
//            saverQueue.async {
////                createFolderIfNeeded()
//                guard
//                    let data = uiImage.jpegData(compressionQuality: saveQuality),
//                    let url = ImageLoader.getLocalURL(from: fromURL) else { return promise(.failure(ImageLoader.Error.noSuchUrl)) }
//                do {
//                    try data.write(to: url)
//                } catch let error {
//                    logger.error("Error saving image: \(error.localizedDescription)")
//                }
//                promise(.success(true))
//            }
//        }
//        return future
//    }
//    /// get image name from URL
//    private static func getFolder() -> URL? {
//        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(ImageLoader.folderName)
//    }
//    /// Creates folder if it doesnt exist
//    private static func createFolderIfNeeded() {
//        guard let url = ImageLoader.getFolder() else { return }
//        if !FileManager.default.fileExists(atPath: url.path) {
//            do {
//                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
//                print("Created folder for images: \(url.path)")
//            } catch let error {
//                print("Error creating folder: \(error.localizedDescription)")
//            }
//        }
//    }
//    /// Get Size of Folder
//    static func getSizeOfFolder() -> String {
//        var str: String = ""
//        guard let url = ImageLoader.getFolder() else { return str }
//        do {
//            if let sizeOnDisk = try url.sizeOnDisk() {
//                str = sizeOnDisk
//            }
//        } catch {
//            str = "no data"
//        }
//        return str
//    }
//    /// Remove all images
//    static func removeAll() {
//        guard
//            let url = getFolder(),
//            FileManager.default.fileExists(atPath: url.path) else { return }
//        loaderQueue.async {
//            do {
//                try FileManager.default.removeItem(atPath: url.path)
//            } catch {
//                print("[❗️] Error to remove: \(url.path)")
//            }
//        }
//    }
//    // MARK: - create from URL
//    static func loadImage(url: URL) -> Future<UIImage, ImageLoader.Error> {
//        let future = Future<UIImage, Error> { promise in
//            loaderQueue.async {
//                do {
////                    logger.debug("Loading image: \(url.path)...")
//                    let image = try ImageLoader.loadImageSynchronously(url: url)
////                    logger.debug("... done loading thumbnail: \(url.path).")
//                    promise(.success(image))
//                } catch ImageLoader.Error.noImage {
//                    logger.error("noImage \(url.path)")
//                    promise(.failure(ImageLoader.Error.noImage))
//                } catch ImageLoader.Error.noThumbnail {
//                    logger.error("noThumbnail \(url.path)")
//                    promise(.failure(ImageLoader.Error.noThumbnail))
//                } catch ImageLoader.Error.noSuchUrl {
//                    logger.error("noThumbnail \(url.path)")
//                    promise(.failure(ImageLoader.Error.noSuchUrl))
//                } catch {
//                    promise(.failure(ImageLoader.Error.unknownError(error)))
//                }
//            }
//        }
//        return future
//    }
//    
//    static func loadThumbnail(url: URL) -> Future<UIImage, ImageLoader.Error> {
//        let future = Future<UIImage, Error> { promise in
//            loaderQueue.async {
//                do {
////                    logger.debug("Loading thumbnail: \(url.path)...")
//                    let image = try ImageLoader.loadThumbnailSynchronously(url: url)
////                    logger.debug("... done loading thumbnail: \(url.path)...")
//                    promise(.success(image))
//                } catch ImageLoader.Error.noImage {
//                    logger.error("noImage \(url.path)")
//                    promise(.failure(ImageLoader.Error.noImage))
//                } catch ImageLoader.Error.noThumbnail {
//                    logger.error("noThumbnail \(url.path)")
//                    promise(.failure(ImageLoader.Error.noThumbnail))
//                } catch ImageLoader.Error.noSuchUrl {
//                    logger.error("noThumbnail \(url.path)")
//                    promise(.failure(ImageLoader.Error.noSuchUrl))
//                } catch {
//                    logger.error("unknownError \(url.path)")
//                    promise(.failure(ImageLoader.Error.unknownError(error)))
//                }
//            }
//        }
//        return future
//    }
//    
//    // 2022 Sergey Petrov
//    static func generateThumbnail(url: URL) -> Future<UIImage, ImageLoader.Error> {
//        let future = Future<UIImage, Error> { promise in
//            loaderQueue.async {
//                do {
////                    logger.debug("Loading thumbnail: \(url.path)...")
//                    let image = try ImageLoader.generateThumbnailSynchronously(url: url)
////                    logger.debug("... done loading thumbnail: \(url.path)...")
//                    promise(.success(image))
//                } catch ImageLoader.Error.noImage {
//                    logger.error("noImage \(url.path)")
//                    promise(.failure(ImageLoader.Error.noImage))
//                } catch ImageLoader.Error.noThumbnail {
//                    logger.error("noThumbnail \(url.path)")
//                    promise(.failure(ImageLoader.Error.noThumbnail))
//                } catch ImageLoader.Error.noSuchUrl {
//                    logger.error("noThumbnail \(url.path)")
//                    promise(.failure(ImageLoader.Error.noSuchUrl))
//                } catch {
//                    logger.error("unknownError \(url.path)")
//                    promise(.failure(ImageLoader.Error.unknownError(error)))
//                }
//            }
//        }
//        return future
//    }
//    
//    /// This method synchronously loads the embedded thumbnail. If it can't load the thumbnail, it returns `nil`.
//    private static func loadThumbnailSynchronously(url: URL) throws -> UIImage {
//        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) else {
//            let msg = "Error in CGImageSourceCreateWithURL for \(url.path)"
//            logger.error("\(msg)")
//            throw Error.noSuchUrl
//        }
//        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, nil) else {
//            let msg = "Error in CGImageSourceCreateThumbnailAtIndex for \(url.path)"
//            logger.error("\(msg)")
//            throw Error.noThumbnail
//        }
//        return UIImage(cgImage: cgImage, scale: 1.0, orientation: .right)
//    }
//    
//    /// This method synchronously loads the embedded image. If it can't load the image, it returns `nil`.
//    private static func loadImageSynchronously(url: URL) throws -> UIImage {
//        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) else {
//            let msg = "Error in CGImageSourceCreateWithURL for \(url.path)"
//            logger.error("\(msg)")
//            throw Error.noSuchUrl
//        }
//        guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
//            let msg = "Error in CGImageSourceCreateImageAtIndex for \(url.path)"
//            logger.error("\(msg)")
//            throw Error.noImage
//        }
//        return UIImage(cgImage: cgImage, scale: 1.0, orientation: .right)
//    }
//    
//    /// 2022 Sergey Petrov
//    /// This method synchronously loads the embedded image. If it can't load the image, it returns `nil`.
//    private static func generateThumbnailSynchronously(url: URL, size: CGSize = CGSize(width: 200, height: 200)) throws -> UIImage {
//        
//        let request = QLThumbnailGenerator.Request(fileAt: url, size: size, scale: (UIScreen.main.scale), representationTypes: .all)
//        let generator = QLThumbnailGenerator.shared
//        
//        var image: CGImage?
//        generator.generateRepresentations(for: request) { (thumbnail, type, error) in
//            DispatchQueue.main.async {
//                if thumbnail == nil || error != nil {
////                    assert(false, "Thumbnail failed to generate")
//                    print("Error generationg thumbnail: \(String(describing: error?.localizedDescription))")
//                    return
//                } else {
//                    DispatchQueue.main.async { // << required !!
////                        self.thumbnail = thumbnail!.cgImage  // here !!
//                        image = thumbnail!.cgImage
//                    }
//                }
//            }
//        }
////        .resume()
//        guard let cgImage = image else {
//            let msg = "Error generationg thumbnail for \(url.path)"
//            logger.error("\(msg)")
//            throw Error.noImage
//        }
//        return UIImage(cgImage: cgImage, scale: 1.0, orientation: .right)
//    }
//}
