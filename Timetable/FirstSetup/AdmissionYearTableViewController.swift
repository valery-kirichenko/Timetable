//
//  AdmissionYearTableViewController.swift
//  Timetable
//
//  Created by Valery Kirichenko on 12.09.17.
//  Copyright © 2017 Valery Kirichenko. All rights reserved.
//

import UIKit

class AdmissionYearTableViewController: UITableViewController {

    @IBOutlet var admissionYearsList: UITableView!
    var admissionYears: [AdmissionYear]!
    var studyGroups: [StudyGroup]!
    var selectedDivision: String!
    var studyProgramId: Int!
    
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! StudyGroupTableViewController
        destination.selectedDivision = selectedDivision
        destination.studyGroups = studyGroups
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return admissionYears != nil ? admissionYears.count : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "admissionYearCell", for: indexPath)
        let text = String(admissionYears[indexPath.row].yearNumber)
        cell.textLabel?.text = text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingIndicator.startAnimating()
        let cell = admissionYearsList.cellForRow(at: indexPath)
        cell?.accessoryView = loadingIndicator
        admissionYearsList.isUserInteractionEnabled = false
        
        studyProgramId = admissionYears[indexPath.row].studyProgramId
        
        URLSession.shared.dataTask(with: URL(string: "https://timetable.spbu.ru/api/v1/\(selectedDivision!)/studyprogram/\(studyProgramId!)/studentgroups")!) {
            data, response, err in
            guard let data = data else {
                print("Error")
                return
            }
            let decoder = JSONDecoder()
            self.studyGroups = (try! decoder.decode([StudyGroup].self, from: data))

            DispatchQueue.main.async {
                self.admissionYearsList.isUserInteractionEnabled = true
                cell?.accessoryView = nil
                cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                self.performSegue(withIdentifier: "showStudyGroupSegue", sender: nil)
            }
        }.resume()
    }


}
