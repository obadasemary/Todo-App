//
//  TodosTableViewController.swift
//  Todo App
//
//  Created by Abdelrahman Mohamed on 5/30/16.
//  Copyright © 2016 Abdelrahman Mohamed. All rights reserved.
//

import UIKit
import CoreData

class TodosTableViewController: UITableViewController {

    var todos = [NSDictionary]()
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // managedObjectContext
        context = CoreDataStackManager.sharedInstacne().managedObjectContext
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // fetching todo
        fetchTodos("") { (array, arrayData) in
            
            self.todos = array as! [NSDictionary]
            // reload data
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todos.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        cell.textLabel?.text = todos[indexPath.row]["todo"] as? String
        cell.detailTextLabel?.text = todos[indexPath.row]["date"]! as? String

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Core Data
    
    func fetchTodos(predicate: String, completion:(array: NSArray, arrayData: NSArray) -> ()) {
        
        var arr = [NSDictionary]()
        var arrData = [NSManagedObject]()
        
        let request = NSFetchRequest(entityName: "Todo")
        
        do {
            let results = try context?.executeFetchRequest(request)
            
            for result in results as! [NSManagedObject] {
                
                let todo = result.valueForKey("todo") as? String
                let date = result.valueForKey("date") as? NSDate
                let completed = result.valueForKey("completed") as! Bool
                
                let dateStr = dateFormat(date!)
                
                let newTodo = ["todo": todo!, "date": dateStr, "completed": completed]
                
                arr.append(newTodo)
                arrData.append(result)
            }
            
            completion(array: arr, arrayData: arrData)
            
        } catch {
            print("Error fetching results")
        }
    }
    
    func dateFormat(date: NSDate) -> String {
        
        var dateString: String?
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM dd, yyyy"
        
        dateString = dateFormatter.stringFromDate(date)
        
        return dateString!
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let inputVC = segue.destinationViewController as! AddTodoViewController
        
        
        if segue.identifier == "addTodo" {
            
            inputVC.isTodoEditing = false
        }
        
        if segue.identifier == "updateTodo" {
            
            let indexPath = tableView.indexPathForSelectedRow
            let todoSelected = todos[indexPath!.row]
            
            inputVC.isTodoEditing = true
            inputVC.todo = todoSelected
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
}
