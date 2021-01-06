//
//  ViewController.swift
//  iOS-Memo-App
//
//  Created by taehy.k on 2021/01/01.
//

import UIKit
import FanMenu
import Macaw
import RealmSwift

class HomeVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    @IBOutlet weak var fanMenu: FanMenu!
    
    //MARK: - Variables
    var memoList = [Memo]()
    var filteredMemoList = [Memo]() // 검색에 의해 필터링 된 배열
    var originMemoList = [Memo]()
    var searching = false
    
    var longpress: UILongPressGestureRecognizer!
    var editMode: Bool = false
    var sortCount: Int = 0
    
    let image = UIImage()
    let emptyView = UIView()

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        fanMenuExec()
        
        memoList = [
            Memo(imageUrl: "avatar1", title: "A - 첫번째 메모", content: "아 오늘은 메모 연습", isOn: false),
            Memo(imageUrl: "avatar2", title: "2 - 두번째 메모", content: "메모 삭제 기능 추가를 했다", isOn: false),
            Memo(imageUrl: "avatar3", title: "Z3 - 세번째 메모", content: "너무 춥다 😂", isOn: false),
            Memo(imageUrl: "avatar4", title: "x - 네번째 메모", content: "놀러 가고 싶다!!!!!", isOn: false),
            Memo(imageUrl: "avatar5", title: "a - 다섯번째 메모", content: "ㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠ", isOn: false),
            Memo(imageUrl: "avatar6", title: "다 - 여섯번째 메모", content: "오늘은 새로운걸 배웠다!! 👻👻👻", isOn: false),
            Memo(imageUrl: "avatar1", title: "메모연습 - 일곱번째 메모", content: "새로운 메모를 작성하였습니다.", isOn: false),
            Memo(imageUrl: "avatar4", title: "A1 - 여덟번째 메모", content: "쓸 내용이 없네 ?!", isOn: false),
            Memo(imageUrl: "avatar3", title: "2 - 아홉번째 메모", content: "잘하고 싶어요 👊", isOn: false),
            Memo(imageUrl: "avatar2", title: "Z3 - 열번째 메모", content: "화이팅!!!!!!!!!!!!!", isOn: false),
            Memo(imageUrl: "avatar1", title: "x", content: "a", isOn: false),
            Memo(imageUrl: "avatar1", title: "a", content: "e", isOn: false),
            Memo(imageUrl: "avatar2", title: "다", content: "e", isOn: false),
            Memo(imageUrl: "avatar5", title: "가", content: "g", isOn: false),
        ]
        
        originMemoList = memoList
        
        // tableView delegate 선언
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .white
        
        // searchBar delegate 선언
        self.searchBar.delegate = self
        self.searchBar.placeholder = "검색할 제목을 입력하세요"
        self.searchBar.backgroundImage = self.image
        self.searchBar.searchTextField.backgroundColor = .systemGray6
        let directionalMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        searchBar.directionalLayoutMargins = directionalMargins
        self.filteredMemoList = self.memoList
        
        // 길게 눌렀을 때 처리
        longpress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureRecognized))
        self.tableView.addGestureRecognizer(longpress)
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
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let identifierName = identifier {
            if identifierName == "homeToDetail" {
                 if editMode {
                      return false
                 }
            }
        }
        return true
    }
    
    //MARK: - Custom Function
    func fanMenuExec() {
        
        // Do any additional setup after loading the view.
        fanMenu.button = FanMenuButton(
            id: "main",
            image: UIImage(named: "plus"),
            color: Color(val: 0x74c7b8)
        )
        
        fanMenu.items = [
            FanMenuButton(
                id: "write",
                image: UIImage(named: "write"),
                color: Color(val: 0x70af85)
            ),
            FanMenuButton(
                id: "delete",
                image: UIImage(named: "delete"),
                color: Color(val: 0x70af85)
            ),
        ]
        
        fanMenu.menuBackground = Color(val: 0xdff3e3)
        fanMenu.menuRadius = 100.0
        fanMenu.duration = 0.2
        fanMenu.interval = (Double.pi + Double.pi/4, Double.pi + 3 * Double.pi/4)
        fanMenu.radius = 25.0
        fanMenu.delay = 0.0
        
        fanMenu.onItemWillClick = { button in

            if button.id == "write" {
                print("hello")
            } else if button.id == "delete" {
                print("hello")
            }

        }
        
        fanMenu.backgroundColor = .clear
        
    }
    
    
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
    
    // 행에 대한 삭제
    @objc func deleteRows() {
        if let selectedRows = tableView.indexPathsForSelectedRows {

            // 1
            var items: [String] = []
            for indexPath in selectedRows  {
                items.append(memoList[indexPath.row].title)
            }
            
            // 2 - 제목으로 index를 찾아서 삭제하는데, 원소로는 배열에서 인덱스를 찾을 수 없는건가..?
            for item in items {
                if let index = items.index(of: item) {
                    self.memoList.remove(at: index)
                }
            }
            
            filteredMemoList = memoList
            
            // 3
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
            
         }
    }
    
    //MARK: - IBAction
    // 편집, 삭제, 전체삭제
    @IBAction func editButtonClicked(_ sender: Any) {
        
        // isEditing이라는 프로퍼티를 이용하면 한줄로 편집모드를 만들수있다.
        // self.tableView.isEditing = !self.tableView.isEditing
        
        let trash = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteRows))
   
        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsMultipleSelectionDuringEditing = true


        if editMode == false {
            editMode = true
            tableView.setEditing(editMode, animated: true)
            navigationItem.leftBarButtonItems?.append(trash)
        } else {
            editMode = false
            tableView.setEditing(editMode, animated: true)
            navigationItem.leftBarButtonItems?.removeLast()
        }
        
    }
    
    // 정렬
    @IBAction func sortButtonClicked(_ sender: Any) {
        
        sortCount += 1

        if sortCount == 1 {
            memoList.sort { $0.title.lowercased() < $1.title.lowercased() }
            self.sortButton.title = "z-a"
            self.tableView.reloadData()
        } else if sortCount == 2 {
            memoList.sort { $0.title.lowercased() > $1.title.lowercased() }
            self.sortButton.title = "기본"
            self.tableView.reloadData()
        } else {
            sortCount = 0
            memoList = originMemoList
            self.sortButton.title = "a-z"
            self.tableView.reloadData()
        }
   
    }
    
}


// MARK: - TableView DataSource
extension HomeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if searching {
            return filteredMemoList.count
        } else {
            return memoList.count
        }
            
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        
        var memoList = [Memo]()
        
        if searching {
            memoList = self.filteredMemoList
        } else {
            memoList = self.memoList
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath) as? MemoTableViewCell  {
            cell.accessoryType = .checkmark
        }
        
    }
    
    // 그룹 헤더
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "메모"
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

// 검색(search) 델리게이트(delegate)
extension HomeVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMemoList = searchText.isEmpty ? memoList : memoList.filter({( memo : Memo) -> Bool in
            searching = true
            return memo.title.range(of: searchText) != nil
        })
        
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        
        self.searching = false
        self.filteredMemoList = memoList
        self.tableView.reloadData()
    }
}
