//
//  postcardCell.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/04/07.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit


class postcardCell: UITableViewCell {
    
    
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var mynameLabael: UILabel!
    @IBOutlet weak var targerNameLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var to: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}