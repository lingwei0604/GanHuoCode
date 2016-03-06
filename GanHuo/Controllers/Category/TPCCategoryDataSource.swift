//
//  TPCCategoryDataSource.swift
//  GanHuo
//
//  Created by tripleCC on 16/3/2.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit
import CoreData

protocol TPCCategoryDataSourceDelegate: class {
    func renderCell(cell: UITableViewCell, withObject object: AnyObject)
}

class TPCCategoryDataSource: NSObject {
    var tableView: TPCTableView!
    weak var delegate: TPCCategoryDataSourceDelegate?
    var fetchedResultController: NSFetchedResultsController! {
        didSet {
            fetchedResultController.delegate = self
            do {
                try fetchedResultController.performFetch()
            } catch {
                print(error)
            }

        }
    }
    private var page = 1
    var categoryTitle: String?
    private var reuseIdentifier: String!
    init(tableView: TPCTableView, reuseIdentifier: String) {
        super.init()
        self.reuseIdentifier = reuseIdentifier
        self.tableView = tableView
    }
}

extension TPCCategoryDataSource: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let object = fetchedResultController.objectAtIndexPath(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        delegate?.renderCell(cell, withObject: object)
        print(object.url)
        return cell
    }

}

extension TPCCategoryDataSource: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
            switch type {
            case .Insert:
                if let newIndexPath = newIndexPath {
                    tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .None)
                }
            case .Delete:
                if let indexPath = indexPath {
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            case .Move:
                if newIndexPath != nil && indexPath != nil {
                    tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
                }
            case .Update:
                if let indexPath = indexPath {
                    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
        }
        
    }
}
