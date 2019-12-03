//
//  resultPostCardCell2.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/06/14.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit

class ResultCell2: UITableViewCell {
    
    
    @IBOutlet weak var label: labele!
    @IBOutlet weak var profaleIcon: UIImageView!
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var to: UILabel!
    @IBOutlet weak var myName: UILabel!

    @IBOutlet weak var targetName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
