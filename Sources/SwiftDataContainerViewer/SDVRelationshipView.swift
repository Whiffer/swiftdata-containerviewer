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
    
    @Environment(SDVViewModel.self) private var viewModel

    var body: some View {
        
        if self.countInRelationship > 0 {
            Button(action: navigate , label: {
                HStack {
                    Spacer()
                    Text("\(countInRelationship)")
                    SwiftUI.Image(systemName: countInRelationship > 1 ? "ellipsis.circle" : "info.circle")
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
        return managedObject.count(in: relationship)
    }
    
    private func navigate() {
        if relationship.isToMany {
            if let objects = relationship.toManyObjects(for: managedObject) {
                let navigationTitle = "\(managedObject.entityName).\(relationship.name) ->  \(relationship.targetName)(\(countInRelationship))"
                let objects = Array(objects)
                viewModel.pushToManyObjects(navigationTitle: navigationTitle, objects: objects)
            }
        } else {
            if let object = relationship.toOneObject(for: managedObject) {
                viewModel.pushToOneObject(object: object)
            }
        }
    }
    
}

#Preview {
    SDVRelationshipView(managedObject: NSManagedObject(), relationship: NSRelationshipDescription())
}
