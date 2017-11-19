//
//  APIManager.swift
//  EasyVideoPlayer
//
//  Created by Franco Driansetti on 19/11/2017.
//  Copyright © 2017 Franco Driansetti. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import MBProgressHUD

class APIManager: NSObject {
    let jsonUrl = "https://api.myjson.com/bins/hyfyv"
    static let sharedInstance = APIManager()
    
    func getMovieList(viewController:UIViewController, completion: @escaping (_ response: movieModel?) -> Void) {
        MBProgressHUD.showAdded(to: viewController.view, animated: true);
        Alamofire.request(jsonUrl, method: .get, parameters: nil, headers: nil).validate().responseObject { (response: DataResponse<movieModel>) in
            MBProgressHUD.hide(for: viewController.view, animated: true)
            completion(response.result.value)
        }
    }
}
