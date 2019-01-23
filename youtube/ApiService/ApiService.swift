//
//  ApiService.swift
//  youtube
//
//  Created by Grisha Stetsenko on 1/22/19.
//

import UIKit

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    let baseUrl = "https://s3-us-west-2.amazonaws.com/youtubeassets"
    
    func fetchVideos(completion: @escaping ([Video]) -> ()) {
        fetchFeedFrom(urlString: "\(baseUrl)/home_num_likes.json", completion: completion)
    }
    
    func fetchTrendingFeed(completion: @escaping ([Video]) -> ()) {
        fetchFeedFrom(urlString: "\(baseUrl)/trending.json", completion: completion)
    }
    
    func fetchSubscriptionFeed(completion: @escaping ([Video]) -> ()) {
        fetchFeedFrom(urlString: "\(baseUrl)/subscriptions.json", completion: completion)
    }
    
    func fetchFeedFrom(urlString: String, completion: @escaping ([Video]) -> ()) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let json = try JSONDecoder().decode([Video].self, from: data)
                
                DispatchQueue.main.async {
                    completion(json)
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
        
    }
}
