//
//  Video.swift
//  youtube
//
//  Created by Grisha Stetsenko on 1/20/19.
//

import UIKit

struct Video: Decodable {
    
    let title: String?
    let number_of_views: Int?
    let thumbnail_image_name: String?
    let channel: Channel?
    let duration: Int?
//    let uploadDate: Date?
}

struct Channel: Decodable {
    let name: String?
    let profile_image_name: String?
}


