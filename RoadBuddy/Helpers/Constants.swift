//
//  Constants.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 26.09.2021.
//

import UIKit

// import Foundation
struct Constants {
    
    struct Storyboard {
        
        static let HomePageViewController = "HomePageVC"
        
        static let FromWhereToViewController = "FromWhereVC"
        
        static let VC = "VC"
        
        static let ToViewController = "ToVC"
        
        static let ResultsViewController = "ResultsVC"
        
        static let DateTimeViewController = "DateTimeVC"
        
        static let PostTripViewController = "PostTripVC"
        
        static let PostTripFromViewController = "PostTripFromVC"
        
        static let PostTripToViewController = "PostTripToVC"
        
        static let PassengerPriceViewController = "PassengerPriceVC"
        
        static let PostFinalViewController = "PostFinalVC"
        
        static let PostViewController = "PostVC"
        
        static let ShareViewController = "ShareTaxiVC"
        
        static let TaxiTripSetViewController = "TaxiTripSetVC"
        
        static let STFromViewController = "STFromVC"
        
        static let STToViewController = "STToVC"
        
        static let STTimeViewController = "STTimeVC"
        
        static let ResultsNavigationController = "ResultsNC"
        
        static let BookTripViewController = "BookTripVC"
        
        static let InboxViewController = "InboxVC"
        
    }
}

class BackgroundColor
{
    struct darkMode
    {
        static let defaultBackgroundColor = color.UIColorFromRGB(rgbValue: 0x0b2f44)
        
        static let secondaryBackgroundColor = color.UIColorFromRGB(rgbValue:0x1c3b4e)
    }
    
    struct lightMode
    {
        static let defaultBackgroundColor = color.UIColorFromRGB(rgbValue: 0xf8f8f9)
    }
    
    static func setViewBackgroundColor(_ vc: UIViewController)
    {
        switch vc.traitCollection.userInterfaceStyle {
        case .dark:
            vc.view.backgroundColor = BackgroundColor.darkMode.defaultBackgroundColor
        case .light:
            vc.view.backgroundColor = BackgroundColor.lightMode.defaultBackgroundColor
        default:
            break
    }
    
}
    
    static func setTableViewBackgroundColor(_ vc: UIViewController,_ tableView: UITableView)
    {
        switch vc.traitCollection.userInterfaceStyle {
        case .dark:
            tableView.backgroundColor = BackgroundColor.darkMode.defaultBackgroundColor
        case .light:
            tableView.backgroundColor = BackgroundColor.lightMode.defaultBackgroundColor
        default:
            break
                                
        }
    }
    
    static func setTableViewCellBackgroundColor(_ view: UIView)
        {
        switch view.traitCollection.userInterfaceStyle {
        case .dark:
           view.backgroundColor = BackgroundColor.darkMode.secondaryBackgroundColor
        case .light:
            view.backgroundColor = .gray
        default:
            break
        }
    }
}

struct Buttons
{
    static var defaultBackButtonWithoutTitle:UIBarButtonItem
    {
        let backButton = UIBarButtonItem()
        backButton.tintColor = .label
        backButton.title = " "
        return backButton
    }
    
    
    static var defaultBackButton:UIBarButtonItem
    {
        let backButton = UIBarButtonItem()
        backButton.tintColor = .label
        backButton.title = "Back".localized()
        return backButton
    }
    
    static func createDefaultRightButton(_ target: Any?,_ action: Selector?) -> UIBarButtonItem
    {
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: target, action: action)
        rightButton.tintColor = .label
        return rightButton
    }
}


