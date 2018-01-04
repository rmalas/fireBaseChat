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
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId )
        fetchUsers()
        
    }
    
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let chatUser = ChatUser()
                chatUser.name = dictionary["name"] as? String
                chatUser.email = dictionary["email"] as? String
                chatUser.profileImageUrl = dictionary["profileImageUrl"] as? String
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
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
//      cell.imageView?.image = UIImage(named: "message")
//      cell.imageView?.contentMode = .scaleAspectFill
        
        let url = URL(string: user.profileImageUrl!)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                // cell.imageView?.image = UIImage(data: data!)
            }
        }.resume()
        
        return cell
    }
    
}


//to register a custom cell
class UserCell: UITableViewCell {
    
    let profileImageView: UIImageView = {
    let piv = UIImageView()
    piv.image = UIImage(named: "message")
    piv.translatesAutoresizingMaskIntoConstraints = false
    return piv
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 56, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height:textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 56, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width, height:detailTextLabel!.frame.height)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("something fatal")
    }
    
    public func setUpProfileImageView() {
       
    }
}
