//
//  LevelTableViewController.swift
//  Timetable
//
//  Created by Valery Kirichenko on 12.09.17.
//  Copyright © 2017 Valery Kirichenko. All rights reserved.
//

import UIKit

class LevelTableViewController: UITableViewController {
    
    @IBOutlet var levelsList: UITableView!
    var studyLevels: [StudyLevel]!
    var studyPrograms: [StudyProgramCombination]!
    var selectedDivision: String!
    var selectedLevel: StudyLevel!

    override func viewDidLoad() {
        super.viewDidLoad()
        levelsList.dataSource = self
        levelsList.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! StudyProgramTableViewController
        destination.studyPrograms = selectedLevel.studyProgramCombinations
        destination.selectedDivision = selectedDivision
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studyLevels != nil ? studyLevels.count : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "levelCell", for: indexPath)
        let text = studyLevels[indexPath.row].studyLevelName
        cell.textLabel?.text = text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLevel = studyLevels[indexPath.row]
        self.performSegue(withIdentifier: "showStudyProgramSegue", sender: nil)
    }
 
}
