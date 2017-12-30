//
//  NewMessageController.swift
//  GameOfChats
//
//  Created by Roman Malasnyak on 12/30/17.
//  Copyright © 2017 Roman Malasnyak. All rights reserved.
//

import UIKit
import Firebase


class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    
    var users = [ChatUser]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        fetchUsers()
    }
    
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let chatUser = ChatUser()
                chatUser.name = dictionary["name"] as? String
                chatUser.email = dictionary["email"] as? String
                self.users.append(chatUser)
                self.tableView.reloadData()
                
            }
            
        }, withCancel: nil)
    
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        return cell
    }

}
