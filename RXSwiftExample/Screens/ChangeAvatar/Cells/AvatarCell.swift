//
//  AvatarCell.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/22/21.
//

import UIKit
import Reusable

class AvatarCell: UICollectionViewCell, NibLoadable, Reusable {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
