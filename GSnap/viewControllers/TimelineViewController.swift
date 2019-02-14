//
//  TimelineViewController.swift
//  GSnap
//
//  Created by Munesada Yohei on 2019/02/06.
//  Copyright © 2019 Munesada Yohei. All rights reserved.
//

import UIKit

class TimelineViewController : UITableViewController {
    
    // 投稿内容.
    var posts: [Post] = []
    
    let items = [ "りんご", "メロン", "もも", "スイカ", "ぶどう" ]
    
    override func viewDidLoad() {
        self.title = "タイムライン"
        
        // カスタム TableCell を使えるように登録する.
        self.tableView.register(UINib(nibName: "TimelineCell", bundle: nil), forCellReuseIdentifier: "TimelineCell")
    }
    
    // ViewController が表示される時.
    override func viewWillAppear(_ animated: Bool) {
        // タイムラインのデータをサーバーから取得して、画面反映.
        self.fetchData()
    }
    
    // タイムラインのデータをサーバーから取得します.
    private func fetchData() {
        
        // APIコールして、データを取得する.
        Api.getTimeline { (errorMessage, data) in
            
            // エラーがある場合には、アラートで表示する.
            if let message = errorMessage {
                self.showAlert(message: message)
                return
            }
            
            // タイムラインデータを取得したら、変数に格納する.
            if let data = data {
                self.posts = data
                self.tableView.reloadData()
            }
        }
    }
}

extension TimelineViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Cellを取得する.
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineCell", for: indexPath) as! TimelineCell
        
        // 投稿データを設定する（設定したらCell内で表示設定が行われる）.
        cell.post = self.posts[indexPath.row]
        
        // 返却する.
        return cell
    }
}
