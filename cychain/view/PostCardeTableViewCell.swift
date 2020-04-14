//
//  PostCardeTableViewCell.swift
//  cychain
//
//  Created by takadahideaki007 on 2020/04/13.
//  Copyright © 2020 高田英明. All rights reserved.
//

import UIKit

class PostCardeTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var view2: View!
    @IBOutlet weak var mynameLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
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
