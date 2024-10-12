//
//  SDVObjectsView.swift
//  SwiftDataTest
//
//  Created by Chuck Hartman on 8/29/23.
//

import SwiftUI
import CoreData

struct SDVObjectsView: View {
    
    let tableObjects: ToManyObjects
    
    @State private var attributes = [NSAttributeDescription]()
    @State private var relationships = [NSRelationshipDescription]()
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true) {
            ScrollView(.horizontal, showsIndicators: true) {
                Grid(alignment: .topLeading, horizontalSpacing: 10.0) {
                    GridRow {
                        ForEach(attributes, id: \.self) { attribute in
                            Text("\(attribute.name)")
                                .gridColumnAlignment(attribute.viewAlignment)
                                .foregroundStyle(Color.headerTextColor)
                        }
                        ForEach(self.relationships, id: \.self) { relationship in
                            Text("\(relationship.name)")
                                .gridColumnAlignment(.trailing)
                                .foregroundStyle(Color.headerTextColor)
                        }
                    }
                    .font(.title3)
                    GridRow {
                        ForEach(attributes, id: \.self) { attribute in
                            Text("\(attribute.attributeValueClassName ?? "nil")")
                                .gridColumnAlignment(attribute.viewAlignment)
                                .foregroundStyle(Color.secondaryLabelColor)
                        }
                        ForEach(relationships, id: \.self) { relationship in
                            Text(relationship.description)
                                .gridColumnAlignment(.trailing)
                                .foregroundStyle(Color.secondaryLabelColor)
                        }
                    }
                    .font(.footnote)
                    Divider()
                        .gridCellUnsizedAxes(.horizontal)
                    ForEach(tableObjects.managedObjects, id: \.self) { managedObject in
                        GridRow {
                            ForEach(attributes, id: \.self) { attribute in
                                SDVAttributeView(managedObject: managedObject, attribute: attribute)
                                    .gridColumnAlignment(attribute.viewAlignment)
                            }
                            ForEach(relationships, id: \.self) { relationship in
                                SDVRelationshipView(managedObject: managedObject, relationship: relationship)
                                    .gridColumnAlignment(.trailing)
                            }
                        }
                        .font(.footnote)
                        Divider()
                            .gridCellUnsizedAxes(.horizontal)
                    }
                    
                }
                .padding()
            }
        }
        .onAppear(perform: onAppear )
        
    }
    
    private func onAppear() {
        if let managedObject = tableObjects.managedObjects.first {
            self.attributes = Array(managedObject.entity.attributesByName.values).sorted { $0.name < $1.name }
            self.relationships = Array(managedObject.entity.relationshipsByName.values).sorted { $0.name < $1.name }
        }
    }
    
}

#Preview {
    SDVObjectsView(tableObjects: ToManyObjects("", [NSManagedObject]()))
}
