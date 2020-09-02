////
////  ImageView.swift
////  HomeGuide
////
////  Created by minsoo kim on 2020/08/25.
////  Copyright © 2020 minsoo kim. All rights reserved.
////
//
//import Foundation
//import SwiftUI
//import Combine
//
//class ImageLoader: ObservableObject {
//    var didChange = PassthroughSubject<Data?, Never>()
//    @Published var data: Data? = nil {
//        didSet {
//            didChange.send(data)
//        }
//    }
//
//    init(urlString:String) {
//        guard let url = URL(string: urlString) else { return }
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else { return }
//            DispatchQueue.main.async {
//                self.data = data
//            }
//        }
//        task.resume()
//    }
//}
//
//struct ImageView: View {
//    init(urlString: String) {
//        self.url = urlString
//        self.imageLoader = ImageLoader(urlString: urlString)
//    }
//    var url : String
//    @ObservedObject private var imageLoader : ImageLoader
//    
//    var image: UIImage? {
//        if let cacheImage = imageCache.get(forKey: self.url){
//            return cacheImage
//        } else {
//            let loadedImage = imageLoader.data.flatMap(UIImage.init)
//            if loadedImage != nil{
//                self.imageCache.set(forKey: self.url, image: loadedImage!)
//            }
//            return loadedImage
//        }
//    }
//    // 캐싱
//    var imageCache = ImageCache.getImageCache()
//    func loadImageFromCache(id:String) -> Bool {
//        guard let cacheImage = imageCache.get(forKey: id) else {
//            return false
//        }
//        return true
//    }
//    var body: some View {
//        Group{
//            if self.image != nil{
//                Image(uiImage: self.image!)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(maxWidth: .infinity)
//                    .clipped()
//            }
//        }
//    }
//}
