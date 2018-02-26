//
//  ViewController.swift
//  Login Practice
//
//  Created by Mason Bender on 2/26/18.
//  Copyright © 2018 Mason Bender. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func login(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        newUser.setValue(textField.text, forKey: "name")
        
        do {
            try context.save()
            loginButton.setTitle("Update username", for: [])
            logoutButton.alpha = 1
            label.alpha = 1
            label.text = "Hello, " + textField.text!
        } catch {
            print("Error while saving")
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results {
                    context.delete(result as! NSManagedObject)
                }
                do {
                    try context.save()
                } catch {
                    print("Individual deletion failed")
                }
            }
            loginButton.setTitle("Login", for: [])
            label.alpha = 0
            logoutButton.alpha = 0
            
        } catch {
            print("Deletion failed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            for result in results as! [NSManagedObject] {
                if let username = result.value(forKey: "name") as? String {
                    loginButton.setTitle("Update username", for: [])
                    logoutButton.alpha = 1
                    label.alpha = 1
                    label.text = "Hello, \(username)!"
                }
            }
        } catch {
            print("something went wrong :(")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

