//
//  ImageCacheManager.swift
//  LoLInfo
//
//  Created by Sergey Petrov on 09.12.2021.
//

import SwiftUI

class ImageCacheManager {
    static let instance = ImageCacheManager()
    private init() { }
    
    var imageCache: NSCache<NSString, UIImage> = {
        var cache = NSCache<NSString, UIImage>()
        cache.countLimit = 2000
        cache.totalCostLimit = 1024 * 1024 * 200 // 200Mb
        return cache
    }()
    
    func add(key: String, value: UIImage) {
        imageCache.setObject(value, forKey: key as NSString)
    }
    func get(key: String) -> UIImage? {
        imageCache.object(forKey: key as NSString)
    }
}

