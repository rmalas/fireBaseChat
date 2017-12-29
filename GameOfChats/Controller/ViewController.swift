//
//  ViewController.swift
//  GameOfChats
//
//  Created by Roman Malasnyak on 12/28/17.
//  Copyright © 2017 Roman Malasnyak. All rights reserved.
//

import UIKit
import  Firebase

class ViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        if Auth.auth().currentUser?.uid == nil {
            handleLogout()
        }
    }
    
    @objc func handleLogout(){
        do{
            try Auth.auth().signOut()
        }
        catch let logOurError {
            print(logOurError)
        }
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
}





