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

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let interactor: SearchInteractor = SearchInteractor()
    
    // MARK: - OVERRIDE FUNC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "TLab Overflow"
        
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
            self.interactor.nextWith(withTag: "ios", pageSize: 10, from: "1473811200", to: "1473897600", success: { () -> (Void) in
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
        interactor.refresh(withTag: "ios", pageSize: 10, from: "1473811200", to: "1473897600", success: { () -> (Void) in
            self.tableView.pullToRefreshView.stopAnimating()
            self.tableView.infiniteScrollingView.stopAnimating()
            self.tableView.showsInfiniteScrolling = self.interactor.hasNext
            self.tableView.reloadData()
            self.tableView.reloadEmptyDataSet()
        }) { (error) -> (Void) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            self.tableView.pullToRefreshView.stopAnimating()
            self.tableView.infiniteScrollingView.stopAnimating()
        }
    }
    
    func loadData() {
        interactor.loadKey()
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

