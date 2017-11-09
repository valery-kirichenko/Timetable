//
//  GroupsController.swift
//  Timetable
//
//  Created by Valery Kirichenko on 01.11.2017.
//  Copyright © 2017 Valery Kirichenko. All rights reserved.
//

import Foundation
import Disk

final class GroupsController {
    static let shared = GroupsController()
    var path = "usersGroups"
    var groups: Groups
    
    private init() {
        if Disk.exists(path, in: .applicationSupport) {
            groups = try! Disk.retrieve(path, from: .applicationSupport, as: Groups.self)
        } else {
            groups = Groups(selected: nil, list: [])
            save()
        }
    }
    
    func count() -> Int {
        return groups.list.count
    }
    
    func rename(at index: Int, to name: String) {
        groups.list[index].groupName = name
        save()
    }
    
    func remove(at index: Int) {
        groups.list.remove(at: index)
        save()
    }
    
    func addGroup(_ id: Int, name: String) {
        groups.list.append(Group(groupId: id, groupName: name))
        save()
    }
    
    func setSelected(at index: Int?) {
        groups.selected = index
        save()
    }
    
    func getSelected() -> Group {
        if groups.selected != nil {
            return groups.list[groups.selected!]
        } else {
            setSelected(at: 0)
            return getSelected()
        }
    }
    
    private func save() {
        try! Disk.save(groups, to: .applicationSupport, as: path)
    }
}

struct Groups: Codable {
    var selected: Int?
    var list: [Group]
}

struct Group: Codable {
    var groupId: Int
    var groupName: String
}
