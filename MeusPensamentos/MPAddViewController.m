//
//  MPAddViewController.m
//  MeusPensamentos
//
//  Created by Lame Black Bunny on 26/05/14.
//  Copyright (c) 2014 Lame Black Bunny. All rights reserved.
//

#import "MPAddViewController.h"

#define kSOURCE_CAMERA 0
#define kSOURCE_LIBRARY 1

@interface MPAddViewController ()

@end

@implementation MPAddViewController
{
    UIActivityIndicatorView *activityView;
    UIView *blackView;
}

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
    
    self.textFieldPensamento.delegate = self;
    self.textFieldPensamento.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    
    [self configureView];
    
    if (self.velhoPensamento != nil)
    {
        self.navigationItem.title = @"Editar";
        self.imageViewPensamento.image = [self loadImageWithName:self.velhoPensamento.image.name];
        self.textFieldPensamento.text = self.velhoPensamento.text;
        [self.buttonAdicionaPensamento setTitle:@"Salvar" forState:UIControlStateNormal];
    }
    
    self.textFieldPensamento.tintColor = kCOLOR_ORANGE;
}


- (void)configureView
{
    self.buttonAdicionaPensamento.titleLabel.font = [UIFont fontWithName:@"Baron Neue" size:20];
    self.buttonAdicionaPensamento.titleLabel.textAlignment = NSTextAlignmentCenter;

    self.view.backgroundColor = kCOLOR_YELLOW;
}

-(void) viewWillAppear:(BOOL)animated {
    // needed to store GPS location for "Map" tab item
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

-(void) viewWillDisappear:(BOOL)animated {
    [locationManager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    userLocation = [locations lastObject];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonAdicionaPressed:(id)sender {
    [self.textFieldPensamento resignFirstResponder];
    
    MeuPensamento *meuPensamento;
    
    if (self.velhoPensamento != nil)
        meuPensamento = self.velhoPensamento;
    else
    {
        meuPensamento = [NSEntityDescription insertNewObjectForEntityForName:@"MeuPensamento" inManagedObjectContext:self.managedObjectContext];

        meuPensamento.latitude = [NSNumber numberWithDouble:userLocation.coordinate.latitude];
        meuPensamento.longitude = [NSNumber numberWithDouble:userLocation.coordinate.longitude];

        meuPensamento.timeStamp = [NSDate date];
        
        meuPensamento.image = [NSEntityDescription insertNewObjectForEntityForName:@"PensamentoImage" inManagedObjectContext:self.managedObjectContext];
    }
    
    NSString *textPensamento = [self.textFieldPensamento.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([textPensamento isEqualToString:@""]) {
        meuPensamento.text = nil;
    } else {
        meuPensamento.text = textPensamento;
    }
    
    NSDateComponents *componentsActualDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSWeekdayCalendarUnit | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:meuPensamento.timeStamp];
    
    int year = (int)[componentsActualDate year];
    int month = (int)[componentsActualDate month];
    int day = (int)[componentsActualDate day];
    int hour = (int)[componentsActualDate hour];
    int minute = (int)[componentsActualDate minute];
    int second = (int)[componentsActualDate second];
    
    NSString *imageName = [NSString stringWithFormat:@"%d%02d%02d_%02d_%02d_%02d.png",
                           year,
                           month,
                           day,
                           hour,
                           minute,
                           second];
    
    // save image to the filesystem and return the name to be added on the database (NSString)
    [self saveImage:self.imageViewPensamento.image withName:imageName];
    meuPensamento.image.name = imageName;
    
    NSData *imageData = UIImagePNGRepresentation(self.imageViewPensamento.image);
    
    CGSize finalsize = CGSizeMake(32,32);
    UIGraphicsBeginImageContextWithOptions(finalsize, NO, 0);
    [[UIImage imageWithData:imageData] drawInRect:CGRectMake(0, 0, finalsize.width, finalsize.height)];
    UIImage *imageThumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    meuPensamento.image.thumbnail = UIImagePNGRepresentation(imageThumbnail);
    
    meuPensamento.image.cell = UIImagePNGRepresentation([self generateCellBackGroundWithImage:self.imageViewPensamento.image]);
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        
        UIAlertView *alertCoreData;
        
        switch ([error code]) {
            case NSValidationMissingMandatoryPropertyError:
            {
                alertCoreData = [[UIAlertView alloc]
                                                     initWithTitle:NSLocalizedString(@"Erro ao adicionar", @"Core data save error title.")
                                                     message:NSLocalizedString(@"O campo texto e imagem não podem estar vazios. Por favor, preencha ambos.", @"Core data save error text.")
                                                     delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
                [alertCoreData show];
            }
                break;
            default:
                NSLog(@"Problema ao salvar pensamento: %@", [error localizedDescription]);
                alertCoreData = [[UIAlertView alloc]
                                 initWithTitle:NSLocalizedString(@"Erro ao adicionar", @"Core data save error title.")
                                 message:NSLocalizedString(@"Erro ao salvar. Por favor, informe o desenvolvedor.", @"Core data generic save error text.")
                                 delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
                [alertCoreData show];
                break;
        }
        [self.managedObjectContext rollback];
    } else {
        if (self.velhoPensamento == nil)
        {
            self.textFieldPensamento.text = @"";
            self.imageViewPensamento.image = nil;
            [self.delegate addedNewPensamento:self];
            [self.tabBarController setSelectedIndex:1];
        }
        else
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

// generate the cut image version used in the background of the tableview (it was slow to cut realtime)
- (UIImage *)generateCellBackGroundWithImage:(UIImage *)originalImage
{
    CGImageRef imageRef = originalImage.CGImage;
    CGImageRef imageRefTL = CGImageCreateWithImageInRect(imageRef, CGRectMake(320,576,640,88));
    UIImage *image = [UIImage imageWithCGImage:imageRefTL];
    
    return image;
}

// save image in the filesystem to avoid saving it in the database
- (void)saveImage:(UIImage*)image withName:(NSString *)name
{
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@", name]];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
}

- (UIImage*)loadImageWithName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"%@", name]];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}

- (IBAction)buttonCameraPressed:(id)sender {
    [self.textFieldPensamento resignFirstResponder];
    
    // if camera available, use camera.. if camera not available (simulator, iPod), use photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        self.actionSheetCamera = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Choose a new picture using:", @"Choose a new picture using:")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", @"SUMMARY - Cancel")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:
                                  NSLocalizedString(@"Camera", @"Camera"),
                                  NSLocalizedString(@"Photo Library", @"Photo Library"),
                                  nil];
        [self.actionSheetCamera showFromTabBar:self.tabBarController.tabBar];
    }
    else
    {
        [self takePictureFrom:kSOURCE_LIBRARY];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == kSOURCE_CAMERA || buttonIndex == kSOURCE_LIBRARY)
        [self takePictureFrom:buttonIndex];
}

// setup different image inputs (library / camera)
- (void)takePictureFrom:(NSInteger)selectedSource
{
    blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.5;
    
    activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityView.center=blackView.center;
    
    [activityView startAnimating];
    
    [self.view addSubview:blackView];
    
    [self.view addSubview:activityView];
    
    [[[[self.tabBarController tabBar]items]objectAtIndex:0] setEnabled:NO];
    [[[[self.tabBarController tabBar]items]objectAtIndex:1] setEnabled:NO];
    [[[[self.tabBarController tabBar]items]objectAtIndex:2] setEnabled:NO];
    
    if (self.imagePicker)
    {
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = YES;
        switch (selectedSource) {
            case kSOURCE_CAMERA:
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case kSOURCE_LIBRARY:
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            default:
                break;
        }
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

- (UIImagePickerController *)imagePicker {
    if (!_imagePicker)
    {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    // put the image in a square, with the black borders in case of panorama images or large images
    self.imageViewPensamento.image = [self createSquareImageFrom:chosenImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];

    [activityView removeFromSuperview];
    [blackView removeFromSuperview];
    activityView = nil;
    blackView = nil;
    
    [[[[self.tabBarController tabBar]items]objectAtIndex:0] setEnabled:YES];
    [[[[self.tabBarController tabBar]items]objectAtIndex:1] setEnabled:YES];
    [[[[self.tabBarController tabBar]items]objectAtIndex:2] setEnabled:YES];
}

// fill the surroundings of a bigger image with a black background and set it to the default size
- (UIImage *)createSquareImageFrom:(UIImage *)image
{
    // image default size (easier to treat and easier to share)
    CGRect pageRect = CGRectMake(0,0,640, 640);
    
    UIGraphicsBeginImageContextWithOptions(pageRect.size, YES, 0.0f);
    
    CGContextRef imageContext = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(imageContext, 0.0,0.0,0.0,1.0);
    
    CGContextFillRect(imageContext,pageRect);
    
    CGContextSaveGState(imageContext);
    
    int imageWidth = image.size.width;
    int imageHeight = image.size.height;
    
    CGPoint imagePoint = CGPointMake((640-imageWidth)/2, (640-imageHeight)/2);
    
    [image drawAtPoint:imagePoint];
    
    UIImage *imageSquared = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageSquared;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];

    [activityView removeFromSuperview];
    [blackView removeFromSuperview];
    activityView = nil;
    blackView = nil;

    [[[[self.tabBarController tabBar]items]objectAtIndex:0] setEnabled:YES];
    [[[[self.tabBarController tabBar]items]objectAtIndex:1] setEnabled:YES];
    [[[[self.tabBarController tabBar]items]objectAtIndex:2] setEnabled:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textFieldPensamento resignFirstResponder];
    
    [super touchesBegan:touches withEvent:event];
}


@end
