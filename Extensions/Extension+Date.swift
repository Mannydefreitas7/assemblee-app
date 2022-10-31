//
//  Extension+Date.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/31/22.
//

import Foundation

extension Date {
  // weekday is in form 1...7
  enum WeekDay: Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
  }
  
  enum SearchDirection {
    case next
    case previous
    
    var calendarOptions: NSCalendar.Options {
      switch self {
      case .next:
        return .matchNextTime
      case .previous:
        return [.searchBackwards, .matchNextTime]
      }
    }
  }
  
  func get(direction: SearchDirection, dayName: WeekDay, considerToday consider: Bool = false) -> Date {
    
    let nextWeekDayIndex = dayName.rawValue
    let today = self
    let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
    
    if consider && calendar.component(.weekday, from: today as Date) == nextWeekDayIndex {
      return today
    }
    
    var nextDateComponent = DateComponents()
    nextDateComponent.weekday = nextWeekDayIndex
    
    let date = calendar.nextDate(after: today, matching: nextDateComponent, options: direction.calendarOptions)!
    return date
  }
  
}
