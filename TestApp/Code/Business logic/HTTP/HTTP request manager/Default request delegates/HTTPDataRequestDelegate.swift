//
//  HTTPDataRequestDelegate.swift
//  Portable
//
//  Created by Ivan Erasov on 08.11.16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

open class HTTPDataRequestDelegate: HTTPRequestDelegate, URLSessionDataDelegate {
    
    private var data = Data()

    override public var taskData: Data? { return data }
    
    //MARK: - URLSessionDataDelegate
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.data.append(data)
    }
}
