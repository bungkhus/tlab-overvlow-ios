//
//  InputSearchCell.swift
//  TLab Overflow
//
//  Created by bungkhus on 06/06/18.
//  Copyright © 2018 TLab. All rights reserved.
//

import UIKit

class InputSearchCell: UITableViewCell {

    @IBOutlet weak var tagTextField: UIStackView!
    @IBOutlet weak var fromTextField: UIStackView!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var pageSize: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func buttonSearchPressed(_ sender: Any) {
        print("search")
    }
}
