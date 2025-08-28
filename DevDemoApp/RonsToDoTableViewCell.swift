//
//  RonsToDoTableViewCell.swift
//  DevDemoApp
//
//  Created by Ronald Jones on 8/25/25.
//

import UIKit

class RonsToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var dte: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var txtLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
