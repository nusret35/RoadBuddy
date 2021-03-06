//
//  DateTimePicker.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 4.10.2021.
//

import UIKit

class DateTimePicker: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
  
    var didSelectDates: ((_ day: Date,_ start: Date) -> Void)?
  
  private lazy var pickerView: UIPickerView = {
    let pickerView = UIPickerView()
    pickerView.delegate = self
    pickerView.dataSource = self
    return pickerView
  }()
  
  private var days = [Date]()
  private var startTimes = [Date]()
  
  let dayFormatter = DateFormatter()
  let timeFormatter = DateFormatter()
  
  var inputView: UIView {
    return pickerView
  }
  
  func setup() {
    dayFormatter.dateFormat = "EEEE, MMM d, yyyy"
      timeFormatter.timeStyle = .short
    days = setDays()
    startTimes = setStartTimes()
  }
  
  // MARK: - UIPickerViewDelegate & DateSource
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 2
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    switch component {
    case 0:
      return days.count
    case 1:
      return startTimes.count
    default:
      return 0
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    var label: UILabel
    
    if let view = view as? UILabel {
      label = view
    } else {
      label = UILabel()
    }
    
    label.textColor = .black
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 15)
    
    var text = ""
    
    switch component {
    case 0:
      text = getDayString(from: days[row])
    case 1:
      text = getTimeString(from: startTimes[row])
    default:
      break
    }
    
    label.text = text
    
    return label
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    let dayIndex = pickerView.selectedRow(inComponent: 0)
    let startTimeIndex = pickerView.selectedRow(inComponent: 1)
    
    guard days.indices.contains(dayIndex),
            startTimes.indices.contains(startTimeIndex) else { return }

    let day = days[dayIndex]
    let startTime = startTimes[startTimeIndex]
    
    didSelectDates?(day,startTime)
  }
  
  // MARK: - Private helpers
  
  private func getDays(of date: Date) -> [Date] {
    var dates = [Date]()
    
    let calendar = Calendar.current
    
    // first date
    var currentDate = date
    
    // adding 30 days to current date
    let oneMonthFromNow = calendar.date(byAdding: .day, value: 30, to: currentDate)
    
    // last date
    let endDate = oneMonthFromNow
    
    while currentDate <= endDate! {
      dates.append(currentDate)
      currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
    }
    
    return dates
  }
  
  private func getTimes(of date: Date) -> [Date] {
    var times = [Date]()
    var currentDate = date
    
    currentDate = Calendar.current.date(bySetting: .hour, value: 7, of: currentDate)!
    currentDate = Calendar.current.date(bySetting: .minute, value: 00, of: currentDate)!
    
    let calendar = Calendar.current
    
    let interval = 15
    var nextDiff = interval - calendar.component(.minute, from: currentDate) % interval
    var nextDate = calendar.date(byAdding: .minute, value: nextDiff, to: currentDate) ?? Date()
    
    var hour = Calendar.current.component(.hour, from: nextDate)
    
    while(hour < 23) {
      times.append(nextDate)
      
      nextDiff = interval - calendar.component(.minute, from: nextDate) % interval
      nextDate = calendar.date(byAdding: .minute, value: nextDiff, to: nextDate) ?? Date()
      
      hour = Calendar.current.component(.hour, from: nextDate)
    }
    
    return times
  }
  
  private func setDays() -> [Date] {
    let today = Date()
    return getDays(of: today)
  }
  
  private func setStartTimes() -> [Date] {
    let today = Date()
    return getTimes(of: today)
  }
  
  
  private func getDayString(from: Date) -> String {
    return dayFormatter.string(from: from)
  }
  
  private func getTimeString(from: Date) -> String {
    return timeFormatter.string(from: from)
  }
  
}

extension Date {

    static func buildTimeRangeString(dayDate: Date,startDate: Date) -> String {
    
    let dayFormatter = DateFormatter()
    dayFormatter.dateFormat = "EEEE, MMM d, yyyy"

    let startTimeFormatter = DateFormatter()
    startTimeFormatter.dateFormat = "HH:mm"
        
    
    
    return String(format: "%@ (%@)",
                  dayFormatter.string(from: dayDate),
                  startTimeFormatter.string(from: startDate))
  }
}

class myDateFormat
{
    static let dateFormatter = DateFormatter()
    
    //static let today = Date()
    
    static func stringToDate(_ from:String) -> Date
    {
        formatDate(dateFormatter)
        let date = dateFormatter.date(from: from)!
        return date
    }
    
    static func stringToMessageDate(_ from:String) -> Date
    {
        formateSeconds(dateFormatter)
        let date = dateFormatter.date(from: from)!
        return date
    }
    
    static func dateToString(_ from:Date) -> String
    {
        formatDate(dateFormatter)
        return dateFormatter.string(from: from)
    }

    
    static func formatDate(_ formatter: DateFormatter)
    {
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEEE, MMM d, yyyy '('HH:mm')'"
    }
    
    static func formateTime(_ formatter: DateFormatter)
    {
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm"
        
    }
    
    static func formateSeconds(_ formatter: DateFormatter)
    {
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEEE, MMM d, yyyy '('HH:mm:ss')'"
    }
    
    static func formateDay(_ formatter: DateFormatter)
    {
        formatter.locale = Locale(identifier: "en_US_POSIX".localized())
        formatter.dateFormat = "EEEE, MMM d, yyyy"
    }
    
    
    static func takeTimeFromStringDate(_ stringDate: String) -> String
    {
        let time = stringToDate(stringDate)
        formateTime(dateFormatter)
        let stringTime = dateFormatter.string(from:time)
        return stringTime
    }
    
    static func takeDayFromStringDate(_ stringDate: String) -> String
    {
        let day = stringToDate(stringDate)
        formateDay(dateFormatter)
        var stringDay = dateFormatter.string(from: day)
        let todayString = dateFormatter.string(from: Date())
        if stringDay == todayString
        {
            stringDay = "Today".localized()
        }
        return stringDay
    }
    
    static func returnMessageTime() -> String
    {
        formateSeconds(dateFormatter)
        let stringSeconds = dateFormatter.string(from: Date())
        return stringSeconds
    }
    
    static func dateInFormat(_ date:Date) -> Date?
    {
        formatDate(dateFormatter)
        let returnDate = dateFormatter.date(from: dateToString(date))
        return returnDate
    }
    
    static func secondsInFormat(_ date:Date) -> Date?
    {
        formateSeconds(dateFormatter)
        let returnSeconds = dateFormatter.date(from: dateToString(date))
        return returnSeconds
    }
}
