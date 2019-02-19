//
//  CommentViewController.swift
//  GSnap
//
//  Created by Munesada Yohei on 2019/02/19.
//  Copyright © 2019 Munesada Yohei. All rights reserved.
//

import UIKit

class CommentViewController : UITableViewController {
    
    // 投稿データ.
    var post: Post?
    
    // コメントデータ.
    var comments: [Comment] = []
    
    // 表示する際に呼び出される.
    override func viewDidLoad() {
        
        // タイトル.
        self.title = "コメント一覧"
        
        // コメントを読み込んで、表示する.
        self.loadCommentList()
        
        // ナビゲーション右上に「+」ボタンを追加します.
        let navItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(CommentViewController.onTapAddComment))
        self.navigationItem.setRightBarButton(navItem, animated: true)
    }
    
    // コメント追加ボタンが押された時.
    @objc func onTapAddComment() {
        
        // アラート表示で、コメント入力ができるようにします.
        let alert = UIAlertController(title: "", message: "コメントを入力してください", preferredStyle: .alert)
        // 入力欄を追加.
        alert.addTextField { textField in
            textField.placeholder = "コメント"
        }
        // 投稿ボタンを追加.
        alert.addAction(UIAlertAction(title: "投稿する", style: .default, handler: { action in
            
            // アンラップ.
            guard
                let post = self.post,
                let comment = alert.textFields?[0].text else {
                return
            }
            
            // API経由でコメント追加.
            Api.addComment(postId: post.id, comment: comment) { errorMessage in
                
                // エラーがあれば、表示して終わり.
                if let errorMessage = errorMessage {
                    self.showAlert(message: errorMessage)
                    return
                }
                
                // 最新を読み込んで、画面に反映する.
                self.loadCommentList()
            }
        }))
        
        // キャンセルボタン（何もしない）.
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { _ in }))
        
        // アラート表示.
        self.present(alert, animated: true)
    }
    
    // コメントデータをAPIから取得して、画面に表示する.
    fileprivate func loadCommentList() {
        
        // アンラップ.
        guard let post = self.post else {
            return
        }
        
        // APIコール.
        Api.getComments(postId: post.id) { errorMessage, comments in
            
            // エラーがあれば表示して終わり.
            if let errorMessage = errorMessage {
                self.showAlert(message: errorMessage)
                return
            }
            
            // コメントの一覧を表示する.
            if let comments = comments {
                self.comments = comments
                self.tableView.reloadData()
            }
            
        }
    }
}

// TableView 関連の処理
extension CommentViewController {
    
    // セクション数.
    override func numberOfSections(in tableView: UITableView) -> Int {
        // 1セクション：Postの本文を表示
        // 2セクション：コメント一覧を表示
        return 2
    }
    
    // セクションごとの行数.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Postの本文の場合、1つで固定.
        if section == 0 {
            return 1
        }
        
        // コメント一覧の場合は、コメント数分だけ表示.
        return self.comments.count
    }
    
    // 表示セルの生成.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを生成.
        let cell = UITableViewCell()
        
        // 1セクション目の場合.
        if indexPath.section == 0 {
            cell.textLabel?.text = self.post?.body
        
        } else {
            // 2セクション目の場合は、コメントを表示.
            let comment = self.comments[indexPath.row]
            cell.textLabel?.text = comment.comment
        }
        
        // 返却.
        return cell
    }
}
