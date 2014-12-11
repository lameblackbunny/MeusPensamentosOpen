//
//  MPAppDelegate.h
//  MeusPensamentos
//
//  Created by Lame Black Bunny on 21/05/14.
//  Copyright (c) 2014 Lame Black Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
