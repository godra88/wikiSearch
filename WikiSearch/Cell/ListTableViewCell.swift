//
//  ListTableViewCell.swift
//  WikiSearch
//
//  Created by Ivan Fabri on 2/23/20.
//  Copyright © 2020 Ivan Fabri. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    var titleLabel:UILabel = {
        var label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont(name: fontAvenirName, size: 17)
        label.textAlignment = .left
        return label
    }()
    
    var snippetLabel:UILabel = {
        var label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name: fontAvenirName, size: 14)
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()
    
    var savedImage:UIImageView = {
        var imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "save")
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(savedImage)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(snippetLabel)
        
        savedImage.anchor(top: self.contentView.topAnchor, right: self.contentView.rightAnchor, paddingTop: 8, paddingRight: 15, width: 30, height: 30)
        titleLabel.anchor(top: self.contentView.topAnchor, left: self.contentView.leftAnchor, paddingTop: 15, paddingLeft: 15)
        let titleHeightContraint = titleLabel.heightAnchor.constraint(equalToConstant: 21)
        titleHeightContraint.priority = UILayoutPriority(999)
        titleHeightContraint.isActive = true
        
        snippetLabel.anchor(top: titleLabel.bottomAnchor, left: self.contentView.leftAnchor, right: self.contentView.rightAnchor, paddingTop: 8, paddingLeft: 15, paddingRight: 15)
        
        let snippetBottomContraint = snippetLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
        snippetBottomContraint.priority = UILayoutPriority(999)
        snippetBottomContraint.isActive = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
