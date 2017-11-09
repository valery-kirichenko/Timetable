//
//  SettingsTableViewController.swift
//  Timetable
//
//  Created by Valery Kirichenko on 13.09.17.
//  Copyright © 2017 Valery Kirichenko. All rights reserved.
//

import UIKit
import Disk

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var updateOnLaunchSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateOnLaunchSwitch.isOn = UserDefaults.standard.bool(forKey: "updateOnLaunch")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func changeGroup() {
        let resetAlert = UIAlertController(title: "Вам потребуется интернет, чтобы выбрать группу", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        resetAlert.addAction(UIAlertAction(title: "Изменить группу", style: .destructive, handler: { (action: UIAlertAction!) in
            UserDefaults.standard.removeObject(forKey: "studyGroup")
            self.present(self.storyboard!.instantiateInitialViewController()!, animated: true, completion: nil)
        }))
        
        resetAlert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (action: UIAlertAction!) in
            return
        }))
        
        present(resetAlert, animated: true, completion: nil)
        
    }
    // MARK: - Table view data source

    func resetCache() {
        let resetAlert = UIAlertController(title: "Сохраненные расписания будут удалены", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        resetAlert.addAction(UIAlertAction(title: "Очистить кэш", style: .destructive, handler: { (action: UIAlertAction!) in
            if Disk.exists("timetable/", in: .caches) {
                try! Disk.remove("timetable/", from: .caches)
            }
        }))
        
        resetAlert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (action: UIAlertAction!) in
            return
        }))
        
        present(resetAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func updateOnLaunchSwitchChanged(_ sender: Any) {
        UserDefaults.standard.set(updateOnLaunchSwitch.isOn, forKey: "updateOnLaunch")
        UserDefaults.standard.synchronize()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                resetCache()
            default:
                break
            }
        case 2:
            let toEmail = "me@vkirichenko.name"
            let subject = "Отзыв о Расписании".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            // let body = "Just testing ...".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let body = "".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            
            let urlString = "mailto:\(toEmail)?subject=\(subject)&body=\(body)",
                url = URL(string: urlString)
            UIApplication.shared.openURL(url!)
            break
            //self.performSegue(withIdentifier: "showAboutSegue", sender: nil)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
            
    }
}
