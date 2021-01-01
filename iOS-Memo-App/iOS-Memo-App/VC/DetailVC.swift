//
//  DetailVC.swift
//  iOS-Memo-App
//
//  Created by taehy.k on 2021/01/01.
//

import UIKit

class DetailVC: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var memoImageView: UIImageView!
    @IBOutlet weak var memoTitleLabel: UITextField!
    @IBOutlet weak var memoContentTextView: UITextView!
    
    //MARK: - Variables
    var memo: Memo?
    var index: Int = 0 //index
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        memoImageView.image = UIImage(named: memo?.imageUrl ?? "avatar7")
        memoTitleLabel.text = memo?.title
        memoContentTextView.text = memo?.content

    }
    
}
