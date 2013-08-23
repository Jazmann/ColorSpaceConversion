//
//  ImagePickerController.m
//  ColorSpaceConversion
//
//  Created by NBTB on 8/23/13.
//  Copyright (c) 2013 University of Houston - Main Campus. All rights reserved.
//

#import "ImagePickerController.h"

@implementation ImagePickerController

@synthesize delegate;
@synthesize imagePickerShown;
@synthesize sourceType;


#pragma mark - Constructors

- (id)init;
{
	self = [super init];
	if (self) {
		self.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
	return self;
}

- (id)initAsCamera;
{
	self = [super init];
	if (self) {
		self.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
	return self;
}

- (id)initAsPhotoLibrary;
{
	self = [super init];
	if (self) {
		self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	return self;
}

- (void)showPicker:(UIViewController*)parent
{
	if (self.imagePickerShown) {
		return;
	}
	UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self.delegate;
	imagePickerController.sourceType = self.sourceType;
	[parent presentModalViewController:imagePickerController animated:YES];
	self.imagePickerShown = YES;
}

- (void)hidePicker:(UIViewController*)viewController;
{
	if (!self.imagePickerShown) {
		return;
	}
	[viewController dismissModalViewControllerAnimated:YES];
	self.imagePickerShown = NO;
}

@end