//
//  InitialViewController.swift
//  Timetable
//
//  Created by Valery Kirichenko on 15.09.17.
//  Copyright © 2017 Valery Kirichenko. All rights reserved.
//

import UIKit
import NotificationCenter

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if GroupsController.shared.groups.selected != nil && GroupsController.shared.groups.list.count > 0 {
            self.present(storyboard!.instantiateViewController(withIdentifier: "TimetableNavigationController"), animated: false, completion: nil)
        } else {
            self.present(storyboard!.instantiateViewController(withIdentifier: "FirstSetupController"), animated: false, completion: nil)
        }
        /*
        if UserDefaults.standard.string(forKey: "studyGroup") != nil {
            self.present(storyboard!.instantiateViewController(withIdentifier: "TimetableNavigationController"), animated: false, completion: nil)
        } else {
            self.present(storyboard!.instantiateViewController(withIdentifier: "FirstSetupController"), animated: false, completion: nil)
        }
         */
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
