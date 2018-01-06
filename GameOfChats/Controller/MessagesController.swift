//
//  ViewController.swift
//  GameOfChats
//
//  Created by Roman Malasnyak on 12/28/17.
//  Copyright © 2017 Roman Malasnyak. All rights reserved.
//

import UIKit
import  Firebase

class MessagesController: UITableViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let messageIcon = UIImage(named: "message")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: messageIcon, style: .plain, target: self, action: #selector(handleNewMessage))
       checkIfUserIsLogged()
    }
    
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLogged() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else {
            setNameToTitleBar()
        }
    }
    
    func setNameToTitleBar() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                self.navigationItem.title = dictionary["name"] as? String
            }
        }, withCancel: nil)
    }
    
    @objc func handleLogout(){
        do{
            try Auth.auth().signOut()
        }
        catch let logOurError {
            print(logOurError)
        }
        let loginController = LoginController()
        loginController.messagesController = self
        present(loginController, animated: true, completion: nil)
    }
}





