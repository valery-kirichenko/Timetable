//
//  StudyProgramTableViewController.swift
//  Timetable
//
//  Created by Valery Kirichenko on 12.09.17.
//  Copyright © 2017 Valery Kirichenko. All rights reserved.
//

import UIKit

class StudyProgramTableViewController: UITableViewController {
    
    @IBOutlet var studyProgramsList: UITableView!
    var studyPrograms: [StudyProgramCombination]!
    var selectedProgram: StudyProgramCombination!
    var selectedDivision: String!
    var admissionYears: [AdmissionYear]!

    override func viewDidLoad() {
        super.viewDidLoad()

        studyProgramsList.dataSource = self
        studyProgramsList.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! AdmissionYearTableViewController
        destination.admissionYears = admissionYears
        destination.selectedDivision = selectedDivision
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studyPrograms != nil ? studyPrograms.count : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studyProgramCell", for: indexPath)
        let text = studyPrograms[indexPath.row].name
        cell.textLabel?.text = text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        admissionYears = studyPrograms[indexPath.row].admissionYears
        self.performSegue(withIdentifier: "showAdmissionYearSegue", sender: nil)
    }

}
