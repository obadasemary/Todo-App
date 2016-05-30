//
//  AddTodoViewController.swift
//  Todo App
//
//  Created by Abdelrahman Mohamed on 5/30/16.
//  Copyright © 2016 Abdelrahman Mohamed. All rights reserved.
//

import UIKit
import CoreData

class AddTodoViewController: UIViewController {

    @IBOutlet weak var todoTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    var dateTodo: NSDate?
    var datePickerView: UIDatePicker?
    
    var context: NSManagedObjectContext?
    
    var isTodoEditing: Bool?
    var todo: NSDictionary?
    
    // MARK: - LifeCycel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = CoreDataStackManager.sharedInstacne().managedObjectContext
        
        datePicker()
        
        if isTodoEditing == true {
            
            self.title = "Update Todo"
            
            todoTextField.text = todo!["todo"] as? String
            dateTextField.text = todo!["date"] as? String
            
        } else {
            
            self.title = "Add Todo"
            
            todoTextField.text = ""
            dateTextField.text = ""
        }
    }
    
    @IBAction func saveEdit(sender: AnyObject) {
        print("Save Edit")
    }
    
    @IBAction func save(sender: AnyObject) {
        
        
        addNewTodo(todoTextField.text!, date: dateTodo!)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addNewTodo(todo: String, date: NSDate) {
        
        let newTodo = NSEntityDescription.insertNewObjectForEntityForName("Todo", inManagedObjectContext: context!)
        
        newTodo.setValue(todo, forKey: "todo")
        newTodo.setValue(date, forKey: "date")
        newTodo.setValue(false, forKey: "completed")
        
        // save new record and values
        
        do {
            try context!.save()
            
            print("Todo: \(todo) successfully saved")
            
        } catch {
            // error
            print("Todo: \(todo) error")
        }
    }
    
    // DatePickerView
    
    func datePicker() {
        
        datePickerView = UIDatePicker()
        datePickerView?.datePickerMode = UIDatePickerMode.Date
        datePickerView?.addTarget(self, action: #selector(AddTodoViewController.handlePickerView(_:)), forControlEvents: .ValueChanged)
        
        dateTextField.inputView = datePickerView
    }
    
    func handlePickerView(sender: UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM dd, yyyy"
        dateTodo = sender.date
        dateTextField.text = dateFormatter.stringFromDate(dateTodo!)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
