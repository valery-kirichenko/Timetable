//
//  TimetableTableViewController.swift
//  Timetable
//
//  Created by Valery Kirichenko on 13.09.17.
//  Copyright © 2017 Valery Kirichenko. All rights reserved.
//

import UIKit

class TimetableTableViewController: UITableViewController {
    
    let division = UserDefaults.standard.string(forKey: "division")!
    let studyGroup = UserDefaults.standard.string(forKey: "studyGroup")!
    var requestedEvents: StudentGroupEvents!
    @IBOutlet var timetable: UITableView!
    let activityIndicatorToolbarItem = UIBarButtonItem()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let weekIndicatorToolbarItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    var currentWeek: String? = nil
    var selectedEvent: StudyEventItem?
    var currentMonday: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "MSK")
        return dateFormatter.string(from:
            Calendar(identifier: .iso8601).date(from:
                Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear],from: Date()))!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(self.fetchAndUpdate), for: .valueChanged)
        self.weekIndicatorToolbarItem.action = #selector(self.resetWeek)
        self.weekIndicatorToolbarItem.target = self
        
        let timetableManager = TimetableDataController(division: division, studyGroup: studyGroup)
        timetableManager.getTimetable(forWeek: currentMonday) { weekInstance in
            // print(weekInstance)
        }
        
        fetchAndUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showSettings(_ sender: Any) {
        self.performSegue(withIdentifier: "showSettings", sender: nil)
    }
    
    @IBAction func weekArrowLeft(_ sender: Any) {
        if (requestedEvents != nil) {
            currentWeek = requestedEvents.previousWeekMonday
            fetchAndUpdate()
        }
    }

    @IBAction func weekArrowRight(_ sender: Any) {
        if (requestedEvents != nil) {
            currentWeek = requestedEvents.nextWeekMonday
            fetchAndUpdate()
        }
    }
    
    @objc func resetWeek() {
        currentWeek = ""
        fetchAndUpdate()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if requestedEvents != nil && requestedEvents.days != nil {
            return (requestedEvents.days?.count)!
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if requestedEvents.days?[section].dayStudyEvents != nil {
            return (requestedEvents.days?[section].dayStudyEvents?.count)!
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timetableCell", for: indexPath) as! TimetableViewCell
        let dayEvent = (requestedEvents.days?[indexPath.section].dayStudyEvents?[indexPath.row])!

        cell.event.text = (dayEvent.subject == nil || dayEvent.subject == "") ? "Неизвестный предмет" : dayEvent.subject
        cell.teacher.text = (dayEvent.educatorsDisplayText == nil || dayEvent.educatorsDisplayText == "") ? "Неизвестный преподаватель" : dayEvent.educatorsDisplayText
        
        if dayEvent.locationsDisplayText != "", let location = dayEvent.locationsDisplayText {
            let splitted = location.split(separator: ",")
            cell.place.text = splitted[0..<(splitted.count - 1)].joined().trimmingCharacters(in: .whitespaces)
            cell.room.text = String(splitted[splitted.count - 1]).trimmingCharacters(in: .whitespaces)
        } else {
            cell.place.text = (dayEvent.locationsDisplayText == nil || dayEvent.locationsDisplayText == "") ? "Неизвестное место" : dayEvent.locationsDisplayText
            cell.room.text = ""
        }
        
        if indexPath.row % 2 == 1 {
            cell.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
        }
        
        // TODO: secure this place
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "MSK")
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let startTime = dateFormatter.date(from: dayEvent.start!)!
        let endTime = dateFormatter.date(from: dayEvent.end!)!
        dateFormatter.dateFormat = "HH:mm"
        cell.startTime.text = dateFormatter.string(from: startTime)
        cell.endTime.text = dateFormatter.string(from: endTime)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return requestedEvents.days?[section].dayString ?? ""
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEvent = requestedEvents.days?[indexPath.section].dayStudyEvents![indexPath.row]
        self.performSegue(withIdentifier: "showEventDetailsSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEventDetailsSegue" {
            let destination = segue.destination as! EventDetailsViewController
            
            destination.event = selectedEvent?.subject
            destination.teacher = selectedEvent?.educatorsDisplayText
            destination.time = selectedEvent?.timeIntervalString
            destination.location = selectedEvent?.locationsDisplayText
        }
    }
    
    @objc func fetchAndUpdate() {
        activityIndicator.startAnimating()
        activityIndicatorToolbarItem.customView = activityIndicator
        self.toolbarItems?.remove(at: 2)
        self.toolbarItems?.insert(activityIndicatorToolbarItem, at: 2)
        self.weekIndicatorToolbarItem.tintColor = UIColor.black
        
        let url = URL(string: "https://timetable.spbu.ru/api/v1/\(division)/studentgroup/\(studyGroup)/events?weekMonday=" + (currentWeek ?? ""))!
        URLSession.shared.dataTask(with: url) {
            data, response, err in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.toolbarItems?.remove(at: 2)
                    self.weekIndicatorToolbarItem.title = "Ошибка обновления"
                    self.toolbarItems?.insert(self.weekIndicatorToolbarItem, at: 2)
                    self.refreshControl?.endRefreshing()
                }
                if self.currentWeek != nil { // Ошибка обновления после загрузки приложения
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        self.weekIndicatorToolbarItem.title = self.requestedEvents.weekDisplayText!
                        self.currentWeek = self.requestedEvents.weekMonday
                    }
                }
                return
            }
            let decoder = JSONDecoder()
            self.requestedEvents = try! decoder.decode(StudentGroupEvents.self, from: data)
            self.currentWeek = self.currentWeek ?? self.requestedEvents.weekMonday
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.toolbarItems?.remove(at: 2)
                self.weekIndicatorToolbarItem.title = self.requestedEvents.weekDisplayText!
                self.toolbarItems?.insert(self.weekIndicatorToolbarItem, at: 2)
                self.refreshControl?.endRefreshing()
                
                self.timetable.reloadData()
                
            }
        }.resume()
    }
}
