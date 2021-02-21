//
//  TagManageViewController.swift
//  ToDo202102
//
//  Created by Chihiro Nishiwaki on 2021/02/21.
//

import UIKit
import PKHUD
import RealmSwift

class TagManageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet var tagTextField: UITextField!
    @IBOutlet var tableview: UITableView!
    //タグ管理
    var userDefaults: UserDefaults = UserDefaults.standard
    var tagSaveData: [String] = ["（タグを指定しない）"]
    //realm
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userDefaults.object(forKey: "tags") != nil {
            tagSaveData = userDefaults.object(forKey: "tags") as! [String]
        }else{
            tagSaveData = ["（タグを指定しない）"]
        }
        tagTextField.delegate = self
        tableview.delegate = self
        tableview.dataSource = self
        //見た目系
        navigationController?.navigationBar.tintColor = .white
        // Do any additional setup after loading the view.
        print(tagSaveData)
    }
    
    //enterが押された時に発動
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //taskNameTextFieldのエンターが押されたら閉じるようにする。
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func addTag() {
        if tagTextField.text != nil && tagTextField.text != "" {
            HUD.flash(.labeledSuccess(title: "保存しました", subtitle: nil), delay: 1.5)
            tagSaveData.append(tagTextField.text ?? "default")
            tableview.reloadData()
            tagTextField.text = ""
            userDefaults.set(tagSaveData, forKey: "tags")
        }else{
            HUD.flash(.labeledError(title: "保存できません", subtitle: "タグ名を記入してください"), delay: 1.5)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagSaveData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = tagSaveData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    //スワイプ削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print(indexPath.row)
            if indexPath.row == 0 {
            }else{
                let alert = UIAlertController(title: "本当に削除しますか", message: "既存のデータからも選択したタグが消去されます", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "はい", style: .default, handler: {action in
                    let saveData = self.realm.objects(SaveDataFormat.self).filter("tag == %@", self.tagSaveData[indexPath.row])
                    self.tagSaveData.remove(at: indexPath.row)
                    self.userDefaults.set(self.tagSaveData, forKey: "tags")
                    self.tableview.reloadData()
                    for i in 0..<saveData.count {
                        try! self.realm.write {
                            saveData[i].tag = ""
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: "いいえ", style: .destructive, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
