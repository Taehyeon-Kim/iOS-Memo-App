//
//  ViewController.swift
//  iOS-Memo-App
//
//  Created by taehy.k on 2021/01/01.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    var memoList: [Memo] = [
        Memo(imageUrl: "avatar1", title: "메모", content: "내용", isOn: false),
        Memo(imageUrl: "avatar2", title: "메모", content: "내용", isOn: false),
        Memo(imageUrl: "avatar1", title: "메모", content: "내용", isOn: false),
        Memo(imageUrl: "avatar2", title: "메모", content: "내용", isOn: false),
        Memo(imageUrl: "avatar1", title: "메모", content: "내용", isOn: false),
        Memo(imageUrl: "avatar2", title: "메모", content: "내용", isOn: false),
        Memo(imageUrl: "avatar1", title: "메모", content: "내용", isOn: false),
        Memo(imageUrl: "avatar2", title: "메모", content: "내용", isOn: false),
        Memo(imageUrl: "avatar1", title: "메모", content: "내용", isOn: false),
        Memo(imageUrl: "avatar2", title: "메모", content: "내용", isOn: false),
        Memo(imageUrl: "avatar1", title: "메모", content: "내용", isOn: false),
        Memo(imageUrl: "avatar2", title: "메모", content: "내용", isOn: false),
        Memo(imageUrl: "avatar1", title: "메모", content: "내용", isOn: false),
        Memo(imageUrl: "avatar2", title: "메모", content: "내용", isOn: false),
        Memo(imageUrl: "avatar1", title: "메모", content: "내용", isOn: false),
        Memo(imageUrl: "avatar2", title: "메모", content: "내용", isOn: false),
        Memo(imageUrl: "avatar1", title: "메모", content: "내용", isOn: false),
        Memo(imageUrl: "avatar2", title: "메모", content: "내용", isOn: false),
        Memo(imageUrl: "avatar1", title: "메모", content: "내용", isOn: false),
        Memo(imageUrl: "avatar2", title: "메모", content: "내용", isOn: false),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView delegate 선언
        tableView.delegate = self
        tableView.dataSource = self
    }


}


// MARK: - TableViewDataSource
extension HomeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        
        cell.index = indexPath.row
        cell.delegate = self
        
        cell.memoImageLabel.image = UIImage(named: memoList[indexPath.row].imageUrl ?? "")
        cell.memoTitleLabel.text = memoList[indexPath.row].title
        cell.memoContentLabel.text = memoList[indexPath.row].content

        if memoList[indexPath.row].isOn == true {
            cell.isClicked = true
        } else {
            cell.isClicked = false
        }
    
        return cell
        
    }
    
}

// MARK: - TableViewDelegate
extension HomeVC: UITableViewDelegate {
    
}


// MARK: - TableViewCellDelegate
extension HomeVC: MemoTableViewCellDelegate {
    
    func selectedToggleButton(index: Int) {
        memoList[index].isOn = !memoList[index].isOn
    }
    
}
