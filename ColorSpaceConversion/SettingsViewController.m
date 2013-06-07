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
@synthesize settingsPickerView;
@synthesize stages = _stages;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Look up list of finger recognition steps
    _stages = [[NSArray alloc] initWithObjects:@"Skin Space", @"Probability Image", @"Blob Image", @"Finger Detection",nil];
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

#pragma mark - SettingsPickerView Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _stages.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_stages objectAtIndex:row];
}

@end
