//
//  MyTableViewCell.swift
//  Alamofire-timezone
//
//  Created by Wali Faisal on 14/04/2024.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var myImage: UIImageView!
    
    @IBOutlet weak var MyLabel_tz: UILabel!
    
    @IBOutlet weak var MyLabel_country: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
