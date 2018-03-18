//
//  Login.swift
//  SmartHome X
//
//  Created by Sotiris  Kapnoullas on 05/03/2018.
//  Copyright © 2018 Apple, Inc. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class LoginViewController: UIViewController , UITextFieldDelegate {
    var ref: DatabaseReference!
    
    
    
    //login uitextfields for log in
    @IBOutlet weak var username:UITextField!
    @IBOutlet weak var loginpassword: UITextField!

    //login button


    //register button for creating online firebase values

    
    @IBOutlet weak var register: UIButton!
    
    //register uitextfields
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var conpassword: UITextField!
    
    func textFieldShouldReturn(_ name: UITextField) -> Bool {
        //self.name.resignFirstResponder()
        self.email.resignFirstResponder()
        return true;
    }
//The register button sender
    

    @IBAction func RegisterFirebase(_ sender: UIButton, forEvent event: UIEvent) {
        if (Registerconfirm() == true){
            handleRegister()
            print("something")
        }
    }

    

    
    @IBOutlet weak var login: UIButton!
 
    @IBAction func log(_ sender: UIButton, forEvent event: UIEvent) {
        if (loggedIn() == true) {
            self.performSegue(withIdentifier: "loginconfirm", sender: self.login)
        }else{
            Loginconfirm()
        }
        
    }
    func Loginconfirm(){
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        Auth.auth().signIn(withEmail: username.text!, password: loginpassword.text!) {
            (user, error) in
            print(self.username.text! , self.loginpassword.text!)
            
            if error != nil {
                print(error!)
                let alert = UIAlertController(title: "Login Failed",
                                              message: "Invalid username or password",
                                              preferredStyle: .alert)
                
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)

            }else{
                UserDefaults.standard.set(true, forKey: "logged")
                UserDefaults.standard.synchronize()
                self.performSegue(withIdentifier: "loginconfirm", sender: self.login)
                
            }
            
        }
    }
    fileprivate func loggedIn() -> Bool{
        return UserDefaults.standard.bool(forKey: "logged")
    }
    func Registerconfirm() -> Bool{
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        let length = (password.text?.count)!
        if (password.text! == conpassword.text! && length >= 6){
            return true
        }else{
            
            let alert = UIAlertController(title: "Registration Failed",
                                          message: "Passwords dont match",
                                          preferredStyle: .alert)
            
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)

            return false
            
        }
    }
    

    
    func handleRegister(){
        //add name = nameField
        guard let email = email.text, let password = password.text , let name = name.text
            else {
                return
            
        }
        Auth.auth().createUser(withEmail: email , password: password)
        { (user: Firebase.User?, error) in
            if (error != nil) {
                print(error!)
                return
            }else{
                self.performSegue(withIdentifier: "loginok", sender: self.register)
            }
            
            
        }
        //Authentication
        let userID = Auth.auth().currentUser?.uid

        let ref = Database.database().reference(fromURL: "https://smart-home-x.firebaseio.com/")
        let userref = ref.child("App Users").child(userID!)
        let values = ["name": name, "email": email, "password": password]
        userref.updateChildValues(values,withCompletionBlock: { (err, ref) in
                if err != nil {
                    return
                } else{
                    print("Successfully saved user to database.")
                    
            }
            
        })
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        if (loggedIn() == true) {
            self.performSegue(withIdentifier: "loginconfirm", sender: self.login)
        }
        // Do any additional setup after loading the view, typically from a nib.
        if Auth.auth().currentUser?.uid == nil {
        }
      
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
