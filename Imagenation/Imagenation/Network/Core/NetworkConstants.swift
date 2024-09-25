//
//  NetworkConstants.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 15.08.24.


import Foundation
import Alamofire

class NetworkConstants {
    static let baseURL = "https://api.unsplash.com/"
    static let header: HTTPHeaders = ["Authorization": "Client-ID xczTRip4D5Xl2l8kR4mvZ-VISN6gUyOXJmGDFFt_mXY"]
        
    static func getUrl(with endpoint: String) -> String {
        baseURL + endpoint
    }
}

