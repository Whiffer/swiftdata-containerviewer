//
//  SDVExtensions.swift
//  SwiftDataTest
//
//  Created by Chuck Hartman on 9/4/23.
//

import SwiftUI
import CoreData

public extension NSEntityDescription {
    
    func allObjects(in context: NSManagedObjectContext) -> [NSManagedObject] {
        let fetch = NSFetchRequest<NSManagedObject>()
        fetch.entity = self
        if let objects = try? context.fetch(fetch) {
            return objects
        } else {
            return [NSManagedObject]()
        }
    }
    
    func count(in context: NSManagedObjectContext) -> Int {
        return self.allObjects(in: context).count
    }
    
}

public extension NSManagedObject {
    
    var entityName: String {
        if let name = self.entity.name {
            return name
        } else {
            return "** ERROR **"
        }
    }

    func count(in relationship: NSRelationshipDescription) -> Int {
        if relationship.isToMany {
            if let objects = self.value(forKey: relationship.name) as? Set<NSManagedObject> {
                return objects.count
            }
        } else {
            if let _ = self.value(forKey: relationship.name) {
                return 1
            }
        }
        return 0
    }
}

public extension NSRelationshipDescription {
    
    override var description: String {
        if let name = self.destinationEntity?.name {
            return self.isToMany ? "[\(name)]" : "\(name)"
        } else {
            return "** ERROR **"
        }
    }
    
    var targetName: String {
        if let name = self.destinationEntity?.name {
            return name
        } else {
            return "** ERROR **"
        }
    }
    
    func toManyObjects(for object: NSManagedObject) -> Set<NSManagedObject>? {
        return object.value(forKey: self.name) as? Set<NSManagedObject>
    }
    
    func toOneObject(for object: NSManagedObject) -> NSManagedObject? {
        return object.value(forKey: self.name) as? NSManagedObject
    }
    
}

public extension NSAttributeDescription {
    
    func value(for object: NSManagedObject) -> Any? {
        return object.value(forKey: self.name)
    }
    
    var valueFont: Font {
        if let attributeValueClassName = self.attributeValueClassName {
            switch attributeValueClassName {
            case "NSUUID":
                return Font.footnote.monospaced()
            default:
                return .footnote
            }
        } else {
            return .footnote
        }
    }
    
    var viewAlignment: HorizontalAlignment {
        if let attributeValueClassName = self.attributeValueClassName {
            switch attributeValueClassName {
            case "NSData":
                return .leading
            case "NSDecimalNumber":
                return .trailing
            case "NSNumber":
                return .trailing
            case "NSDate":
                return .leading
            case "NSString":
                return .leading
            case "NSUUID":
                return .leading
            default:
                return .center
            }
        } else {
            return .center
        }
    }
    
}

public extension Color {
#if canImport(UIKit)
    static let headerTextColor = Color(uiColor: .label)
    static let secondaryLabelColor = Color(uiColor: .secondaryLabel)
    static let linkColor = Color(uiColor: .link)
#endif
    
#if canImport(AppKit)
    static let headerTextColor = Color(nsColor: .headerTextColor)
    static let secondaryLabelColor = Color(nsColor: .secondaryLabelColor)
    static let linkColor = Color(nsColor: .linkColor)
#endif
}
