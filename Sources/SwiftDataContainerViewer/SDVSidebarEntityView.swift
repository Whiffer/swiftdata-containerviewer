//
//  SDVRootEntityView.swift
//  SwiftDataTest
//
//  Created by Chuck Hartman on 9/6/23.
//

import SwiftUI
import CoreData

struct SDVSidebarEntityView: View {
    
    let entity: NSEntityDescription
    
    @Environment(\.managedObjectContext) private var context   // Core Data's Context

    var body: some View {
        
        HStack {
            HStack {
                Spacer()
                Text("\(entity.count(in: context))")
            }
            .frame(width: 30.0)
            Text(" \(entity.name ?? "** ERROR **")")
            Spacer()
        }
    }
}

#Preview {
    SDVSidebarEntityView(entity: NSEntityDescription())
}
