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
