//
//  CoreDataManager.swift
//  PecodeNewsApp
//
//  Created by Саша Василенко on 30.11.2022.
//

import CoreData

protocol CoreDataManagerProtocol: AnyObject {
    func save(article: MainScreenModel)
    func getSavedNews() -> [SavedNewsModel]?
}

class CoreDataManager: CoreDataManagerProtocol {
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PecodeNewsApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var viewContext: NSManagedObjectContext = Self.persistentContainer.viewContext
    
    func save(article: MainScreenModel) {
        let context = Self.persistentContainer.viewContext
        let entity = SavedNewsModel(context: context)
        entity.articleDescription = article.description
        entity.author = article.author
        entity.content = article.content
        entity.publishedAt = article.publishedAt
        entity.title = article.title
        entity.url = article.url
        entity.urlToImage = article.urlToImage
        entity.source?.name = article.source.name
        entity.source?.id = article.source.id
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror)")
            }
        }
    }
    
    func getSavedNews() -> [SavedNewsModel]? {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedNewsModel")
        fetch.returnsObjectsAsFaults = false
        if let data = try? viewContext.fetch(fetch) as? [SavedNewsModel], !data.isEmpty {
            return data
        }
        let entity = SavedNewsModel(context: viewContext)
        return [entity]
    }
}
