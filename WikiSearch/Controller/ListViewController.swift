//
//  ListViewController.swift
//  WikiSearch
//
//  Created by Ivan Fabri on 2/17/20.
//  Copyright © 2020 Ivan Fabri. All rights reserved.
//

import UIKit
import Combine

class ListViewController: UIViewController {
    
    //MARK: - Properties
    
    var listTableView : UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = true
        return tableView
    }()
    
    var searchView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.customBlue.cgColor
        view.backgroundColor = .customLightBlue
        return view
    }()
    
    var chooseLanguageView: UIView = {
        var view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.customBlue.cgColor
        view.backgroundColor = .customLightBlue
        view.isHidden = true
        return view
    }()
    var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    var searchTextField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .search
        textField.borderStyle = .none
        textField.clearButtonMode = .always
        textField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("placeholderSearchText", comment: ""), attributes: [NSAttributedString.Key.foregroundColor : UIColor.customBlue, NSAttributedString.Key.font : UIFont(name: fontAvenirName, size: 15)!])
        return textField
    }()
    var searchButton :UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "search"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .customYeallow
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var doneChoosingLangButton :UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("DoneButtonText", comment: ""), for: .normal)
        button.tintColor = .customBlue
        button.addTarget(self, action: #selector(doneChoosingLangButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var languagePicker: UIPickerView = {
        var picker = UIPickerView()
        picker.tintColor = .customBlue
        return picker
    }()
    
    var languageButton :UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("EnglishTextShort", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(languageButtonPressed), for: .touchUpInside)
        button.tintColor = .white
        button.backgroundColor = .customBlue
        return button
    }()
    
    var activityIndicator: UIActivityIndicatorView = {
        var activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.color = .gray
        activityIndicator.isHidden = true
        return activityIndicator
    }()
    
    var activityIndicatorLoadMore: LoadMoreActivityIndicator!
    var listViewModel: ListViewModel!
    var cancelables:[Cancellable]!
    var didFinishLoading = false
    var currentLangage = baseWikiUrl.english.rawValue
    var isItSearchController:Bool?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listViewModel = ListViewModel()
        bind()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isItSearchController! {
            self.parent?.title = NSLocalizedString("SearchTitleText", comment: "")
        } else {
            self.parent?.title = NSLocalizedString("SavedTitleText", comment: "")
        }
        listViewModel.fetchSavedData {self.listTableView.reloadData()}
    }
    
    //MARK: - Helper Functions
    
    func configureUI() {
        searchTextField.delegate = self
        
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.tableFooterView = UIView()
        listTableView.rowHeight = UITableView.automaticDimension
        listTableView.estimatedRowHeight = 100
        listTableView.register(ListTableViewCell.self, forCellReuseIdentifier: savedCell)
        activityIndicatorLoadMore = LoadMoreActivityIndicator(scrollView: listTableView, spacingFromLastCell: 0, spacingFromLastCellWhenLoadMoreActionStart: 0)
        
        languagePicker.delegate = self
        languagePicker.dataSource = self
        
        view.backgroundColor = .white
        
        view.addSubview(listTableView)
        view.addSubview(headerView)
        view.addSubview(chooseLanguageView)
        view.addSubview(activityIndicator)
        chooseLanguageView.addSubview(languagePicker)
        chooseLanguageView.addSubview(doneChoosingLangButton)
        headerView.addSubview(searchView)
        searchView.addSubview(searchTextField)
        searchView.addSubview(searchButton)
        searchView.addSubview(languageButton)
        
        if isItSearchController! {
            headerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        } else {
            headerView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            headerView.isHidden = true
        }
        headerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        listTableView.anchor(top: headerView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        searchView.anchor(left: headerView.safeAreaLayoutGuide.leftAnchor, right: headerView.safeAreaLayoutGuide.rightAnchor, paddingLeft: 20, paddingRight: 20, height: 60)
        searchView.centerY(inView: headerView)
        
        searchTextField.anchor(left: searchView.leftAnchor, right: languageButton.leftAnchor, paddingLeft: 10, height: 40)
        searchTextField.centerY(inView: searchView)
        
        languageButton.anchor(right: searchButton.leftAnchor, height: 40)
        languageButton.centerY(inView: searchTextField)
        
        searchButton.anchor(right: searchView.rightAnchor, paddingRight: 10, width: 50, height: 40)
        searchButton.centerY(inView: searchTextField)
        
        chooseLanguageView.anchor(width: view.frame.width/2, height: view.frame.width/2)
        chooseLanguageView.centerY(inView: view)
        chooseLanguageView.centerX(inView: view)
        
        languagePicker.anchor(top: chooseLanguageView.topAnchor, left: chooseLanguageView.leftAnchor, bottom: chooseLanguageView.bottomAnchor, right: chooseLanguageView.rightAnchor, paddingTop: 25)
        doneChoosingLangButton.anchor(top: chooseLanguageView.topAnchor, right: chooseLanguageView.rightAnchor, paddingRight: 10, width: 40, height: 25)
        
        activityIndicator.anchor()
        activityIndicator.centerX(inView: view)
        activityIndicator.centerY(inView: view)
    }
    
    func bind() {
        cancelables = [
            listViewModel.didFinishLoading.sink(receiveValue: { bool in
                if bool == true {
                    self.listTableView.reloadData()
                    self.activityIndicatorLoadMore.stop()
                    self.activityIndicator.stopAnimating()
                } else if bool == false {
                    self.showAlert(title: NSLocalizedString("ErrorAlertTitle", comment: ""), message: NSLocalizedString("DataNotBeenParseAlertMessage", comment: ""), timeInterval: 1.0)
                }
            })
        ]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isItSearchController! {
            activityIndicatorLoadMore.start {
                self.listViewModel.getData(search: self.searchTextField.text!, url: self.currentLangage)
            }
        }
    }
    
    func goToDetails(indexPath: IndexPath, notSaved:Bool = false) {
        let detailsView = DetailsViewController()
        if isItSearchController! {
            detailsView.wikiList = listViewModel.wikiList[indexPath.row]
            detailsView.url = currentLangage
            detailsView.notSaved = notSaved
        } else {
            detailsView.wikiSaved = listViewModel.wikiListSaved[indexPath.row]
        }
        
        self.navigationController?.pushViewController(detailsView, animated: true)
    }
    
    //MARK: - Selectors
    
    @objc func searchButtonPressed() {
        if searchTextField.text!.count > 0 {
            activityIndicator.startAnimating()
            listViewModel.getData(search: searchTextField.text!, url: currentLangage, firstSearch: true)
        } else {
            listViewModel.wikiList.removeAll()
            listTableView.reloadData()
        }
        searchTextField.resignFirstResponder()
    }
    
    @objc func languageButtonPressed() {
        chooseLanguageView.isHidden = false
        listTableView.allowsSelection = false
    }
    
    @objc func doneChoosingLangButtonPressed() {
        chooseLanguageView.isHidden = true
        listTableView.allowsSelection = true
        searchButton.sendActions(for: .touchUpInside)
        searchTextField.resignFirstResponder()
    }
    
    @objc func tapOnView() {
        searchTextField.resignFirstResponder()
    }
}

//MARK: - TableView delegate and Datasource

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isItSearchController! {
            return listViewModel.wikiList.count
        } else {
            return listViewModel.wikiListSaved.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: savedCell) as! ListTableViewCell
        if isItSearchController! {
            cell.savedImage.isHidden = listViewModel.filterSavedObjects(indexPath: indexPath)
            
            let wikiList = listViewModel.wikiList[indexPath.row]
            cell.titleLabel.text = wikiList.title
            cell.snippetLabel.text = wikiList.snippet.htmlDecoded
        } else {
            let wikiListSaved = listViewModel.wikiListSaved[indexPath.row]
            cell.titleLabel.text = wikiListSaved.title
            cell.snippetLabel.text = wikiListSaved.snippet?.htmlDecoded
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if !isItSearchController! {
            let contextItem = UIContextualAction(style: .destructive, title: NSLocalizedString("DeleteCellText", comment: "")) {  (contextualAction, view, boolValue) in
                
                self.listViewModel.deleteObjectAtIndex(indexPath: indexPath)
                self.listTableView.deleteRows(at: [(indexPath as IndexPath)], with: .fade)
            }
            contextItem.backgroundColor = .customBlue
            let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
            
            return swipeActions
            
        } else {
            
            return UISwipeActionsConfiguration()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isItSearchController! {
            let notSaved = listViewModel.filterSavedObjects(indexPath: indexPath)
            goToDetails(indexPath: indexPath, notSaved: notSaved)
        } else {
            goToDetails(indexPath: indexPath)
        }
        searchTextField.resignFirstResponder()
    }
}

//MARK: - Picker delegate and Datasource

extension ListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listViewModel.languageArray.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listViewModel.languageArray[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        languageButton.setTitle(listViewModel.languageArray[row], for: .normal)
        switch row {
        case 0:
            currentLangage = baseWikiUrl.english.rawValue
        case 1:
            currentLangage = baseWikiUrl.slovak.rawValue
        case 2:
            currentLangage = baseWikiUrl.czech.rawValue
        default: break
        }
    }
}

//MARK: - TextField delegate

extension ListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchTextField.resignFirstResponder()
            searchButton.sendActions(for: .touchUpInside)
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            textField.text = ""
            searchButton.sendActions(for: .touchUpInside)
        }
        return true
    }
}
