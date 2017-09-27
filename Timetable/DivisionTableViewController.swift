//
//  DivisionTableViewController.swift
//  Timetable
//
//  Created by Valery Kirichenko on 12.09.17.
//  Copyright © 2017 Valery Kirichenko. All rights reserved.
//

import UIKit

class DivisionTableViewController: UITableViewController {
    @IBOutlet var divisionsList: UITableView!
    
    var divisions: [Division]!
    var selectedDivision: Division!
    var studyLevels: [StudyLevel]!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        divisionsList.dataSource = self
        divisionsList.delegate = self

        URLSession.shared.dataTask(with: URL(string: "https://timetable.spbu.ru/api/v1/divisions")!) {
            data, response, err in
            guard let data = data else {
                print("Error")
                return
            }
            
            let decoder = JSONDecoder()
            self.divisions = (try! decoder.decode([Division].self, from: data)).filter {$0.name.range(of: "Юриспруденция") == nil && $0.name.range(of: "Академическая гимназия") == nil}

            DispatchQueue.main.async {
                self.divisionsList.reloadData()
            }
            }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return divisions != nil ? divisions.count : 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! LevelTableViewController
        destination.studyLevels = studyLevels
        destination.selectedDivision = selectedDivision.alias
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "divisionCell", for: indexPath)
        let text = divisions[indexPath.row].name
        cell.textLabel?.text = text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingIndicator.startAnimating()
        let cell = divisionsList.cellForRow(at: indexPath)
        cell?.accessoryView = loadingIndicator
        divisionsList.isUserInteractionEnabled = false
        
        selectedDivision = divisions[indexPath.row]
        URLSession.shared.dataTask(with: URL(string: "https://timetable.spbu.ru/api/v1/\(selectedDivision.alias)/studyprograms")!) {
            data, response, err in
            guard let data = data else {
                print("Error")
                return
            }
            let decoder = JSONDecoder()
            self.studyLevels = (try! decoder.decode([StudyLevel].self, from: data))
            
            DispatchQueue.main.async {
                self.divisionsList.isUserInteractionEnabled = true
                cell?.accessoryView = nil
                cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                self.performSegue(withIdentifier: "showLevelSegue", sender: nil)
            }
        }.resume()
    }

}
