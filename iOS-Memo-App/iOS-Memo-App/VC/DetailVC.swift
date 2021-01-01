//
//  DetailVC.swift
//  iOS-Memo-App
//
//  Created by taehy.k on 2021/01/01.
//

import UIKit

//MARK: - Memo Write Protocol
protocol MemoUpdateDelegate {
    func updateData(index: Int, imageUrl: String, title: String, content: String)
}

class DetailVC: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var memoImageView: UIImageView!
    @IBOutlet weak var memoTitleLabel: UITextField!
    @IBOutlet weak var memoContentTextView: UITextView!
    
    //MARK: - Variables
    var memo: Memo?
    var index: Int = 0 //index
    var delegate: MemoUpdateDelegate?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        memoContentTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        memoImageView.image = UIImage(named: memo?.imageUrl ?? "avatar7")
        memoTitleLabel.text = memo?.title
        memoContentTextView.text = memo?.content
        
        memoTitleLabel.addTarget(self, action: #selector(memoTitleLabelClicked), for: .touchDown)
    }

    
    //MARK: - Custom Function
    @objc func memoTitleLabelClicked(textField: UITextField){

        // 수정하려고 하면 네비바에 수정 버튼 추가
        let complete = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.compose, target: self, action: #selector(completeTapped))
        self.navigationItem.rightBarButtonItems = [complete]
        self.navigationItem.title = "메모 수정하기"
    }
    
    @objc func completeTapped() {
        let imageUrl = memo?.imageUrl ?? "avatar5"

        guard let memoTitle = memoTitleLabel.text, memoTitle.count > 0,
              let memoContent = memoContentTextView.text, memoContent.count > 0 else {
            alert(message: "메모를 입력하세요")
            return
        }
        
        self.delegate?.updateData(index: self.index, imageUrl: imageUrl, title: memoTitle, content: memoContent)
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - Text View Delegate
extension DetailVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // 수정하려고 하면 네비바에 수정 버튼 추가
        let complete = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.compose, target: self, action: #selector(completeTapped))
        self.navigationItem.rightBarButtonItems = [complete]
        self.navigationItem.title = "메모 수정하기"
    }
    
}

//MARK: - Alert extension
extension DetailVC {
    func alert(title: String = "알림", message: String) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
}


