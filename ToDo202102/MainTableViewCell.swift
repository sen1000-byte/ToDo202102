//
//  MainTableViewCell.swift
//  ToDo202102
//
//  Created by Chihiro Nishiwaki on 2021/02/18.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet var taskNameLable: UILabel!
    @IBOutlet var dealLineLable: UILabel!
    @IBOutlet var tagLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
