# SwiftDataContainerViewer

This package is a general purpose interractive development tool for viewing the contents of a SwiftData Container.

## Verion History

2023-09-27 v1.0.0 Initial Package Release

## Why use SwiftDataContainerViewer?

Adding a `SwiftDataContainerViewer` Scene to your App can give you an easy way to browse a live SwiftData Container after you have completed some of your data model code, but may not have completed enough of your UI code to confirm that your data model code is correct.  It may also be useful at incremental stages during development to avoid the need to create temporary XCTest cases.

## Usage Notes

- The SideBar View displays a list of all SwiftData Entities (PersistentModel Types) and a count of how many records are currently in each.

- Tapping on one of the Entity names will display a table in the Detail View with a row for each record and a column for each of the attributes and relationships that are defined for that Entity.

- The Detail View header row shows the name of each attribute and relationship for the Entity being displayed.  The attribute's data type is shown below the attribute name. The name of the entity targeted by a relationship is shown below the relationship name.  "ToOne" relationships show only the targeted entity name.  "ToMany" relationships will show the targeted entity name in square brackets.

- For Attribute columns, the table cells show the value of the attribute displayed appropriately according to its data type.  If the attribute's value is nil, the table cell is blank.

- For Relationship columns, the table cell values are displayed as clickable links according to the type of the relationship and the count of records related to that record.  If a relationship has no records related to it, the table cell is blank.

- If a "ToOne" relationship has a related record or if a "ToMany" relationship has only one record related to it, the link will show a count of one and an "info.circle" icon. Tapping the link will open the Inspector View to show the each of the attribute and relationship values for the record targeted by the relationship.

- If a "ToMany" relationship has more than one record related to it, the link will show the count of records related to it and the "ellipsis.circle" icon.  Tapping the link will display a table in the Detail View with a row for each of the related records.

- The Detail View and the Inspector View each have backward and forward navigation buttons.

- This package works best with macOS on a Mac.  

- It works fairly well with iPadOS on an iPad. 

- It may not be as useful using iOS on an iPhone due to the smaller screen size. The overall usefulness will depend on your SwiftData PersistentModel Types and how many attributes and relationsbips there are per Type.

## Steps to add SwiftDataContainerViewer to an existing SwiftData Project

- There are several ways this package could be integrated into an existing SwiftData based preoject.  One approach is available as a completed sample project at:  https://github.com/Whiffer/SampleSwiftDataViewer 

- Add a Package Dependancy to your Project for: https://github.com/Whiffer/swiftdata-containerviewer

- Add a Library to your project's Target for: SwiftDataContainerViewer

- In your App struct, add an import for the SwiftDataContainerViewer module, and create a static let for an array of all of your PersistentModel Types:
```swift
import SwiftDataContainerViewer
// ...
    static let modelTypes = [
        Item.self,
    ] as [any PersistentModel.Type]
```

Use that static let to create your Schema in your App's sharedModelContainer property:
```swift
        let schema = Schema(modelTypes)
```

Add a new WindowGroup to your App's Scene giving it the same sharedModelContainer and passing the same modelTypes array to the initializer for the SwiftDataContainerViewer:
```swift
        WindowGroup(id: "swiftdata-viewer") {
            SwiftDataContainerViewer(modelTypes: [your-App-struct-name].modelTypes)
        }
        .modelContainer(sharedModelContainer)
```

Add a Toolbar button (or whatever works for you) to open the SwiftDataContainerViewer's Window:
```swift
    @Environment(\.openWindow) private var openWindow
    // ...
    .toolbar {
        ToolbarItem(placement: .automatic) {
            Button(action: { self.openWindow(id: "swiftdata-viewer") }) {
                Label("SwiftData Viewer", systemImage: "tablecells.badge.ellipsis")
                    .help("SwiftData Viewer")
                }
            }
    }
```

## Possible Enhancements

- Create a general purpose API for use with XCTest

## Known Issues

One issue that has been observed on an iPad is with the NavigationStack in the .inspector as part of the NavigationSplitView. On an iPad, when selecting the first "ToOne" relationship link, the inspector will open, but nothing is displayed. Tapping the same link a second time will show the correct data.  This issue appears to be documented in the Release Notes for the iPadOS 17 Release Candidate.
