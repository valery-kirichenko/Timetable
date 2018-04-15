//
//  TimetableTableViewController.swift
//  Timetable
//
//  Created by Valery Kirichenko on 13.09.17.
//  Copyright © 2017 Valery Kirichenko. All rights reserved.
//

import UIKit

class TimetableTableViewController: UITableViewController {
    // let studyGroup = UserDefaults.standard.string(forKey: "studyGroup")!
    var studyGroup = String(GroupsController.shared.getSelected().groupId)
    @IBOutlet var timetable: UITableView!
    let activityIndicatorToolbarItem = UIBarButtonItem()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let weekIndicatorToolbarItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    var currentWeek = ""
    var previoiusWeek: String?
    let timetableManager = TimetableDataController()
    var timetableData: WeekInstance?
    var selectedSubject: SubjectInstance?
    var dateFormatter = DateFormatter()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
        let testSelected = String(GroupsController.shared.getSelected().groupId)
        if studyGroup != testSelected {
            studyGroup = testSelected
            timetableManager.setStudyGroup(studyGroup: String(studyGroup))
            fetchAndUpdate()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForPreviewing(with: self, sourceView: timetable)
        
        weekIndicatorToolbarItem.action = #selector(self.resetWeek)
        weekIndicatorToolbarItem.target = self
        timetableManager.setStudyGroup(studyGroup: studyGroup)
        
        dateFormatter.timeZone = TimeZone(abbreviation: "MSK")
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(self.forceUpdate), for: .valueChanged)
        //timetable.refreshControl = refreshControl
        timetable.addSubview(refreshControl!)
        //timetable.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
        print(UserDefaults.standard.bool(forKey: "updateOnLaunch"))
        resetWeek(forceUpdate: UserDefaults.standard.bool(forKey: "updateOnLaunch"))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showSettings(_ sender: Any) {
        self.performSegue(withIdentifier: "showSettingsSegue", sender: nil)
    }
    
    @IBAction func showGroupsList(_ sender: Any) {
        self.performSegue(withIdentifier: "showGroupsListSegue", sender: nil)
    }
    
    @IBAction func weekArrowLeft(_ sender: Any) {
        if (timetableData != nil) {
            previoiusWeek = currentWeek
            currentWeek = timetableData!.prevWeek
            fetchAndUpdate()
        }
    }

    @IBAction func weekArrowRight(_ sender: Any) {
        if (timetableData != nil) {
            previoiusWeek = currentWeek
            currentWeek = timetableData!.nextWeek
            fetchAndUpdate()
        }
    }
    
    @objc func resetWeek(forceUpdate: Bool = false) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        currentWeek = dateFormatter.string(from:
            Calendar(identifier: .iso8601).date(from:
                Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear],from: Date()))!)
        fetchAndUpdate(forceUpdate: forceUpdate)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if timetableData != nil && timetableData!.days.count > 0 {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
            return timetableData!.days.count
        } else {
            /*
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "Занятий нет. Ура!"
            noDataLabel.textColor = UIColor.darkGray
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            */
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timetableData != nil ? timetableData!.days[section].subjects.count : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timetableCell", for: indexPath) as! TimetableViewCell
        let data = timetableData!.days[indexPath.section].subjects[indexPath.row]
        
        if indexPath.row % 2 == 1 {
            cell.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
        }
        
        dateFormatter.dateFormat = "HH:mm"
        if let startTime = data.startTime {
            if indexPath.row > 0, let previousTime = timetableData!.days[indexPath.section].subjects[indexPath.row - 1].startTime,
                previousTime == startTime {
                cell.startTime.text = ""
            } else {
                cell.startTime.text = dateFormatter.string(from: startTime)
            }
        } else {
            cell.startTime.text = ""
        }
        if let endTime = data.endTime {
            // Hide endTime if next field has the same
            if indexPath.row < timetableData!.days[indexPath.section].subjects.count - 1, let nextTime = timetableData!.days[indexPath.section].subjects[indexPath.row + 1].endTime,
                nextTime == endTime {
                cell.endTime.text = ""
            } else {
                cell.endTime.text = dateFormatter.string(from: endTime)
            }
        } else {
            cell.endTime.text = ""
        }
        cell.subject.text = data.subject
        cell.educator.text = data.locations?[0].educator
        cell.building.text = data.locations?[0].building
        cell.audience.text = data.locations?[0].audience
        
        if data.isCancelled {
            let attributedString = NSMutableAttributedString(string: data.subject)
            attributedString.addAttribute(.strikethroughStyle, value: 1, range: .init(location: 0, length: attributedString.length))
            cell.subject.attributedText = attributedString
            cell.contentView.layer.opacity = 0.5
        }
        let changedColor = UIColor(red:0.00, green:0.35, blue:0.71, alpha:1.0)
        if data.isTimeChanged {
            cell.startTime.textColor = changedColor
            cell.endTime.textColor = changedColor
        }
        if data.isEducatorChanged {
            cell.educator.textColor = changedColor
        }
        if data.isLocationChanged {
            cell.building.textColor = changedColor
            cell.audience.textColor = changedColor
        }
        if data.isNew {
            cell.subject.textColor = UIColor(red: 0.25, green: 0.71, blue: 0.00, alpha: 1.0)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        dateFormatter.dateFormat = "EEEE, d MMMM"
        return dateFormatter.string(from: timetableData!.days[section].day)
    }
    /*
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
        view.layer.zPosition = 2
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.darkGray
    }
     */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSubject = timetableData?.days[indexPath.section].subjects[indexPath.row]
        //self.performSegue(withIdentifier: "showEventDetailsSegue", sender: nil)
        self.performSegue(withIdentifier: "showNewEventDetailsSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEventDetailsSegue" {
            let destination = segue.destination as! EventDetailsViewController
            destination.subject = selectedSubject
        } else if segue.identifier == "showNewEventDetailsSegue" {
            let destination = segue.destination as! EventDetailsTableViewController
            destination.subject = selectedSubject
        }
    }
    
    @objc func forceUpdate() {
        fetchAndUpdate(forceUpdate: true)
    }
    
    @objc func fetchAndUpdate(forceUpdate: Bool = false) {
        activityIndicator.startAnimating()
        activityIndicatorToolbarItem.customView = activityIndicator
        self.toolbarItems?.remove(at: 2)
        self.toolbarItems?.insert(activityIndicatorToolbarItem, at: 2)
        self.weekIndicatorToolbarItem.tintColor = UIColor.black
        
        timetableManager.getTimetable(forWeek: currentWeek, forceUpdate: forceUpdate) { week in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.toolbarItems?.remove(at: 2)

                if week == nil {
                    self.weekIndicatorToolbarItem.title = "Ошибка обновления"
                    self.currentWeek = self.previoiusWeek ?? self.currentWeek
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        self.dateFormatter.dateFormat = "yyyy-MM-dd"
                        let weekDate = self.dateFormatter.date(from: self.currentWeek)!
                        self.dateFormatter.dateFormat = "d MMMM"
                        self.weekIndicatorToolbarItem.title = self.dateFormatter.string(from: weekDate) + "–" + self.dateFormatter.string(from: weekDate.addingTimeInterval(6 * 24 * 60 * 60))
                    }
                } else {
                    self.dateFormatter.dateFormat = "yyyy-MM-dd"
                    let weekDate = self.dateFormatter.date(from: self.currentWeek)!
                    self.dateFormatter.dateFormat = "d MMMM"
                    self.weekIndicatorToolbarItem.title = self.dateFormatter.string(from: weekDate) + "–" + self.dateFormatter.string(from: weekDate.addingTimeInterval(6 * 24 * 60 * 60))
                    self.timetableData = week
                    self.dateFormatter.dateFormat = "dd.MM в HH:mm:ss"
                    self.refreshControl?.attributedTitle = NSAttributedString(string: "Обновлено " + self.dateFormatter.string(from: self.timetableData!.updated))
                    self.timetable.reloadData()
                }
                if self.timetableData == nil || self.timetableData!.days.count <= 0 {
                    let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.timetable.bounds.size.width, height: self.timetable.bounds.size.height))
                    noDataLabel.text = "Занятий нет. Ура!"
                    noDataLabel.textColor = UIColor.darkGray
                    noDataLabel.textAlignment = .center
                    self.timetable.backgroundView = noDataLabel
                    self.timetable.separatorStyle = .none
                } else {
                    self.timetable.backgroundView = nil
                }
                self.toolbarItems?.insert(self.weekIndicatorToolbarItem, at: 2)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                    self.refreshControl?.endRefreshing()
                }
            }
        }
    }
}

extension TimetableTableViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = timetable.cellForRow(at: indexPath) else {
            return nil
        }
        guard let destinationController = storyboard!.instantiateViewController(withIdentifier: "EventDetailsTableViewController") as? EventDetailsTableViewController else {
            return nil
        }
        destinationController.subject = timetableData?.days[indexPath.section].subjects[indexPath.row]
        previewingContext.sourceRect = cell.frame
        return destinationController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    
}
