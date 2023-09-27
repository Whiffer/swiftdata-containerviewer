//
//  SDVAttributeView.swift
//  SwiftDataTest
//
//  Created by Chuck Hartman on 8/31/23.
//

import SwiftUI
import CoreData

struct SDVAttributeView: View {
    
    let managedObject: NSManagedObject
    let attribute: NSAttributeDescription
    
    var body: some View {
        
        Text(self.attributeValueText)
            .font(self.attribute.valueFont)
    }
    
    private var attributeValue: Any? {
        return self.managedObject.value(forKey: attribute.name)
    }
    
    private var attributeValueText: String {
        
        if let attributeValueClassName = self.attribute.attributeValueClassName {
            switch attributeValueClassName {
            case "NSData":
                if let data = self.attributeValue as? NSData {
                    return String(format: "%lu bytes", data.length)
                }
            case "NSDecimalNumber":
                if let number = self.attributeValue as? NSDecimalNumber {
                    return "\(number)"
                }
            case "NSNumber":
                if let number = self.attributeValue as? NSNumber {
                    return "\(number)"
                }
            case "NSDate":
                if let date = self.attributeValue as? NSDate {
                    return "\(date)"
                }
            case "NSString":
                if let string = self.attributeValue as? NSString {
                    let maxlen = 20
                    return "\(string.substring(to: min(string.length,maxlen))) \(string.length > maxlen ? "􀍠" : "")"
                }
            case "NSUUID":
                if let uuid = self.attributeValue as? NSUUID {
                    return "\(uuid.description)"
                }
            default:
                return attributeValueClassName
            }
        } else {
            return "** Unknown **"
        }
        return String()
    }
    
}

#Preview {
    SDVAttributeView(managedObject: NSManagedObject(), 
                                 attribute: NSAttributeDescription())
}
