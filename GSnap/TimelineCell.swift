//
//  TimelineCell.swift
//  GSnap
//
//  Created by Munesada Yohei on 2019/02/14.
//  Copyright © 2019 Munesada Yohei. All rights reserved.
//

import UIKit

class TimelineCell : UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var bodyLabel: UILabel!
    
    // 投稿データ.
    var post: Post? {
        
        // 値がセットされたら
        didSet {
            
            // 値がなければそれで終わり.
            guard let post = post else {
                return
            }
            
            // 投稿画像を読み込むまでは、ダミーを表示することとする.
            self.photoImageView.image = UIImage(named: "default")
            
            // ユーザー名.
            self.userNameLabel.text = post.user.name
            
            // ユーザーアバター画像.
            self.avatarImageView.downloadedFrom(path: post.user.avatar_url)
            
            // 投稿画像.
            self.photoImageView.downloadedFrom(path: post.image_url)
            
            // 投稿本文.
            self.bodyLabel.text = post.body
        }
    }
}
