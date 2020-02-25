//
//  ListViewModel.swift
//  WikiSearch
//
//  Created by Ivan Fabri on 2/18/20.
//  Copyright © 2020 Ivan Fabri. All rights reserved.
//

import UIKit
import Combine
import CoreData

class ListViewModel {
    var wikiList = [PageList]()
    var wikiListSaved = [ResultData]()
    var languageArray = [NSLocalizedString("EnglishTextShort", comment: ""), NSLocalizedString("SlovakTextShort", comment: ""), NSLocalizedString("CzechTextShort", comment: "")]
    var countNumberOfLoaging = 0
    var didFinishLoading = CurrentValueSubject<Bool?, Never>(nil)
    var searchFirstTimeString:String?
    
    private var cancellables = Set<AnyCancellable>()
    
    public func getData(search:String, url:String, firstSearch:Bool = false) {
        
        let searchString = firstTimeSearch(firstSearch: firstSearch, search: search)
        
        Service.shared.parseWikiList(searchString: searchString, Offset: "\(countNumberOfLoaging)", url: url, completion: { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.didFinishLoading.send(false)
                }
                print(error)
            case .success(let pages):
                self.wikiList += pages
                self.countNumberOfLoaging += 10
                DispatchQueue.main.async {
                    self.didFinishLoading.send(true)
                }
            }
        })
    }
    
    private func firstTimeSearch(firstSearch: Bool, search: String) -> String {
        let searchString:String
        
        if firstSearch {
            self.wikiList.removeAll()
            self.countNumberOfLoaging = 0
            self.searchFirstTimeString = search
        }
        if self.searchFirstTimeString != nil {
            searchString = self.searchFirstTimeString!
        } else {
            searchString = search
        }
        
        return searchString
    }
    
    public func fetchSavedData(completion: @escaping () -> Void) {
        wikiListSaved.removeAll()
        
        let fetchRequest: NSFetchRequest<ResultData> = ResultData.fetchRequest()
        
        do {
            let resultData = try PersistanceService.context.fetch(fetchRequest)
            for item in resultData {
                wikiListSaved.append(item)
            }
            completion()
        } catch let error {
            print(error)
        }
    }
    
    public func deleteObjectAtIndex(indexPath: IndexPath) {
        let context:NSManagedObjectContext = PersistanceService.context
        context.delete(wikiListSaved[indexPath.row] )
        wikiListSaved.remove(at: indexPath.row)
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    public func filterSavedObjects(indexPath: IndexPath) -> Bool {
        let pageId = wikiList[indexPath.row].pageid
        
        let isIsSaved = wikiListSaved.filter({$0.pageid == pageId})
        if isIsSaved.count == 1 {
            return false
        } else {
            return true
        }
    }
}
