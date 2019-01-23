//
//  VideoLauncher.swift
//  youtube
//
//  Created by Grisha Stetsenko on 1/23/19.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {

    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    let pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "pause")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handlePause() {
        if isPlaying() {
            player?.pause()
            pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            player?.play()
            pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        
    }
    
    let controlContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPlayerView()

        controlContainerView.frame = frame
        
        addSubview(controlContainerView)
        
        controlContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        controlContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        backgroundColor = .black
        
    }
    
    var player: AVPlayer?
    
    private func setupPlayerView() {
        let urlString: String = {
            return "https://r6---sn-3c27sn7z.googlevideo.com/videoplayback?requiressl=yes&clen=52446690&c=WEB&source=youtube&ei=aLdIXPODMq-MkAT2-aXIDg&lmt=1544834843713207&ip=181.126.84.96&pl=16&dur=646.118&id=o-AJtCk0UuaRl2HBGoJNHTSSqJgV222he5dvTA5RndJWEv&gir=yes&key=cms1&sparams=clen,dur,ei,expire,gir,id,ip,ipbits,ipbypass,itag,lmt,mime,mip,mm,mn,ms,mv,nh,pl,ratebypass,requiressl,source&expire=1548291016&fvip=1&ratebypass=yes&itag=18&mime=video%2Fmp4&txp=5531432&ipbits=0&signature=0C434A945DE9E255D6DED60B85368BB20D330412.5A4FABDA3569DBC4D88468CFA453B45111514B5A&video_id=WvDeKZGunjY&title=This+Guy+Streamsnipes+%26+Scares+PUBG+Streamers%21+%28Hilarious+PUBG+Jumpscares%29+-+PART+2&rm=sn-upbv2t-5n0l7e,sn-bg0sk76&req_id=6df6535ee3efa3ee&redirect_counter=2&cms_redirect=yes&ipbypass=yes&mip=176.36.193.245&mm=29&mn=sn-3c27sn7z&ms=rdu&mt=1548274187&mv=m&nh=IgpwcjAxLmticDAzKgkxMjcuMC4wLjE"
        }()
        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.frame
            self.layer.addSublayer(playerLayer)
            
            player?.play()
            
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
        }
    }
    
    func isPlaying() -> Bool {
        return player?.rate != 0 && player?.error == nil
    };
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // this is when the player is ready and rendering frames
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlContainerView.backgroundColor = .clear
            pausePlayButton.isHidden = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoLauncher: NSObject {
    
    func showVideoPlayer() {

        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = .white
            
            view.frame = CGRect(x: 0,
                                y: keyWindow.frame.height,
                                width: keyWindow.frame.width,
                                height: 1)
            
            // 16x9 is the aspect of ratio of all HD videos
            let height = keyWindow.frame.width / 16 * 9
            
            let videoPlayerRect = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            
            let videoPlayerView = VideoPlayerView(frame: videoPlayerRect)
            view.addSubview(videoPlayerView)
            
            keyWindow.addSubview(view)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                view.frame = keyWindow.frame
                
            }) { (completedAnimation ) in
                // maybe we'll do something here later.
                keyWindow.windowLevel = UIWindow.Level.statusBar
                
            }
        }

    }
    
}
