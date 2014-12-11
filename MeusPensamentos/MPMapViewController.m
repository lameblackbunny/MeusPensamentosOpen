//
//  MPMapViewController.m
//  MeusPensamentos
//
//  Created by Lame Black Bunny on 27/05/14.
//  Copyright (c) 2014 Lame Black Bunny. All rights reserved.
//

#import "MPMapViewController.h"

@interface MPMapViewController ()

@end

@implementation MPMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MPAppDelegate *appDelegate = (MPAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.mapView removeAnnotations:self.mapView.annotations];
        
    [self addAnnotations];
    [self zoomToRegion];
}

-(void) addAnnotations  {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MeuPensamento" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    // sorting results using the timeStamp (the newer on the top)
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];

    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Error returning images in the map.");
    }

    // adding map annotations according to image results returned
    for (MeuPensamento *pensamento in fetchedObjects) {
        if ([pensamento.latitude doubleValue] != 0 && [pensamento.longitude doubleValue] != 0) {
            MapAnnotation *pointAnnotation = [[MapAnnotation alloc] init];
            
            CLLocationCoordinate2D coord = {[pensamento.latitude doubleValue] , [pensamento.longitude doubleValue]};
            pointAnnotation.coordinate = coord;
            pointAnnotation.title = pensamento.text;
            pointAnnotation.subtitle = [pensamento.timeStamp description];
            pointAnnotation.pensamento = pensamento;

            [self.mapView addAnnotation:pointAnnotation];
        }
    }
}

- (void) zoomToRegion {
    // http://stackoverflow.com/questions/5040175/iphone-mkmapview-set-map-region-to-show-all-pins-on-map
    
    NSArray *annotationArray = [self.mapView annotations];
    
    if ([annotationArray count] > 0) {
        //calculate new region to show on map
        MKPointAnnotation *firstMember = [annotationArray objectAtIndex:0];
        double max_long = firstMember.coordinate.longitude;
        double min_long = firstMember.coordinate.longitude;
        double max_lat = firstMember.coordinate.latitude;
        double min_lat = firstMember.coordinate.latitude;
        
        //find min and max values
        for (MKPointAnnotation *annotation in annotationArray) {
            if (annotation.coordinate.latitude > max_lat) {max_lat = annotation.coordinate.latitude;}
            if (annotation.coordinate.latitude < min_lat) {min_lat = annotation.coordinate.latitude;}
            if (annotation.coordinate.longitude > max_long) {max_long = annotation.coordinate.longitude;}
            if (annotation.coordinate.longitude < min_long) {min_long = annotation.coordinate.longitude;}
        }
        
        //calculate center of map
        double center_long = (max_long + min_long) / 2;
        double center_lat = (max_lat + min_lat) / 2;
        
        //calculate deltas
        double deltaLat = abs(max_lat - min_lat);
        double deltaLong = abs(max_long - min_long);
        
        //set minimal delta
        if (deltaLat < 5) {deltaLat = 0.05;}
        if (deltaLong < 5) {deltaLong = 0.05;}
        
        //create new region and set map
        CLLocationCoordinate2D coord = {center_lat, center_long};
        MKCoordinateSpan span = MKCoordinateSpanMake(deltaLat + deltaLat * 0.1, deltaLong + deltaLong * 0.1);
        MKCoordinateRegion region = {coord, span};
        [self.mapView setRegion:region];
    } else {
        //create new region and set map
        CLLocationCoordinate2D coord = {-23.5484 , -46.6329};
        MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
        MKCoordinateRegion region = {coord, span};
        [self.mapView setRegion:region];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showDetailFromMap"]) {
        MKAnnotationView *annotationView = (MKAnnotationView *)sender;
        MapAnnotation *pensamentoAnnotation = (MapAnnotation *)annotationView.annotation;
        MeuPensamento *pensamento = pensamentoAnnotation.pensamento;
        [[segue destinationViewController] setDetailItem:pensamento];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // If you are showing the users location on the map you don't want to change it
    MKAnnotationView *view = nil;
    if (annotation != mapView.userLocation) {
        // This is not the users location indicator (the blue dot)
        view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"myAnnotationIdentifier"];
        
        // Creating a new annotation view, in this case it still looks like a pin
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotationIdentifier"];
        view.canShowCallout = YES; // So that the callout can appear
        
        MapAnnotation *mapAnnotation = (MapAnnotation *)annotation;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:mapAnnotation.pensamento.image.thumbnail]];
        myImageView.frame = CGRectMake(0,0,32,32); // Change the size of the image to fit the callout
        
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [infoButton setTintColor:[UIColor grayColor]];
        view.rightCalloutAccessoryView = infoButton;
        
        // Change this to rightCallout... to move the image to the right side
        view.leftCalloutAccessoryView = myImageView;
    }
    return view;
}

// touching an annotation takes the user to the detail view of that image
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    // Go to detail view
    [self performSegueWithIdentifier:@"showDetailFromMap" sender:view];
}

@end
