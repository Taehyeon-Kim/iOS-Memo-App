//
//  WriteVC.swift
//  iOS-Memo-App
//
//  Created by taehy.k on 2021/01/01.
//

import UIKit
import RealmSwift

//MARK: - Memo Write Protocol
protocol MemoWriteDelegate {
    func writeData(imageUrl: String, title: String, content: String)
}

class WriteVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var memoTitleTextField: UITextField!
    @IBOutlet weak var memoContentTextView: UITextView!
    
    //MARK: - Variables
    var delegate: MemoWriteDelegate?
    var realm: Realm?
    var items: Results<RealmMemo>?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try? Realm()
        
        items = realm?.objects(RealmMemo.self)
    }
    
    // 뒤로 가기 시 자동 저장
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let defaultIamgeUrl = "avatar1"
        let title = memoTitleTextField.text ?? ""
        let content = memoContentTextView.text ?? ""
        
        guard let memoTitle = memoTitleTextField.text, memoTitle.count > 0,
              let memoContent = memoContentTextView.text, memoContent.count > 0 else {
            alert(message: "메모를 입력하세요.")
            return
        }
        try! realm?.write {
            realm?.add(inputData(database: RealmMemo()))
        }
        self.delegate?.writeData(imageUrl: defaultIamgeUrl, title: title, content: content)
        return
        
    }
    
    // Shopping List 객체가 매개변수 및 리턴값
    func inputData(database: RealmMemo) -> RealmMemo {
        if let title = memoTitleTextField.text {
            database.title = title
        }
        
        if let content = memoContentTextView.text {
            database.content = content
        }
        
        return database
    }
    
    // MARK: - IBAction
    // 메모 작성 버튼
    @IBAction func memoWriteButtonClicked(_ sender: Any) {
        
        // 제목, 내용 둘 다 작성되어야 저장 가능, 아니면 경고창
        guard let memoTitle = memoTitleTextField.text, memoTitle.count > 0,
              let memoContent = memoContentTextView.text, memoContent.count > 0 else {
            
            alert(message: "메모를 입력하세요.")
            return
            
        }
        
        self.navigationController?.popViewController(animated: true)
    }

}


//MARK: - Alert extension
extension WriteVC {
    
    func alert(title: String = "알림", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}
