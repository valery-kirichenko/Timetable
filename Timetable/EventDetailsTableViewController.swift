//
//  EventDetailsTableViewController.swift
//  Timetable
//
//  Created by Valery Kirichenko on 08.11.2017.
//  Copyright © 2017 Valery Kirichenko. All rights reserved.
//

import UIKit

class EventDetailsTableViewController: UITableViewController {

    @IBOutlet var detailsTable: UITableView!
    var subject: SubjectInstance!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsTable.rowHeight = UITableView.automaticDimension
        detailsTable.estimatedRowHeight = 44.0

        // detailsTable.register(LocationTableViewCell.self, forCellReuseIdentifier: "locationCell")
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
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            if subject.isLocationChanged || subject.isEducatorChanged ||
                subject.isTimeChanged || subject.isCancelled || subject.isNew {
                return 3
            }
            return 2
        case 1:
            if subject.locations != nil {
                return subject.locations!.count
            } else {
                return 0
            }
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicInformationCell")! as! BasicInformationTableViewCell
            switch indexPath.row {
            case 0:
                cell.caption.text = "Занятие"
                cell.value.text = subject.subject
                break
            case 1:
                cell.caption.text = "Время проведения"
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "ru_RU")
                dateFormatter.timeZone = TimeZone(identifier: "MSK")
                dateFormatter.dateFormat = "HH:mm"
                cell.value.text = dateFormatter.string(from: subject.startTime!) + "–" + dateFormatter.string(from: subject.endTime!)
                break
            case 2:
                cell.caption.text = "Статус"
                var status = ""
                if subject.isCancelled {
                    status = "Занятие отменено\n"
                }
                if subject.isNew {
                    status = status + "Занятие добавлено\n"
                }
                if subject.isTimeChanged {
                    status = status + "Изменилось время\n"
                }
                if subject.isEducatorChanged {
                    status = status + "Поменялся преподаватель\n"
                }
                if subject.isLocationChanged {
                    status = status + "Изменилось место проведения\n"
                }
                cell.value.text = status.trimmingCharacters(in: .whitespacesAndNewlines)
                break
            default:
                break
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell") as! LocationTableViewCell
            let location = subject.locations![indexPath.row]
            cell.audience.text = location.audience ?? "Кабинет неизвестен"
            cell.educator.text = location.educator ?? "Преподаватель неизвестен"
            cell.building.text = location.building ?? "Адрес неизвестен"
            return cell
        default:
            return UITableViewCell()
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
