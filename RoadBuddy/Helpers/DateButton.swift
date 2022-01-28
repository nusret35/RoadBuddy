//
//  DateButton.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 4.10.2021.
//
import UIKit

class DateButton: UIButton {

    var dateView = UIView()
    var toolBarView = UIView()
    
    private lazy var dateTimePicker : DateTimePicker = {
        let picker = DateTimePicker()
        picker.setup()
        picker.didSelectDates = { (dayDate,startDate) in
            let text = Date.buildTimeRangeString(dayDate: dayDate,startDate: startDate)
        }
        return picker
    }()
    
    override var inputView: UIView {

        get {
            return self.dateTimePicker.inputView

        }
        set {
            self.dateView = newValue
            self.becomeFirstResponder()
        }

    }

   override var inputAccessoryView: UIView {
         get {
            return self.toolBarView
        }
        set {
            self.toolBarView = newValue
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

}
