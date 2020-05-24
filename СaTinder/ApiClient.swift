//
//  ApiClient.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 07.05.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit


class APIClient: APIClientProtocol {
    
    static let shared = APIClient()
    let headers = [
        "x-api-key": Const.apikey
    ]
    
    func getBreeds() -> Result<[Breed]?, Error> {
        //getting all breeds
        let urlString = "https://api.thecatapi.com/v1/breeds"
        guard let url = URL(string: urlString) else {
            return .success(nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        
        var result: Result<[Breed]?, Error>!
        
        let semaphore = DispatchSemaphore(value: 0)
    
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                result = .failure(error)
                semaphore.signal()
                return
            }
            
            guard let data = data else {
                result = .success(nil)
                semaphore.signal()
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let breeds = try decoder.decode([Breed].self, from: data)
                result = .success(breeds)
            } catch let error {
                result = .failure(error)
            }
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
        
        return result
    }

    
    func getImages(by breed: Breed) -> Result<[CatImage]?, Error> {
        let urlString = "https://api.thecatapi.com/v1/images/search"
        var urlcomponets = URLComponents(string: urlString)
        var items = [URLQueryItem]()
        items.append(URLQueryItem(name: "breed_id", value: breed.id))
        items.append(URLQueryItem(name: "limit", value: "3"))
        urlcomponets?.queryItems = items
        
        guard let url = urlcomponets?.url else {
            return .failure(APIError.brokenURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared

        
        var result: Result<[CatImage]?, Error>!
        
        let sema = DispatchSemaphore(value: 0)
        
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                result = .failure(error)
                sema.signal()
                return
            }
            
            guard let data = data else {
                result = .failure(APIError.emptyBody)
                sema.signal()
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let images = try decoder.decode([CatImage].self, from: data)
                result = .success(images)
            } catch let error {
                result = .failure(error)
            }
            sema.signal()
            
        }.resume()
        
        sema.wait()
        
        return result
    }
}



protocol APIClientProtocol: class {
    func getBreeds() -> Result<[Breed]?, Error>
    func getImages(by breed: Breed) -> Result<[CatImage]?, Error>
}



private struct AddToFavoriteRequest: Codable {
    var image_id: String
    var sub_id: String
}

enum APIError: Error {
    case imagesNotFound
    case brokenURL
    case emptyBody
}
