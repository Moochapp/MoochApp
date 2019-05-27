////
//  Future.swift
//  Mooch
//
//  Created by App Center on 5/22/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation

//enum Result<Value> {
//    case value(Value)
//    case error(Error)
//}
//
//class Future<Value> {
//    fileprivate var result: Result<Value>? {
//        didSet { result.map(report) }
//    }
//    private lazy var callbacks = [(Result<Value>) -> Void]()
//    
//    func observe(with callback: @escaping (Result<Value>) -> Void) {
//        callbacks.append(callback)
//        result.map(callback)
//    }
//    
//    private func report(result: Result<Value>) {
//        for callback in callbacks {
//            callback(result)
//        }
//    }
//}
//
//class Promise<Value>: Future<Value> {
//    init(value: Value? = nil) {
//        super.init()
//        result = value.map(Result.value)
//    }
//    
//    func resolve(with value: Value) {
//        result = .value(value)
//    }
//    
//    func reject(with error: Error) {
//        result = .error(error)
//    }
//}
