//
//  MWLoginViewController.m
//  TuxMobile
//
//  Created by Andrey Durbalo on 03.09.13.
//  Copyright (c) 2013 The Men's Wearhouse. All rights reserved.
//

#import "MWLoginViewController.h"

@interface MWLoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *signInButton;


- (IBAction)signInButtonPressed:(id)sender;

@end

@implementation MWLoginViewController

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
    // Do any additional setup after loading the view from its nib.
    
    [MWThemeManager customizeButton:self.signInButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInButtonPressed:(id)sender
{
    DDLogVerbose(@"%@", sender);
    
    MWLoginViewController* login = [MWLoginViewController new];
    login.title = [NSString stringWithFormat:@"%d", self.navigationController.viewControllers.count+1];
    [self.navigationController pushViewController:login animated:YES];
}
@end
