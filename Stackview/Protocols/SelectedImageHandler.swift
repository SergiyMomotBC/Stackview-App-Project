//
//  SelectedImageHandler.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/27/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation
import ImageViewer
import Kingfisher

protocol SelectedImageHandler: class {
    func handleImageURL(_ imageURL: String)
}

fileprivate class ImageDataSource: GalleryItemsDataSource {
    let imageURL: URL
    
    init(with urlString: String) {
        imageURL = URL(string: urlString)!
    }
    
    func itemCount() -> Int {
        return 1
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        return GalleryItem.image(fetchImageBlock: { (completion: @escaping ImageCompletion) in
            ImageDownloader.default.downloadImage(with: self.imageURL, options: [], progressBlock: nil) { (image, _, _, _) in
                completion(image)
            }
        })
    }
}

extension SelectedImageHandler where Self: UIViewController {
    func handleImageURL(_ imageURL: String) {
        let config: [GalleryConfigurationItem] = [GalleryConfigurationItem.pagingMode(.standard),
                                                  GalleryConfigurationItem.presentationStyle(.fade),
                                                  GalleryConfigurationItem.deleteButtonMode(.none),
                                                  GalleryConfigurationItem.thumbnailsButtonMode(.none),
                                                  GalleryConfigurationItem.overlayBlurOpacity(0.0)]
        
        let gallery = GalleryViewController(startIndex: 0, itemsDataSource: ImageDataSource(with: imageURL), itemsDelegate: nil, displacedViewsDataSource: nil, configuration: config)
        self.presentImageGallery(gallery)
    }
}
