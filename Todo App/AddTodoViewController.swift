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
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var completedBtn: UIButton!
    
    var dateTodo: NSDate?
    var datePickerView: UIDatePicker?
    
    var context: NSManagedObjectContext?
    
    var isTodoEditing: Bool = false
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
            editBtn.hidden = false
            completedBtn.hidden = false
            
            let btnToggle = isComplete(todoTextField.text!)
            
            if btnToggle == true {
                
                self.completedBtn.tintColor = UIColor.greenColor()
                
            } else {
                
                self.completedBtn.tintColor = UIColor.blackColor()
            }
            
        } else {
            
            self.title = "Add Todo"
            
            todoTextField.text = ""
            dateTextField.text = ""
            editBtn.hidden = true
            completedBtn.hidden = true
            
        }
    }
    
     // MARK: - Actions
    
    @IBAction func completeTodoAction(sender: AnyObject) {
        
        markAsComplete((todo!["todo"] as? String)!)
    }
    
    @IBAction func edit(sender: AnyObject) {
        print("Edit")
        

        saveTodo((todo!["todo"] as? String)!, date: dateTodo!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save(sender: AnyObject) {
        
        if todoTextField.text != "" && dateTextField.text != "" {
            
            addNewTodo(todoTextField.text!, date: dateTodo!)
            self.dismissViewControllerAnimated(true, completion: nil)
        } else if todoTextField.text != "" {
            alertDialog("date")
        } else if dateTextField.text != "" {
            alertDialog("Todo")
        } else if todoTextField.text == "" && dateTextField.text == "" {
            alertDialog("Todo and Date")
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
     // MARK: - CoreData Func
    
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
    
    func saveTodo(todo: String, date: NSDate) {
        
        fetchTodos(todo) { (array, arrayData) in
            
//            var newDate = NSDate()
//            
//            let formatter = NSDateFormatter()
//            formatter.dateFormat = "MM dd, yyyy"
//            newDate = formatter.dateFromString(date)!
            
            arrayData.setValue(self.todoTextField.text, forKey: "todo")
            arrayData.setValue(date, forKey: "date")
        
            // save new record and values
            
            do {
                try self.context!.save()
                
                print("Todo: \(todo) successfully updated")
                
            } catch {
                // error
                print("Todo: \(todo) error")
            }
        }
    }
    
    func fetchTodos(predicate: String, completion:(array: NSArray, arrayData: NSArray) -> ()) {
        
        var arr = [NSDictionary]()
        var arrData = [NSManagedObject]()
        
        let request = NSFetchRequest(entityName: "Todo")
        request.predicate = NSPredicate(format: "todo = %@", predicate)
        
        do {
            let results = try context?.executeFetchRequest(request)
            
            for result in results as! [NSManagedObject] {
                
                let todo = result.valueForKey("todo") as? String
                let date = result.valueForKey("date") as? NSDate
                let completed = result.valueForKey("completed") as! Bool
                
                let dateStr = dateFormat(date!)
                
                let existingTodo = ["todo": todo!, "date": dateStr, "completed": completed]
                
                arr.append(existingTodo)
                arrData.append(result)
            }
            
            completion(array: arr, arrayData: arrData)
            
        } catch {
            print("Error fetching results")
        }
    }
    
    func markAsComplete(todoC: String) {
        
        fetchTodos(todoC) { (array, arrayData) in
            
            for result in arrayData {
                
                let todoValue = result.valueForKey("todo") as? String
                let togoleCompleted = result.valueForKey("completed") as? Bool
                
                
                if todoC == todoValue! {

                    
                    if togoleCompleted == true {
                        
                        result.setValue(false, forKey: "completed")
                        self.completedBtn.tintColor = UIColor.blackColor()
                        
                    } else {
                        
                        result.setValue(true, forKey: "completed")
                        self.completedBtn.tintColor = UIColor.greenColor()
                    }
                    
                    do {
                        try self.context!.save()
                        
                        print("Todo: \(todoC) marked as complete")
                        
                    } catch {
                        // error
                        print("Todo: \(todoC) error")
                    }
                    
                }
            }
            
        }
    }
    
    func isComplete(todoC: String) -> Bool {
        
        var isCompleted: Bool?
        
        fetchTodos(todoC) { (array, arrayData) in
            
            for result in arrayData {
                
                let todoValue = result.valueForKey("todo") as? String
                let togoleCompleted = result.valueForKey("completed") as? Bool
                
                
                if todoC == todoValue {
                    
                    if togoleCompleted == true {
                        
                        isCompleted = true
                        
                    } else {
                        
                        isCompleted = false
                    }
                    
                }
                
            }
        }
        
        return isCompleted!
    }
    
     // MARK: - DateFormat
    
    func dateFormat(date: NSDate) -> String {
        
        var dateString: String?
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM dd, yyyy"
        
        dateString = dateFormatter.stringFromDate(date)
        
        return dateString!
    }
    
    // MARK: - DatePickerView
    
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

    
    //Alert Dialog
    
    func alertDialog(message:String) {
        
        
        let alertDialog = UIAlertController(title: "Fields Missing", message: "Please add \(message)", preferredStyle:.Alert)
        
        //ok Button
        let ok = UIAlertAction(title: "OK", style: .Default) { (UIAlertAction) -> Void in
            
            //code
        }
        
        alertDialog.addAction(ok)
        
        presentViewController(alertDialog , animated: true, completion: nil)
        
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
