//
//  ItemDescriptionVC.swift
//  LocationBasedEcommerceApp
//
//  Created by Subham Padhi on 04/02/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import Foundation
import UIKit

class ItemDescriptionVC : UIViewController {
    
    var items: StoreItem?
    var index: String = ""
    
    lazy var itemImage: UIImageView = {
        
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var itemNameLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Nunito-SemiBold", size: 16)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    var itemPriceLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Nunito-Bold", size: 12)
        label.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    
    override func viewDidLoad() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupViews()
        itemNameLabel.text = self.items?.name
        itemPriceLabel.text = "Rs \((self.items?.price)!)"
    }
    
    var submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 0.9529411765, alpha: 1)
        button.setTitle("Buy Now", for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito-SemiBold", size: 20)
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(ItemDescriptionVC.submit), for: .touchUpInside)
        return button
    }()
    
   @objc func submit(){
    }

    
    func setupViews() {
        view.addSubview(itemImage)
        view.addSubview(itemNameLabel)
        view.addSubview(itemPriceLabel)
        view.addSubview(submitButton)
        
        itemImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 15).isActive = true
        itemImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        itemImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        itemImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        itemNameLabel.topAnchor.constraint(equalTo: itemImage.bottomAnchor, constant: 15).isActive = true
        itemNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        itemNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        
        itemPriceLabel.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant:5).isActive = true
        itemPriceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        itemPriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        if #available(iOS 11.0, *) {
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }

        
    }
}
