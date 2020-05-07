//
//  TableViewCell.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/01/30.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit

class inputDataListCell: UITableViewCell {
    
        
    @IBOutlet var myName: UILabel!
    @IBOutlet var targetName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
