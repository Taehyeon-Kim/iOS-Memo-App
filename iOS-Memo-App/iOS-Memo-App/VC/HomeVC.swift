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
    var longpress: UILongPressGestureRecognizer!

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView delegate 선언
        tableView.delegate = self
        tableView.dataSource = self
        
        // 길게 눌렀을 때 처리
        longpress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureRecognized))
        tableView.addGestureRecognizer(longpress)
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
    
    //MARK: - Custom Function
    @objc func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
            let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        
            if longPress.state == UIGestureRecognizer.State.began {
                let locationInTableView = longPress.location(in: tableView)
                let indexPath = tableView.indexPathForRow(at: locationInTableView)
                
                let title = memoList[indexPath?.row ?? -0].title
                let content = memoList[indexPath?.row ?? -0].content
                
                // 알림
                let alert = UIAlertController(title: title, message: content, preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "자세히 보기", style: .default, handler: { action in
                        
                    // handler에 함수를 바로 처리한 이유: indexPath를 사용하기 위해서 (질문)
                    let detailVC = self.storyboard?.instantiateViewController(identifier: "DetailVC") as! DetailVC
                    
                    detailVC.memo = self.memoList[indexPath?.row ?? -0]
                    detailVC.index = indexPath?.row ?? -0
                    
                    self.navigationController?.pushViewController(detailVC, animated: true)
                })
                
                let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                
                // 연결
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                
                present(alert, animated: true, completion: nil)
                
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
