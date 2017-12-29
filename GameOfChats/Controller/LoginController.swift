//
//  LoginController.swift
//  GameOfChats
//
//  Created by Roman Malasnyak on 12/28/17.
//  Copyright © 2017 Roman Malasnyak. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(displayP3Red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleRegisterLogin), for: .touchUpInside)
        return button
    }()
    
    lazy var loginRegisterSegmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login","Regiser"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    @objc func handleLoginRegisterChange(){
        let title = loginRegisterSegmentControl.titleForSegment(at: loginRegisterSegmentControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        //change height of input control
        
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentControl.selectedSegmentIndex == 0 ? 100 : 150
        
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
    
    @objc func handleRegisterLogin() {
        if loginRegisterSegmentControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegistration()
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text,let password = passwordTextField.text else {
        print("not valid data")
            return
        }
        Auth.auth().signIn(withEmail: email,password: password) { (user,err) in
            if err != nil {
                print(err!)
                return
            }
            else{
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    //sending to firebase db
    
    func handleRegistration() {
        guard let email = emailTextField.text,let password = passwordTextField.text, let name = nameTextField.text else
        {
            print("Form is not valid")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: { (
            user: User?, error) in
            if error != nil {
                print (error!)
                return
            }
            guard let uid = user?.uid  else {
                return
            }
            
            let ref = Database.database().reference(fromURL: "https://fir-chat-4ce61.firebaseio.com/")
            let userReference = ref.child("users").child(uid)
            let values = ["name": name,"email": email]
            userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
                self.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        return emailTextField
    }()
    
    let emailSeparatorView: UIView = {
        let esv = UIView()
        esv.backgroundColor = UIColor(displayP3Red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        esv.translatesAutoresizingMaskIntoConstraints = false
        return esv
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let ptf = UITextField()
        ptf.placeholder = "Password"
        ptf.isSecureTextEntry = true
        ptf.translatesAutoresizingMaskIntoConstraints = false
        return ptf
    }()
    
    let profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "somePictureNameFromAssets")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(displayP3Red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profilePicture)
        view.addSubview(loginRegisterSegmentControl)
        
        
        //need some hieght width Constaints, X and  Y
        //is going to be placed in the center of View
        setUpInputsContainer()
        setUpLoginRegisterButton()
        setUpLoginPicture()
        setUpLoginRegisterSegmentedControl()
        
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setUpInputsContainer() {
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        
        //need to specify anchors for a nameTextField
        inputsContainerView.addSubview(nameTextField)
        
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor,constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        //specify anchors for separating line
        
        inputsContainerView.addSubview(nameSeparatorView)
        
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //specidy anchors for a emailTextField
        
        inputsContainerView.addSubview(emailTextField)
        
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo:nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        //specify anchors for separating line
        
        inputsContainerView.addSubview(emailSeparatorView)
        
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        //specify anchors for passwordTextField
        
        inputsContainerView.addSubview(passwordTextField)
        
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
        
    }
    
    func setUpLoginRegisterButton(){
        //need some hieght width Constaints, X and  Y
        //is going to be placed in the center of View  and below the inputs container
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setUpLoginPicture(){
        profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePicture.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setUpLoginRegisterSegmentedControl() {
        //need some hieght width Constaints, X and  Y
        loginRegisterSegmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .lightContent
    }
    
    
    
}











