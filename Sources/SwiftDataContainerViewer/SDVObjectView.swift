//
//  SDVObjectView.swift
//  SwiftDataTest
//
//  Created by Chuck Hartman on 8/8/23.
//

import SwiftUI
import CoreData

struct SDVObjectView: View {
    
    let managedObject: NSManagedObject
    
    @State private var attributes = [NSAttributeDescription]()
    @State private var relationships = [NSRelationshipDescription]()
    
    @Environment(SDVViewModel.self) private var viewModel

    var body: some View {
        
        VStack {
            List {
                Section(header: Text("Attributes")) {
                    Grid(alignment: .topLeading, horizontalSpacing: 10.0) {
                        ForEach(attributes, id: \.self) { attribute in
                            GridRow {
                                let attributeValue = attributeValue(attribute: attribute)
                                Text("\(attributeValue.name): \(attributeValue.class)")
                                HStack {
                                    Spacer()
                                    Text("\(attributeValue.value)")
                                        .foregroundStyle(Color.secondaryLabelColor)
                                }
                                .gridColumnAlignment(.trailing)
                            }
                            .font(.footnote)
                            Divider()
                                .gridCellUnsizedAxes(.horizontal)
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                Section(header: Text("Relationships")) {
                    Grid(alignment: .topLeading, horizontalSpacing: 10.0) {
                        ForEach(relationships, id: \.self) { relationship in
                            GridRow {
                                Text("\(relationship.name)")
                                Button(action: { navigate(relationship: relationship) }, label: {
                                    HStack {
                                        Spacer()
                                        Text("\(relationshipValue(relationship: relationship))")
                                        SwiftUI.Image(systemName: self.countInRelationship(relationship: relationship) > 1 ? "ellipsis.circle" : "info.circle")
                                    }
                                } )
                                .contentShape(Rectangle())
                                .disabled(countInRelationship(relationship: relationship) < 1)
                                .buttonStyle(.plain)
                                .foregroundStyle(Color.linkColor)
                                    .gridColumnAlignment(.trailing)
                            }
                            .font(.footnote)
                            Divider()
                                .gridCellUnsizedAxes(.horizontal)
                        }
                    }
                    .listRowSeparator(.hidden)
                }
            }
        }
        .onAppear(perform: onAppear )
    }
    
    private func onAppear() {
        self.attributes = Array(managedObject.entity.attributesByName.values).sorted { $0.name < $1.name }
        self.relationships = Array(managedObject.entity.relationshipsByName.values).sorted { $0.name < $1.name }
    }
    
    private func attributeValue(attribute: NSAttributeDescription) -> (name: String, class: String, value: String) {
        
        let name = attribute.name
        
        switch attribute.attributeValueClassName {
        case "NSData":
            if let data = managedObject.value(forKey: name) as! NSData? {
                let value = String(format: "Size: %lu bytes", data.length)
                return (name: name, class: "Data", value: value)
            } else {
                return (name: name, class: "Data", value: "nil")
            }
        case "NSDecimalNumber":
            if let number = managedObject.value(forKey: name) as? NSDecimalNumber {
                return (name: name, class: "DecimalNumber", value: "\(number)")
            } else {
                return (name: name, class: "DecimalNumber", value: "nil")
            }
        case "NSNumber":
            if let number = managedObject.value(forKey: name) as? NSNumber {
                return (name: name, class: "Number", value: "\(number)")
            } else {
                return (name: name, class: "Number", value: "nil")
            }
        case "Bool":    //TODO: make this work?
            if let number = managedObject.value(forKey: name) as? Bool {
                return (name: name, class: "Bool", value: "\(number)")
            } else {
                return (name: name, class: "Bool", value: "nil")
            }
        case "NSDate":
            if let date = managedObject.value(forKey: name) as? NSDate {
                return (name: name, class: "Date", value: "\(date)")
            } else {
                return (name: name, class: "Date", value: "nil")
            }
        case "NSString":
            if let string = managedObject.value(forKey: name) as? String {
                return (name: name, class: "String", value: "\"\(string)\"")
            } else {
                return (name: name, class: "String", value: "nil")
            }
        case "NSUUID":
            if let uuid = managedObject.value(forKey: name) as? NSUUID {
                return (name: name, class: "UUID", value: uuid.uuidString)
            } else {
                return (name: name, class: "UUID", value: "nil")
            }
        default:
            if let className = attribute.attributeValueClassName {
                let value = managedObject.value(forKey: name) as Any
                return (name: name, class: className, value: "\(value)")
            } else {
                return (name: name, class: "** Unknown **", value: "** Unknown **")
            }
        }
    }
    
    private func relationshipValue(relationship: NSRelationshipDescription) -> String {
        if let name = relationship.destinationEntity?.name {
            let name = relationship.isToMany ? "[\(name)]" : "\(name)"
            return "\(name)(\(countInRelationship(relationship: relationship)))"
        } else {
            return "** Unknown **"
        }
    }
    
    private func navigate(relationship: NSRelationshipDescription) {
        if relationship.isToMany {
            if let objects = relationship.toManyObjects(for: managedObject) {
                let navigationTitle = "\(managedObject.entityName).\(relationship.name) ->  \(relationship.targetName)(\(countInRelationship(relationship: relationship)))"
                let objects = Array(objects)
                self.viewModel.pushToManyObjects(navigationTitle: navigationTitle, objects: objects)
            }
        } else {
            if let object = relationship.toOneObject(for: managedObject) {
                self.viewModel.pushToOneObject(object: object)
            }
        }
    }
    
    private func countInRelationship(relationship: NSRelationshipDescription) -> Int {
        if relationship.isToMany {
            if let objects = managedObject.value(forKey: relationship.name) as? Set<NSManagedObject> {
                return objects.count
            } else {
                return 0
            }
        } else {
            if let _ = self.managedObject.value(forKey: relationship.name) {
                return 1
            } else {
                return 0
            }
        }
    }
    
}

#Preview {
    SDVObjectView(managedObject: NSManagedObject())
}
