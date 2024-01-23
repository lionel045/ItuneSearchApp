//
//  LikeViewCell.swift
//  iTunesSearchApp
//
//  Created by Lion on 22/01/2024.
//

import UIKit

class LikeViewCell: UITableViewCell {

    @IBOutlet weak var imageSaved: UIImageView!
    
    @IBOutlet weak var artistSaved: UILabel!
    
    var onDelete: ((String) -> Void)?
    @IBOutlet weak var titleSaved: UILabel!
    
    
    @IBOutlet weak var dislikeButton: UIButton!
    
    
    @IBAction func dislikeTapped(_ sender: UIButton) {
    
        if let title = titleSaved.text {
            onDelete?(title)
        }
        
    }
    
    
    
    
}
