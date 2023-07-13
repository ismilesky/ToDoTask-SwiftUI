//
//  ToDoTask_SwiftUIApp.swift
//  ToDoTask-SwiftUI
//
//  Created by edy on 2023/7/7.
//

import SwiftUI

@main
struct ToDoTask_SwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
