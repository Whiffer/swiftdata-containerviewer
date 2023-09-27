//
//  SDVRelationshipView.swift
//  SwiftDataTest
//
//  Created by Chuck Hartman on 8/31/23.
//

import SwiftUI
import CoreData

struct SDVRelationshipView: View {
    
    let managedObject: NSManagedObject
    let relationship: NSRelationshipDescription
    
    @EnvironmentObject private var viewModel: SDVViewModel

    var body: some View {
        
        if self.countInRelationship > 0 {
            Button(action: self.navigate , label: {
                HStack {
                    Spacer()
                    Text("\(self.countInRelationship)")
                    SwiftUI.Image(systemName: self.countInRelationship > 1 ? "ellipsis.circle" : "info.circle")
                }
            } )
            .buttonStyle(.plain)
            .foregroundStyle(Color.linkColor)
        } else {
            // Empty Grid cell
            Text("")
        }
    }
    
    private var countInRelationship: Int {
        return self.managedObject.count(in: self.relationship)
    }
    
    private func navigate() {
        if relationship.isToMany {
            if let objects = relationship.toManyObjects(for: managedObject) {
                let navigationTitle = "\(self.managedObject.entityName).\(relationship.name) ->  \(relationship.targetName)(\(self.countInRelationship))"
                let objects = Array(objects)
                self.viewModel.pushToManyObjects(navigationTitle: navigationTitle, objects: objects)
            }
        } else {
            if let object = relationship.toOneObject(for: managedObject) {
                self.viewModel.pushToOneObject(object: object)
            }
        }
    }
    
}

#Preview {
    SDVRelationshipView(managedObject: NSManagedObject(), relationship: NSRelationshipDescription())
}
