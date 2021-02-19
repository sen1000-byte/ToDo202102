//
//  ViewController.swift
//  ToDo202102
//
//  Created by Chihiro Nishiwaki on 2021/02/15.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    //StroyBoadで扱うTableViewを宣言
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableViewを使う準備　ViewControllerが主導で、TableViewを使ってくよ
        table.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    //セルの数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //セーブデータの数にする
        return 10
    }
    
    //cellの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableViewCell
        cell.taskNameLable.text = "a"
        cell.dealLineLable.text = "2021/02/18"
        return cell
    }


}

