//
//  SettingsViewController.h
//  ColorSpaceConversion
//
//  Created by NBTB on 6/6/13.
//  Copyright (c) 2013 University of Houston - Main Campus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsViewController;

@protocol SettingsViewControllerDelegate <NSObject>
- (void)settingsViewControllerDidCancel:
(SettingsViewController *)controller;
- (void)settingsViewControllerDidSave:
(SettingsViewController *)controller;
@end

@interface SettingsViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *settingsPickerView;
@property (nonatomic, weak) id <SettingsViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray * stages;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
