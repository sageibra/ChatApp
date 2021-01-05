//
//  ViewController.swift
//  ChatApp
//
//  Created by Ibragim Akaev on 03/01/2021.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    private let firebaseAuth = Auth.auth()
    private let db = Firestore.firestore()
    private var messages: [Message] = [
        Message(sender: "123@gmail.com", body: "Ассаламу Алайкум"),
        Message(sender: "456@gmail.com", body: "Ваалайкум ассалам брат"),
        Message(sender: "123@gmail.com", body: "Х1у ду цигахь?")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        navigationItem.hidesBackButton = true
        title = K.appName
        loadMessages()
    }
    
    func loadMessages() {
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField )
            .addSnapshotListener { (querySnapshot, error) in
                
            self.messages = []
            
            if let error = error {
                print("There was a problem retrianing data from Firestore\(error)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let message = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: message)
                            self.messages.append(newMessage)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = firebaseAuth.currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.bodyField: messageBody, K.FStore.senderField: messageSender, K.FStore.dateField: Date().timeIntervalSince1970]) { (error) in
                if let er = error {
                    print("There is a problem with a saving data in firestore \(er)")
                } else {
                    DispatchQueue.main.async {
                        self.messageTextfield.text = nil
                    }
                    print("Success saved data")
                }
                
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        cell.label?.text = message.body
        if  message.sender == firebaseAuth.currentUser?.email {
            cell.rightImageView.isHidden = false
            cell.leftImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        } else {
            cell.rightImageView.isHidden = true
            cell.leftImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        
        return cell
    }
    
    
}

