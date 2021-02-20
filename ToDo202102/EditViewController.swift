//
//  EditViewController.swift
//  ToDo202102
//
//  Created by Chihiro Nishiwaki on 2021/02/20.
//

import UIKit
import RealmSwift
import PKHUD

class EditViewController: UIViewController,UITextFieldDelegate, UITextViewDelegate{
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var deadLineTextField: UITextField!
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var deatailTextView: UITextView!
    
    //cellの番号
    var indexNumber: Int = 0
    //realmのインスタンス作成
    let realm = try! Realm()
    var saveData = SaveDataFormat()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveData = realm.objects(SaveDataFormat.self)[indexNumber]
        taskNameTextField.text = saveData.taskName
        deadLineTextField.text = saveData.deadLine
        tagTextField.text = saveData.tag
        deatailTextView.text = saveData.deatail
        
        //キーボード設定のための準備
        taskNameTextField.delegate = self
        deatailTextView.delegate = self
    }
    
    //キーボード関連
    //enterが押された時に発動
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //taskNameTextFieldのエンターが押されたら閉じるようにする。
        textField.resignFirstResponder()
        return true
    }
    //画面が押された時に発動
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.deatailTextView.isFirstResponder{
            self.deatailTextView.resignFirstResponder()
        }
    }
    
    @IBAction func save() {
        
        if taskNameTextField.text == "" {
            HUD.flash(. labeledError(title: "保存できません", subtitle: "タスク名を記入してください"), delay: 1.5)
        }else{
            //realmに上書き保存
            try! realm.write{
                let results = realm.objects(SaveDataFormat.self)
                results[indexNumber].taskName = taskNameTextField.text ?? "no name"
                results[indexNumber].deadLine = deadLineTextField.text ?? ""
                //            results[indexNumber].deadLineInt = 0
                results[indexNumber].tag = tagTextField.text ?? ""
                results[indexNumber].deatail = deatailTextView.text ?? ""
            }
            //navigationControllerの戻り方
            self.navigationController?.popViewController(animated: true)
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
