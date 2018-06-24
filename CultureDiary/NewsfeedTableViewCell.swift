//
//  NewsfeedTableViewCell.swift
//  CultureDiary
//
//  Created by SWUCOMPUTER on 2018. 6. 19..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class NewsfeedTableViewCell: UITableViewCell {

    @IBOutlet var friendId: UILabel!
    @IBOutlet var friendTitle: UILabel!
    @IBOutlet var friendImage: UIImageView!
    @IBOutlet var friendRate: CosmosView!
    @IBOutlet var friendReview: UILabel!
//    @IBOutlet var buttonLike: UIButton!
//    @IBOutlet var labelLike: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
