//
//  SettingsLauncher.swift
//  youtube
//
//  Created by Grisha Stetsenko on 1/21/19.
//

import UIKit

class Setting: NSObject {
    let name: settingName
    let imageName: settingImageName
    
    init(name: settingName, imageName: settingImageName) {
        self.name = name
        self.imageName = imageName
    }
}

enum settingName: String {
    case Settings = "Settings"
    case TermsPrivacy = "Terms & privacy policy"
    case SendFeedback = "Send FeedBack"
    case Help = "Help"
    case SwitchAccount = "Switch Account"
    case Cancel = "Cancel"
}

enum settingImageName: String {
    case Settings = "settings"
    case TermsPrivacy = "privacy"
    case SendFeedback = "feedback"
    case Help = "help"
    case SwitchAccount = "switch_account"
    case Cancel = "cancel"
}

class SettingsLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    let cellId = "cellId"
    let cellHeight: CGFloat = 50
    
    let settings: [Setting] = {
         return [Setting(name: .Settings, imageName: .Settings),
                 Setting(name: .TermsPrivacy, imageName: .TermsPrivacy),
                 Setting(name: .SendFeedback, imageName: .SendFeedback),
                 Setting(name: .Help, imageName: .Help),
                 Setting(name: .SwitchAccount, imageName: .SwitchAccount),
                 Setting(name: .Cancel, imageName: .Cancel)]
    }()
    
    var homeController: HomeController?
    
    @objc func showSettings() {
        //show menu
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            let height: CGFloat = CGFloat(settings.count) * cellHeight
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0,
                                          y: window.frame.height,
                                          width: window.frame.width,
                                          height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0,
                                                   y: y,
                                                   width: self.collectionView.frame.width,
                                                   height: self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    
    @objc func handleDismiss(setting: Setting) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0,
                                                   y: window.frame.height,
                                                   width: self.collectionView.frame.width,
                                                   height: self.collectionView.frame.height)
            }
            
        }) { (completed: Bool) in
            
            if setting.name != .Cancel {
                self.homeController?.showControllerForSetting(setting: setting)
            }
            
        }
    }
    
    //MARK: Collection view delegate / data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        
        let setting = settings[indexPath.item]
        cell.setting = setting
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let setting = self.settings[indexPath.item]
        handleDismiss(setting: setting)
    }
    
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingCell.self,  forCellWithReuseIdentifier: cellId)
    }
}
