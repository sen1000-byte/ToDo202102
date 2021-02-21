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
    var id: Int = 0
    //realmのインスタンス作成
    let realm = try! Realm()
    var saveData = SaveDataFormat()
    
    //日付関連
    let dateformatter = DateFormatter()
    var datePicker: UIDatePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveData = realm.object(ofType: SaveDataFormat.self, forPrimaryKey: id)!
        taskNameTextField.text = saveData.taskName
        deadLineTextField.text = saveData.deadLine
        tagTextField.text = saveData.tag
        deatailTextView.text = saveData.deatail
        
        //キーボード設定のための準備
        taskNameTextField.delegate = self
        deatailTextView.delegate = self

        navigationController?.navigationBar.tintColor = .white

        //日付系
        dateformatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMMHHmm", options: 0, locale: Locale(identifier: "ja_JP"))
        //datePickerの設定
        //からからにする。
        datePicker.preferredDatePickerStyle = .wheels
        //日付と時間を表示させる（一応デフォルトでもそうなってる）
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        datePicker.minuteInterval = 5
        datePicker.date = dateformatter.date(from: saveData.deadLine) ?? NSDate() as Date
        deadLineTextField.inputView = datePicker
        
        //キーボードにdoneボタンをつける
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 43))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spaceItem,doneItem], animated: true)

        //紐づいているUITextfieldへ代入
        deadLineTextField.inputView = datePicker
        deadLineTextField.inputAccessoryView = toolbar

    }
    
    @objc func done() {
            deadLineTextField.endEditing(true)
            deadLineTextField.text = "\(dateformatter.string(from: datePicker.date))"
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
            //idを使って上書き
            let newSaveData = SaveDataFormat()
            newSaveData.id = id
            newSaveData.taskName = taskNameTextField.text ?? "no name"
            newSaveData.deadLine = deadLineTextField.text ?? ""
            newSaveData.tag = tagTextField.text ?? ""
            newSaveData.deatail = deatailTextView.text ?? ""
            try! realm.write{
                realm.add(newSaveData, update: .all)
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
