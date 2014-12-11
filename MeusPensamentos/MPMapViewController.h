//
//  MPMapViewController.h
//  MeusPensamentos
//
//  Created by Lame Black Bunny on 27/05/14.
//  Copyright (c) 2014 Lame Black Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "MPAppDelegate.h"
#import "MeuPensamento.h"
#import "PensamentoImage.h"
#import "MapAnnotation.h"
#import "MPDetailViewController.h"

#define METERS_PER_MILE 1609.344

@interface MPMapViewController : UIViewController <MKMapViewDelegate> {
    MeuPensamento *meuPensamento;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
