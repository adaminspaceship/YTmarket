//
//  TableViewCell.swift
//  YT Market
//
//  Created by Adam Eliezerov on 16/08/2018.
//  Copyright © 2018 Adam Eliezerov. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var subCountLabel: UILabel!
    @IBOutlet weak var percentChangeLabel: UILabel!
    
}
