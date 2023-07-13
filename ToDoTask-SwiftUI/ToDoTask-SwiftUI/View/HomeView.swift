//
//  HomeView.swift
//  ToDoTask-SwiftUI
//
//  Created by edy on 2023/7/7.
//

import SwiftUI

struct HomeView: View {
    
    // @Environment环境变量从环境中获取托管对象上下文viewContext
    @Environment(\.managedObjectContext) private var viewContext
    
    //@FetchRequest的属性包装器，用于从持久存储中获取数据。它可以指定要检索的实体对象以及数据的排序方式，然后，CoreData框架就可以将使用@Environment环境的托管对象上下文context来获取数据。
    @FetchRequest(entity: TaskItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath:\TaskItem.date, ascending: false)], predicate: nil, animation: .easeInOut)
    private var tasks: FetchedResults<TaskItem>
    
    
    @StateObject var taskModel = TaskViewModel()
    
    @State var isShowingSheet = false
    
    @State var currentTab: String = "今天"
    
    @Environment(\.managedObjectContext) var context
    
    @Namespace var tabAnimation
    
    var body: some View {
        VStack {
            
            // 头部
            VStack {
                TopView()
                MenuBar().offset(y:-70)
            }
            .padding(.bottom, -60)
            
            // 列表
            ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        // 头视图
                        ListHeader()
                        
                        // 待办列表
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
                            FilteredTaskView(currentTab: currentTab) {
                                (task:TaskItem) in
                                TaskRowView(task: task)
                                    .contextMenu {
                                       OptMenuView(task: task)
                                    }
                            }
                            
                        }
                        .padding()
                    }
            }
        }
        .sheet(isPresented: $isShowingSheet, onDismiss: {
            taskModel.setDefaultValue()
        }) {
            AddTaskView()
                .environmentObject(taskModel)
        }
        .onAppear{
            taskModel.requestAuthorization()
        }
        .background(
            Color("bg").opacity(0.8)
        )
        .edgesIgnoringSafeArea(.all)
    }
    
    
    
    // 筛选器
    @ViewBuilder
    func MenuBar() -> some View {
        let tabs = ["今天","未来","完成"]
        HStack(spacing:15){
            ForEach(tabs,id:\.self){  tab in
                Text(tab)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.vertical,8)
                    .padding(.horizontal, 30)
                    .foregroundColor(currentTab == tab ? .black : .gray)
                    .background{
                        if currentTab == tab {
                            Capsule()
                                .fill(Color("GrassGreen").opacity(0.7))
                                .matchedGeometryEffect(id: "TAB", in: tabAnimation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation{currentTab = tab}
                    }
            }
        }
        .padding(20)
        .padding(.top, 0)
        .background(Color("cooking"))
        .cornerRadius(20)
    }
    
    
    // 待办列表头
    @ViewBuilder
    func ListHeader() -> some View {
        HStack {
            Text("待办列表")
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            Button(action: {
                isShowingSheet = true
            }) {
                Image("add")
                    .resizable()
                    .frame(width: 36, height: 36)
                
            }
        }
        .foregroundColor(.black)
        .padding(.horizontal)
    }
    
    // 任务
    @ViewBuilder
    func TaskRowView(task: TaskItem) -> some View {
        VStack(alignment:.leading, spacing: 15){
            HStack {
                Text(task.type ?? "")
                    .font(.caption2)
                    .padding(.vertical, 3)
                    .padding(.horizontal, 5)
                    .foregroundColor(Color(task.color ?? "Grey"))
                    .background {
                        RoundedRectangle(cornerRadius: 5,style: .continuous)
                            .fill(.white.opacity(0.8))
                    }
                if task.isCompleted {
                    Text("归档")
                        .font(.caption2)
                        .padding(.vertical, 3)
                        .padding(.horizontal, 5)
                        .foregroundColor(Color(task.color ?? "Grey"))
                        .background {
                            RoundedRectangle(cornerRadius: 5,style: .continuous)
                                .fill(.white.opacity(0.8))
                        }
                }
                
                Spacer()
                
                Image(task.iconName ?? "fun_2")
                    .resizable()
                    .frame(width: 36, height: 36)
                
            }
            .padding(.top, -10)
            
            Text(task.title ?? "")
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(3)
                .padding(.top, -10)
            
                .strikethrough(task.isCompleted, pattern: .solid, color: Color(task.color ?? "Grey"))
            
            HStack(alignment:.bottom,spacing: 0) {
                VStack(alignment:.leading,spacing: 10){
                    Label{
                        Text(task.date ?? Date(), formatter: DateFormatter.customDateFormatter("yyyy.MM.dd HH:mm"))
                        
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    .font(.caption)
                }
                .frame(maxWidth:.infinity,alignment: .leading)
                
                Spacer()
                
                if task.isCompleted {
                    
                    Image("mark")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            }
        }
        
        .padding([.leading,.trailing],12)
        .padding([.top,.bottom],15)
        
        .frame(maxWidth:.infinity)
        .background{
            RoundedRectangle(cornerRadius: 12,style: .continuous)
                .fill(Color(task.color ?? "Grey"))
        }
    }
    
    
    // 长按操作
    @ViewBuilder
    func OptMenuView(task: TaskItem) -> some View {
        Button(action: {
            taskModel.openEditTask = true
            if taskModel.openEditTask{
                taskModel.editTask = task
                isShowingSheet = true
            }
        }) {
            Text("编辑")
            Image(systemName: "square.and.pencil")
        }
        Button(action: {
            context.delete(task)
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }) {
            Text("删除")
            Image(systemName: "trash")
        }
        
        Button(action: {
            task.isCompleted.toggle()
            try? context.save()
        }) {
            Text("标记完成")
            Image(systemName: "checkmark.icloud")
        }
    }
    
}

// 头部
struct TopView: View {
    var body: some View {
        VStack(spacing: 0){
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Hello Self-discipline")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("每日一事")
                }
                .padding()
                .padding(.top, 45)
                .foregroundColor(.black)

                Spacer()

                Image("avatar")
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 50, height: 50)
                    .padding()
                    .padding(.top, 45)
            }
            .background(Color("GrassGreen"))

            Image("top_pic")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .background(Color("GrassGreen"))
                .clipShape(CustomShape(corners: [.bottomLeft, .bottomRight], size: 65))
        }

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}





