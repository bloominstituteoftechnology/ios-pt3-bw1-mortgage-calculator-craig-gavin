//
//  LoanCalculatorViewController.swift
//  PalmMortgageCalc
//
//  Created by Craig Swanson on 10/18/19.
//  Copyright © 2019 Gavin Murphy. All rights reserved.
//

import UIKit

protocol AddLoanDelegate {
    func loanWasAdded(_ loan: Loan)
}

class LoanCalculatorViewController: UIViewController {
    
    // MARK: Properties
    var delegate: AddLoanDelegate?
    
    
    // MARK: Outlets
    @IBOutlet weak var loanTypeTextField: UITextField!
    @IBOutlet weak var loanPrincipalTextField: UITextField!
    @IBOutlet weak var loanTermTextField: UITextField!
    @IBOutlet weak var loanInterestRateTextField: UITextField!
    @IBOutlet weak var loanDownPaymentTextField: UITextField!
    @IBOutlet weak var loanAdditionalPaymentTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Actions
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let loanType = loanTypeTextField.text,
            let loanPrincipal = loanPrincipalTextField.text,
            let loanTerm = loanTermTextField.text,
            let interestRate = loanInterestRateTextField.text,
            let loanDownPayment = loanDownPaymentTextField.text,
            let loanAdditionalPayment = loanAdditionalPaymentTextField.text else { return }
        guard let principal = Double(loanPrincipal),
            let term = Double(loanTerm),
            let rate = Double(interestRate),
            let downPayment = Double(loanDownPayment),
            let additionalPayment = Double(loanAdditionalPayment) else { return }
        
        let loan = Loan(type: loanType, principal: principal, years: term, rate: (rate / 100), downPayment: downPayment, paymentsPerPeriod: 12, additionalPrincipal: additionalPayment)
        
        delegate?.loanWasAdded(loan)
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoanCalculatorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text,
            !text.isEmpty {
            switch textField {
            case loanTypeTextField:
                loanPrincipalTextField.becomeFirstResponder()
            case loanPrincipalTextField:
                loanTermTextField.becomeFirstResponder()
            case loanTermTextField:
                loanInterestRateTextField.becomeFirstResponder()
            case loanInterestRateTextField:
                loanDownPaymentTextField.becomeFirstResponder()
            case loanDownPaymentTextField:
                loanAdditionalPaymentTextField.becomeFirstResponder()
            default:
                textField.resignFirstResponder()
            }
        }
        return false
    }
}

