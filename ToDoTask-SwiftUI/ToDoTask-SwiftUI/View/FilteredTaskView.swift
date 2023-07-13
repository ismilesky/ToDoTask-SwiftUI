//
//  FilteredTaskView.swift
//  ToDoTask-SwiftUI
//
//  Created by edy on 2023/7/11.
//

import SwiftUI
import CoreData

struct FilteredTaskView<Content: View,T>: View where T: NSManagedObject {
    
    @FetchRequest var request: FetchedResults<T>
    let content: (T)->Content
    
    init(currentTab: String, @ViewBuilder content: @escaping (T)->Content) {
        
        let calendar = Calendar.current
        var predicate: NSPredicate!
        
        let filterKey = "date"
        if currentTab == "今天" {
            let today = calendar.startOfDay(for: Date())
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
            
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tomorrow, 0])
        } else if currentTab == "未来" {
            let today = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
            let tomorrow = Date.distantFuture

            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tomorrow, 0])
        } else if currentTab == "完成" {
            let past = Date.distantPast
            let tomorrow = Date.distantFuture
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [past, tomorrow, 1])

        } else {
            predicate = NSPredicate(format: "isCompleted == %i", argumentArray: [1])
        }
        // 通过条件筛选
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [NSSortDescriptor(keyPath:\TaskItem.date, ascending: false)], predicate: predicate)
        self.content = content
    }
    
    var body: some View {
        Group {
            if request.isEmpty {
                    VStack(spacing: 30) {
                        Image("default")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.top, 10)
                            .frame(width: 200, height: 140)
                       
                        Text("还没有添加待办呦~")
                            .font(.system(size: 18))
                            .fontWeight(.light)
                            .frame(width: 200)

                    }
                    .padding(.leading, (UIScreen.main.bounds.size.width - 200))

                
            } else {
                ForEach(request, id: \.objectID) { object in
                    self.content(object)
                }
            }
            
        }
        
    }
}
