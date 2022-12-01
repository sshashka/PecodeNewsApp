//
//  WebImageManager.swift
//  PecodeNewsApp
//
//  Created by Саша Василенко on 01.12.2022.
//
import SDWebImage

class WebImageManager {
    static var shared = WebImageManager()
    
    func setupSDWebImage() {
        //doing this prevents big memory usage when scrolling I managed to use up to 2G without this
        SDImageCache.shared.config.maxDiskSize = 1024 * 1024
        SDImageCache.shared.config.shouldCacheImagesInMemory = false
    }
    
    func removeCache() {
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }
}
