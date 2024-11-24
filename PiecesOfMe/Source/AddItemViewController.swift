//
//  AddItemViewController.swift
//  PiecesOfMe
//
//  Created by 이현욱 on 11/21/24.
//

import UIKit

import SnapKit

enum PreferenceLevel: String {
    case strongDislike = "매우 싫어함"
    case dislike = "싫어함"
    case neutral = "중립"
    case like = "좋아함"
    case love = "매우 좋아함"
}

class AddItemViewController: UIViewController {
    var level: PreferenceLevel!
    
    var txtField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "Item Name"
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()

    var hundred_btn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor(_colorLiteralRed: 138/255, green: 176/255, blue: 167/255, alpha: 1)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    var seventyfive_btn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor(_colorLiteralRed: 138/255, green: 176/255, blue: 167/255, alpha: 1)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    var fifty_btn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor(_colorLiteralRed: 138/255, green: 176/255, blue: 167/255, alpha: 1)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    var twentyfive_btn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor(_colorLiteralRed: 138/255, green: 176/255, blue: 167/255, alpha: 1)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    var zero_btn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor(_colorLiteralRed: 138/255, green: 176/255, blue: 167/255, alpha: 1)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let stackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.backgroundColor = .red
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        self.view.addSubview(stackView)
        self.stackView.addSubviews(hundred_btn, seventyfive_btn, fifty_btn, twentyfive_btn, zero_btn)
        
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(70)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func done() {
        if level == nil {
            //alert
        }
        
        //DB처리 하고 pop or alert
    }
}
