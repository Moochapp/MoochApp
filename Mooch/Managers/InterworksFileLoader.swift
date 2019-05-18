////
//  InterWorksFileLoader.swift
//  Mooch
//
//  Created by Luke Davis on 5/10/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit

enum InterWorksFileLoaderError: Error {
    case invalidFileName(String)
    case invalidFileURL(URL)
}

class InterWorksFileLoader {
    private let cache: Cache
    private let bundle: Bundle
    
    init(cache: Cache = .init(), bundle: Bundle = .main) {
        self.cache = cache
        self.bundle = bundle
    }
    
    func file(named fileName: String) throws -> File {
        if let file = cache.file(named: fileName) {
            return file
        }
        
        guard let url = bundle.url(forResource: fileName, withExtension: nil) else {
            throw InterWorksFileLoaderError.invalidFileName(fileName)
        }
        
        do {
            let data = try Data(contentsOf: url)
            let file = File(data: data)
            
            cache.cache(file: file, name: fileName)
            
            return file
        } catch {
            throw InterWorksFileLoaderError.invalidFileURL(url)
        }
    }
}





























class Cache {
    func cache(file: File, name: String) {}
    func file(named: String) -> File? {
        return nil
    }
}
class File {
    let data: Data
    init(data: Data) {
        self.data = data
    }
}
