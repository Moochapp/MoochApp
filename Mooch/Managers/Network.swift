////
//  Network.swift
//  Mooch
//
//  Created by App Center on 5/5/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
import UIKit

class Network {
    var url: URL?
    
    init(urlString: String) {
        url = URL(string: urlString)
    }
    
    func startTask(completion: @escaping (Data?)->()) {
        guard url != nil else { return }
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard error == nil else {
                completion(nil)
                return
            }
            
            completion(data)
            
        }
        
        task.resume()
    }
}
