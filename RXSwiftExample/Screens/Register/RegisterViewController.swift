//
//  RegisterViewController.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/22/21.
//

import Reusable
import RxCocoa
import RxFlow
import RxSwift
import UIKit

class RegisterViewController: UIViewController, Stepper {
    // MARK: Outlets

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var registerButton: UIButton!
    
    // MARK: - Stepper conformances
    let steps = PublishRelay<Step>()
    
    var avatartIndex = 0
    private let disposeBag = DisposeBag()
    private let image = BehaviorRelay<UIImage?>(value: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Register"
        
        setupUIElements()
        
        image.subscribe(onNext: { [weak self] image in
            self?.avatarImageView.image = image
        }).disposed(by: disposeBag)
    }

    private func setupUIElements() {
        avatarImageView.layer.cornerRadius = 50.0
        avatarImageView.layer.borderWidth = 5.0
        avatarImageView.layer.borderColor = UIColor.gray.cgColor
        avatarImageView.layer.masksToBounds = true
        
        let rightBarButtonItem = UIBarButtonItem(title: "Change Avatar", style: .plain, target: self, action: #selector(changeAvatar))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @IBAction func clear(_ sender: Any) {}
    
    @IBAction func register(_ sender: Any) {
        RegisterModel
            .shared()
            .register(
            username: usernameTextField.text,
            password: passwordTextField.text,
            email: emailTextField.text,
            avatar: avatarImageView.image)
            .subscribe { success in
            print("Register successfully")
        } onError: { error in
            if let error = error as? ApiError {
                print("Error: \(error.description)")
            }
        }.disposed(by: disposeBag)
    }
    
    @objc func changeAvatar() {
        steps.accept(MainSteps.changAvatarScreenIsRequired(onSelect: { image in
            self.image.accept(image)
        }))
    }
}

// MARK: - Rx Setup

private extension RegisterViewController {}
