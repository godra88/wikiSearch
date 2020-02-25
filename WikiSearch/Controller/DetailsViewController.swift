//
//  DetailsViewController.swift
//  WikiSearch
//
//  Created by Ivan Fabri on 2/17/20.
//  Copyright © 2020 Ivan Fabri. All rights reserved.
//

import UIKit
import Combine

class DetailsViewController: UIViewController {
    
    //MARK: - Properties
    
    let detailsTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: fontAvenirName, size: 15)
        return textView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.color = .gray
        activityIndicator.isHidden = true
        return activityIndicator
    }()
    
    var saveButton = UIBarButtonItem()
    
    var detailsViewModel: DetailsViewModel!
    var cancelables:[Cancellable]!
    var wikiList:PageList?
    var wikiSaved:ResultData?
    var notSaved:Bool?
    var url:String?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsViewModel = DetailsViewModel()
        bind()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if wikiList != nil {
            activityIndicator.startAnimating()
            self.title = wikiList?.title
            detailsViewModel.getDataWithSavingOptions(pageId: wikiList!.pageid, url: url!, title: wikiList!.title, snippet: wikiList!.snippet)
        } else {
            if wikiSaved != nil {
                detailsTextView.text = wikiSaved?.details
                self.title = wikiSaved?.title
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        detailsTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    //MARK: - Helper Functions
    
    func configureUI() {
        view.backgroundColor = .white
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed))
        if wikiList == nil {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            if notSaved! {
                self.navigationItem.rightBarButtonItem = saveButton
            }
        }
        
        view.addSubview(detailsTextView)
        view.addSubview(activityIndicator)
        
        detailsTextView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.readableContentGuide.leftAnchor, bottom: view.bottomAnchor, right: view.readableContentGuide.rightAnchor)
        
        activityIndicator.anchor()
        activityIndicator.centerY(inView: view)
        activityIndicator.centerX(inView: view)
    }
    
    func bind() {
        cancelables = [
            detailsViewModel.wikiDetails.sink(receiveValue: { (value) in
                self.detailsTextView.text = value
                self.activityIndicator.stopAnimating()
            }),
            
            detailsViewModel.savedData.sink(receiveValue: { (value) in
                if value == true {
                    self.showAlert(title: "", message: NSLocalizedString("SavedMessageAlert", comment: ""), timeInterval: 1.0)
                    self.navigationItem.rightBarButtonItem = nil
                } else if value == false {
                    self.showAlert(title: "Error", message: NSLocalizedString("ErrorSavingMessage", comment: ""), timeInterval: 0.5)
                }
            }),
            
            detailsViewModel.didFinishLoading.sink(receiveValue: { (value) in
                if value == false {
                    self.showAlert(title: NSLocalizedString("ErrorAlertTitle", comment: ""), message: NSLocalizedString("DataNotBeenParseAlertMessage", comment: ""), timeInterval: 1.0)
                }
            })
        ]
    }
    
    //MARK: - Selectors
    
    @objc func saveButtonPressed() {
        if wikiList != nil {
            detailsViewModel.getDataWithSavingOptions(pageId: wikiList!.pageid, url: url!, title: wikiList!.title, snippet: wikiList!.snippet, save: true)
        }
    }
}
