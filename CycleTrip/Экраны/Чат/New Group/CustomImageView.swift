//
//  CustomImageView.swift
//  Cycle Trip
//
//  Created by Vladimir Ovsiannikov on 26.04.2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import UIKit

class CustomImageView : UIImageView {
    
    func loadImage(from url: URL){
    let task = URLSession.shared.dataTask(with: url) { (data,response,error)in
        guard
            let data = data,
            let newImage = UIImage(data: data)
            else {
                print("couldn't load image from url: \(url)")
                return
        }
        DispatchQueue.main.async {
        self.image = newImage
        }
    }

    task.resume()
    }
}
