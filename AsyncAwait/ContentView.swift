//
//  ContentView.swift
//  AsyncAwait
//
//  Created by Ignacio Cervino on 06/08/2024.
//

import SwiftUI

class DogViewModel: ObservableObject {
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
}

struct ContentView: View {
    @StateObject private var dogViewModel = DogViewModel()
    @State private var dogImage: UIImage?

    var body: some View {
        VStack {
            if let dogImage {
                Image(uiImage: dogImage)
                    .resizable()
                    .scaledToFit()
            }

            Button {
                dogViewModel.fetchDogData { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let image):
                            dogImage = image
                        case .failure(let failure):
                            break
                        }
                    }
                }
            } label: {
                Text("Fetch Dog Image")
                    .padding()
                    .cornerRadius(8)
            }


        }
        .padding()
    }
}

#Preview {
    ContentView()
}
