//
//  ResultSearchCell.swift
//  TLab Overflow
//
//  Created by bungkhus on 06/06/18.
//  Copyright © 2018 TLab. All rights reserved.
//

import UIKit
import AlamofireImage

class ResultSearchCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var nameAndDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var searchResult: SearchItem? {
        didSet {
            if let searchResult = searchResult {
                if let title = searchResult.title {
                    self.titleLabel.text = title
                } else {
                    
                }
                
                if let owner = searchResult.owner {
                    if let name = owner.displayName, let createDate = searchResult.createDate {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd MMM yyyy hh:mm"
                        let dateStr = formatter.string(from: createDate as Date)
                        nameAndDateLabel.text = "\(name) - asked \(dateStr)"
                        
                    }
                    if let thumbnailString = owner.profileImageUrl, let url = URL(string: (thumbnailString)) {
                        avaImage.af_setImage(withURL: url, placeholderImage: UIImage(named: "contact"), imageTransition: .crossDissolve(0.2))
                    } else {
                        avaImage.image = UIImage(named: "contact")
                    }
                }
            }
        }
    }

}
