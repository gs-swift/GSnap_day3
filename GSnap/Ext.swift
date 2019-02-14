//
//  Ext.swift
//  GSnap
//
//  Created by Munesada Yohei on 2019/02/06.
//  Copyright © 2019 Munesada Yohei. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // アラートを手軽に出せるように、拡張します.
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        })
        self.present(alert, animated: true)
    }
    
    // ローディングを表示します.
    func showProgress() {
        
        // ローディングを作成します.
        let indicator = UIActivityIndicatorView()
        
        // サイズを指定します.
        indicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        // 表示位置は画面中央とします.
        indicator.center = self.view.center
        
        // tag番号を指定します（ローディングを消す際に利用します、適当な値でOK）.
        indicator.tag = 123
        
        // 表示します.
        self.view.addSubview(indicator)
        
        // アニメーションを開始します.
        indicator.startAnimating()
    }
    
    // ローディングを削除します.
    func hideProgress() {
        
        // tag をキーにローディングのビューを取得します.
        if let indicator = self.view.viewWithTag(123) {
            
            // ビューから削除します.
            indicator.removeFromSuperview()
        }
    }
    
}

// UIImageViewの拡張.
extension UIImageView {
    
    // 指定URLから画像をダウンロードして、表示します（ダウンロード先を文字列で指定）.
    func downloadedFrom(path: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        
        // http:// から始まるフルパスにする.
        let urlString = apiRoot + path
        
        guard let url = URL(string: urlString) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }

    // 指定URLから画像をダウンロードして、表示します.
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        // ダウンロード先にリクエストを発行します.
        URLSession.shared.dataTask(with: url) { data, response, error in
            // 正しくHTTP通信ができたことを確認します.
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                // メインスレッドで、表示する画像の更新を行います.
                self.image = image
            }
            }.resume()
    }
}
