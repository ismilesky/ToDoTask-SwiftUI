//
//  AddTaskView.swift
//  ToDoTask-SwiftUI
//
//  Created by edy on 2023/7/7.
//

import SwiftUI

struct AddTaskView: View {
    
    @EnvironmentObject var taskModel: TaskViewModel

    @State var isShowingSheet = false
    
    @Environment(\.managedObjectContext) var context
    
    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        
        VStack {
            VStack(alignment:.leading, spacing: 15) {
                Text(taskModel.openEditTask ? "编辑待办" : "添加待办")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
                
                // icon
                Icon()
                
                // 颜色
                ColorView()
                
                // 标题
                TitleView()
                
                // 时间
                TimeView()
                
                // type
                TypeView()
                
                // 保存
                BottomView()
            }
            .padding()
        }
        
        .background(
            Color("bg").opacity(0.8)
        )
        .sheet(isPresented: $isShowingSheet) {
            IconPanelView { icon in
                taskModel.taskIcon = icon
            }
        }
        .overlay(alignment: .bottomTrailing) {
            if taskModel.showDatePicker {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                    .onTapGesture{
                        taskModel.showDatePicker = false
                    }
                    
                DatePicker("Select a time", selection: $taskModel.taskDate, displayedComponents: [.date, .hourAndMinute])
                    .environment(\.locale, Locale(identifier: "zh_CN"))
                    .labelsHidden()
            }
        }
    }
    
    
    // 图标
    @ViewBuilder
    func Icon()-> some View {
        VStack(alignment:.leading){

            Button(action: {
                isShowingSheet.toggle()
            }) {
                Image(taskModel.taskIcon)
                            .resizable()
                            .padding(10)
            }
            .background(Color(taskModel.taskColor).opacity(0.8))
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 40))
        }
    }
    
    // 颜色
    @ViewBuilder
    func ColorView() -> some View {
        VStack(alignment:.leading){
            Text("选择颜色")
                .font(.caption)
                .foregroundColor(.gray)
           
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing:15){
                    ForEach(colors, id: \.self){ color in
                        Circle()
                            .fill(Color(color))
                            .frame(width: 25, height: 25)
                            .background{
                                if taskModel.taskColor == color {
                                    Circle()
                                        .strokeBorder(Color(color))
                                        .padding(-3)
                                }
                            }
                            .contentShape(Circle())
                            .onTapGesture {
                                taskModel.taskColor = color
                            }
                    }
                }
                .padding(.top,10)
                .padding(.bottom,10)
            }
        }
        .padding(.top,30)
        Divider()
    }
    
    // 标题
    @ViewBuilder
    func TitleView() -> some View {
        VStack(alignment: .leading,spacing: 12){
            Text("任务标题")
                .font(.caption)
                .foregroundColor(.gray)
            TextField("输入标题",text: $taskModel.taskTitle)
                .frame(maxWidth:.infinity)
                .padding()
                .padding(.leading, -15)
        }
        Divider()
    }
    
    // 类型
    @ViewBuilder
    func TypeView() -> some View {
        VStack(alignment: .leading,spacing: 12){
            Text("任务类型")
                .font(.caption)
                .foregroundColor(.gray)
            HStack(spacing:12){
                ForEach(taskTypes, id: \.self) { type in
                    Text(type)
                        .lineLimit(2)
                        .font(.callout)
                        .padding(.vertical,10)
                        .frame(maxWidth:.infinity)
                        .foregroundColor(taskModel.taskType == type ? .black : .gray)
                        .background {
                            
                          if taskModel.taskType == type {
                              Capsule().fill(Color("GrassGreen").opacity(0.7))
                          } else {
                              Capsule().strokeBorder(.gray)
                          }
 
                        }
                        .onTapGesture {
                            withAnimation{taskModel.taskType = type}
                        }
                }
            }
            .padding()
        }
        Divider()
    }
    
    // 保存
    @ViewBuilder
    func BottomView() -> some View {
        VStack(alignment: .center, spacing: 10) {
            Button {
                let dateComponents = Calendar.current.dateComponents([.day,.hour, .minute], from: taskModel.taskDate)
                guard let hour = dateComponents.hour, let minute = dateComponents.minute, let day = dateComponents.day else { return }
                taskModel.createLocalNotification(title: taskModel.taskTitle,day: day, hour: hour, minute: minute) { error in
                    print(minute)
                    if let err = error {
                        fatalError("Unresolved error " + err.localizedDescription)
                    }
                }
                
                if taskModel.addTask(context: context){
                    presentationMode.wrappedValue.dismiss()
                }
                
            } label: {
                Text("保存")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth:.infinity)
                    .background{
                        Capsule()
                            .fill(Color("cooking"))
                    }
            }
           
        }
        .frame(maxHeight:.infinity, alignment: .bottom)
        .padding(.vertical,8)
    }
    
    @ViewBuilder
    func TimeView() -> some View {
        VStack(alignment: .leading,spacing: 12){
            Text("任务时间")
                .font(.caption)
                .foregroundColor(.gray)
            HStack {

                Text(taskModel.taskDate, formatter: DateFormatter.customDateFormatter())
                    .font(.callout.weight(.semibold))
                                        
                Spacer()
                
                Button{
                    taskModel.showDatePicker.toggle()
                } label: {
                    Image(systemName: "calendar")
                        .foregroundColor(.black)
                        .font(.title2)
                }
            }
            
        }
        Divider()

    }
}


// 颜色
let colors: [String] =
["Grey","Blue","Brown","DarkGreen","LightGreen","LightPurple","Orange","Pink","Purple","Red","Turquoise","Yellow"]

// 任务类型
let taskTypes : [String] = ["普通","紧急","重要"]


struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
            .environmentObject(TaskViewModel())
    }
}
