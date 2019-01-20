//
//  ViewController.swift
//  youtube
//
//  Created by Grisha Stetsenko on 1/17/19.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var videos: [Video] = {
        
        var ddeChannel = Channel()
        ddeChannel.name = "DailyDrivenExotics"
        ddeChannel.profileImageName = "dde_profile"
        
        var wylsacomChannel = Channel()
        wylsacomChannel.name = "Wylsacom"
        wylsacomChannel.profileImageName = "wylsacom_profile"
        
        var lamboUrusVideo = Video()
        lamboUrusVideo.title = "650HP Lamborghini Urus goes off-roading"
        lamboUrusVideo.tumbnailImageName = "lamborghini_urus"
        lamboUrusVideo.chanel = ddeChannel
        lamboUrusVideo.numberOfViews = 1915132352
        
        var macProVideo = Video()
        macProVideo.title = "Apple Mac Pro 2013: unpacking and first impression"
        macProVideo.tumbnailImageName = "mac_pro"
        macProVideo.chanel = wylsacomChannel
        macProVideo.numberOfViews = 1204911311
        
        return [lamboUrusVideo, macProVideo]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false

        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        
        navigationItem.titleView = titleLabel
        
        collectionView.backgroundColor = .white
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "cellId")
        
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        setupMenuBar()
        setupNavBarButtons()
        
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addConstraintsWithFormat("H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat("V:|[v0(50)]", views: menuBar)
    }
    
    private func setupNavBarButtons(){
        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        
        let moreImage = UIImage(named: "more_icon")?.withRenderingMode(.alwaysOriginal)
        let moreBarButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
        
    }
    
    //MARK: - Actions
    @objc func handleSearch() {
        print(123)
    }
    
    @objc func handleMore() {
        print(321)
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
        
        cell.video = videos[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.width - 16 - 16) * 9 / 16
        return CGSize(width: view.frame.width, height: height + 16 + 88)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}



