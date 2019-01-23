//
//  TrendingCell.swift
//  youtube
//
//  Created by Grisha Stetsenko on 1/23/19.
//

import UIKit

class TrendingCell: FeedCell {
    
    override func fetchVideos() {
        ApiService.sharedInstance.fetchTrendingFeed { (videos: [Video]) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
    
}
