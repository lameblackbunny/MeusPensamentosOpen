//
//  MPDetailViewController.h
//  MeusPensamentos
//
//  Created by Lame Black Bunny on 21/05/14.
//  Copyright (c) 2014 Lame Black Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MeuPensamento.h"
#import "MPAddViewController.h"

@interface MPDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *viewPhoto;
@property (strong, nonatomic) IBOutlet UIButton *buttonShare;

- (IBAction)editButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;


@end
