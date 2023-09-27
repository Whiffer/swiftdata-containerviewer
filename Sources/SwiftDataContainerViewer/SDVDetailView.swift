//
//  SDVDetailView.swift
//  SwiftDataTest
//
//  Created by Chuck Hartman on 9/7/23.
//

import SwiftUI

struct SDVDetailView: View {
    
    @EnvironmentObject private var viewModel: SDVViewModel

    var body: some View {
        
        NavigationStack(path: self.$viewModel.toManyObjectsPath) {
            Text("Select a SwiftData Entity")
                .navigationDestination(for: ToManyObjects.self) { tableObjects in
                    SDVObjectsView(tableObjects: tableObjects)
                        .toolbar {
                            ToolbarItem(placement: .navigation) {
                                Button(action: { self.viewModel.backwardToManyObjects() },
                                       label: { SwiftUI.Image(systemName: "chevron.backward") })
                                .disabled(self.viewModel.backwardToManyDisabled)
                            }
                            ToolbarItem(placement: .navigation) {
                                Button(action: { self.viewModel.forwardToManyObjects() },
                                       label: { SwiftUI.Image(systemName: "chevron.forward") })
                                .disabled(self.viewModel.forwardToManyDisabled)
                            }
                            ToolbarItem(placement: .primaryAction) {
                                Button(action: { self.viewModel.inspectorPresented.toggle() },
                                       label: { SwiftUI.Image(systemName: "info.circle") } )
                            }
                        }
                        .navigationBarBackButtonHidden(true)
                        .navigationTitle("\(self.viewModel.navigationTitle)")
                #if os(iOS)
                        .navigationBarTitleDisplayMode(.inline)
                #endif
                }
        }
        .toolbar { 
            ToolbarItem(placement: .primaryAction) {
                Button(action: { self.viewModel.inspectorPresented.toggle() },
                       label: { SwiftUI.Image(systemName: "info.circle") } )
            }
        }
    }
}

#Preview {
    SDVDetailView()
}
