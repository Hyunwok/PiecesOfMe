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
    var level: PreferenceLevel?
    private var parentFolder: FolderEntity
    private var expandableHeightConstraint: Constraint? // 높이 제약조건
    
    private var segementControl: UISegmentedControl = {
        let sege = UISegmentedControl(items: ["📁", "📄"])
        sege.selectedSegmentIndex = 0
        return sege
    }()
    
    private lazy var txtField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "Fill Its Name"
        return txtField
    }()
    
    lazy var selectedItemView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.addSubviews(stackView, descriptionTxtField)
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(70).priority(.medium)
        }
        
        descriptionTxtField.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview()
        }
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stackview = UIStackView()
        stackview.distribution = .fillEqually
        stackview.spacing = 10
        stackview.backgroundColor = .red
        stackview.addArrangedSubviews(hundred_btn, seventyfive_btn, fifty_btn, twentyfive_btn, zero_btn)
        return stackview
    }()
    
    lazy var hundred_btn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor(_colorLiteralRed: 138/255, green: 176/255, blue: 167/255, alpha: 1)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var seventyfive_btn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor(_colorLiteralRed: 138/255, green: 176/255, blue: 167/255, alpha: 1)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var fifty_btn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor(_colorLiteralRed: 138/255, green: 176/255, blue: 167/255, alpha: 1)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var twentyfive_btn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor(_colorLiteralRed: 138/255, green: 176/255, blue: 167/255, alpha: 1)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var zero_btn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor(_colorLiteralRed: 138/255, green: 176/255, blue: 167/255, alpha: 1)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var descriptionTxtField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "Fill Its Name"
        return txtField
    }()
    
    init(parentFolder: FolderEntity) {
        self.parentFolder = parentFolder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        segementControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        settingUI()
        setupDismissKeyboardGesture()
    }
    
    private func settingUI() {
        self.view.addSubviews(segementControl, txtField, selectedItemView)
        
        segementControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.width.equalTo(100)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
        }
        
        txtField.snp.makeConstraints {
            $0.top.equalTo(segementControl.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        selectedItemView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(txtField.snp.bottom).offset(40)
            expandableHeightConstraint = $0.height.equalTo(0).constraint
        }
    }
    
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // 다른 터치 이벤트와 동작이 겹치지 않도록 설정
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true) // 현재 활성화된 텍스트 입력기 종료
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            expandableHeightConstraint?.update(offset: 0)
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                self.selectedItemView.alpha = 0 // 투명도 조정
            })
        case 1:
            expandableHeightConstraint?.update(offset: 160)
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                self.selectedItemView.alpha = 1 // 투명도 조정
            })
            
        default:
            fatalError("이건 아직 불가능")
        }
    }
    
    @objc func done() {
        if txtField.text?.isEmpty ?? true {
            return self.present(AlertFactory.createAlert(title: "이름이 없습니다.", actions: UIAlertAction(title: "OK", style: .default)), animated: true)
        }
        
        if segementControl.selectedSegmentIndex == 1 && level == nil {
            return self.present(AlertFactory.createAlert(title: "감정이 없습니다.", actions: UIAlertAction(title: "OK", style: .default)), animated: true)
        }
        
        if segementControl.selectedSegmentIndex == 0 {
            let childFolder = FolderEntity(date: Date(), id: UUID().uuidString, name: txtField.text ?? "")
            parentFolder.subFolders.append(childFolder)
            PersistenceController.shared.create(item: parentFolder) {
                if $0 {
//                    self.navigationController.viewco
                    self.navigationController?.popViewController(animated: true)
                    self.parentFolder.subFolders.append(childFolder)
                }
            }
            
        } else if segementControl.selectedSegmentIndex == 1 {
            let preferences = PreferenceEntity(date: Date(), descriptionThing: descriptionTxtField.text ?? "", id: UUID().uuidString, image: nil, location_lat: nil, location_lon: nil, name: txtField.text ?? "")
            parentFolder.preferences.append(preferences)
//            PersistenceController.shared.create(item: parentFolder) {
//                
//            }
        }
        
    }
}


struct AlertFactory {
    static func createAlert(style: UIAlertController.Style = .alert,
                            title: String? = nil,
                            message: String? = nil,
                            actions: UIAlertAction...) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { action in
            alert.addAction(action)
        }
        
        return alert
    }
}

