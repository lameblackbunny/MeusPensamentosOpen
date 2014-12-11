//
//  MPMasterViewController.h
//  MeusPensamentos
//
//  Created by Lame Black Bunny on 21/05/14.
//  Copyright (c) 2014 Lame Black Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

#import "MPAppDelegate.h"
#import "MeuPensamento.h"
#import "PensamentoImage.h"
#import "MPCustomTableViewCell.h"
#import "MPAddViewController.h"

@interface MPMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, MPAddViewControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
