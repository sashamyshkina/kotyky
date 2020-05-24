//
//  RegistrationViewControlle.swift
//  СaTinder
//
//  Created by Sasha Myshkina on 22.04.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController {
    
    var imagePicker = UIImagePickerController()
    var registrtionViewModel = ProfileViewModel.shared
    
    var chosenImage: UIImage?
    
    let catinderImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "paw_print")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.contentMode = .center
        return view
    }()
    
    let catinderNameLabel: UILabel = {
        let label = UILabel()
        label.text = Const.kotyky
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .systemPink
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    let selectPhotoView: RegistrationPhotoView = {
        let view = RegistrationPhotoView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 400).isActive = true
        return view
    }()
    
    let nameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.placeholder = NSLocalizedString(Const.enterName, comment: "")
        tf.backgroundColor = .systemBackground
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return tf
    }()
    
    let registerButton: GradientButton = {
        let button = GradientButton(type: .system)
        button.setTitle(NSLocalizedString(Const.next, comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(nextButtonPressed), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let privacyView: PrivacyView = {
        let view = PrivacyView(frame: CGRect.zero)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    lazy var stackView = UIStackView(arrangedSubviews: [
        selectPhotoView,
        nameTextField,
        privacyView,
        registerButton
    ])
    
    lazy var topStackView = UIStackView(arrangedSubviews: [
        catinderImageView,
        catinderNameLabel,
    ])

    fileprivate func configureView() {
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 8
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        
        
        view.addSubview(topStackView)
        topStackView.distribution = .equalSpacing
        topStackView.axis = .vertical
        topStackView.spacing = 10
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.pin(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        stackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    }
    
    override func viewDidLoad() {
        imagePicker.delegate = self
        selectPhotoView.cameraManager = self
        super.viewDidLoad()
        setupGradientLayer()
        configureView()
        setupNotificationObservers()
        setupTapGesture()
    }

        
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func nextButtonPressed() {

        if registrtionViewModel.registrationAllowed {
            UserDefaults.standard.set(registrtionViewModel, forKey: "profile")
            let vc = HomeViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        } else {
            if registrtionViewModel.name == nil {
                nameTextField.shake()
            }
            if registrtionViewModel.image == nil {
                selectPhotoView.shake()
            }
            if registrtionViewModel.privacyCheck == false {
                privacyView.shake()
            }
        }
    }
    
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        let name = textField.text
        registrtionViewModel.name = name
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true)
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self) // you'll have a retain cycle
    }
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }

    
    fileprivate func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        let topColor = UIColor.systemBackground
        let bottomColor = UIColor(named: "lightgrey")
        gradientLayer.colors = [topColor.cgColor, bottomColor?.cgColor ?? UIColor.lightGreyColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
            
        }
        self.dismiss(animated: true, completion: { () -> Void in

        })
        chosenImage = selectedImage
        registrtionViewModel.image = selectedImage
        selectPhotoView.updateImage(selectedImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}


extension RegistrationController: CameraManager {
    
    var chosenPhoto: UIImage? {
        return chosenImage
    }

    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
}
