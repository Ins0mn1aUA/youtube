//
//  VideoLauncher.swift
//  youtube
//
//  Created by Grisha Stetsenko on 1/23/19.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        let urlString = "https://r1---sn-upbv2t-5n0l.googlevideo.com/videoplayback?txp=5535432&key=yt6&c=WEB&mt=1548269287&requiressl=yes&sparams=dur%2Cei%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Cratebypass%2Crequiressl%2Csource%2Cexpire&expire=1548291016&fvip=1&mv=m&source=youtube&ms=au%2Crdu&ratebypass=yes&ei=aLdIXPODMq-MkAT2-aXIDg&lmt=1544839363552919&ip=181.126.84.96&pl=21&itag=22&dur=646.118&initcwndbps=577500&mime=video%2Fmp4&mn=sn-upbv2t-5n0l%2Csn-bg0ezn7z&mm=31%2C29&id=o-AJtCk0UuaRl2HBGoJNHTSSqJgV222he5dvTA5RndJWEv&ipbits=0&signature=CE85848C29B648A9DA1A55DAF210DC0B6DA36074.16B7C4271A63D6E6ECCAD44C6E8360F135C1D2D4&video_id=WvDeKZGunjY&title=This+Guy+Streamsnipes+%26+Scares+PUBG+Streamers%21+%28Hilarious+PUBG+Jumpscares%29+-+PART+2"
        
        if let url = URL(string: urlString) {
            let player = AVPlayer(url: url)
            
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.frame
            self.layer.addSublayer(playerLayer)
            
            player.play()
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
