//
//  TableCell.swift
//  YT Market
//
//  Created by Adam Eliezerov on 27/08/2018.
//  Copyright © 2018 Adam Eliezerov. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet var channelNameLabel: UILabel!
    @IBOutlet var channelImageView: UIImageView!
    @IBOutlet var subCountLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
