//
//  CachedImageLoader.swift
//  Nugget
//
//  Created by Robert Tolar Haining on 10/15/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import Foundation
import UIKit

final class CachedImageLoader: ObservableObject {
    static private let cache: URLCache = {
        return URLCache(memoryCapacity: 10000000, diskCapacity: 100000000) //50mb, 100mb
    }()
    
    @Published var data = Data() {
        didSet {
            if let completion = completion, let image = UIImage(data: data) {
                completion(image)
            }
        }
    }
    
    let completion: ((UIImage) -> Void)?
    
    init(imageURL: URL, completion: ((UIImage) -> Void)? = nil) {
        self.completion = completion
        
        self.load(imageURL: imageURL)
    }
    
    private func load(imageURL: URL) {
        if let avatarImageData = self.cachedData(for: imageURL) {
            self.updateData(avatarImageData)
        } else {
            DispatchQueue.global().async { [weak self] in
                self?.loadRemote(imageURL: imageURL)
            }
        }
    }
    
    private func loadRemote(imageURL: URL) {
        let request = URLRequest(url: imageURL,
                                 cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad,
                                 timeoutInterval: 60.0)
        
        URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let data = data, let response = response {
                self.updateData(data)
                self.save(data: data, response: response, imageURL: imageURL)
            } else if let error = error {
                NSLog("error downloading image \(error)")
            }
            
        }).resume()
    }
    
    private func updateData(_ data: Data) {
        if Thread.isMainThread {
            self.data = data
        } else {
            DispatchQueue.main.async {
                self.data = data
            }
        }
    }
    
    private func cachedData(for imageURL: URL) -> Data? {
        let cacheRequest = URLRequest(url: imageURL)
        let cacheResponse = CachedImageLoader.cache.cachedResponse(for: cacheRequest)
        let data = cacheResponse?.data
        return data
    }
    
    private func save(data: Data, response: URLResponse, imageURL: URL) {
        if self.cachedData(for: imageURL) == nil {
            let cachedData = CachedURLResponse(response: response, data: data, storagePolicy: .allowed)
            let cacheRequest = URLRequest(url: imageURL)
            CachedImageLoader.cache.storeCachedResponse(cachedData, for: cacheRequest)
        }
    }
}
