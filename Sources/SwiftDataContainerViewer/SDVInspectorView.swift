//
//  SDVInspectorView.swift
//  SwiftDataTest
//
//  Created by Chuck Hartman on 8/31/23.
//

import SwiftUI
import CoreData

struct SDVInspectorView: View {
    
    @Environment(SDVViewModel.self) private var viewModel

    var body: some View {
        
        @Bindable var viewModel = viewModel
        
        NavigationStack(path: $viewModel.toOneObjectPath) {
            EmptyView()
                .navigationDestination(for: NSManagedObject.self) { managedObject in
                    SDVObjectView(managedObject: managedObject)
                        .navigationBarBackButtonHidden(true)
                        .toolbar {
                            if viewModel.inspectorPresented {
                                ToolbarItem(placement: .primaryAction) {
                                    Button(action: { viewModel.backwardToOneObject() },
                                           label: { SwiftUI.Image(systemName: "chevron.backward") } )
                                    .disabled(viewModel.backwardToOneDisabled)
                                }
                                ToolbarItem(placement: .primaryAction) {
                                    Button(action: { viewModel.forwardToOneObject() },
                                           label: { SwiftUI.Image(systemName: "chevron.forward") } )
                                    .disabled(viewModel.forwardToOneDisabled)
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
