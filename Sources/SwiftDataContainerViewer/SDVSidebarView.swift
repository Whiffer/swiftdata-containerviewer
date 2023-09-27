//
//  SDVSidebarView.swift
//  SwiftDataTest
//
//  Created by Chuck Hartman on 7/31/23.
//

import SwiftUI
import SwiftData
import CoreData

@MainActor
struct SDVSidebarView: View {
    
    @EnvironmentObject private var viewModel: SDVViewModel
    
    @Environment(\.managedObjectContext) private var context   // Core Data's Context

    var body: some View {
        
        List {
            Section(header: Text("All SwiftData Entities".uppercased())) {
                ForEach(self.viewModel.objectModel.entities, id: \.self) { entity in
                    Button(action: { self.pushAllObjects(for: entity) },
                           label: { SDVSidebarEntityView(entity: entity) }
                    )
                    .buttonStyle(.plain)
                    .foregroundStyle(Color.linkColor)
                }
            }
        }
    }
    
    private func pushAllObjects(for entity: NSEntityDescription) {
        let navigationTitle = "\(entity.name ?? "** ERRROR **")(\(entity.count(in: context)))"
        let objects = entity.allObjects(in: context)
        self.viewModel.pushToManyObjects(navigationTitle: navigationTitle, objects: objects)
    }
    
}

#Preview {
    SDVSidebarView()
}
