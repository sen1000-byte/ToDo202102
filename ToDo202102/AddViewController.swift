//
//  AddViewController.swift
//  ToDo202102
//
//  Created by Chihiro Nishiwaki on 2021/02/18.
//

import UIKit
import RealmSwift
import PKHUD

class AddViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var taskNameTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker! = UIDatePicker()
    @IBOutlet var tagTextField: UITextField!
    @IBOutlet var deatailTextView: UITextView!
    
    var pickerView = UIPickerView()
    
    var id: Int = 0
    var taskName: String = ""
    var deadLine: String!
//    var deadLineInt: Int!
    var tag: String = ""
    var deatail: String = ""
    
    //タグ管理
    var userDefaults: UserDefaults = UserDefaults.standard
    var tagSaveData: [String] = ["（タグを指定しない）"]
    
    //保存準備
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //タグ
        if userDefaults.object(forKey: "tags") != nil {
            tagSaveData = userDefaults.object(forKey: "tags") as! [String]
        }else{
            tagSaveData = ["（タグを指定しない）"]
        }
        //datePickerの設定
        //からからにする。
        datePicker.preferredDatePickerStyle = .wheels
        //日付と時間を表示させる（一応デフォルトでもそうなってる）
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        datePicker.minuteInterval = 5
        print(datePicker.date)
        //キーボード閉じるために設定準備
        taskNameTextField.delegate = self
        deatailTextView.delegate = self
        
        pickerView.delegate = self
        //キーボードにdoneボタンをつける
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 43))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spaceItem,doneItem], animated: true)
        //pickerviewとtagtextfieldを連携
        tagTextField.inputView = pickerView
        tagTextField.inputAccessoryView = toolbar
        //見た目系
        deatailTextView.layer.borderColor = CGColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        deatailTextView.layer.borderWidth = 1
        deatailTextView.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
    }
    
    @objc func done() {
        tagTextField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tagSaveData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tagSaveData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tagTextField.text = tagSaveData[row]
    }
    
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
        //id
        id = realm.objects(SaveDataFormat.self).count
        
        //タスク名
        taskName = taskNameTextField.text ?? ""
        
        let formatter = DateFormatter()
        //表示方法の設定 下記方法で、携帯に合わせた表示方法ができるけど、今回は相互にやりとりしたいので、フォーマットを指定した方がやりやすい、、
//        formatter.dateStyle = .long
//        formatter.timeStyle = .short
        //どの携帯でも西暦で扱うようにする??
        //formatter.calendar = Calendar(identifier: .gregorian)
        //formatter.dateFormat = "yyyy/MM/dd HH:mm"
        //日本時間に合わせる
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMMHHmm", options: 0, locale: Locale(identifier: "ja_JP"))
        //print(formatter.string(from: datePicker.date))
        
        deadLine = formatter.string(from: datePicker.date)
//        formatter.dateFormat = "yyyyMMddHHmm"
//        deadLineInt = Int(formatter.string(from: datePicker.date))
        
        //タグ
        if tagTextField.text == "（タグを指定しない）" {
            tag = ""
        }else{
            tag = tagTextField.text ?? ""
        }
        
        //詳細
        deatail = deatailTextView.text ?? ""
        
        //nameが何もない時にアラートを出す。
        if taskName == "" {
            HUD.dimsBackground = true
            HUD.flash(.labeledError(title: "保存のエラー", subtitle: "タスク名を記入してください"), delay: 1.5)
        }else{
            //realmに保存準備
            let newSaveData = SaveDataFormat()
            newSaveData.id = id
            newSaveData.taskName = taskName
            newSaveData.deadLine = deadLine!
//            newSaveData.deadLineInt = deadLineInt!
            newSaveData.tag = tag
            newSaveData.deatail = deatail
            //realmに保存
            try! realm.write{
                realm.add(newSaveData)
            }
            let preNC = self.presentingViewController as! UINavigationController
            let preVC = preNC.viewControllers[0] as! ViewController
            preVC.whetherSaved = true
            //画面遷移
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel() {
        let alert = UIAlertController(title: "本当にキャンセルしますか", message: "はいを押すと記入したデータは失われます", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "はい", style: .default, handler: {action in
//            let prevViewController = self.presentingViewController as! ViewController
//            prevViewController.whetherSaved = false
            let preNC = self.presentingViewController as! UINavigationController
            let preVC = preNC.viewControllers[0] as! ViewController
//            let preVC = self.presentingViewController as! ViewController
            preVC.whetherSaved = false
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "いいえ", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
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
