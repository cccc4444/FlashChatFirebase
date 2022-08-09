//
//  TableCell.swift
//  Flash Chat iOS13
//
//  Created by Danylo Kushlianskyi on 08.08.2022.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 8
        
    }

   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
