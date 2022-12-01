//
//  SavedSourcesModel+CoreDataProperties.swift
//  PecodeNewsApp
//
//  Created by Саша Василенко on 01.12.2022.
//
//

import Foundation
import CoreData


extension SavedSourcesModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedSourcesModel> {
        return NSFetchRequest<SavedSourcesModel>(entityName: "SavedSourcesModel")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?

}

extension SavedSourcesModel : Identifiable {

}
