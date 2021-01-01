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
    ]

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView delegate 선언
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        // view가 다시 나타날때 tableview 데이터 리로드
        tableView.reloadData()
    }

    //MARK: - Prepare (write To Home)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // WriteVC의 권한을 뷰컨에 위임
        if segue.identifier == "writeToHome" {
            if let writeVC = segue.destination as? WriteVC {
                writeVC.delegate = self
            }
        }
        
        // DetailVC의 권한을 뷰컨에 위임
        else if segue.identifier == "homeToDetail" {
            if let detailVC = segue.destination as? DetailVC {
                if let cell = sender as? MemoTableViewCell, let indexPath = tableView.indexPath(for: cell) {

                    detailVC.delegate = self
                    detailVC.index = indexPath.row
                    detailVC.memo = self.memoList[indexPath.row]
                    
                }
                
            }
        }
        
    }
}


// MARK: - TableView DataSource
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

// MARK: - TableView Delegate
extension HomeVC: UITableViewDelegate {
    
    // 왼쪽 스와이프
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pinAction = UIContextualAction(style: .normal, title: "고정", handler: { (ac:UIContextualAction, UIView, success: (Bool) -> Void) in
            
        })
        
        return UISwipeActionsConfiguration(actions: [pinAction])
    }
    
    
    // 오른쪽 스와이프
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제", handler: { (ac:UIContextualAction, UIView, success: (Bool) -> Void) in
            self.memoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        })
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}


// MARK: - TableViewCellDelegate
extension HomeVC: MemoTableViewCellDelegate {
    
    func selectedToggleButton(index: Int) {
        memoList[index].isOn = !memoList[index].isOn
    }
    
}

// MARK: - Memo Write Delegate
extension HomeVC: MemoWriteDelegate {
    
    // 작성한 메모 데이터 전달
    func writeData(imageUrl: String, title: String, content: String) {
        let memo = Memo(imageUrl: imageUrl, title: title, content: content, isOn: false)
        self.memoList.append(memo)
    }
    
}

// MARK: - Memo Update Delegate
extension HomeVC: MemoUpdateDelegate {
    
    // 작성한 메모 데이터 전달
    func updateData(index: Int, imageUrl: String, title: String, content: String) {
        let memo = Memo(imageUrl: imageUrl, title: title, content: content, isOn: false)
        
        self.memoList[index].imageUrl = memo.imageUrl
        self.memoList[index].title = memo.title
        self.memoList[index].content = memo.content
        self.memoList[index].isOn = memo.isOn
    }
    
}
