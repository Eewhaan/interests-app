//
//  Items.swift
//  challenge4
//
//  Created by Ivan Pavic on 3.2.22..
//

import UIKit

class Items: NSObject, NSCoding {
    var caption: String
    var imageName: String
    
    init(imageName: String, caption: String) {
        self.imageName = imageName
        self.caption = caption
    }
    required init(coder aDecoder: NSCoder) {
        imageName = aDecoder.decodeObject(forKey: "imageName") as? String ?? ""
        caption = aDecoder.decodeObject(forKey: "caption") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(imageName, forKey: "imageName")
        aCoder.encode(caption, forKey: "caption")
    }

}
