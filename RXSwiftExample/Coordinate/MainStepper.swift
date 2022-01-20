//
//  MainStepper.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/22/21.
//

import Foundation
import RxCocoa
import RxFlow

class MainStepper: Stepper {
    let steps = PublishRelay<Step>()

    var initialStep: Step {
        return MainSteps.homeScreenIsRequired
    }

    func readyToEmitSteps() {
    }
}
