//
//  VideoLauncher.swift
//  youtube
//
//  Created by Grisha Stetsenko on 1/23/19.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    var player: AVPlayer?
    var isControlsActive = true
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    let controlContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "pause")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        return button
    }()
    
    lazy var videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        
        return slider
    }()
    
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
         return label
    }()
    
    //MARK: - Actions
    @objc func handlePause() {
        if isPlaying() {
            player?.pause()
            pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            player?.play()
            pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
    }
    
    @objc func handleSliderChange() {
        print(videoSlider.value)
        
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSlider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                // do something here maybe
            })
        }
    }
    
    @objc func handleHideControlMenu() {
        pausePlayButton.isHidden = isControlsActive
        videoSlider.isHidden = isControlsActive
        currentTimeLabel.isHidden = isControlsActive
        videoLengthLabel.isHidden = isControlsActive
        
        
        isControlsActive = !isControlsActive
    }
    
    private func setupPlayerView() {
        let urlString: String = {
            return "https://r15---sn-3c27sn7e.googlevideo.com/videoplayback?source=youtube&signature=68931055FECD9C58BE57012555371DD97314FB4E.4AC72FF6F493537DF23E9F6115486F59DA1CD9BB&requiressl=yes&mime=video%2Fmp4&clen=20907280&itag=18&ip=5.58.167.211&pl=16&ei=x4JQXNaGN9rE7QSMooCwCw&txp=5531432&gir=yes&sparams=clen,dur,ei,expire,gir,id,ip,ipbits,ipbypass,itag,lmt,mime,mip,mm,mn,ms,mv,nh,pl,ratebypass,requiressl,source&ratebypass=yes&fvip=15&c=WEB&id=o-AJQP8GMsd3yjoM8KL0WtPoljV3EL5PCWFqImmGwJWUco&ipbits=0&lmt=1540661473071949&key=cms1&expire=1548801832&dur=253.933&video_id=wTcNtgA6gHs&title=GoPro+HERO4-+The+Adventure+of+Life+in+4K&rm=sn-a5oxu-uoae7l,sn-3c2eee6&req_id=ab58cca6490ea3ee&redirect_counter=2&cms_redirect=yes&ipbypass=yes&mip=176.36.193.245&mm=29&mn=sn-3c27sn7e&ms=rdu&mt=1548782396&mv=m&nh=IgpwcjAxLmticDAzKgkxMjcuMC4wLjE"
        }()
        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.frame
            self.layer.addSublayer(playerLayer)
            player?.play()
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
            //track player progress
            
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
                
                let seconds = CMTimeGetSeconds(progressTime)
                let secondsString = String(format: "%02d", Int(seconds) % 60)
                let minutesString = String(format: "%02d", Int(seconds) / 60)
                
                self.currentTimeLabel.text = "\(minutesString):\(secondsString)"
                
                //move the slider thumb
                if let duration = self.player?.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    
                    self.videoSlider.value = Float(seconds / durationSeconds)
                }
            })
            
        }
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.8, 1.3]
        
        controlContainerView.layer.addSublayer(gradientLayer)
    }
    
    private func isPlaying() -> Bool {
        return player?.rate != 0 && player?.error == nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // this is when the player is ready and rendering frames
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlContainerView.backgroundColor = .clear
            pausePlayButton.isHidden = false
            
            if let duration = player?.currentItem?.duration {
                let seconds = Int(CMTimeGetSeconds(duration))
                let secondsText = seconds % 60
                let minutesText = String(format: "%02d", seconds / 60)
                videoLengthLabel.text = "\(minutesText):\(secondsText)"
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPlayerView()
        
        setupGradientLayer()
        
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
        
        controlContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 45).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlContainerView.addSubview(currentTimeLabel)
        currentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 45 ).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlContainerView.addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleHideControlMenu))
        controlContainerView.addGestureRecognizer(gestureRecognizer)
        
        
        
        backgroundColor = .black
        
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
                
            }) { (completedAnimation) in
                // maybe we'll do something here later.
                keyWindow.windowLevel = UIWindow.Level.statusBar
                
            }
        }

    }
}
