//
//  FirebaseImage.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/08/01.
//  Copyright © 2020 minsoo kim. All rights reserved.
//


import SwiftUI
import Combine

import FirebaseStorage

final class Loader : ObservableObject {
    let didChange = PassthroughSubject<Data?, Never>()
    @Published var data: Data? = nil {
        didSet { didChange.send(data) }
    }
    
    init(_ id: String){
        let url = "images/\(id)"
        print(url)
        let storage = Storage.storage()
        let ref = storage.reference().child(url)
        ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("\(error)")
            }
            DispatchQueue.main.async {
                self.data = data
            }
        }
    }
}

let placeholder = UIImage(named: "building")!

struct FirebaseImage : View {
    
    init(id: String) {
        self.id = id
        self.imageLoader = Loader(id)
    }
    var id : String
    @ObservedObject private var imageLoader : Loader
    
    var image: UIImage? {
        if let cacheImage = imageCache.get(forKey: id){
            return cacheImage
        } else {
            var loadedImage = imageLoader.data.flatMap(UIImage.init)
            if loadedImage != nil{
                self.imageCache.set(forKey: self.id, image: loadedImage!)
            }
            return loadedImage
        }
    }
    // 캐싱
    var imageCache = ImageCache.getImageCache()
    func loadImageFromCache(id:String) -> Bool {
        guard let cacheImage = imageCache.get(forKey: id) else {
            return false
        }
        return true
    }
    var body: some View {
        Group{
            if self.image != nil{
                Image(uiImage: self.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipped()
            }
        }
    }
}

#if DEBUG
struct FirebaseImage_Previews : PreviewProvider {
    static var previews: some View {
        FirebaseImage(id: "yontong3.jpg")
    }
}
#endif

// 캐싱
class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}
