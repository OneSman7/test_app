//
//  LastFmServiceImplementation.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import Foundation

class LastFmServiceImplementation: BaseNetworkService, LastFmService {
    
    func searchMusicTracks(with query: String, completion: @escaping LastFmMultipleMusicTrackResultHandler) -> HTTPRequest {
        
        var configuration = HTTPRequestConfiguration(withMethod: HTTPMethod.GET.rawValue, andUrlString: String())
        configuration.parameters = [
            "method" : "track.search",
            "api_key" : lastFmAPIIdentifier,
            "format" : "json",
            "track" : query
        ]
        
        var urlRequest = requestBuilder.request(with: configuration)
        
        let request = requestManager.perform(dataRequest: urlRequest)
            .validate(acceptableStatusCodes: [200])
            .validate(acceptableContentTypes: [HTTPRequestContentType.json.rawValue])
            .responseJson(responseHandler: { [weak self] parsingResult in
                
                guard let strongSelf = self else {return}
                
                var result: LastFmMultipleMusicTrackResult
                
                defer {
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
                
                switch parsingResult {
                    
                case .success(let json):
                    
                    guard let response = json as? NSDictionary else {
                        result = .failure(error: HTTPRequestError.jsonMappingNotExpectedStructure)
                        return
                    }
                    
                    guard let resultsJson = response["results", "trackmatches", "track"] as? [NSDictionary] else {
                        result = .failure(error:HTTPRequestError.jsonMappingNotExpectedStructure)
                        return
                    }
                    
                    let tracks = strongSelf.responseMapper.mapJsonAsArray(resultsJson, ofResourcesOfType: MusicTrackLastFm.self)
                    result = .success(tracks: tracks)
                    
                case .failure(let error):
                    result = .failure(error: error)
                }
            })
        
        return request
    }
}
