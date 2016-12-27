//
//  MenuTableViewCell.swift
//  Nerdologia
//
//  Created by John Lima on 5/28/16.
//  Copyright © 2016 John Lima. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            self.avatarImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var displayNameLabel: UILabel!

}
