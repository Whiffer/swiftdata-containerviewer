//
//  SwiftDataViewerDataModel.swift
//  SwiftDataTest
//
//  Created by Chuck Hartman on 9/2/23.
//

import SwiftUI
import SwiftData
import CoreData

@MainActor
class SDVViewModel : ObservableObject {
    
    @Published public var toManyObjectsPath: [ToManyObjects]
    private var toManyObjectsForwardPath: [ToManyObjects]
    
    @Published public var toOneObjectPath: [NSManagedObject]
    private var toOneObjectForwardPath: [NSManagedObject]

        @Published public var inspectorPresented: Bool
    
    init() {
        self.toManyObjectsPath = [ToManyObjects]()
        self.toManyObjectsForwardPath = [ToManyObjects]()
        
        self.toOneObjectPath = [NSManagedObject]()
        self.toOneObjectForwardPath = [NSManagedObject]()
        self.inspectorPresented = false
    }
    
    // SwiftData Model Context
    private var _modelContext: ModelContext?
    public var modelContext: ModelContext {
        get {
            guard let modelContext = _modelContext else {
                fatalError("Trying to access modelContext before being set.")
            }
            return modelContext
        }
    }
    
    // SwiftData Model Types
    private var _modelTypes: [any PersistentModel.Type]?
    private var modelTypes: [any PersistentModel.Type] {
        get {
            guard let modelTypes = _modelTypes else {
                fatalError("Trying to access modelTypes before being set.")
            }
            return modelTypes
        }
    }
    
    // Saves the SwiftData ModelContext and returns the Core Data NSManagedObjectContext
    public func setModel(modelContext: ModelContext, modelTypes: [any PersistentModel.Type]) -> NSManagedObjectContext {
        self._modelContext = modelContext
        self._modelTypes = modelTypes
    
        return self.context
    }

    // Core Data Managed Object Model
    public lazy var objectModel: NSManagedObjectModel = {
        
        guard let modelConfiguration = self.modelContext.container.configurations.first else {
            fatalError("Unable to get SwiftData model configuration.")
        }
        
        guard let schema = modelConfiguration.schema else {
            fatalError("Unable to get SwiftData's model schema.")
        }
        
        guard let coreDataModel = NSManagedObjectModel.makeManagedObjectModel(for: self.modelTypes) else {
            fatalError("Unable to access Core Data Managed Object Model.")
        }
        return coreDataModel
    }()
    
    // Core Data Managed Object Context
    public lazy var context: NSManagedObjectContext = {
        
        guard let urlApp = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last else {
            fatalError("Unable to get applicationSupportDirectory.")
        }

        let urlStore = urlApp.appendingPathComponent("default.store")
        if !FileManager.default.fileExists(atPath: urlStore.path) {
            fatalError("Unable to find SwiftData default.store file.")
        }

        let persistentContainer = NSPersistentContainer(name: "SwiftDataViewer", managedObjectModel: self.objectModel)
        
        if let persistentStoreDescription = persistentContainer.persistentStoreDescriptions.first {
            persistentStoreDescription.url = urlStore
            persistentStoreDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        }

        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error in loadPersistentStores \(error), \(error.userInfo)")
            }
        })

        let context = persistentContainer.viewContext
        return context
    }()
    
    public var navigationTitle: String{
        if let navigationTitle = self.toManyObjectsPath.last?.navigationTitle {
            return navigationTitle
        } else {
            return "SwiftData Viewer"
        }
    }
    
    // To Many Objects Stack
    
    public func pushToManyObjects(navigationTitle: String, objects: [NSManagedObject]) {
        if objects.count > 1 {
            let toManyObjects = ToManyObjects(navigationTitle, objects)
            self.toManyObjectsPath.append(toManyObjects)
            self.toManyObjectsForwardPath = [ToManyObjects]()
        } else {
            // To Many relationshiop, but only containing one object
            if let object = objects.first {
                self.pushToOneObject(object: object)
            }
        }
    }
    
    public func backwardToManyObjects() {
        let objects = self.toManyObjectsPath.removeLast()
        self.toManyObjectsForwardPath.insert(objects, at: 0)
    }
    
    public var backwardToManyDisabled: Bool {
        return self.toManyObjectsPath.isEmpty
    }
    
    public func forwardToManyObjects() {
        let objects = self.toManyObjectsForwardPath.removeFirst()
        self.toManyObjectsPath.append(objects)
    }
    
    public var forwardToManyDisabled: Bool {
        return self.toManyObjectsForwardPath.isEmpty
    }
    
    // To One Object Stack
    
    public func pushToOneObject(object: NSManagedObject) {
        self.inspectorPresented = true
        
        self.toOneObjectPath.append(object)
        self.toOneObjectForwardPath = [NSManagedObject]()
    }
    
    public func backwardToOneObject() {
        let object = self.toOneObjectPath.removeLast()
        self.toOneObjectForwardPath.insert(object, at: 0)
        
        self.inspectorPresented = self.toOneObjectPath.count > 0
    }
    
    public var backwardToOneDisabled: Bool{
        return self.toOneObjectPath.isEmpty
    }
   
    public func forwardToOneObject() {
        let object = self.toOneObjectForwardPath.removeFirst()
        self.toOneObjectPath.append(object)
    }
    
    public var forwardToOneDisabled: Bool{
        return self.toOneObjectForwardPath.isEmpty
    }
   
}

public class ToManyObjects : Hashable, ObservableObject {
    
    public static func == (lhs: ToManyObjects, rhs: ToManyObjects) -> Bool {
        lhs.managedObjects == rhs.managedObjects
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(navigationTitle)
        hasher.combine(managedObjects)
    }
    
    var navigationTitle: String
    var managedObjects: [NSManagedObject]
    
    init(_ navigationTitle: String, _ managedObjects: [NSManagedObject]) {
        self.navigationTitle = navigationTitle
        self.managedObjects = managedObjects
    }
}
