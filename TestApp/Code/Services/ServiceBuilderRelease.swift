//
//  ServiceBuilderRelease.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation

class ServiceBuilderRelease: ServiceBuilder {
    
    func configureBaseNetworkService(with service: BaseNetworkService, baseUrl: String, sessionDelegate: HTTPSessionDelegate = HTTPSessionDelegate()) {
        
        service.requestBuilder = HTTPRequestBuilderDefault()
        service.requestBuilder.baseURLString = baseUrl
        service.requestBuilder.parametersEncoder = HTTPRequestParameterEncoderDefault()
        
        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.timeoutIntervalForRequest = networkingTimeoutIntervalForRequest
        urlSessionConfiguration.timeoutIntervalForResource = networkingTimeoutIntervalForResource
        
        service.responseMapper = JsonResourceMapperImplementation()
        service.urlSessionConfiguration = urlSessionConfiguration
        
        service.requestManager = HTTPRequestManagerDefault(with: service.urlSessionConfiguration, and: sessionDelegate)
    }
    
    //MARK: - ServiceBuilder
    
    lazy var fileDownloadManager: FileDownloadManager = {
        
        let manager = FileDownloadManagerImplementation()
        manager.urlSessionConfiguration = URLSessionConfiguration.default
        manager.requestManager = HTTPRequestManagerDefault(with: manager.urlSessionConfiguration, and: manager)
        
        return manager
    }()
    
    lazy var defaultFileCacheManager: FileCacheManager = {
        
        let configuration = FileCacheConfiguration()
        let manager = FileCacheManagerImplementation(with: configuration)
        
        return manager
    }()
    
    func getITunesService() -> iTunesService {
        
        let itunesService = iTunesServiceImplementation()
        configureBaseNetworkService(with: itunesService, baseUrl: baseUrlStringITunesAPI)
        
        return itunesService
    }
    
    func getLastFmService() -> LastFmService {
        
        let lastfmService = LastFmServiceImplementation()
        configureBaseNetworkService(with: lastfmService, baseUrl: baseUrlStringLastFmAPI)
        
        return lastfmService
    }
}
