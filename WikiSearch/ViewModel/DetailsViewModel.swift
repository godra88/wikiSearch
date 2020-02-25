//
//  DetailsViewModel.swift
//  WikiSearch
//
//  Created by Ivan Fabri on 2/19/20.
//  Copyright © 2020 Ivan Fabri. All rights reserved.
//

import UIKit
import Combine

class DetailsViewModel {
    var wikiDetails = CurrentValueSubject<String?, Never>(nil)
    var savedData = CurrentValueSubject<Bool?, Never>(nil)
    var didFinishLoading = CurrentValueSubject<Bool?, Never>(nil)
    
    public func getDataWithSavingOptions(pageId:Int, url:String, title:String, snippet:String, save:Bool = false) {
        Service.shared.parseDetailsFromId(pageId: pageId, url: url) { result in
            switch result {
            case .success(let item):
                DispatchQueue.main.async {
                    self.wikiDetails.send(item.htmlDecoded)
                    if save == true {
                        self.saveDataToPhoneMemory(pageId: pageId, title: title, snippet: snippet, details: item.htmlDecoded)
                    }
                }
            case .failure(let error):
                if save {
                    self.savedData.send(false)
                } else {
                    self.didFinishLoading.send(false)
                }
                print(error)
            }
        }
    }
    
    private func saveDataToPhoneMemory(pageId:Int, title:String, snippet:String, details:String) {
        let resultData = ResultData(context: PersistanceService.context)
        resultData.pageid = Int32(pageId)
        resultData.title = title
        resultData.snippet = snippet
        resultData.details = details
        PersistanceService.saveContext()
        savedData.send(true)
    }
}
