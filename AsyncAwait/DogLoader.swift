//
//  DogLoader.swift
//  AsyncAwait
//
//  Created by Ignacio Cervino on 06/08/2024.
//

import Foundation
import UIKit

typealias DogImage = UIImage

enum DogImageError: Error {
    case invalidImageData
    case noImageData
}

func fetchDogData(completion: @escaping (Result<DogImage, Error>) -> Void) {
    let url = URL(string: "https://i.ytimg.com/vi/SfLV8hD7zX4/maxresdefault.jpg")!
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let data = data else {
            completion(.failure(DogImageError.noImageData))
            return
        }

        guard let dogImage =  DogImage(data: data) else {
            completion(.failure(DogImageError.invalidImageData))
            return
        }
        completion(.success(dogImage))
    }.resume()
}
