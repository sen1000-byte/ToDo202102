//
//  ViewController.swift
//  ToDo202102
//
//  Created by Chihiro Nishiwaki on 2021/02/15.
//

import UIKit
import RealmSwift
import PKHUD

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    //StroyBoadで扱うTableViewを宣言
    @IBOutlet var table: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet var searchField: UISearchBar!
    @IBOutlet var sortTagBarButton: UIBarButtonItem!
    //realmから値を全て取り出し
    let realm = try! Realm()
    var saveData = try! Realm().objects(SaveDataFormat.self)
    //保存されたかどうか
    var whetherSaved: Bool = false
    //選択したセルの番号
    var id: Int = 0
    //タグ管理
    var userDefaults: UserDefaults = UserDefaults.standard
    var tagSaveData: [String] = ["（タグを指定しない）"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableViewを使う準備　ViewControllerが主導で、TableViewを使ってくよ
        table.delegate = self
        table.dataSource = self
        navigationController?.navigationBar.barTintColor = .darkGray
//        navigationController?.toolbar.barTintColor = .lightGray

        editBarButton.title = "Edit"
        editBarButton.tintColor = UIColor.white
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        searchField.delegate = self
        searchField.tintColor = UIColor.orange
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveData = saveData.sorted(byKeyPath: "id", ascending: true)
        self.table.reloadData()
        navigationController?.setToolbarHidden(false, animated: false)
        //タグ
        if userDefaults.object(forKey: "tags") != nil {
            tagSaveData = userDefaults.object(forKey: "tags") as! [String]
        }else{
            tagSaveData = ["（タグを指定しない）"]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if whetherSaved {
            HUD.dimsBackground = false
            HUD.flash(.labeledSuccess(title: "保存しました", subtitle: nil), delay: 1.0)
            whetherSaved = false
        }
    }
    
    //検索バーに記入があった時
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        if table.isEditing {
            table.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            editBarButton.style = .plain
            editBarButton.tintColor = UIColor.white
            table.reloadData()
        }
    }
    //検索でキャンセルが押された時
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //キーボードを閉じる(最初の状態に戻す)
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        saveData = realm.objects(SaveDataFormat.self)
        table.reloadData()
    }
    //検索を押された時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //キーボードを閉じる
        view.endEditing(true)
        //nilでなければ処理を行う
        if searchBar.text != "" && searchBar.text != nil {
            let word = searchBar.text ?? ""
            saveData = realm.objects(SaveDataFormat.self).filter("taskName CONTAINS '\(word)' OR deatail CONTAINS '\(word)'")
            table.reloadData()
        }else{
            searchBar.setShowsCancelButton(false, animated: true)
            saveData = realm.objects(SaveDataFormat.self)
            table.reloadData()
        }
    }
    
    //セルの数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //セーブデータの数にする
        return saveData.count
    }
    
    //cellの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableViewCell
        cell.taskNameLable.text = saveData[indexPath.row].taskName
        cell.dealLineLable.text = saveData[indexPath.row].deadLine
        cell.tagLabel.text = saveData[indexPath.row].tag
        cell.tagLabel.layer.cornerRadius = 5
        cell.tagLabel.clipsToBounds = true
        return cell
    }
    
    //編集モード
    @IBAction func edit() {
        if table.isEditing {
            table.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            editBarButton.style = .plain
            editBarButton.tintColor = UIColor.white
            table.reloadData()
        }else{
            table.setEditing(true, animated: true)
            editBarButton.title = "Done"
            editBarButton.style = .done
            editBarButton.tintColor = UIColor.orange
        }
    }
    
    //編集モードの時にdeleteを選択した時に呼ばれる　commitに削除を示すeditingStyle.deleteが渡される forRowAtは選択された行番号
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        try! realm.write {
            realm.delete(saveData[indexPath.row])
        }
        table.reloadData()
    }
    
    //編集モードで、入れ替えが行われた時に発動 moveRowAtが動く前 toが動いた後の行番号
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        print("入れ替えが呼ばれました")
//        print(sourceIndexPath.row, destinationIndexPath.row)
        //やばい、絶対もっといい方法ある
        let tempMoveData = SaveDataFormat()
        let tempDestinationData = SaveDataFormat()
        
        tempMoveData.id = saveData[sourceIndexPath.row].id
        tempMoveData.taskName = saveData[destinationIndexPath.row].taskName
        tempMoveData.deadLine = saveData[destinationIndexPath.row].deadLine
        tempMoveData.tag = saveData[destinationIndexPath.row].tag
        tempMoveData.deatail = saveData[destinationIndexPath.row].deatail
        
        tempDestinationData.id = saveData[destinationIndexPath.row].id
        tempDestinationData.taskName = saveData[sourceIndexPath.row].taskName
        tempDestinationData.deadLine = saveData[sourceIndexPath.row].deadLine
        tempDestinationData.tag = saveData[sourceIndexPath.row].tag
        tempDestinationData.deatail = saveData[sourceIndexPath.row].deatail
        print(tempMoveData, tempDestinationData)
        //realmに書き込み プライマリキー（id）を使って上書き
        try! realm.write {
            realm.add(tempMoveData, update: .all)
            realm.add(tempDestinationData, update: .all)
        }
    }
    //cell選択時に呼ばれるメゾット
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "toEdit", sender: nil)
        id = saveData[indexPath.row].id
        let nextVC = self.storyboard?.instantiateViewController(identifier: "EditViewController") as! EditViewController
        nextVC.id = id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
//    //遷移の準備
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toEdit" {
//
//        }
//    }
    
    //cellの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
    @IBAction func Add() {
        performSegue(withIdentifier: "toAdd", sender: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if table.isEditing {
            table.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            editBarButton.style = .plain
            editBarButton.tintColor = UIColor.white
            table.reloadData()
        }
    }
    
    @IBAction func toTagView() {
        performSegue(withIdentifier: "toTag", sender: nil)
    }
    
    @IBAction func custom() {
        saveData =  realm.objects(SaveDataFormat.self)
        saveData = saveData.sorted(byKeyPath: "id", ascending: true)
        editBarButton.isEnabled = true
        editBarButton.tintColor = .white
        table.reloadData()
    }
    
    @IBAction func sortDate() {
        saveData = saveData.sorted(byKeyPath: "deadLine", ascending: true)
        editBarButton.isEnabled = false
        editBarButton.tintColor = .lightGray
        table.reloadData()
    }
    
    @IBAction func sortTag() {
        var menueElement: [UIMenuElement] = []
//            [UIAction(title:"", handler: {_ in
//            self.saveData = self.saveData.filter("tag == %@", "")
//            self.table.reloadData()
//        })]
        for i in 1..<tagSaveData.count {
            menueElement.append(UIAction(title: tagSaveData[i], handler: {_ in
                self.saveData = self.realm.objects(SaveDataFormat.self).filter("tag == %@", "\(self.tagSaveData[i])")
                self.table.reloadData()
            }))
        }
        if tagSaveData.count > 1 {
            let items = UIMenu(options: .displayInline, children: menueElement)
            sortTagBarButton.menu = UIMenu(title: "", children: [items])
        print(menueElement)
        }
    }

}

