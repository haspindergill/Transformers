//
//  CreateTransformerViewController.swift
//  Transformers
//
//  Created by Haspinder Gill on 2020-07-11.
//  Copyright © 2020 Haspinder Gill. All rights reserved.
//

import UIKit

class CreateTransformerViewController: UIViewController {

    //Use term Invade instead of transformer
    
    // MARK: Outlets
    @IBOutlet weak var nameTxt: PaddedTextField!
    @IBOutlet weak var teamSegmentControl: UISegmentedControl!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet var transformerValueSliders: [UISlider]!
    @IBOutlet var transformerValues: [UILabel]!

    var currentInvade: Transformer?
    var editableInvade: Bool?
    
    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        if editableInvade ?? false {
            //Update transformer
            self.setupView()
        } else {
            //Create new transformer
            currentInvade = Transformer(courage: 5,
                                        endurance: 5,
                                        firepower: 5,
                                        id: "",
                                        intelligence: 5,
                                        rank: 5,
                                        skill: 5,
                                        speed: 5,
                                        strength: 5,
                                        team: "A",
                                        name: "")
        }
    }
    
    // MARK: - Private

    private func setupView() {
        //Fill up view with previous values in order to edit transformer
        self.submitButton.setTitle("Update", for: .normal)
        self.nameTxt.text = self.currentInvade?.name
        self.teamSegmentControl.selectedSegmentIndex = self.currentInvade?.team == "A" ? 0 : 1
        var sliderValue: Int = 0
        
        for (index,_) in transformerValues.enumerated() {
            switch index {
            case 0:
               sliderValue = self.currentInvade?.strength ?? 0
            case 1:
                sliderValue = self.currentInvade?.intelligence ?? 0
            case 2:
                sliderValue = self.currentInvade?.endurance ?? 0
            case 3:
                sliderValue = self.currentInvade?.rank ?? 0
            case 4:
                sliderValue = self.currentInvade?.courage ?? 0
            case 5:
                sliderValue = self.currentInvade?.firepower ?? 0
            case 6:
                sliderValue = self.currentInvade?.skill ?? 0
            case 7:
                sliderValue = self.currentInvade?.speed ?? 0
            default:
                break
            }
            self.transformerValues[index].text = "\(sliderValue)"
            self.transformerValueSliders[index].value = Float(sliderValue)
        }
        
    }
    
    // MARK: - Actions
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func updateSliderValue(_ sender: UISlider) {
        self.transformerValues[sender.tag].text = String(format: "%.0f", sender.value)
        guard var currentInvade = currentInvade else { return }
        let value = Int(String(format: "%.0f", sender.value)) ?? 1
        switch sender.tag {
        case 0:
            currentInvade.strength = value
        case 1:
            currentInvade.intelligence = value
        case 2:
            currentInvade.endurance = value
        case 3:
            currentInvade.rank = value
        case 4:
            currentInvade.courage = value
        case 5:
            currentInvade.firepower = value
        case 6:
            currentInvade.skill = value
        case 7:
            currentInvade.speed = value
        default:
            break
        }
        self.currentInvade = currentInvade
    }
    
    @IBAction func createTransformer(_ sender: Any) {
        view.endEditing(true)
        if editableInvade ?? false {
            self.updateTransformer()
        } else {
            self.createTransformerAtServer()
        }
    }
    
    @IBAction func chooseTeamSegmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.currentInvade?.team = "A"
        default:
            self.currentInvade?.team = "D"
        }
    }
    
}

// MARK: - API

extension CreateTransformerViewController {
    
    private func createTransformerAtServer() {
        guard let currentInvade = currentInvade else { return }
        DispatchQueue.main.sync {
            self.showInternetActivity()
        }
        APIManager.sharedInstance.opertationWithRequest(withApi: API.CreateTransformer(transformer: currentInvade)) { (result) in
            DispatchQueue.main.sync {
                self.hideInternetActivity()
            }
            switch result {
            case .Success(let response):
                guard var invade = response as? Transformer else {
                    return
                }
                invade.teamIcon = ""
                DispatchQueue.main.async {
                    DataManager.sharedInstance.storeTransformerInDatabase(transformers: [invade])
                    self.navigationController?.popViewController(animated: true)
                }
            case .Failure(let error):
                self.showAlert(message: error ?? "")
                print("Error: \(error ?? "")")
            }
        }
    }
    
    private func updateTransformer() {
        guard let currentInvade = currentInvade else { return }
        self.showInternetActivity()
        APIManager.sharedInstance.opertationWithRequest(withApi: API.EditTransformer(transformer: currentInvade)) { (result) in
            DispatchQueue.main.sync {
                self.hideInternetActivity()
            }
            switch result {
            case .Success(let response):
                guard let invade = response as? Transformer else {
                    return
                }
                DataManager.sharedInstance.updateTransformer(transformer: invade)
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    self.showAlert(title: "Success", message: "Succesfully updated!!!")
                }
            case .Failure(let error):
                self.showAlert(message: error ?? "")
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension CreateTransformerViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.currentInvade?.name = textField.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
