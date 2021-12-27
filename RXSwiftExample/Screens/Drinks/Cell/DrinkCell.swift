//
//  DrinkCell.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//
import UIKit
import Reusable

class DrinkCell: UITableViewCell, NibLoadable {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
