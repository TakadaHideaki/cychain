//
//  resultPostCardcell.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/06/05.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {
    
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var to: UILabel!
    @IBOutlet weak var myName: UILabel!
    @IBOutlet weak var targetName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
