//
//  ViewController.swift
//  ToDo202102
//
//  Created by Chihiro Nishiwaki on 2021/02/15.
//

import UIKit
import RealmSwift
import PKHUD

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    //StroyBoadで扱うTableViewを宣言
    @IBOutlet var table: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    //realmから値を全て取り出し
    let realm = try! Realm()
    var saveData = try! Realm().objects(SaveDataFormat.self)
    //保存されたかどうか
    var whetherSaved: Bool = false
    //選択したセルの番号
    var id: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableViewを使う準備　ViewControllerが主導で、TableViewを使ってくよ
        table.delegate = self
        table.dataSource = self
        navigationController?.navigationBar.barTintColor = .darkGray

        editBarButton.title = "Edit"
        editBarButton.tintColor = UIColor.white
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveData = saveData.sorted(byKeyPath: "id", ascending: true)
        self.table.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if whetherSaved {
            HUD.dimsBackground = false
            HUD.flash(.labeledSuccess(title: "保存しました", subtitle: nil), delay: 1.0)
            whetherSaved = false
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
        return cell
    }
    
    //編集モード
    @IBAction func edit() {
        if table.isEditing {
            table.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            editBarButton.tintColor = UIColor.white
            table.reloadData()
        }else{
            table.setEditing(true, animated: true)
            editBarButton.title = "Done"
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
        print("入れ替えが呼ばれました")
        print(sourceIndexPath.row, destinationIndexPath.row)
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
    
//    //cellの高さ
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80
//    }
    
    
    @IBAction func Add() {
        performSegue(withIdentifier: "toAdd", sender: nil)
    }


}

