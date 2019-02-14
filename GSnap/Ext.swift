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
