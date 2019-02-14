//
//  MyPageViewController.swift
//  GSnap
//
//  Created by Munesada Yohei on 2019/02/14.
//  Copyright © 2019 Munesada Yohei. All rights reserved.
//

import UIKit

class MyPageViewController : UICollectionViewController {
    
    // 自分が投稿した一覧.
    var posts: [Post] = [] {
        
        didSet {
            // 値がセットされたら、表示を更新する.
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "マイページ"
    }
    
    // 画面が表示される時.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // データを取得します.
        self.fetchData()
    }
    
}

extension MyPageViewController {
    
    // セクション数を返します.
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 各セクションに含まれるアイテム数を返します.
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    // 表示する Cell を返します.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 「Identifier = cell」を指定し、Storyboard上でカスタマイズしたセルを取得します.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        // Storyboard上で指定した「tag = 1」を使い、セル上にある UIImageView を取得します.
        if let imageView = cell.viewWithTag(1) as? UIImageView {
            imageView.downloadedFrom(path: posts[indexPath.row].image_url)
        }
        
        // セルを返却します.
        return cell
        
    }
}

// UICollectionViewのデザインレイアウトを指定する.
extension MyPageViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 画面横幅の1/2にする（=2カラム表示とする）.
        let width = self.view.bounds.size.width / 2
        
        // セルのサイズを返却する.
        return CGSize(width: width, height: width)
    }

}


extension MyPageViewController {
    
    // APIからタイムラインを取得し、自分の投稿のみに絞り込みます.
    private func fetchData() {
        
        // APIからタイムラインデータを取得します.
        Api.getTimeline { (errorMessage, posts) in
            
            // エラーがあったら、それを通知して終わり.
            if let errorMessage = errorMessage {
                self.showAlert(message: errorMessage)
                return
            }
            
            // API結果を取得します.
            guard let posts = posts else {
                return
            }
            
            // 自分のユーザーIDを取得.
            let userId = UserDefaults.standard.integer(forKey: "userId")
            
            // 自分の投稿に絞って、表示対象とする.
            self.posts = posts.filter({ post -> Bool in
                return post.user.id == userId
            })
        }
    }
}
