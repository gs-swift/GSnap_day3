//
//  PostViewController.swift
//  GSnap
//
//  Created by Munesada Yohei on 2019/02/14.
//  Copyright © 2019 Munesada Yohei. All rights reserved.
//

import UIKit

class PostViewController : UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        
        // タイトルを指定.
        self.title = "投稿"
        
        // textView の Delegate 設定.
        self.textView.delegate = self        
    }
    
    // 「カメラを起動する」がタップされた.
    @IBAction func onTapCamera(_ sender: Any) {
        
        // カメラが起動できるかをチェックします.
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            self.showAlert(message: "カメラは利用できません")
            return
        }
        
        // カメラを起動します.
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        self.present(picker, animated: true)
        
    }
    
    // 「写真を選ぶ」がタップされた.
    @IBAction func onTapPhoto(_ sender: Any) {
        
        // アルバムが利用可能かをチェックします.
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == false {
            self.showAlert(message: "アルバムは利用できません。")
            return
        }
        
        // アルバムを起動します.
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    // 「投稿する」がタップされた.
    @IBAction func onTapPost(_ sender: Any) {
        
        // 投稿画像を取得します.
        guard let image = self.userImageView.image else {
            return
        }
        
        // 投稿本文を取得します.
        guard let text = self.textView.text else {
            return
        }
        
        // ローディングを開始します.
        self.showProgress()
        
        // APIで投稿します.
        Api.post(image: image, text: text) { errorMessage in
            
            // APIが終わったら、ローディングを削除します.
            self.hideProgress()
            
            // エラーがあれば表示します.
            if let errorMessage = errorMessage {
                self.showAlert(message: errorMessage)
                return
            }
            
            // 成功したらそれを通知します.
            self.showAlert(message: "投稿しました。")
            
            // タイムラインに遷移する.
            self.navigationController?.tabBarController?.selectedIndex = 0
        }
    }
    
    
}

// TextView の Delegate.
extension PostViewController : UITextViewDelegate {
    
    // 文字が入力された.
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // 改行だったら、キーボードを閉じる.
        if text == "\n" {
            self.textView.resignFirstResponder()
            return false
        }
        
        // 改行以外は、入力を許可.
        return true
    }
}

// UIImagePickerController で必要なので実装します（具体的な処理は不要なので中身はない）.
extension PostViewController: UINavigationControllerDelegate {}

// カメラまたは写真で、画像が選択された時などの処理を実装する.
extension PostViewController: UIImagePickerControllerDelegate {

    // カメラまたは写真で、画像が選択された.
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // ピッカーを閉じる.
        picker.dismiss(animated: true, completion: nil)
        
        // ユーザーが撮影した or 選んだ、画像を取得する.
        if let image = info[.originalImage] as? UIImage {
            
            // このアプリでは、正方形に勝手にクロップする.
            let croppedImage = self.cropRect(image: image)
            
            // 画面に表示する.
            self.userImageView.image = croppedImage
        }
    }
}

// ユーティリティ系.
extension PostViewController {
    
    // 画像を正方形にクロップする.
    private func cropRect(image: UIImage) -> UIImage {
        
        // 加工対象の画像.
        var image = image
        
        // 天地が反転している場合があるので、対応しておく.
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        if let _image = UIGraphicsGetImageFromCurrentImageContext() {
            image = _image
        }
        UIGraphicsEndImageContext()
        
        // 正方形にクロップする.
        if image.size.width != image.size.height {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var w = image.size.width
            var h = image.size.height
            if w > h {
                // 横長の場合.
                x = (w - h) / 2
                w = h
            } else {
                // 縦長の場合.
                y = (h - w) / 2
                h = w
            }
            let cgImage = image.cgImage?.cropping(to: CGRect(x: x, y: y, width: w, height: h))
            image = UIImage(cgImage: cgImage!)
        }
        
        // サイズが大きすぎても困るので、小さくしておく.
        let newSize = CGSize(width: 720, height: 720)
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        if let _image = UIGraphicsGetImageFromCurrentImageContext() {
            image = _image
        }
        UIGraphicsEndImageContext()
        
        // 返却する.
        return image
    }
}
