//
//  Task.swift
//  TodoAppRx
//
//  Created by Omar Khaled on 17/07/2022.
//

import Foundation

struct Task {
    let title:String
    let priority:Priority
}

enum Priority:Int{
    case high
    case medium
    case low
}
