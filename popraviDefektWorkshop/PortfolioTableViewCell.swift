//
//  PortfolioTableViewCell.swift
//  popraviDefektWorkshop
//
//  Created by simona on 12/26/20.
//  Copyright © 2020 simona. All rights reserved.
//

import UIKit

class PortfolioTableViewCell: UITableViewCell {

    @IBOutlet weak var solvedImage: UIImageView!
    
    @IBOutlet weak var solvedDatum: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
