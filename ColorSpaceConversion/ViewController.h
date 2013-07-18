//
//  ViewController.h
//  ColorSpaceConersion
//

#include <opencv2/core/mat.hpp>
#import <UIKit/UIKit.h>
#import "SettingsViewController.h"

@interface ViewController : UIViewController <SettingsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hsvButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *grayButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *binaryButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem * backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem * forwardButton;
@property (weak, nonatomic) IBOutlet UISlider *thresholdSlider;

#ifdef __cplusplus
@property (readonly, nonatomic) cv::Mat inputMat;
@property (readwrite,nonatomic) cv::Mat hsvImage;
// @property (readwrite,nonatomic) cv::Mat *imageHistory;
#endif 

- (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;
- (cv::Mat)cvMatFromUIImage:(UIImage *)image;
- (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image;

-(IBAction)hsvImageAction:(id)sender;
-(IBAction)grayImageAction:(id)sender;
-(IBAction)binaryImageAction:(id)sender;
-(IBAction)binarySliderAction:(id)sender;
-(IBAction)backward:(id)sender;
-(IBAction)forward:(id)sender;
@end
