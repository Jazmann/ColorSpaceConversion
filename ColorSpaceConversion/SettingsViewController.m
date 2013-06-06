//
//  SettingsViewController.m
//  ColorSpaceConversion
//
//  Created by NBTB on 6/6/13.
//  Copyright (c) 2013 University of Houston - Main Campus. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end


@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@synthesize delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender
{
	[self.delegate settingsViewControllerDidCancel:self];
}
- (IBAction)done:(id)sender
{
	[self.delegate settingsViewControllerDidSave:self];
}

@end
