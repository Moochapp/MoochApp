////
//  CreateItemViewController.swift
//  Mooch
//
//  Created by App Center on 3/29/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding

class CreateItemViewController: UIViewController {
    
    var coordinator: MainCoordinator!
    var item: Item!
    let cellDescriptions = ["ImageAreaSectionCell", "ItemNameCell", "CategoryCell", "SubCategoryCell", "AvailableCell", "RentalFeeCell", "SalePrceCell"]
    var dataSource: [String] = []
    var selectedAvailabilities: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Item"
        self.view.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        setupTable()
        setupCollectionViews()
        setupPickerView()
        setupToolbar()
        setupDoneButton()
        
    }
    
    var tableView: UITableView!
    var imageGallaryCollectionView: UICollectionView?
    var moreItemsCollectionView: UICollectionView!
    var moreByOwnerCollectionView: UICollectionView!
    var pickerView: UIPickerView!
    var toolbar: UIToolbar!
    var activeTextField: UITextField?
    
    func setupTable() {
        self.tableView = UITableView(frame: .zero, style: .plain)
        self.view.addSubview(tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(8)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(16)
        }
        for item in cellDescriptions {
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: item)
        }
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 20
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        KeyboardAvoiding.avoidingView = tableView
        KeyboardAvoiding.padding = 16
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    func setupCollectionViews() {
        moreItemsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        moreItemsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "SimilarItem")
        moreItemsCollectionView.backgroundColor = .clear
        
        moreByOwnerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        moreByOwnerCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "OwnerItem")
        moreByOwnerCollectionView.backgroundColor = .clear
    }
    
    func setupPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        self.pickerView = pickerView
    }
    
    func setupToolbar() {
        let toolbar = UIToolbar()
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneEditing))
        done.tintColor = EKColor.Mooch.lightBlue
        toolbar.setItems([spacer, done], animated: false)
        toolbar.sizeToFit()
        self.toolbar = toolbar
    }
    
    func setupDoneButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(createItem))
    }
    
    @objc func changeContentMode(sender: UITapGestureRecognizer) {
        if let view = sender.view {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: {
                    if view.contentMode == .scaleAspectFill {
                        view.contentMode = .scaleAspectFit
                    } else {
                        view.contentMode = .scaleAspectFill
                    }
                })
            }
        }
    }
    @objc func doneEditing() {
        self.view.endEditing(true)
    }
    @objc func createItem() {
        print("Created Item")
        guard let name = (view.viewWithTag(12) as? UITextField)?.text else { return }
        guard name.isEmpty == false else {
            showAlert(title: "Hmm...", desc: "Please enter a name for the item.")
            return
        }
        self.item.name = name
        
        guard let category = (view.viewWithTag(22) as? UITextField)?.text else { return }
        guard category.isEmpty == false else {
            showAlert(title: "Hmm...", desc: "Please select an item from categories.")
            return
        }
        self.item.category = category
        
        guard let subcategory = (view.viewWithTag(32) as? UITextField)?.text else { return }
        guard subcategory.isEmpty == false else {
            showAlert(title: "Hmm...", desc: "Please select an item from subcategories.")
            return
        }
        self.item.subcategory = subcategory
        
        guard let mooching = (view.viewWithTag(42) as? Checkbox)?.isChecked else { return }
        guard let renting = (view.viewWithTag(43) as? Checkbox)?.isChecked else { return }
        guard let buying = (view.viewWithTag(44) as? Checkbox)?.isChecked else { return }
        
        self.item.availableFor = [.buy: buying, .mooch: mooching, .rent: renting]
        
        guard mooching == true || renting == true || buying == true else {
            showAlert(title: "Hmm...", desc: "Please select availability for this item.")
            return
        }
        
        if renting == true {
            guard let rentalFee = (view.viewWithTag(53) as? UITextField)?.text else {
                showAlert(title: "Hmm...", desc: "Please enter a fee for renting this item.")
                return
            }
            
            guard let unit = (view.viewWithTag(55) as? UITextField)?.text else { return }
            guard unit.isEmpty == false else {
                showAlert(title: "Hmm...", desc: "Please select a rental fee interval.")
                return
            }
            
            item.rentalFee = Double(rentalFee) ?? 0.0
            self.item.rentalInterval = unit
        }
        
        if buying == true {
            guard let price = (view.viewWithTag(63) as? UITextField)?.text else { return }
            guard price.isEmpty == false else {
                showAlert(title: "Hmm...", desc: "Please enter a price for this item.")
                return
            }
            item.price = Double(price) ?? 0.0
        }
        
        self.item.owner = Session.shared.moocher.id
        self.showProgressIndicator(completion: { (view) in
            self.item.upload(progress: { (index, progress) in
                print(index, progress)
            }) { (error) in
                guard error == nil else {
                    print(error!.localizedDescription)
                    view.stopAnimating()
                    return
                }
                view.stopAnimating()
                self.finishCreate()
                print("DONE!!!")
            }
        })
        
    }
    
    let categoryData = ExploreViewModel.categoryData.data
    let units = ["Hour", "Day", "Week", "Month"]
    
    func showAlert(title: String, desc: String) {
        let em = EntryManager(viewController: self)
        em.showNotificationMessage(attributes: em.topToast, title: title, desc: desc,
                                   textColor: UIColor.white, imageName: nil, backgroundColor: EKColor.Mooch.darkGray,
                                   haptic: .error)
    }
    
    func finishCreate() {
        coordinator.navigationController.popToRootViewController(animated: true)
    }
}

extension CreateItemViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 250
        } else {
            return 90
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            // Configure cell 1
            let cell = tableView.dequeueReusableCell(withIdentifier: cellDescriptions[indexPath.section], for: indexPath)
            cell.selectionStyle = .none
            
            if self.item.images.count > 1 {
                if let cv = self.view.viewWithTag(01) as? UICollectionView {
                    imageGallaryCollectionView = cv
                } else {
                    let layout = SnappingCollectionViewLayout()
                    layout.scrollDirection = .horizontal
                    imageGallaryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
                    imageGallaryCollectionView?.backgroundColor = .clear
                    imageGallaryCollectionView?.decelerationRate = .fast
                    imageGallaryCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ItemImage")
                    imageGallaryCollectionView?.delegate = self
                    imageGallaryCollectionView?.dataSource = self
                    imageGallaryCollectionView?.tag = 01
                    
                    cell.addSubview(imageGallaryCollectionView!)
                    cell.backgroundColor = .clear
                    imageGallaryCollectionView!.snp.makeConstraints { (make) in
                        make.edges.equalToSuperview()
                    }
                }
                
            } else {
                guard let image = self.item.images.first else {
                    return cell
                }
                
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                
                cell.addSubview(imageView)
                
                imageView.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
                
            }
            
            return cell
        } else if section == 1 {
            // Configure cell 2
            let cell = tableView.dequeueReusableCell(withIdentifier: cellDescriptions[indexPath.section], for: indexPath)
            cell.selectionStyle = .none
            
            var header: UILabel
            if let label = self.view.viewWithTag(11) as? UILabel {
                header = label
            } else {
                header = UILabel(frame: .zero)
                header.font = UIFont(name: "Avenir", size: 20)
                header.textColor = #colorLiteral(red: 0.01112855412, green: 0.7845740914, blue: 0.9864193797, alpha: 1)
                header.text = "ITEM"
                header.tag = 11
                cell.addSubview(header)
                header.snp.makeConstraints { (make) in
                    make.left.top.right.equalToSuperview().inset(16)
                }
            }
            
            var textfield: UITextField
            if let view = self.view.viewWithTag(12) as? UITextField {
                textfield = view
            } else {
                textfield = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
                textfield.text = self.item.name
                cell.addSubview(textfield)
                textfield.snp.makeConstraints { (make) in
                    make.left.right.equalToSuperview().inset(16)
                    make.top.equalTo(header.snp.bottom).offset(8)
                    make.height.equalTo(35)
                }
                textfield.borderStyle = .none
                textfield.layer.borderColor = UIColor.lightGray.cgColor
                textfield.layer.borderWidth = 1
                textfield.layer.cornerRadius = textfield.frame.height / 2
                textfield.setLeftPaddingPoints(16)
                textfield.delegate = self
                textfield.tag = 12
            }
            
            return cell
        } else if section == 2 {
            // Configure cell 3
            let cell = tableView.dequeueReusableCell(withIdentifier: cellDescriptions[indexPath.section], for: indexPath)
            cell.selectionStyle = .none
            
            let header: UILabel
            if let label = self.view.viewWithTag(21) as? UILabel {
                header = label
            } else {
                header = UILabel(frame: .zero)
                header.font = UIFont(name: "Avenir", size: 20)
                header.textColor = #colorLiteral(red: 0.01112855412, green: 0.7845740914, blue: 0.9864193797, alpha: 1)
                header.text = "CATEGORY"
                header.tag = 21
                cell.addSubview(header)
                header.snp.makeConstraints { (make) in
                    make.left.top.right.equalToSuperview().inset(16)
                }
            }
            
            let textfield: UITextField
            if let tf = self.view.viewWithTag(22) as? UITextField {
                textfield = tf
            } else {
                textfield = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
                textfield.borderStyle = .none
                textfield.layer.borderColor = UIColor.lightGray.cgColor
                textfield.layer.borderWidth = 1
                textfield.layer.cornerRadius = textfield.frame.height / 2
                textfield.setLeftPaddingPoints(16)
                textfield.delegate = self
                textfield.tag = 22
                cell.addSubview(textfield)
                
                textfield.snp.makeConstraints { (make) in
                    make.left.right.equalToSuperview().inset(16)
                    make.top.equalTo(header.snp.bottom).offset(8)
                    make.height.equalTo(35)
                }
            }
            
            return cell
        } else if section == 3 {
            // Configure cell 4
            let cell = tableView.dequeueReusableCell(withIdentifier: cellDescriptions[indexPath.section], for: indexPath)
            cell.selectionStyle = .none
            
            let header: UILabel
            if let lbl = self.view.viewWithTag(31) as? UILabel {
                header = lbl
            } else {
                header = UILabel(frame: .zero)
                header.font = UIFont(name: "Avenir", size: 20)
                header.textColor = #colorLiteral(red: 0.01112855412, green: 0.7845740914, blue: 0.9864193797, alpha: 1)
                header.text = "SUBCATEGORY"
                header.tag = 31
                cell.addSubview(header)
                header.snp.makeConstraints { (make) in
                    make.left.top.right.equalToSuperview().inset(16)
                }
            }
            
            var textfield: UITextField
            if let tf = self.view.viewWithTag(32) as? UITextField {
                textfield = tf
            } else {
                textfield = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
                textfield.borderStyle = .none
                textfield.layer.borderColor = UIColor.lightGray.cgColor
                textfield.layer.borderWidth = 1
                textfield.layer.cornerRadius = textfield.frame.height / 2
                textfield.setLeftPaddingPoints(16)
                textfield.delegate = self
                textfield.tag = 32
                cell.addSubview(textfield)
                
                textfield.snp.makeConstraints { (make) in
                    make.left.right.equalToSuperview().inset(16)
                    make.top.equalTo(header.snp.bottom).offset(8)
                    make.height.equalTo(35)
                }
            }
            
            return cell
        } else if section == 4 {
            // Configure cell 3
            let cell = tableView.dequeueReusableCell(withIdentifier: cellDescriptions[indexPath.section], for: indexPath)
            cell.selectionStyle = .none
            
            var header: UILabel
            if let lbl = self.view.viewWithTag(41) as? UILabel {
                header = lbl
            } else {
                header = UILabel(frame: .zero)
                header.font = UIFont(name: "Avenir", size: 20)
                header.textColor = #colorLiteral(red: 0.01112855412, green: 0.7845740914, blue: 0.9864193797, alpha: 1)
                header.text = "AVAILABLE FOR"
                header.tag = 41
                cell.addSubview(header)
                header.snp.makeConstraints { (make) in
                    make.left.top.right.equalToSuperview().inset(16)
                }
            }
            
            let w = cell.frame.width
            let width = (w - 32 - 16) / 3
            let height = CGFloat(50)
            
            var mooching: Checkbox
            if let cb = view.viewWithTag(42) as? Checkbox {
                mooching = cb
            } else {
                mooching = Checkbox(frame: CGRect(x: 0, y: 0, width: width, height: height))
                mooching.setTitle(text: "Mooching")
                mooching.delegate = self
                mooching.tag = 42
                cell.addSubview(mooching)
                mooching.snp.makeConstraints { (make) in
                    make.left.equalToSuperview().inset(16)
                    make.top.equalTo(header.snp.bottom).offset(8)
                    make.width.equalTo(width)
                    make.height.equalTo(height)
                }
            }
            
            var renting: Checkbox
            if let cb = view.viewWithTag(43) as? Checkbox {
                renting = cb
            } else {
                renting = Checkbox(frame: CGRect(x: 0, y: 0, width: width, height: height))
                renting.setTitle(text: "Renting")
                renting.delegate = self
                renting.tag = 43
                cell.addSubview(renting)
                renting.snp.makeConstraints { (make) in
                    make.left.equalTo(mooching.snp.right).offset(8)
                    make.top.equalTo(header.snp.bottom).offset(8)
                    make.width.equalTo(width)
                    make.height.equalTo(height)
                }
            }
            
            var buying: Checkbox
            if let cb = view.viewWithTag(44) as? Checkbox {
                buying = cb
            } else {
                buying = Checkbox(frame: CGRect(x: 0, y: 0, width: width, height: height))
                buying.setTitle(text: "Buying")
                buying.delegate = self
                buying.tag = 44
                cell.addSubview(buying)
                buying.snp.makeConstraints { (make) in
                    make.left.equalTo(renting.snp.right).offset(8)
                    make.top.equalTo(header.snp.bottom).offset(8)
                    make.width.equalTo(width)
                    make.height.equalTo(height)
                }
            }
            
            return cell
        } else if section == 5 {
            // Configure cell 3
            let cell = tableView.dequeueReusableCell(withIdentifier: cellDescriptions[indexPath.section], for: indexPath)
            cell.selectionStyle = .none
            
            var header: UILabel
            if let lbl = view.viewWithTag(51) as? UILabel {
                header = lbl
            } else {
                header = UILabel(frame: .zero)
                header.font = UIFont(name: "Avenir", size: 20)
                header.textColor = #colorLiteral(red: 0.01112855412, green: 0.7845740914, blue: 0.9864193797, alpha: 1)
                header.text = "RENTAL FEE"
                header.tag = 51
                cell.addSubview(header)
                header.snp.makeConstraints { (make) in
                    make.left.top.right.equalToSuperview().inset(16)
                }
            }
            
            var lbl2: UILabel
            if let lbl = view.viewWithTag(52) as? UILabel {
                lbl2 = lbl
            } else {
                lbl2 = UILabel(frame: .zero)
                lbl2.font = UIFont(name: "Avenir", size: 20)
                lbl2.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                lbl2.text = "$"
                lbl2.tag = 52
                lbl2.sizeToFit()
                cell.addSubview(lbl2)
                lbl2.snp.makeConstraints { (make) in
                    make.left.equalToSuperview().offset(16)
                    make.top.equalTo(header.snp.bottom).offset(8)
                }
            }
            
            var priceTF: UITextField
            if let tf = view.viewWithTag(53) as? UITextField {
                priceTF = tf
            } else {
                priceTF = UITextField(frame: CGRect(x: 0, y: 0, width: 40, height: 35))
                cell.addSubview(priceTF)
                priceTF.borderStyle = .none
                priceTF.layer.borderColor = UIColor.lightGray.cgColor
                priceTF.layer.borderWidth = 1
                priceTF.layer.cornerRadius = 5
                priceTF.setLeftPaddingPoints(8)
                priceTF.placeholder = "0.00"
                priceTF.tag = 53
                priceTF.keyboardType = .decimalPad
                priceTF.delegate = self
                priceTF.snp.makeConstraints { (make) in
                    make.left.equalTo(lbl2.snp.right).offset(8)
                    make.centerY.equalTo(lbl2.snp.centerY)
                    make.width.equalTo(100)
                    make.height.equalTo(35)
                }
            }
            
            var lbl3: UILabel
            if let lbl = view.viewWithTag(54) as? UILabel {
                lbl3 = lbl
            } else {
                lbl3 = UILabel(frame: .zero)
                cell.addSubview(lbl3)
                lbl3.font = UIFont(name: "Avenir", size: 20)
                lbl3.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                lbl3.text = "per"
                lbl3.tag = 54
                lbl3.sizeToFit()
                lbl3.snp.makeConstraints { (make) in
                    make.left.equalTo(priceTF.snp.right).offset(8)
                    make.centerY.equalTo(priceTF.snp.centerY)
                }
            }
            
            var unit: UITextField
            if let tf = view.viewWithTag(55) as? UITextField {
                unit = tf
            } else {
                unit = UITextField(frame: CGRect(x: 0, y: 0, width: 40, height: 35))
                cell.addSubview(unit)
                unit.borderStyle = .none
                unit.layer.borderColor = UIColor.lightGray.cgColor
                unit.layer.borderWidth = 1
                unit.layer.cornerRadius = unit.frame.height / 2
                unit.setLeftPaddingPoints(16)
                unit.delegate = self
                unit.tag = 55
                unit.snp.makeConstraints { (make) in
                    make.left.equalTo(lbl3.snp.right).offset(8)
                    make.centerY.equalTo(lbl3.snp.centerY)
                    make.width.equalTo(120)
                    make.height.equalTo(35)
                }
            }
            
            return cell
        } else if section == 6 {
            // Configure cell 3
            let cell = tableView.dequeueReusableCell(withIdentifier: cellDescriptions[indexPath.section], for: indexPath)
            cell.selectionStyle = .none
            
            var header: UILabel
            if let lbl = view.viewWithTag(61) as? UILabel {
                header = lbl
            } else {
                header = UILabel(frame: .zero)
                header.font = UIFont(name: "Avenir", size: 20)
                header.textColor = #colorLiteral(red: 0.01112855412, green: 0.7845740914, blue: 0.9864193797, alpha: 1)
                header.text = "SALE PRICE"
                header.tag = 61
                cell.addSubview(header)
                header.snp.makeConstraints { (make) in
                    make.left.top.right.equalToSuperview().inset(16)
                }
            }
            
            var lbl2: UILabel
            if let lbl = view.viewWithTag(62) as? UILabel {
                lbl2 = lbl
            } else {
                lbl2 = UILabel(frame: .zero)
                cell.addSubview(lbl2)
                lbl2.font = UIFont(name: "Avenir", size: 20)
                lbl2.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                lbl2.text = "$"
                lbl2.sizeToFit()
                lbl2.tag = 62
                lbl2.snp.makeConstraints { (make) in
                    make.left.equalToSuperview().offset(16)
                    make.top.equalTo(header.snp.bottom).offset(8)
                }
            }
            
            var priceTF: UITextField
            if let tf = self.view.viewWithTag(63) as? UITextField {
                priceTF = tf
            } else {
                priceTF = UITextField(frame: CGRect(x: 0, y: 0, width: 40, height: 35))
                cell.addSubview(priceTF)
                priceTF.placeholder = "0.00"
                priceTF.borderStyle = .none
                priceTF.layer.borderColor = UIColor.lightGray.cgColor
                priceTF.layer.borderWidth = 1
                priceTF.layer.cornerRadius = 5
                priceTF.setLeftPaddingPoints(8)
                priceTF.tag = 63
                priceTF.keyboardType = .decimalPad
                priceTF.delegate = self
                priceTF.snp.makeConstraints { (make) in
                    make.left.equalTo(lbl2.snp.right).offset(8)
                    make.centerY.equalTo(lbl2.snp.centerY)
                    make.width.equalTo(100)
                    make.height.equalTo(35)
                }
            }
            
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
    }
    
}

extension CreateItemViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == moreItemsCollectionView {
            return 2
        } else if collectionView == moreByOwnerCollectionView {
            return 2
        } else {
            return self.item.images.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == moreItemsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarItem", for: indexPath)
            
            cell.backgroundColor = .red
            
            return cell
        } else if collectionView == moreByOwnerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OwnerItem", for: indexPath)
            
            cell.backgroundColor = .blue
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemImage", for: indexPath)
            
            cell.backgroundColor = .clear
            let imageView = UIImageView(image: self.item.images[indexPath.row])
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            imageView.backgroundColor = .clear
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(changeContentMode(sender:)))
            tap.numberOfTapsRequired = 2
            
            imageView.addGestureRecognizer(tap)
            
            cell.addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == moreItemsCollectionView {
            return CGSize(width: 80, height: 80)
        } else if collectionView == moreByOwnerCollectionView {
            let cWidth = collectionView.frame.width
            let numberPerRow = CGFloat(3.0)
            let spacing = CGFloat(8.0)
            let width = (cWidth - (numberPerRow * spacing)) / numberPerRow
            
            return CGSize(width: width, height: width)
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == moreItemsCollectionView {
            return 8.0
        } else if collectionView == moreByOwnerCollectionView {
            return 8.0
        } else {
            return 8.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == moreItemsCollectionView {
            return 8.0
        } else if collectionView == moreByOwnerCollectionView {
            return 8.0
        } else {
            return 8.0
        }
    }
}

extension CreateItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 12 {
            //
        } else if textField.tag == 22 {
            dataSource = Array(categoryData.keys)
            pickerView.reloadAllComponents()
            textField.inputView = pickerView
            textField.inputAccessoryView = toolbar
        } else if textField.tag == 32 {
            if let tf = self.view.viewWithTag(22) as? UITextField {
                if tf.text!.count > 0 {
                    let category = tf.text!
                    if let subcategories = categoryData[category] {
                        self.dataSource = subcategories
                        pickerView.reloadAllComponents()
                        textField.inputView = pickerView
                        textField.inputAccessoryView = toolbar
                    }
                } else {
                    showAlert(title: "Oops!", desc: "Please select an item from the 'Category' first!")
                    return false
                }
            }
        } else if textField.tag == 53 {
            textField.inputAccessoryView = toolbar
        } else if textField.tag == 55 {
            dataSource = self.units
            pickerView.reloadAllComponents()
            textField.inputView = pickerView
            textField.inputAccessoryView = toolbar
        } else if textField.tag == 63 {
            textField.inputAccessoryView = toolbar
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
}

extension CreateItemViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let tf = activeTextField {
            guard dataSource.count > 0 else { return }
            let item = dataSource[row]
            tf.text = item
        }
    }
}

extension CreateItemViewController: CheckBoxDelegate {
    func checkbox(checkbox: Checkbox, didChange checked: Bool) {
        switch checkbox.title.text {
        case "Mooching":
            print("Mooching")
        case "Renting":
            print("Renting")
            if checked {
                item.availableFor[.rent] = true
                
            } else {
                item.availableFor[.rent] = false
            }
        case "Buying":
            print("Buying")
            if checked {
                item.availableFor[.buy] = true
            } else {
                item.availableFor[.buy] = false
            }
        default:
            break
        }
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

