//
//  ImagePickerController.h
//  ColorSpaceConversion
//
//  Created by NBTB on 8/23/13.
//  Copyright (c) 2013 University of Houston - Main Campus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImagePickerController : NSObject
{
	BOOL imagePickerShown;
	UIImagePickerControllerSourceType sourceType;
}

@property (nonatomic, assign) id<UINavigationControllerDelegate,UIImagePickerControllerDelegate> delegate;
@property (nonatomic, assign) BOOL imagePickerShown;
@property (nonatomic, assign) UIImagePickerControllerSourceType sourceType;


- (id)initAsCamera;
- (id)initAsPhotoLibrary;

- (void)showPicker:(UIViewController*)parent;
- (void)hidePicker:(UIViewController*)viewController;

@end


