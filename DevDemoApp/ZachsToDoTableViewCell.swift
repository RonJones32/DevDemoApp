//
//  ZachsToDoTableViewCell.swift
//  DevDemoApp
//  Created by Zach Keyser on 8/28/25.


import UIKit

class ZachsToDoTableViewCell: UITableViewCell {

    //Creates variables for the dateLabel, textLabel and the image
    @IBOutlet weak var dte: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var txtLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Change background of cells
        self.contentView.backgroundColor = UIColor.lightGray
        //Add a border to the cells
        self.contentView.layer.borderWidth = 1.0
        //Change the border color of cells
        self.contentView.layer.borderColor = UIColor.blue.cgColor
        //Change border to have round edges
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.clipsToBounds = true
        
        //Change text to Bold
        //txtLbl.font = UIFont.boldSystemFont(ofSize: 18)
        //Change text to Italics
        //txtLbl.font = UIFont.italicSystemFont(ofSize: 18)
        //Change text to custom Font
        txtLbl.font = UIFont(name: "Times New Roman", size: 18)
        //Change text color
        txtLbl.textColor = UIColor.black
        //Change dateLabel to custom Font
        dte.font = UIFont(name: "Times New Roman", size: 14)
        //Change dateLabel color
        dte.textColor = UIColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
