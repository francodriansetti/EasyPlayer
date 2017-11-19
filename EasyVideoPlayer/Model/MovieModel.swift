//
//  MovieModel.swift
//  EasyVideoPlayer
//
//  Created by Franco Driansetti on 19/11/2017.
//  Copyright © 2017 Franco Driansetti. All rights reserved.
//

import Foundation
import ObjectMapper

class movieModel: Mappable {
    var data:[movieItemModel]?
    var movieUrl:String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        data <- map["data"]
    }
}

class movieItemModel: Mappable {
  
    var videoUrl:String?
    var imageUrl:String?
    var movieTitle:String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        videoUrl <- map["videoUrl"]
        imageUrl <- map["imageUrl"]
        movieTitle <- map["movieTitle"]
    }
}
