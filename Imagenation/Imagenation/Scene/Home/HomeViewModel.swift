//
//  HomeViewModel.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 14.08.24.
//

import Foundation
import Alamofire

class FetchTopics {
    static let shared = FetchTopics()
    
    func fetchTopics(completion: @escaping ([Topic]?) -> Void) {
        let url = "https://api.unsplash.com/topics"
        let parameters: [String: String] = ["client_id": "xczTRip4D5Xl2l8kR4mvZ-VISN6gUyOXJmGDFFt_mXY"]
        
        AF.request(url, parameters: parameters).responseDecodable(of: [Topic].self) { response in
            switch response.result {
            case .success(let topics):
                completion(topics)
            case .failure(let error):
                print("Failed to fetch topics: \(error)")
                completion(nil)
            }
        }
    }
    
    func fetchPhotos(forTopic topicID: String, completion: @escaping ([Photo]?) -> Void) {
        let url = "https://api.unsplash.com/topics/\(topicID)/photos"
        let parameters: [String: String] = ["client_id": "xczTRip4D5Xl2l8kR4mvZ-VISN6gUyOXJmGDFFt_mXY"]
        
        AF.request(url, parameters: parameters).responseDecodable(of: [Photo].self) { response in
            switch response.result {
            case .success(let photos):
                completion(photos)
            case .failure(let error):
                print("Failed to fetch photos: \(error)")
                completion(nil)
            }
        }
    }
}

class HomeViewModel {
//    var photoURL = [PhotoURLs]()
//    func getPhotos() {
//        PhotoService.fetchRandomPhoto { photo, errorMessage in
//            if let photo {
//                self.photoURL.append(photo.urls)
//                print(self.photoURL)
//            } else if let errorMessage {
//                print(errorMessage)
//            }
//        }
//    }
}
