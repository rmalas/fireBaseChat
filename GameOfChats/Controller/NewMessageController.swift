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

        //check for image in cache first
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let url = URL(string: user.profileImageUrl!){
            
           // cell.profileImageView.image = nil
            
            //check for image in cache first
            if let cachedImage = imageCache.object(forKey: url as AnyObject) {
                cell.profileImageView.image = cachedImage as? UIImage
            }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    
                    if let downLoadedImage = UIImage(data: data!) {
                        imageCache.setObject(downLoadedImage, forKey: url as AnyObject)
                        cell.profileImageView.image = UIImage(data: data!)
                    }
                    
                }
                }.resume()
        }
        
        return cell
    }
    
    
    //make some spacing between rows
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
}

let imageCache = NSCache<AnyObject, AnyObject>()




//to register a custom cell
class UserCell: UITableViewCell {
    
    let profileImageView: UIImageView = {
        let piv = UIImageView()
        piv.image = UIImage(named: "lovelyPicture")
        piv.translatesAutoresizingMaskIntoConstraints = false
        piv.layer.cornerRadius = 25
        piv.layer.masksToBounds = true
        piv.contentMode = .scaleAspectFill
        return piv
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height:textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height:detailTextLabel!.frame.height)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("something fatal")
    }
    
    public func setUpProfileImageView() {
        
    }
}
