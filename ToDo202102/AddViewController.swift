//
//  AddViewController.swift
//  ToDo202102
//
//  Created by Chihiro Nishiwaki on 2021/02/18.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var taskNameTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker! = UIDatePicker()
    @IBOutlet var tagTextField: UITextField!
    @IBOutlet var deatailTextField: UITextField!
    
    var taskName: String = ""
    var deadLine: String!
    var deadLineInt: Int!
    var tag: String = ""
    var deatail: String = ""
    
    //タグ管理
    var tagArray = [String?]()
    
    //保存
    let realm = try! Realm()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //datePickerの設定
        //からからにする。
        datePicker.preferredDatePickerStyle = .wheels
        //日付と時間を表示させる（一応デフォルトでもそうなってる）
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        datePicker.minuteInterval = 5
        
        taskNameTextField.delegate = self
        

        // Do any additional setup after loading the view.
    }
    
    //enterが押された時に発動
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //taskNameTextFieldのエンターが押されたら閉じるようにする。
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func save() {
        
        //タスク名
        taskName = taskNameTextField.text ?? ""
        
        let formatter = DateFormatter()
        //表示方法の設定 下記方法で、携帯に合わせた表示方法ができるけど、今回は相互にやりとりしたいので、フォーマットを指定した方がやりやすい、、
//        formatter.dateStyle = .long
//        formatter.timeStyle = .short
        //どの携帯でも西暦で扱うようにする??
        //formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy/MM/DD HH:ss"
        print(formatter.string(from: datePicker.date))
        deadLine = formatter.string(from: datePicker.date)
        
        formatter.dateFormat = "yyyyMMDDHHss"
        deadLineInt = Int(formatter.string(from: datePicker.date))
        
        //タグ
        tag = ""
        
        //詳細
        deatail = deatailTextField.text ?? ""
        
        //nameが何もない時にアラートを出す。
        if taskName == "" {
            
        }
        //realmに保存準備
        let newSaveData = SaveDataFormat()
        newSaveData.taskName = taskName
        newSaveData.deadLine = deadLine!
        newSaveData.deadLineInt = deadLineInt!
        newSaveData.tag = tag
        newSaveData.deatail = deatail
        
        //realmに保存
        try! realm.write{
            realm.add(newSaveData)
        }
        
        //画面遷移
        //dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel() {
        //dismiss(animated: true, completion: nil)
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