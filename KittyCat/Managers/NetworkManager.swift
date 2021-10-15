//
//  NetworkManager.swift
//  KittyCat
//
//  Created by Антон Усов on 12.10.2021.
//

import UIKit


class NetworkManager {
    
    func getCats(completion: @escaping ([Cat]) -> Void) {
        
        var cats: [Cat] = []
        
        let catsQuantity = 20
        
        let urlString = "https://api.thecatapi.com/v1/images/search?limit=\(catsQuantity)"
        
        let api_key = "49f109ce-cee1-4a43-ac7f-5348650a2615"
        
        var index = 0
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.setValue(api_key, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode([URLAddress].self, from: data)
                
                for i in result {
                    let newUrl = i.url
                    
                    self?.getPhoto(url: newUrl) { (newCat) in
                        
                        cats.append(newCat)
                        index += 1
                        
                        if index == catsQuantity {
                            DispatchQueue.main.async {
                                completion(cats)
                            }
                        }
                    }
                }
            }
            catch {
                print(error)
            }
        }.resume()
    }
    
    private func getPhoto(url: String, completion: @escaping (Cat) -> Void) {
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            let cat = Cat()
            cat.image = data
            
            completion(cat)
        }.resume()
    }
}
