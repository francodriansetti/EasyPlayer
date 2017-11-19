//
//  PlayerViewController.swift
//  EasyVideoPlayer
//
//  Created by Franco Driansetti on 19/11/2017.
//  Copyright © 2017 Franco Driansetti. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
class PlayerViewController: UIViewController {
    // Player container view
    @IBOutlet weak var containerView: UIView!
    
    // Control button
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextbutton: UIButton!
    
    // Movie status
    @IBOutlet weak var timeProgress: UIProgressView!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var timeLast: UILabel!
    @IBOutlet weak var vieoTitle: UILabel!
    
    private var playerViewController: AVPlayerViewController = AVPlayerViewController()
    public var urlList:[movieItemModel]?
    public var currentPosition = 0
    var timer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAndPlayMovie(withUrl: urlList?[currentPosition].videoUrl ?? "")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        stop()
    }
    
    func setupAndPlayMovie(withUrl:String)
    {
        playerViewController.player = nil
        
        if let urlExist = URL(string: withUrl) {
            playerViewController = AVPlayerViewController()
            playerViewController.player = AVPlayer(url: urlExist)
            playerViewController.showsPlaybackControls = false
            playerViewController.view.frame = (containerView.bounds)
            containerView.addSubview(playerViewController.view)
            vieoTitle.text = urlList?[currentPosition].movieTitle
            play()
            
            playerViewController.player?.isMuted = false
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
            
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerViewController.player?.currentItem, queue: nil, using: { (_) in
                DispatchQueue.main.async {
                    self.pause()
                    self.playerViewController.player?.seek(to: kCMTimeZero)
                    self.currentTime.text = "00:00"
                    self.timeLast.text =  "00:00"
                    self.timeProgress.progress = 0.0
                }
            })
        } else {
            // TODO: handle message
        }
    }
    
    // MARK: Button delegate
    
    @IBAction func playPressed(_ sender: Any)
    {
        if playerViewController.player?.rate == 0.0 {
            play()
        } else {
            pause()
        }
    }
    
    @IBAction func previousItemPressed(_ sender: Any) {
        let newPosition = currentPosition - 1
        
        if newPosition >= 0 {
            setupAndPlayMovie(withUrl: urlList?[newPosition].videoUrl ?? "")
            vieoTitle.text = urlList?[newPosition].movieTitle
            currentPosition = newPosition
        }
    }
    
    @IBAction func nextItemPressed(_ sender: Any) {
        let newPosition = currentPosition + 1
        
        if let countExit = urlList?.count, newPosition < countExit {
            setupAndPlayMovie(withUrl: urlList?[newPosition].videoUrl ?? "")
            vieoTitle.text = urlList?[newPosition].movieTitle
            currentPosition = newPosition
        }
    }
    
    // MARK: Player utility
    
    @objc func updateTime() {
        // Access current item
        
        if let currentItem = playerViewController.player?.currentItem {
            // Get the current time in seconds
            let playhead = currentItem.currentTime().seconds
            let duration = currentItem.duration.seconds
            
            // Format seconds for human readable string
            currentTime.text = formatTime(timeInterval: playhead)
            timeLast.text = formatTime(timeInterval: duration - playhead)
            timeProgress.progress = Float(playhead / duration)
        }
    }
    
    func formatTime(timeInterval:TimeInterval?) -> String{
        guard let timeIntervalExist = timeInterval, timeIntervalExist > 0 else {
            return "-:--"
        }
        
        let hh = Int(timeIntervalExist / 3600)
        let mm = Int((timeIntervalExist.truncatingRemainder(dividingBy: 3600)) / 60)
        let ss = Int(timeIntervalExist.truncatingRemainder(dividingBy: 60))
        
        if hh > 0 {
            return String.localizedStringWithFormat("%0d:%02d:%02d", hh, mm, ss)
        } else {
            return String.localizedStringWithFormat("%02d:%02d", mm, ss)
        }
    }
    
    func play()
    {
        playerViewController.player?.play()
        playButton.setImage(#imageLiteral(resourceName: "ic_pause"), for: .normal)
    }
    
    func pause()
    {
        playButton.setImage(#imageLiteral(resourceName: "ic_play"), for: .normal)
        playerViewController.player?.pause()
    }
    
    func stop() {
        timer = nil
        playerViewController.player?.rate = 0.0
        playerViewController.player = nil
    }
}
