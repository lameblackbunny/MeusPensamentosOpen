//
//  MPDetailViewController.m
//  MeusPensamentos
//
//  Created by Lame Black Bunny on 21/05/14.
//  Copyright (c) 2014 Lame Black Bunny. All rights reserved.
//

#import "MPDetailViewController.h"

@interface MPDetailViewController ()
- (void)configureView;
@end

@implementation MPDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (IBAction)editButtonPressed:(id)sender
{
    // open "add screen" already filled to edit data
    [self performSegueWithIdentifier:@"editItem" sender:self.detailItem];
}

- (IBAction)shareButtonPressed:(id)sender
{
    // create shareable image and send it to the UIActivityViewController
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObject:[self createProductImage]] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MPAddViewController *addViewController = segue.destinationViewController;
    addViewController.velhoPensamento = (MeuPensamento *)sender;
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        
        MeuPensamento *meuPensamento = self.detailItem;
        
        self.detailDescriptionLabel.text = meuPensamento.text;
        
        // get image from filesystem
        self.imageView.image = [self loadImageWithName:meuPensamento.image.name];
        
        self.detailDescriptionLabel.font = [UIFont fontWithName:@"Cardenio Modern" size:24];
        self.detailDescriptionLabel.textColor = [UIColor whiteColor];
        self.detailDescriptionLabel.shadowColor = [UIColor blackColor];
        self.detailDescriptionLabel.shadowOffset = CGSizeMake(1.0, 1.0);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        self.navigationItem.title = [dateFormatter stringFromDate:meuPensamento.timeStamp];
        [self.navigationItem.titleView sizeToFit];
    }
    
    self.view.backgroundColor = kCOLOR_YELLOW;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// render the shareable image from the view where the image is so we can mix it with the overlay
- (UIImage *)createProductImage
{
    // hide share button so it is not visible in the shared image
    self.buttonShare.hidden = YES;
    
    CGSize pageSize = self.viewPhoto.bounds.size;

    UIGraphicsBeginImageContextWithOptions(pageSize, YES, 0.0f);
    
    CGContextRef imageContext = UIGraphicsGetCurrentContext();

    [self.viewPhoto.layer renderInContext:imageContext];
    UIImage *imageToPost = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // after creating the shareable image, re-display the share button in the view
    self.buttonShare.hidden = NO;
    
    return imageToPost;
}

// load stored image from filesystem
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

@end
