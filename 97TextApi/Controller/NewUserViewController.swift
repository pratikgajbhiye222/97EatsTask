//
//  NewUserViewController.swift
//  97TextApi
//
//  Created by Vinay Gajbhiye on 17/01/22.
//

import UIKit

class NewUserViewController: UIViewController {
    
    @IBOutlet weak var fName: UITextField!
    
    @IBOutlet weak var lName: UITextField!
    
    @IBOutlet weak var Email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

  
    
    @IBAction func createUserTapped(_ sender: Any) {
        APIClient.createUser(fName: fName.text ?? "", lName: lName.text ?? "", Email: Email.text ?? "") { response, error in
            print("Done")
        }
        
    }
    

}
