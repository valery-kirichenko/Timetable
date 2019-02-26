//
//  StudyGroupTableViewController.swift
//  Timetable
//
//  Created by Valery Kirichenko on 12.09.17.
//  Copyright © 2017 Valery Kirichenko. All rights reserved.
//

import UIKit

class StudyGroupTableViewController: UITableViewController {
    
    var studyGroups: [StudyGroup]!
    var selectedDivision: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studyGroups != nil ? studyGroups.count : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studyGroupCell", for: indexPath)
        let text = String(studyGroups[indexPath.row].studentGroupName)
        cell.textLabel?.text = text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // UserDefaults.standard.set(studyGroups[indexPath.row].studentGroupId, forKey: "studyGroup")
        // UserDefaults.standard.synchronize()
        // self.present(storyboard!.instantiateViewController(withIdentifier: "timetableViewController"), animated: true, completion: nil)
        GroupsController.shared.addGroup(studyGroups[indexPath.row].studentGroupId, name: studyGroups[indexPath.row].studentGroupName)
        GroupsController.shared.setSelected(at: GroupsController.shared.count() - 1)
        self.performSegue(withIdentifier: "showTimetableNavigationController", sender: nil)
    }
}
