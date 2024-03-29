//
//  LoanController.swift
//  PalmMortgageCalc
//
//  Created by Craig Swanson on 10/17/19.
//  Copyright © 2019 Gavin Murphy. All rights reserved.
//

import UIKit

class LoanController {
    
    // MARK: Properties
    var loan: Loan?
    
    
    // MARK: Methods
    // This function takes in a Loan and calculates the monthly payment amount for a loan, returning a Double
    // The equation is: Payment = Principal / DiscountFactor
    // DiscountFactor is ((1 + i)^n - 1) / (i * (1 + i)^n)  where i = interest rate / 12, n = years * paymentsPerYear
    func paymentAmount(_ loan: Loan?) -> Double {
        guard let loan = loan else { fatalError("paymentAmount called without a loan value") }
        let principal = (loan.principal - loan.downPayment)
        let timeFactor = pow((1 + (loan.rate / 12)), (loan.paymentsPerPeriod * loan.years))
        let discountFactor = (timeFactor - 1) / (timeFactor * (loan.rate / 12))
        return ((principal / discountFactor) * 100).rounded() / 100
//        return (((principal / discountFactor) + loan.additionalPrincipal) * 100).rounded() / 100
    }
    
    // This function takes in a Loan and calculates the monthly interest payment included in the loan payment
    // The equation is:  Interest = Principal * (interestRate / paymentsPerYear)
    func interestAmountPaid(_ loan: Loan?) -> Double {
        guard let loan = loan else { fatalError("interestAmount called without a loan value") }
        let principal = loan.principal
        
        return ((principal * (loan.rate / (loan.paymentsPerPeriod)))*100).rounded() / 100
        
    }
    
    // This function takes in a Loan and calculates the monthly principal payment included in the loan payment
    // If the user selects a value for additionalPrincipal, the function adds that as well to get the total principal paid for that payment
    // I don't think we need this method so I am commenting it out to see if it produces an error.  If not, we can delete it.
//    func principalAmountPaid(_ loan: Loan?) -> Double {
//        guard let loan = loan else { fatalError("principalAmountPaid called without a loan value") }
//        let totalPayment = paymentAmount(loan)
//        let interestAmount = interestAmountPaid(loan)
//
//        return totalPayment - interestAmount + loan.additionalPrincipal
//    }
    
    // This function takes in a Loan and returns the cumulative interest paid over the life of the loan as well as the total number of payments.  Note: to call the result, we need to use the notation as follows:  If we declare a variable of loan1 = lifeOfLoanAmounts(xxxxxxx), we would need to use loan1.totalInterest or loan1.numberPayments
    func lifeOfLoanAmounts(_ loan: Loan?) -> (totalInterest: Double, numberPayments: Int) {
        guard let loan = loan else { fatalError("lifeOfLoan called without a loan value") }
        
        var cumulativeInterestPaid: Double = 0   // start the cumulative counter at 0
        var totalNumberOfPayments: Int = 0   // start the # of payments counter at 0
        var newLoanValues: Loan = loan   // the while loop will need to recalculate the values for each loop
        let monthlyPayment = paymentAmount(loan)  // the monthly payment will not change, so it is set outside the loop
        
        //  I set variables/constants for these just to make it easier to call them in the while loop
        let type = loan.type
        var currentPrincipal = (loan.principal * 100).rounded() / 100
        let years = loan.years
        let rate = loan.rate
        var downPayment = loan.downPayment
        let paymentsPerPeriod = loan.paymentsPerPeriod
        let additionalPrincipal = loan.additionalPrincipal

        // This first while loop only runs if the downpayment is greater than zero.
        // It reduces the principal by the downpayment amount, sets the downpayment to zero, and then continues to the next while loop.
        while downPayment > 0 {
            currentPrincipal = currentPrincipal - downPayment
            downPayment = 0
        }
        
        // This second while loop iterates over the total number of monthly payment over the life of the loan while the remaining principal is still greater than the monthly payment.
        // It calculates the cumulative interest paid over the life of the loan and also counts the total number of payments.
        while currentPrincipal > monthlyPayment {
            totalNumberOfPayments += 1
            let currentInterestPaid = interestAmountPaid(newLoanValues)
            cumulativeInterestPaid = cumulativeInterestPaid + currentInterestPaid
            currentPrincipal = ((currentPrincipal - (monthlyPayment - currentInterestPaid + additionalPrincipal)) * 100).rounded() / 100
            
            newLoanValues = Loan(type: type, principal: currentPrincipal, years: years, rate: rate, downPayment: downPayment, paymentsPerPeriod: paymentsPerPeriod, additionalPrincipal: additionalPrincipal)
        }
        
        // When the while loop ends, there will be a residual value in the principal (it will be between zero and the monthly payment amount).
        // The next two lines adds the interest paid on that residual value for the final loan payment.
        totalNumberOfPayments += 1
        cumulativeInterestPaid = cumulativeInterestPaid + monthlyPayment - currentPrincipal
        
        return ((cumulativeInterestPaid * 100).rounded() / 100, totalNumberOfPayments)
    }
    
}
