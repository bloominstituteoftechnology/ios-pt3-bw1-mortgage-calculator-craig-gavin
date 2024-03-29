//
//  Loan.swift
//  PalmMortgageCalc
//
//  Created by Craig Swanson on 10/16/19.
//  Copyright © 2019 Gavin Murphy. All rights reserved.
//

import Foundation

// I named it "Loan" instead of Mortgage because I think it is more general to any loan, not just a mortgage

struct Loan: Equatable, Codable {
    var type: String       // a user selected string value to identify the loan
    var principal: Double   // the initial loan value and the principal remaining after each payment
    var years: Double       // number of years in the term of the loan
    var rate: Double        // interest rate of the loan
    var downPayment: Double  //  additional down payment the user makes upfront
    var paymentsPerPeriod: Double   //  number of payments per year. Usually 12 but doesn't have to be
    var additionalPrincipal: Double  // for each payment, user could add additional money to reduce principal
    
    // for the initializer, I set the default paymentsPerPeriod to 12.  I updated it to also set defaults for the downPayment and additionalPrincipal.  They used to be optionals but now they are not. I'm not great with initializers though
    init(type: String, principal: Double, years: Double, rate: Double, downPayment: Double = 0, paymentsPerPeriod: Double = 12, additionalPrincipal: Double = 0) {
        self.type = type
        self.principal = principal
        self.years = years
        self.rate = rate
        self.downPayment = downPayment
        self.paymentsPerPeriod = paymentsPerPeriod
        self.additionalPrincipal = additionalPrincipal
    }
}

class LoanModelController {
    var loans: [Loan] = []
    
    func addNewLoan(_ loan: Loan) {
        loans.append(loan)
    }
}
