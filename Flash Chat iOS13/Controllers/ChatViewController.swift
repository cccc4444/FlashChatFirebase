//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messsages: [Message] = [
    Message(sender: "Dad", body: "Hello!"),
    Message(sender: "Mom", body: "SUP"),
    Message(sender: "Alina", body: "SDADASDS DSD ASD sd asd asd asd asd ")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = K.appName
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text,
           let messageSender = Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField:messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField:Date().timeIntervalSince1970]){error in
                if let e = error {
                    print("there was an issue")
                }
                else {
                    print("sucesssfully saved data")
                    self.messageTextfield.text = ""
                }
            }
        }
        
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    
    }
    
    func loadMessages(){
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { [weak self] querySnapshot, error in
            self?.messsages = []
            if let error = error {
                print("There was an issue retrieving messsages from store")
            }
            else{
                if let querySnapshot = querySnapshot?.documents {
                    querySnapshot.forEach { element in
                        let data = element.data()
                        if let sender = data[K.FStore.senderField] as? String,
                           let body = data[K.FStore.bodyField] as? String,
                           let time = data[K.FStore.dateField] {
                            let newMessage = Message(sender: sender, body: body)
                            self?.messsages.append(newMessage)
                            
                            DispatchQueue.main.async{
                                self?.tableView.reloadData()
                                let indexPath = IndexPath(row: (self?.messsages.count)! - 1, section: 0)
                                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
}

extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messsages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.messsages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! TableCell
        cell.label.text = message.body
        
        // from current user
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        
        
        return cell
    }
    
    
}
extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
