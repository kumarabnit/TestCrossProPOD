//
//  TestResultsDetailsViewController.swift
//  TestCrossProPOD
//
//  Created by Kumar Abnit on 16/08/18.
//  Copyright © 2018 Kumar Abnit. All rights reserved.
//

import UIKit
import TPMGCommon

class TestResultsDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TPMGAlertView.showAlert(withMessage:nil, title: "This is details Class", cancelButtonTitle: TPMGAlertViewCancelButtonTitleOK)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
