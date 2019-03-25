//
//  C1.swift
//  CashFlow
//
//  Created by David on 2019/3/25.
//  Copyright © 2019 葛茂菁. All rights reserved.
//

import UIKit

class C1: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = 	UIBarButtonItem(image: UIImage(named: "增加"), style: .plain, target: self, action: #selector(addRelations))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "c1reuse")
    }

    @objc func addRelations() {
        print("添加事件")
    
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "c1reuse")!
        cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "c1reuse")
        cell.textLabel?.text = "张三总送来53度飞天茅台一箱美元教育金券5w"
        cell.detailTextLabel?.text = "2019-03-25"
        return cell
    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print("leadingSwipeActions")
        let action = UIContextualAction(style: .normal, title: "Mark") { (action, view, handler) in
            self.updateMarkState(for: indexPath)
            handler(true)
        }
        action.backgroundColor = UIColor.green
        
        if markState(for: indexPath) {
            action.title = "Unmark"
            action.backgroundColor = UIColor.green
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print("trailingSwipeActions")
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            self.removeItem(at: indexPath)
            handler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
        
    }
    func  updateMarkState(for: IndexPath) {
        
    }
    
    func removeItem(at: IndexPath) {
        
    }
    func markState(for: IndexPath) -> Bool {
        return true
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
