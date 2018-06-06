//
//  ViewController.swift
//  TLab Overflow
//
//  Created by bungkhus on 05/06/18.
//  Copyright © 2018 TLab. All rights reserved.
//

import UIKit
import SVPullToRefresh
import SVProgressHUD
import DZNEmptyDataSet
import ActionSheetPicker_3_0

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let interactor: SearchInteractor = SearchInteractor()
    let strFormat = "yyyy-MM-dd"
    //input
    var tag: String?
    var dateFrom: Date?
    var dateTo: Date?
    var pageSize: Int?
    
    // MARK: - OVERRIDE FUNC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "TLab Overflow"
        self.hideKeyboardWhenTappedAround()
        setupTableView()
    }
    
    // MARK: - METHODE
    
    func setupTableView() {
        tableView.register(UINib(nibName: "InputSearchCell", bundle: nil), forCellReuseIdentifier: "InputSearchCell")
        tableView.register(UINib(nibName: "ResultSearchCell", bundle: nil), forCellReuseIdentifier: "ResultSearchCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        tableView.addPullToRefresh {
            self.refresh()
        }
        
        tableView.addInfiniteScrolling {
            guard let tag = self.tag, let pageSize = self.pageSize, let from = self.dateFrom, let to = self.dateTo else {
                SVProgressHUD.showError(withStatus: "Failed to infinit scrolling becuse data does not exist.")
                return
            }
            
            self.interactor.nextWith(withTag: tag, pageSize: pageSize, from: from.toString(withFormat: self.strFormat), to: to.toString(withFormat: self.strFormat), success: { () -> (Void) in
                self.tableView.infiniteScrollingView.stopAnimating()
                self.tableView.showsInfiniteScrolling = self.interactor.hasNext
                self.tableView.reloadData()
                self.tableView.reloadEmptyDataSet()
            }, failure: { (error) -> (Void) in
                self.tableView.infiniteScrollingView.stopAnimating()
            })
        }
        
        tableView.pullToRefreshView.activityIndicatorViewColor = UIColor.gray
        tableView.pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        tableView.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        tableView.showsInfiniteScrolling = false
        
        loadData()
    }
    
    func refresh() {
        guard let tag = self.tag, let pageSize = self.pageSize, let from = self.dateFrom, let to = self.dateTo else {
            SVProgressHUD.showError(withStatus: "Error Input Data")
            return
        }
        
        let newParam = SearchParam.with(tag: tag, pageSize: pageSize, from: from, to: to)
        self.interactor.saveModel(data: newParam!)
        interactor.refresh(withTag: tag, pageSize: pageSize, from: from.toString(withFormat: self.strFormat), to: to.toString(withFormat: self.strFormat), success: { () -> (Void) in
            SVProgressHUD.dismiss()
            self.tableView.pullToRefreshView.stopAnimating()
            self.tableView.infiniteScrollingView.stopAnimating()
            self.tableView.showsInfiniteScrolling = self.interactor.hasNext
            self.loadData()
        }) { (error) -> (Void) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            SVProgressHUD.dismiss(withDelay: 3.0)
            if error.localizedDescription.contains("Data doesn't exists") {
                self.interactor.removeObject()
                self.tableView.reloadData()
                self.tableView.reloadEmptyDataSet()
            }
            self.tableView.pullToRefreshView.stopAnimating()
            self.tableView.infiniteScrollingView.stopAnimating()
        }
    }
    
    func loadData() {
        self.interactor.load()
        self.interactor.loadParam()
        if let paramSaved = self.interactor.searchParam {
            print("param berhasil disimpan \(paramSaved.tag)")
            self.tag = paramSaved.tag
            self.pageSize = paramSaved.pageSize
            self.dateFrom = paramSaved.from as? Date
            self.dateTo = paramSaved.to as? Date
        }

        tableView.reloadData()
        tableView.reloadEmptyDataSet()
    }


}

// MARK: - TableView Delegate

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Delegate
    
    //
    
    // Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return interactor.items.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputSearchCell", for: indexPath) as! InputSearchCell
            cell.delegate = self
            cell.tagTextField.delegate = self
            cell.searchParam = self.interactor.searchParam
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultSearchCell", for: indexPath) as! ResultSearchCell
            cell.searchResult = interactor.items[indexPath.row]
            return cell
        }
    }
    
}

extension ViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return interactor.items.count == 0
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let title = NSAttributedString(string: "No Data.", attributes: [NSAttributedStringKey.foregroundColor: UIColor.accent(), NSAttributedStringKey.font: UIFont.ProximaNova(size: 13)])
        return title
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 20
    }
    
}

extension ViewController: InputSearchCellDelegate {
    func buttonSearchPressed(tag: String, from: String, to: String, pageSize: Int) {
        self.view.endEditing(true)
        SVProgressHUD.show()
        self.tag = tag
        refresh()
    }
    
    func fromButtonPressed(inTextFiled textField: UITextField) {
        let datePicker = ActionSheetDatePicker(title: "From:", datePickerMode: UIDatePickerMode.date, selectedDate: dateFrom ?? Date(), doneBlock: {
            picker, value, index in
            let date = value as! Date
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy"
            let dateStr = formatter.string(from: date as Date)
            textField.text = dateStr
            
            self.dateFrom = date
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: self.view)
        
        datePicker?.show()
    }
    
    func toButtonPressed(inTextFiled textField: UITextField) {
        let datePicker = ActionSheetDatePicker(title: "To:", datePickerMode: UIDatePickerMode.date, selectedDate: dateTo ?? Date(), doneBlock: {
            picker, value, index in
            let date = value as! Date
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy"
            let dateStr = formatter.string(from: date as Date)
            textField.text = dateStr
            
            self.dateTo = date
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: self.view)
        
        datePicker?.show()
    }
    
    func pageSizeButtonPressed(inTextFiled textField: UITextField) {
        let valueArr = ["10", "20", "30", "50"]
        var curIdx = 0
        if let page = self.pageSize, let curPage = valueArr.index(of: "\(page)") {
            curIdx = curPage
        }
        ActionSheetStringPicker.show(withTitle: "Number of Items Per Page", rows: valueArr, initialSelection: curIdx, doneBlock: {
            _, index, value in

            if let pageSize = value {
                textField.text = pageSize as? String
                self.pageSize = Int(textField.text!)
            }
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: self.view)
    }
    
    func showError(msg: String) {
        SVProgressHUD.showError(withStatus: msg)
        SVProgressHUD.dismiss(withDelay: 3.0)
    }
    
    // Selector
    
    @objc func performActionSheetClicked() {
        
    }
    
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension Date {
    func toString(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let strDate = formatter.string(from: self as Date)
        return strDate
    }
}

