//
//  PostCardMessageCell.swift
//  cychain
//
//  Created by takadahideaki007 on 2020/04/15.
//  Copyright © 2020 高田英明. All rights reserved.
//

import UIKit

class PostCardMessageCell: UITableViewCell {
    
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
