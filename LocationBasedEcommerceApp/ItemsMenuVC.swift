//
//  ItemsMenuVC.swift
//  LocationBasedEcommerceApp
//
//  Created by Subham Padhi on 04/02/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import Foundation
import UIKit

class ItemsMenuVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
   
    var selectedCategory: String = ""
    var items: [StoreItem]?
    
    lazy var itemsTable: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.isTranslucent = false
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        titleLabel.text = "\(selectedCategory)"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Nunito-Bold", size: 18)
        titleLabel.textColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 0.9529411765, alpha: 1)
        navigationItem.titleView = titleLabel
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(itemsTable)
        itemsTable.dataSource = self
        itemsTable.delegate = self
        itemsTable.separatorStyle = .none
        itemsTable.leadingAnchor.constraint(equalTo:view.leadingAnchor).isActive = true
        itemsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        itemsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        itemsTable.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        itemsTable.register(ItemsTableViewCell.self, forCellReuseIdentifier: "itemsTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (items?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemsTableViewCell") as! ItemsTableViewCell
        cell.selectionStyle = .none
        cell.itemNameLabel.text = items?[indexPath.row].name
        cell.itemPriceLabel.text = "\((items?[indexPath.row].price)!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ItemDescriptionVC()
        vc.items = items?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

class ItemsTableViewCell: UITableViewCell {
    
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
        return label
    }()
    
    var itemPriceLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Nunito-Bold", size: 12)
        label.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        return label
    }()
    
    var bottomView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.7333333333, green: 0.7333333333, blue: 0.7333333333, alpha: 1)
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView() {
        addSubview(itemImage)
        addSubview(itemNameLabel)
        addSubview(itemPriceLabel)
        addSubview(bottomView)
        
        itemImage.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        itemImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        itemImage.widthAnchor.constraint(equalToConstant: frame.width/3).isActive = true
        itemImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        bottomView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomView.widthAnchor.constraint(equalToConstant: frame.width/1.2).isActive = true
        bottomView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        bottomView.topAnchor.constraint(equalTo: itemPriceLabel.bottomAnchor, constant: 15).isActive = true
        
        itemNameLabel.leadingAnchor.constraint(equalTo: itemImage.trailingAnchor, constant: 10).isActive = true
        itemNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        itemNameLabel.topAnchor.constraint(equalTo: itemImage.topAnchor, constant: 10).isActive = true
        
        itemPriceLabel.leadingAnchor.constraint(equalTo: itemNameLabel.leadingAnchor).isActive = true
        itemPriceLabel.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: 15).isActive = true
        
        
    }
}

