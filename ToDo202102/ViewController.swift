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
    //realmから値を全て取り出し
    var saveData = try! Realm().objects(SaveDataFormat.self)
    //保存されたかどうか
    var whetherSaved: Bool = false
    //選択したセルの番号
    var indexNumber: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableViewを使う準備　ViewControllerが主導で、TableViewを使ってくよ
        table.delegate = self
        table.dataSource = self
        navigationController?.navigationBar.barTintColor = .darkGray

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    //cell選択時に呼ばれるメゾット
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "toEdit", sender: nil)
        indexNumber = indexPath.row
        let nextVC = self.storyboard?.instantiateViewController(identifier: "EditViewController") as! EditViewController
        nextVC.indexNumber = indexNumber
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

