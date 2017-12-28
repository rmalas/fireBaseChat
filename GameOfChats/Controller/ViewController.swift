//
//  ViewController.swift
//  GameOfChats
//
//  Created by Roman Malasnyak on 12/28/17.
//  Copyright © 2017 Roman Malasnyak. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
    }
    
    @objc func handleLogout(){
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    

    
}

