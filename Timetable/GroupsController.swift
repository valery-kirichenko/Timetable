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
    var groups: Groups {
        didSet {
            save()
        }
    }
    
    private init() {
        if Disk.exists(path, in: .sharedContainer(appGroupName: "group.dev.valery.timetable")) {
            groups = try! Disk.retrieve(path, from: .sharedContainer(appGroupName: "group.dev.valery.timetable"), as: Groups.self)
        } else {
            groups = Groups(selected: nil, list: [])
        }
    }
    
    func count() -> Int {
        return groups.list.count
    }
    
    func rename(at index: Int, to name: String) {
        groups.list[index].groupName = name
    }
    
    func remove(at index: Int) {
        groups.list.remove(at: index)
    }
    
    func move(from: Int, to: Int) {
        let movedObj = groups.list[from]
        if groups.selected == from {
            groups.selected = to
        }
        groups.list.remove(at: from)
        groups.list.insert(movedObj, at: to)
    }
    
    func addGroup(_ id: Int, name: String) {
        groups.list.append(Group(groupId: id, groupName: name))
    }
    
    func setSelected(at index: Int?) {
        groups.selected = index
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
        try! Disk.save(groups, to: .sharedContainer(appGroupName: "group.dev.valery.timetable"), as: path)
    }
    
    func getQuickActions() -> [UIApplicationShortcutItem]? {
        if groups.list.count < 2 {
            return nil
        }
        
        return groups.list.prefix(4).enumerated().map { (index, group) in
            return UIApplicationShortcutItem(type: "FavoriteAction",
                                             localizedTitle: group.groupName,
                                             localizedSubtitle: nil,
                                             icon: UIApplicationShortcutIcon(type: .favorite),
                                             userInfo: [ "index": index as NSSecureCoding])
        }
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
