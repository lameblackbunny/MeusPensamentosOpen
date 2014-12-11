//
//  MPSplashViewController.m
//  MeusPensamentos
//
//  Created by Lame Black Bunny on 09/06/14.
//  Copyright (c) 2014 Lame Black Bunny. All rights reserved.
//

#import "MPSplashViewController.h"

@interface MPSplashViewController ()

@end

@implementation MPSplashViewController

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
    
    // just a timer to wait for the logo to be seen before going to the app
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(finishSplash) userInfo:nil repeats:NO];
}

- (void)finishSplash
{
    [self performSegueWithIdentifier:@"segueIntroToApp" sender:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
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

@end
