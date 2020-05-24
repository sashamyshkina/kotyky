//
//  ProfileViewController.swift
//  СaTinder
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//


import UIKit

class ProfileViewController: UIViewController {
    var imagePicker = UIImagePickerController()
    var chosenImage: UIImage!
    var profileImageView = UIImageView()
    var profileViewModel = ProfileViewModel.shared
    var nameLabel = UILabel()
    var container = UIView()
    
    var nameTextView = ProfileCellView()
    var ageTextView = ProfileCellView()
    var bioTextView = ProfileCellView()
    
    let button: GradientButton = {
        let button = GradientButton(type: .system)
        button.setTitle(NSLocalizedString(Const.save, comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(saveTapped), for: UIControl.Event.touchUpInside)
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        chosenImage = profileViewModel.image
        imagePicker.delegate = self
        view.backgroundColor = .systemBackground
        setupNavigationItems()
        configureLayout()
        self.setupHideKeyboardOnTap()
        setupNotificationObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        profileImageView.maskCircle(anyImage: chosenImage)
    }
    
    fileprivate func setupNavigationItems() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString(Const.logout, comment: ""), style: .plain, target: self, action: #selector(logOutTapped))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: NSLocalizedString(Const.cancel, comment: ""), style: .plain, target: self, action: #selector(cancelTapped)),
        ]
    }
    
    @objc fileprivate func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc fileprivate func saveTapped() {
        profileViewModel.saveData(name: nameTextView.textField.text, age: ageTextView.textField.text, bio: bioTextView.textField.text, image: chosenImage)
        dismiss(animated: true)
        
    }
    
    @objc fileprivate func logOutTapped() {
        profileViewModel.removeData()
        let vc = RegistrationController()
        vc.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(vc, animated: false, completion: nil)
        
    }
    @objc fileprivate func changePhotoTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    fileprivate func configureLayout() {
        
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: view.frame.size.height/5).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: view.frame.size.height/5).isActive = true
        profileImageView.image = profileViewModel.image
        
        let butt = UIButton()
        view.addSubview(butt)
        butt.backgroundColor = .systemPink
        butt.layer.cornerRadius = 20
        butt.setImage(UIImage(named: "cross"), for: .normal)
        butt.translatesAutoresizingMaskIntoConstraints = false
        butt.heightAnchor.constraint(equalToConstant: 40).isActive = true
        butt.widthAnchor.constraint(equalToConstant: 40).isActive = true
        butt.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -15).isActive = true
        butt.rightAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: -15).isActive = true
        butt.addTarget(self, action: #selector(changePhotoTapped), for: UIControl.Event.touchUpInside)
    
        
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 27).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        nameLabel.textAlignment = .center
        nameLabel.textColor = .darkerGrey
        nameLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        nameLabel.text = profileViewModel.name
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50).isActive = true
        button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        
        view.addSubview(container)
        container.pin(top: nameLabel.bottomAnchor, leading: view.leadingAnchor, bottom: button.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 10, right: 0))
        
        container.addSubview(nameTextView)
        nameTextView.translatesAutoresizingMaskIntoConstraints = false
        nameTextView.textField.text = profileViewModel.name
        nameTextView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20).isActive = true
        nameTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        nameTextView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        container.addSubview(ageTextView)
        ageTextView.translatesAutoresizingMaskIntoConstraints = false
        ageTextView.topAnchor.constraint(equalTo: nameTextView.bottomAnchor, constant: 5).isActive = true
        ageTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        ageTextView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        ageTextView.mainLabel.text = NSLocalizedString(Const.age, comment: "")
        ageTextView.textField.text = profileViewModel.age
        ageTextView.textField.placeholder = NSLocalizedString(Const.howOld, comment: "")
        
        
        container.addSubview(bioTextView)
        bioTextView.translatesAutoresizingMaskIntoConstraints = false
        bioTextView.topAnchor.constraint(equalTo: ageTextView.bottomAnchor, constant: 5).isActive = true
        bioTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        bioTextView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        bioTextView.mainLabel.text = NSLocalizedString(Const.whatQuestion, comment: "")
        bioTextView.textField.text = profileViewModel.bio
        bioTextView.textField.placeholder = NSLocalizedString(Const.whyQuestion, comment: "")

        
    }
}



extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
            
        }
        chosenImage = selectedImage
        viewDidLayoutSubviews()
        self.dismiss(animated: true, completion: { () -> Void in

        })
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - container.frame.origin.y - container.frame.height
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference)
    }    
}
