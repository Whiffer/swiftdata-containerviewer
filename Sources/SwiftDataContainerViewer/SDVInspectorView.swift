//
//  SDVInspectorView.swift
//  SwiftDataTest
//
//  Created by Chuck Hartman on 8/31/23.
//

import SwiftUI
import CoreData

struct SDVInspectorView: View {
    
    @EnvironmentObject private var viewModel: SDVViewModel

    var body: some View {
        
        NavigationStack(path: self.$viewModel.toOneObjectPath) {
            EmptyView()
                .navigationDestination(for: NSManagedObject.self) { managedObject in
                    SDVObjectView(managedObject: managedObject)
                        .navigationBarBackButtonHidden(true)
                        .toolbar {
                            if self.viewModel.inspectorPresented {
                                ToolbarItem(placement: .primaryAction) {
                                    Button(action: { self.viewModel.backwardToOneObject() },
                                           label: { SwiftUI.Image(systemName: "chevron.backward") } )
                                    .disabled(self.viewModel.backwardToOneDisabled)
                                }
                                ToolbarItem(placement: .primaryAction) {
                                    Button(action: { self.viewModel.forwardToOneObject() },
                                           label: { SwiftUI.Image(systemName: "chevron.forward") } )
                                    .disabled(self.viewModel.forwardToOneDisabled)
                                }
                                ToolbarItem(placement: .primaryAction) {
                                    Text(managedObject.entityName)
                                }
                            }
                        }
                }
        }
    }
}

#Preview {
    SDVInspectorView()
}
