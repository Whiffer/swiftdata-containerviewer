//
//  SDVDetailView.swift
//  SwiftDataTest
//
//  Created by Chuck Hartman on 9/7/23.
//

import SwiftUI

struct SDVDetailView: View {
    
    @Environment(SDVViewModel.self) private var viewModel

    var body: some View {
        
        @Bindable var viewModel = viewModel
        
        NavigationStack(path: $viewModel.toManyObjectsPath) {
            Text("Select a SwiftData Entity")
                .navigationDestination(for: ToManyObjects.self) { tableObjects in
                    SDVObjectsView(tableObjects: tableObjects)
                        .toolbar {
                            ToolbarItem(placement: .navigation) {
                                Button(action: { viewModel.backwardToManyObjects() },
                                       label: { SwiftUI.Image(systemName: "chevron.backward") })
                                .disabled(viewModel.backwardToManyDisabled)
                            }
                            ToolbarItem(placement: .navigation) {
                                Button(action: { viewModel.forwardToManyObjects() },
                                       label: { SwiftUI.Image(systemName: "chevron.forward") })
                                .disabled(viewModel.forwardToManyDisabled)
                            }
                            ToolbarItem(placement: .primaryAction) {
                                Button(action: { viewModel.inspectorPresented.toggle() },
                                       label: { SwiftUI.Image(systemName: "info.circle") } )
                            }
                        }
                        .navigationBarBackButtonHidden(true)
                        .navigationTitle("\(viewModel.navigationTitle)")
                #if os(iOS)
                        .navigationBarTitleDisplayMode(.inline)
                #endif
                }
        }
        .toolbar { 
            ToolbarItem(placement: .primaryAction) {
                Button(action: { viewModel.inspectorPresented.toggle() },
                       label: { SwiftUI.Image(systemName: "info.circle") } )
            }
        }
    }
}

#Preview {
    SDVDetailView()
}
