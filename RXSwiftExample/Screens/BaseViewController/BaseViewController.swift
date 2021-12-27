//
//  BaseViewController.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/29/21.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindingPresenterInputs()
        bindingPresenterOutputs()
        setupData()
    }
    
    //MARK: - Configuration
    
    func bindingPresenterInputs() { }
    
    func bindingPresenterOutputs() { }
    
    func setupData() { }
    
    func setupUI() { }
}
