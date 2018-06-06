//
//  InputSearchCell.swift
//  TLab Overflow
//
//  Created by bungkhus on 06/06/18.
//  Copyright © 2018 TLab. All rights reserved.
//

import UIKit

protocol InputSearchCellDelegate {
    func buttonSearchPressed(tag: String, from: String, to: String, pageSize: Int )
    func fromButtonPressed(inTextFiled textField: UITextField)
    func toButtonPressed(inTextFiled textField: UITextField)
    func pageSizeButtonPressed(inTextFiled textField: UITextField)
    func showError(msg: String)
}

class InputSearchCell: UITableViewCell {

    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var pageSize: UITextField!

    var delegate: InputSearchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func buttonSearchPressed(_ sender: Any) {
        guard let tag = tagTextField.text, let from = fromTextField.text, let to = toTextField.text, let page = pageSize.text, tag != "", from != "", to != "" else {
            delegate?.showError(msg: "Please isi semua data!")
            return
        }
        guard let pageInt = Int(page) else {
            delegate?.showError(msg: "Please isi page dengan angka!")
            return
        }
        delegate?.buttonSearchPressed(tag: tag, from: from, to: to, pageSize: pageInt)
    }
    @IBAction func fromButtonPressed(_ sender: Any) {
        delegate?.fromButtonPressed(inTextFiled: self.fromTextField)
    }
    @IBAction func toButtonPressed(_ sender: Any) {
        delegate?.toButtonPressed(inTextFiled: self.toTextField)
    }
    @IBAction func pageSizeButtonPressed(_ sender: Any) {
        delegate?.pageSizeButtonPressed(inTextFiled: self.pageSize)
    }
}
