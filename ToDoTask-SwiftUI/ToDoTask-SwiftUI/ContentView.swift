//
//  ContentView.swift
//  ToDoTask-SwiftUI
//
//  Created by edy on 2023/7/7.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        HomeView()
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
