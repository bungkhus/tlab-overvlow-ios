//
//  SearchInteractor.swift
//  TLab Overflow
//
//  Created by bungkhus on 06/06/18.
//  Copyright © 2018 TLab. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class SearchInteractor: BaseInteractor {
    
    fileprivate var currentPage = 1
    
    open var hasNext: Bool {
        return currentPage != -1
    }
    
    var items: [SearchItem] = [SearchItem]()
    
    func loadKey() {
        items.removeAll()
        if let key = storeKey,
            let keyedValue = realm.object(ofType: KeyedValue.self, forPrimaryKey: key as AnyObject),
            let value = keyedValue.value
        {
            let json = JSON.init(parseJSON: value) // parse(value)
            for child in json.arrayValue {
                if let item = realm.object(ofType: SearchItem.self, forPrimaryKey: child.rawValue as AnyObject) {
                    items.append(SearchItem(value: item))
                }
            }
        }
    }
    
    //pagesize=10&fromdate=1473811200&todate=1473897600&order=desc&sort=activity&tagged=ios&site=stackoverflow
    func refresh(withTag tag: String, pageSize: Int, from: String, to: String, success: @escaping () -> (Void), failure: @escaping (NSError) -> (Void)) {
        currentPage = 1
        nextWith(withTag: tag, pageSize: pageSize, from: from, to: to, success: success, failure: failure)
    }
    
    func nextWith(withTag tag: String, pageSize: Int, from: String, to: String, success: @escaping () -> (Void), failure: @escaping (NSError) -> (Void)) {
        //var params = [String: String]()
        params = [
            "tagged": "\(tag)",
            "pagesize": "\(pageSize)",
            "fromdate": "\(from)",
            "todate": "\(to)",
            "order": "desc",
            "sort": "activity",
            "site": "stackoverflow"
        ]
        
        service.getSeacrhResultItems(params: params, page: currentPage, callback: { result in
            switch result {
            case let .success(pagination) :
                if pagination.currentPage == 1 {
                    self.items.removeAll()
                    self.removeAllModelsOf(type: SearchItem.self, filter: nil)
                }
                if pagination.hasMore {
                    self.currentPage = pagination.currentPage + 1
                } else {
                    self.currentPage = -1
                }
                for object in pagination.data {
                    self.saveModel(data: SearchItem(value: object))
                }
                self.items.append(contentsOf: pagination.data)
                success()
            case let .failure(error) :
                failure(error)
            }
        })
    }
    
}
