//
//  ViewController.swift
//  GSnap
//
//  Created by Munesada Yohei on 2019/02/05.
//  Copyright © 2019 Munesada Yohei. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var idInput: UITextField!
    
    @IBOutlet weak var passwordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // テキストフィールドの delegate を指定.
        self.idInput.delegate = self
        self.passwordInput.delegate = self
        
        // エラーラベルは、初期表示では非表示とする.
        self.errorLabel.isHidden = true
    }

    // ログインボタンがタップされた.
    @IBAction func onTapLogin(_ sender: Any) {
        
        // オプショナルからアンラップする.
        guard let id = self.idInput.text,
            let password = self.passwordInput.text else {
                return
        }
                
        // APIコールしてログインする.
        Api.login(id: id, password: password) { errorMessage in
            
            // 失敗した場合には、エラーを画面に表示する.
            if let message = errorMessage {
                self.errorLabel.isHidden = false
                self.errorLabel.text = message
                return
            }
            
            // 成功した場合には、タイムラインへ移動.
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showTimelineStoryboard()
            }            
            
        }
    }
    
}

// テキストフィールドの Delegate
extension LoginViewController : UITextFieldDelegate {
    
    // エンターキーを押された.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // キーボードを閉じる.
        textField.resignFirstResponder()
        
        // 許可.
        return true
    }
}

