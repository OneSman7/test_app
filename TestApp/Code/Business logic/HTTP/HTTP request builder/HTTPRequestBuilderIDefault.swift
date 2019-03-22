//
//  HTTPRequestBuilderDefault.swift
//  Portable
//
//  Created by Ivan Erasov on 09.12.15.
//  Copyright © 2015. All rights reserved.
//

import Foundation

open class HTTPRequestBuilderDefault: HTTPRequestBuilder {
    
    public var baseURLString: String!
    public var parametersEncoder: HTTPRequestParameterEncoder!
    
    public init() {}
    
    //MARK: - URLRequestBuilder
    
    public func request(with configuration: HTTPRequestConfiguration) -> URLRequest {
        
        var requestUrlString = configuration.urlString
        var url = URL(string: requestUrlString)
        
        //здесь и далее url разименовывается строго (URL(string: requestUrlString)!, url!), чтобы падать при попытках передачи строк, из которых нельзя сделать url
        //мотивация: получение данных все равно будет протестировано самим программистом и он увидит креш, к тому же строки, определяющие методы апи, меняются очень редко
        
        if url?.host == nil && baseURLString != nil {
            requestUrlString = pathFromComponents([baseURLString!, requestUrlString])
            url = URL(string: requestUrlString)!
        }
        
        var mutableURLRequest = URLRequest(url: url!)
        mutableURLRequest.httpMethod = configuration.method
        
        if let httpHeaders = configuration.headers {
            for (headerField, headerValue) in httpHeaders {
                mutableURLRequest.setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
        
        if let queryParameters = configuration.queryStringParameters {
            parametersEncoder.encoding = .url
            mutableURLRequest = parametersEncoder.encode(mutableURLRequest, parameters: queryParameters).0
        }

        let requestParameters = configuration.parameters
        parametersEncoder.encoding = configuration.parametersEncoding
        mutableURLRequest = parametersEncoder.encode(mutableURLRequest, parameters: requestParameters).0
        
        return mutableURLRequest
    }
}
