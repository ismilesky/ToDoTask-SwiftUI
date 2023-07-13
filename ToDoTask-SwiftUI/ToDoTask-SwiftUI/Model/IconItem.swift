//
//  IconItem.swift
//  ToDoTask-SwiftUI
//
//  Created by edy on 2023/7/7.
//

import Foundation

struct IconItem: Identifiable, Hashable {
    var id = UUID().uuidString
    var name: String
    
}

struct IconGroup {
    var groupName: String
    var icons: [IconItem]
}


class IconViewModel: ObservableObject {
    
    /// 数据
   @Published var datas: [IconGroup] = []
    
    init() {
        loadIconData()
    }
    
    
    private func loadIconData() {
        setIconItems(15, prefix: "learn", groupName: "学习")
        setIconItems(32, prefix: "work", groupName: "工作")
        setIconItems(17, prefix: "sport", groupName: "运动")
        setIconItems(13, prefix: "read", groupName: "阅读")
        setIconItems(32, prefix: "life", groupName: "生活")
        setIconItems(18, prefix: "shopping", groupName: "购物")
        setIconItems(17, prefix: "fun", groupName: "娱乐")

    }
    
    private func setIconItems(_ count: Int, prefix: String, groupName: String) {
        var items: [IconItem] = []
        for i in 1..<count {
            let icon = IconItem(name: prefix + "_" + "\(i)")
            items.append(icon)
        }
        let group = IconGroup(groupName: groupName, icons: items)
        datas.append(group)
    }
}




