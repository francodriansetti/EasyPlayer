//
//  ContentListTableViewController.swift
//  EasyVideoPlayer
//
//  Created by Franco Driansetti on 19/11/2017.
//  Copyright © 2017 Franco Driansetti. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import AFNetworking

class ContentListTableViewController: UITableViewController {
    let cellIdentifier = "content_list_cell"
    
    var movieList:movieModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ContentListCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.clearsSelectionOnViewWillAppear = false
        
        tableView.rowHeight = UITableViewAutomaticDimension
        loadData()
    }
    
    func loadData() {
        APIManager.sharedInstance.getMovieList(viewController: self) { (data) in
            self.movieList = data
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ContentListTableViewCell
        cell.titleLabel.text = movieList?.data?[indexPath.row].movieTitle ?? ""
        
        if let urlExist = URL(string: movieList?.data?[indexPath.row].imageUrl ?? "" ) {
            cell.cellImage?.layer.cornerRadius = 8.0
            cell.cellImage?.clipsToBounds = true
            cell.cellImage?.contentMode = .scaleAspectFill
            cell.cellImage.setImageWith(urlExist, placeholderImage: #imageLiteral(resourceName: "ic_movie_placeholder"))
        }
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList?.data?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerVC: PlayerViewController = storyboard.instantiateViewController(withIdentifier: "player_vc") as! PlayerViewController
        playerVC.urlList =  movieList?.data
        playerVC.currentPosition = indexPath.row
        self.navigationController?.pushViewController(playerVC, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
