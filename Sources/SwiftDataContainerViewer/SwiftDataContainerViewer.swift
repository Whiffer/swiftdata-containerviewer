//
//  SwiftDataViewer.swift
//  SwiftDataTest
//
//  Created by Chuck Hartman on 8/26/23.
//

import SwiftUI
import SwiftData

@available(iOS 17, macOS 14.0, *)
public struct SwiftDataContainerViewer: View {
    
    // SwiftData's Schema (all Persistent Model Types)
    public let modelTypes: [any PersistentModel.Type]
    
    public init(modelTypes: [any PersistentModel.Type]) {
        self.modelTypes = modelTypes
    }
    
    @State private var viewModel = SDVViewModel()
    @Environment(\.modelContext) private var modelContext   // SwiftData's Model Context

    public var body: some View {
        
        NavigationSplitView {
            SDVSidebarView()
        }  detail: {
            SDVDetailView()
        }
        .inspector(isPresented: $viewModel.inspectorPresented) {
            SDVInspectorView()
                .inspectorColumnWidth(min: 350, ideal: 450, max: 700)
        }
        .id(viewModel.refreshID)
        .environment(viewModel)
        .environment(\.managedObjectContext, viewModel.setModel(modelContext: modelContext,
                                                                modelTypes: modelTypes))
    }
    
}

#Preview {
    SwiftDataContainerViewer(modelTypes: [any PersistentModel.Type]())
}
