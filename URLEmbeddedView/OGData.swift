//
//  OGData.swift
//  Pods
//
//  Created by 鈴木大貴 on 2016/03/11.
//
//

import Foundation
import CoreData

public final class OGData: NSManagedObject {
    private enum PropertyName: String {
        case Description = "og:description"
        case Image       = "og:image"
        case SiteName    = "og:site_name"
        case Title       = "og:title"
        case Type        = "og:type"
        case Url         = "og:url"
    }
    
    private lazy var URL: NSURL? = {
        return NSURL(string: self.sourceUrl)
    }()

    class func fetchOrInsertOGData(url url: String) -> OGData {
        let managedObjectContext = OGDataCacheManager.sharedInstance.mainManagedObjectContext
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("OGData", inManagedObjectContext: managedObjectContext)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "sourceUrl = %@", url)
        guard let fetchedList = (try? managedObjectContext.executeFetchRequest(fetchRequest)) as? [OGData], ogData = fetchedList.first else {
            let newOGData = NSEntityDescription.insertNewObjectForEntityForName("OGData", inManagedObjectContext: managedObjectContext) as! OGData
            let date = NSDate()
            newOGData.createDate = date
            newOGData.updateDate = date
            return newOGData
        }
        return ogData
    }
    
    func setValue(property property: String, content: String) {
        guard let propertyName = PropertyName(rawValue: property) else { return }
        switch propertyName  {
        case .SiteName    : siteName        = content
        case .Type        : pageType        = content
        case .Title       : pageTitle       = content
        case .Image       : imageUrl        = content
        case .Url         : url             = content
        case .Description : pageDescription = content
        }
    }
    
    func save() {
        updateDate = NSDate()
        OGDataCacheManager.sharedInstance.saveContext(nil)
    }
}