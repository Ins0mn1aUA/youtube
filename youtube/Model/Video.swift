//
//  Video.swift
//  youtube
//
//  Created by Grisha Stetsenko on 1/20/19.
//

import UIKit

class Video: NSObject {
    var tumbnailImageName: String?
    var title: String?
    var numberOfViews: NSNumber?
    var uploadDate: NSDate?
    var chanel: Channel?
}

class Channel: NSObject {
    var name: String?
    var profileImageName: String?
}
