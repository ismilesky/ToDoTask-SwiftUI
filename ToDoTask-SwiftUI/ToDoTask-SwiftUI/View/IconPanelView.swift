//
//  IconPanelView.swift
//  ToDoTask-SwiftUI
//
//  Created by edy on 2023/7/7.
//

import SwiftUI

struct IconPanelView: View {
    
    var selectIconClosure: (String)-> Void
    
    @StateObject var iconData: IconViewModel = IconViewModel()


    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(iconData.datas, id: \.groupName) { gData in
                GroupView(items: gData.icons, title: gData.groupName, selectIconClosure: selectIconClosure)
            }
        }
    }
}

struct GroupView: View {
    var items: [IconItem]
    var title: String
    var selectIconClosure: (String)-> Void
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(10)
            
            LazyVGrid(columns:
                        Array(repeating: GridItem(.flexible(), spacing: 20), count: 4)
                      , spacing: 20) {
                ForEach(items, id: \.self) { item in
                    Image(item.name)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 55, height: 55)
                        .onTapGesture {
                            selectIconClosure(item.name)
                            presentationMode.wrappedValue.dismiss()
                        }
                }
            }
        }
        .padding()
    }
}

struct IconPanelView_Previews: PreviewProvider {
    static var previews: some View {
        IconPanelView { icon in
            
        }
    }
}
