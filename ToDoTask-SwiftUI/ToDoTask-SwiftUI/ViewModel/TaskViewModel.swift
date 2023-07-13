//
//  TaskViewModel.swift
//  ToDoTask-SwiftUI
//
//  Created by edy on 2023/7/10.
//

import Foundation
import CoreData
import UserNotifications


class TaskViewModel : ObservableObject {
    
    // MARK: - Task

    @Published var taskTitle: String = ""
    @Published var taskColor: String = "Grey"
    @Published var taskDate: Date = Date()
    @Published var taskType: String = "普通"
    @Published var taskIcon = "learn_7"
    
    @Published var showDatePicker: Bool = false

    
    @Published var editTask : TaskItem? {
        didSet {
            if let task = editTask {
                taskType = task.type ?? "普通"
                taskColor = task.color ?? "Grey"
                taskTitle = task.title ?? ""
                taskIcon = task.iconName ?? "learn_7"
                taskDate = task.date ?? Date()
            }
        }
    }
    @Published var openEditTask: Bool = false

    
    func addTask(context: NSManagedObjectContext) -> Bool{
        var task:TaskItem!

        if editTask != nil && openEditTask == true {
            task = editTask
        } else {
            task = TaskItem(context: context)
        }
      
        task.title = taskTitle
        task.color = taskColor
        task.date = taskDate
        task.type = taskType
        task.iconName = taskIcon
        task.isCompleted = false
        do {
            try context.save()
            return true
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
    
    func setDefaultValue() {
        taskType = "普通"
        taskColor = "Grey"
        taskTitle = ""
        taskDate = Date()
        taskIcon = "learn_7"
        openEditTask = false
        
        editTask = nil
    }
    
    
    
    
    // MARK: - NOTIFICATION
    @Published private(set) var notifications: [UNNotificationRequest] = []
    @Published private(set) var authorizationStatus: UNAuthorizationStatus?
    
    func reloadAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { isGranted, _ in
            DispatchQueue.main.async {
                self.authorizationStatus = isGranted ? .authorized : .denied
            }
        }
    }
    
    func reloadLocalNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            DispatchQueue.main.async {
                self.notifications = notifications
            }
        }
    }
    
    func createLocalNotification(title: String,day:Int, hour: Int, minute: Int, completion: @escaping (Error?) -> Void) {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.day = day
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "To Do Task"
        notificationContent.sound = .default
        notificationContent.body = title
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: completion)
    }
    
    func deleteLocalNotifications(identifiers: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
}
