//
//  Languages.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-15.
//

import Foundation


extension String
{
    func localized() -> String
    {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
    
}
