//
//  HomeVC.swift
//  LocationBasedEcommerceApp
//
//  Created by Subham Padhi on 03/02/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import MapKit
import FirebaseDatabase
import Firebase
import CodableFirebase
import Alamofire
import SwiftyJSON

typealias JSONDictionary = [String:Any]

class HomeVC: UIViewController , CLLocationManagerDelegate , UITableViewDelegate ,UITableViewDataSource {
    
    var ref: DatabaseReference?
    var location: [Location]?
    var isReady = false
    var category: [Category]?
    var items: [StoreItem]?
    var currentState: String?
    var currentCity: String?
    var indexOfCurrentCity: Int?
    
    func showAlert(title: String, message: String, presenter: UIViewController) {
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        presenter.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isReady{
            return (category?.count)! + 1
            
        }else {
            return 0
        }
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! HeaderCell
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell", for: indexPath) as! CategoriesCell
            cell.selectionStyle = .none
            
            cell.categoriesButton.setTitle(category?[indexPath.row - 1].category_name, for: .normal)
            cell.selectCategories = {
               () in
                print("clicked")
               let vc = ItemsMenuVC()
                vc.selectedCategory = (self.category?[indexPath.row - 1].category_name)!
                let item = self.category?[indexPath.row-1].items
                self.items = item
                vc.items = self.items
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        }else {
            return 70
        }
    }
    
    
    var locationManager:CLLocationManager!
    
    let authStatus = CLLocationManager.authorizationStatus()
    let inUse = CLAuthorizationStatus.authorizedWhenInUse
    let always = CLAuthorizationStatus.authorizedAlways
    
    override func viewDidLoad() {
        super .viewDidLoad()
        UserDefaults.standard.set(false, forKey: "isLocationSet")
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        initUI()
    }
    
    var tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.separatorColor = #colorLiteral(red: 0.1215686277, green: 0.1294117719, blue: 0.1411764771, alpha: 1)
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    func initUI() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(HeaderCell.self, forCellReuseIdentifier: "headerCell")
        tableView.register(CategoriesCell.self, forCellReuseIdentifier: "categoriesCell")
        
        view.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        findCurrentLocation()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(true)
        }
    
    func parseJSON() {
        DispatchQueue.main.async {
        var isStoreAvailableInLocation = false
        
        let url = URL(string: "http://ec2-35-154-201-59.ap-south-1.compute.amazonaws.com:5000/getlocations")!
            
        Alamofire.request(url).validate().responseJSON(completionHandler: { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let newJson = json["result"][0]["locations"]
                let encodedData = try? JSONEncoder().encode(newJson)
                if let encodedObjectJsonString = String(data: encodedData!, encoding: .utf8)
                {
                  //  print(encodedObjectJsonString)
                    if let model = try? JSONDecoder().decode([Location].self, from: encodedData!) {
                      self.location = model
                        for i in 0..<(self.location?.count)!{
                            print((self.currentState)!)
                            if ((self.location?[i].state)! == (self.currentState)!){
                                self.currentCity  = self.location?[i].name
                                self.indexOfCurrentCity = i
                                isStoreAvailableInLocation = true
                                if !UserDefaults.standard.bool(forKey: "isLocationSet") {
                                    self.showAlert(title: "Yay!", message: "We have found a store nearby in \((self.currentCity)!)", presenter: self)
                                    self.dismiss(animated: true){
                                        self.setCurrentLocation(location: (self.currentCity)!)
                                    }
                                    UserDefaults.standard.set(true, forKey: "isLocationSet")
                                }
                            }
                        }
                        if !isStoreAvailableInLocation {
                            if !UserDefaults.standard.bool(forKey: "isLocationSet"){
                                let actionSheet = UIAlertController(title: "Oops", message: "Looks like there is no store nearby , Please chose one from the list", preferredStyle: .actionSheet)
                                for i in 0..<(self.location?.count)!{
                                    actionSheet.addAction(UIAlertAction(title: "\((self.location?[i].name)!)", style: .default, handler: { (action: UIAlertAction) in
                                        self.setCurrentLocation(location: "\((self.location?[i].name)!)")
                                    }))
                                }
                                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                                self.present(actionSheet, animated: true, completion: nil)
                            }
                        }
                    
                    } else {
                        print("JSON failed")
                    }
                }
                
            case .failure(let error):
                self.showAlert(title: "OOPS", message: error.localizedDescription, presenter: self)
                print(error.localizedDescription)
            }
        })
        }
    }
    

    
    func setCurrentLocation (location:String){
        self.currentCity = location
        print(location)
        print(currentCity!)
        UserDefaults.standard.set(true, forKey: "isLocationSet")
        showCategories()
    }
    
    func showValues() {
        
    }
    
    func showCategories() {
                for i in 0..<(self.location?.count)! {
                    if (self.location?[i].name)! == (self.currentCity!){
                        self.indexOfCurrentCity = i
                         print(self.indexOfCurrentCity!)
                    }
                }
                print((self.location?[self.indexOfCurrentCity!].stores?[0].categories.count)!)
                self.category = self.location?[self.indexOfCurrentCity!].stores?[0].categories
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.isReady = true
    }
    
    func findCurrentLocation() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        setUsersClosestCity(lat: userLocation.coordinate.latitude, long: userLocation.coordinate.longitude)
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func setUsersClosestCity(lat:Double , long: Double)
    {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude:lat, longitude: long)
        geoCoder.reverseGeocodeLocation(location)
        {
            (placemarks, error) -> Void in
            
            let placeArray = placemarks
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placeArray?[0]
            if let locationName = placeMark.administrativeArea as NSString?
            {
                print(locationName)
                self.currentState = locationName as String
                
            }
            
            if let street = placeMark.thoroughfare as NSString?
            {
                print(street)
            }
            
            if let city = placeMark.subAdministrativeArea as NSString?
            {
                print(city)
            }
            
            if let zip = placeMark.isoCountryCode as NSString?
            {
                print(zip)
            }
            
            if let country = placeMark.country as NSString?
            {
                print(country)
            }
            self.parseJSON()
        }
        
        
    }
    
    //    func getInfo() {
    //        var isStoreAvailableInLocation = false
    //        ref = Database.database().reference()
    //        ref?.child("locations").observeSingleEvent(of: .value, with: { snapshot in
    //            guard let value = snapshot.value else { return }
    //            do {
    //                let model = try FirebaseDecoder().decode([Location].self, from: value)
    //
    //                self.location = model
    //
    //                for i in 0..<(self.location?.count)!{
    //                   print((self.currentState)!)
    //                   if ((self.location?[i].state)! == (self.currentState)!){
    //                    self.currentCity  = self.location?[i].name
    //                    self.indexOfCurrentCity = i
    //                    isStoreAvailableInLocation = true
    //                    if !UserDefaults.standard.bool(forKey: "isLocationSet") {
    //                        self.showAlert(title: "Yay!", message: "We have found a store nearby in \((self.currentCity)!)", presenter: self)
    //                        self.dismiss(animated: true){
    //                            self.setCurrentLocation(location: (self.currentCity)!)
    //                        }
    //                        UserDefaults.standard.set(true, forKey: "isLocationSet")
    //                    }
    //                   }
    //                }
    //
    //                if !isStoreAvailableInLocation {
    //                    if !UserDefaults.standard.bool(forKey: "isLocationSet"){
    //                    let actionSheet = UIAlertController(title: "Oops", message: "Looks like there is no store nearby , Please chose one from the list", preferredStyle: .actionSheet)
    //                    for i in 0..<(self.location?.count)!{
    //                        actionSheet.addAction(UIAlertAction(title: "\((self.location?[i].name)!)", style: .default, handler: { (action: UIAlertAction) in
    //                            self.setCurrentLocation(location: "\((self.location?[i].name)!)")
    //                        }))
    //                    }
    //                    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    //                    self.present(actionSheet, animated: true, completion: nil)
    //                    }
    //                }
    //            } catch let error {
    //                print(error)
    //            }
    //        })
    //    }
    
}

class HeaderCell: UITableViewCell {
    
    var heading: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Nunito-Bold", size: 10)
        label.textColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 0.9529411765, alpha: 1)
        label.text = "Please select your shopping category"
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        initViews()
    }
    
    func initViews () {
        
        addSubview(heading)
        heading.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        heading.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
    }
}

class CategoriesCell: UITableViewCell {
    
    var selectCategories: (() -> ())?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func selectItem(){
        selectCategories?()
    }
    
    let categoriesButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("VISIT", for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito", size: 14)
        button.setTitleColor(#colorLiteral(red: 0.1215686277, green: 0.1294117719, blue: 0.1411764771, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.layer.cornerRadius = 25
        button.isUserInteractionEnabled = true
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        initViews()
    }
    
    func initViews() {
        addSubview(categoriesButton)
        categoriesButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        categoriesButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        categoriesButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25).isActive = true
        categoriesButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let buttonTap = UITapGestureRecognizer(target: self, action: #selector(CategoriesCell.selectItem))
        categoriesButton.addGestureRecognizer(buttonTap)
        categoriesButton.isUserInteractionEnabled = true
    }
}
