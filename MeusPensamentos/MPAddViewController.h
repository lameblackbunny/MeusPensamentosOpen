//
//  MPAddViewController.h
//  MeusPensamentos
//
//  Created by Lame Black Bunny on 26/05/14.
//  Copyright (c) 2014 Lame Black Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

#import "MeuPensamento.h"
#import "PensamentoImage.h"
#import "MPAppDelegate.h"

@class MPAddViewController;

@protocol MPAddViewControllerDelegate <NSObject>

-(void) addedNewPensamento:(MPAddViewController *)viewController;

@end

@interface MPAddViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate, UIActionSheetDelegate> {
    CLLocationManager *locationManager;
    CLLocation *userLocation;
}

@property (strong, nonatomic) IBOutlet UITextField *textFieldPensamento;
@property (strong, nonatomic) IBOutlet UIButton *buttonAdicionaPensamento;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewPensamento;
@property (strong, nonatomic) IBOutlet UIButton *buttonCamera;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) MeuPensamento *velhoPensamento;
@property (weak, nonatomic) id<MPAddViewControllerDelegate> delegate;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIActionSheet *actionSheetCamera;

- (IBAction)buttonAdicionaPressed:(id)sender;
- (IBAction)buttonCameraPressed:(id)sender;

@end
