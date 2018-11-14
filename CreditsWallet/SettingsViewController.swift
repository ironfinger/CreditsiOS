//
//  SettingsViewController.swift
//  CreditsWallet
//
//  Created by Thomas Houghton on 31/10/2018.
//  Copyright © 2018 Thomas Houghton. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var darkModePicker: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        
    }
    
    func setupView() {
        // Corner radiuses:
        mainView.layer.cornerRadius = 20
    }
    
    @IBAction func DarkMode(_ sender: Any) {
        if (darkModePicker.isOn == true) {
            print("On")
            save(state: true)
            
            viewData()
        } else if (darkModePicker.isOn == false) {
            print("Off")
            save(state: false)
            
            viewData()
        }
        
    }
    
    func tutorial() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Theme", in: context)
        
        let theme = NSManagedObject(entity: entity!, insertInto: context)
        theme.setValue(false, forKey: "isDark")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func tutorialFetch() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Theme") // Request
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "username") as! String)
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    func save(state: Bool) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Theme", in: managedContext)!
        
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
        person.setValue(state, forKeyPath: "Theme")
        
        // 4
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func viewData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Theme")
        
        do {
            print(try managedContext.fetch(fetchRequest))
        } catch let error as NSError {
            print("Error")
        }
    }
}
