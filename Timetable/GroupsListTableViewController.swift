//
//  GroupsListViewController.swift
//  Timetable
//
//  Created by Valery Kirichenko on 30.10.2017.
//  Copyright © 2017 Valery Kirichenko. All rights reserved.
//

import UIKit

class GroupsListViewController: UITableViewController {
    @IBOutlet var groupsList: UITableView!
    
    lazy var editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editButton))
    lazy var cancelBarButton = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelButton))
    lazy var addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButton))
    lazy var doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButton))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelBarButton.style = .done
        
        self.navigationItem.leftBarButtonItem = editBarButton
        self.navigationItem.rightBarButtonItem = cancelBarButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func cancelButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @objc func addButton(_ sender: Any) {
        self.performSegue(withIdentifier: "showSetupSegue", sender: nil)
    }
    
    @objc func doneButton(_ sender: Any) {
        self.setEditing(false, animated: true)
        self.navigationItem.leftBarButtonItem = editBarButton
        self.navigationItem.rightBarButtonItem = cancelBarButton
    }
    
    @objc func editButton(_ sender: Any) {
        self.navigationItem.leftBarButtonItem = addBarButton
        self.navigationItem.rightBarButtonItem = doneBarButton
        self.setEditing(true, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = doneBarButton
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        self.navigationItem.leftBarButtonItem = editBarButton
        self.navigationItem.rightBarButtonItem = cancelBarButton
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        GroupsController.shared.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GroupsController.shared.count()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupsListCell", for: indexPath) as! GroupsListTableViewCell
        cell.groupName.text = GroupsController.shared.groups.list[indexPath.row].groupName
        if indexPath.row == GroupsController.shared.groups.selected {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        GroupsController.shared.setSelected(at: indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction  = UITableViewRowAction(style: .destructive, title: "Удалить") { (rowAction, indexPath) in
            GroupsController.shared.remove(at: indexPath.row)
            self.groupsList.deleteRows(at: [indexPath], with: .automatic)
            if GroupsController.shared.count() == 0 {
                GroupsController.shared.setSelected(at: nil)
                self.performSegue(withIdentifier: "showSetupSegue", sender: nil)
            }
            if indexPath.row == GroupsController.shared.groups.selected {
                GroupsController.shared.setSelected(at: 0)
                self.groupsList.cellForRow(at: IndexPath(row: 0, section: 0))?.accessoryType = .checkmark
            }
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Изменить") { (rowAction, indexPath) in
            let editAlert = UIAlertController(title: "Переименовать группу", message: "Введите новое название для группы \(GroupsController.shared.groups.list[indexPath.row].groupName)", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
                GroupsController.shared.rename(at: indexPath.row, to: editAlert.textFields![0].text!)
                self.groupsList.reloadRows(at: [indexPath], with: .automatic)
            }
            let cancelAction = UIAlertAction(title: "Отменить", style: .cancel) { _ in }
            editAlert.addTextField { textField in
                textField.placeholder = "Введите название"
                textField.autocorrectionType = .yes
                textField.autocapitalizationType = .sentences
            }
            editAlert.addAction(confirmAction)
            editAlert.addAction(cancelAction)
            
            self.present(editAlert, animated: true, completion: nil)
        }
        
        return [deleteAction, editAction]
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
