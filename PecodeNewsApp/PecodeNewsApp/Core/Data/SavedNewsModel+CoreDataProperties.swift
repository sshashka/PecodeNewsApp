//
//  SavedNewsModel+CoreDataProperties.swift
//  PecodeNewsApp
//
//  Created by Саша Василенко on 01.12.2022.
//
//

import Foundation
import CoreData


extension SavedNewsModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedNewsModel> {
        return NSFetchRequest<SavedNewsModel>(entityName: "SavedNewsModel")
    }

    @NSManaged public var articleDescription: String?
    @NSManaged public var author: String?
    @NSManaged public var content: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var source: SavedSourcesModel?

}

extension SavedNewsModel : Identifiable {

}
