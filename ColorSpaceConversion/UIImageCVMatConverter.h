//
//  UIImageCVMatConverter.h
//  OpenCViOS
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>

#ifdef __cplusplus

#include <opencv2/imgproc.hpp>
#include <opencv2/core.hpp>
using namespace cv;

#include <list>
using namespace std;

#endif


@interface UIImageCVMatConverter : NSObject

+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;
+ (cv::Mat)cvMatFromUIImage:(UIImage *)image;
+ (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image;
+ (void)filterCanny:(Mat)image withKernelSize:(int)kernel_size andLowThreshold:(int)lowThreshold;

@end
