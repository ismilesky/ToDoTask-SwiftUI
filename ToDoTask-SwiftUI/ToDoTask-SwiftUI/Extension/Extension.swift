//
//  Extension.swift
//  ToDoTask-SwiftUI
//
//  Created by edy on 2023/7/11.
//

import Foundation
import SwiftUI

struct CustomShape: Shape {
    var corners: UIRectCorner
    var size: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: size, height: size))
        return Path(path.cgPath)
    }
}


extension DateFormatter {
    static let chartDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        
        return formatter
    }()
    
    static func customDateFormatter(_ format: String = "yyyy年MM月dd日 HH:mm") -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = format
        
        return formatter
    }
    
}


extension Color {
    static func hextoRGB(colors: [String], alpha: CGFloat = 1.0) -> [Color] {
        var colors1: [Color] = []
        
        for color in colors {
            // removing hash #
            var trimmed = color.trimmingCharacters(in: .whitespaces).uppercased()
            
            trimmed.remove(at: trimmed.startIndex)
            
            var hexValue: UInt64 = 0
            Scanner(string: trimmed).scanHexInt64(&hexValue)
            
            let r = CGFloat((hexValue & 0x00FF0000) >> 16) / 255
            let g = CGFloat((hexValue & 0x0000FF00) >> 8) / 255
            let b = CGFloat(hexValue & 0x000000FF) / 255
            
            colors1.append(Color(UIColor(red: r, green: g, blue: b, alpha: alpha)))
        }
        
        return colors1
    }
}

