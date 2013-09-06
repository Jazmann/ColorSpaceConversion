//
//  UIImageCVMatConverter.m
//  OpenCViOS
//


#import "UIImageCVMatConverter.h"


@implementation UIImageCVMatConverter
+(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat{
    NSLog(@"UIImageFromCVMat : in");
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    NSLog(@"UIImageFromCVMat : cvMat.elemSize()");
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    NSLog(@"UIImageFromCVMat : Out");

    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage; 
}
+ (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    NSLog(@"cvMatFromUIImage : in");
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage); // image.CGImage may be null is UIImage is initialized with CIImage. Test for null to make robust.
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return cvMat;
}
+ (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image
{
    NSLog(@"cvMatGrayFromUIImage : in");
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage); // image.CGImage may be null is UIImage is initialized with CIImage. Test for null to make robust.

    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return cvMat;
}

+ (void)filterCanny:(Mat)image withKernelSize:(int)kernel_size andLowThreshold:(int)lowThreshold;
{
	int ratio = 3;
	
	
	const int& width = image.cols;
	const int& height = image.rows;
	const int& bytesPerRow = image.step[0];
	
	// we need to copy because src.data != dst.data must hold with bilateral filter
	unsigned char* data_copy = new unsigned char[max(width,bytesPerRow)*height];
	memcpy(data_copy, image.data, max(width,bytesPerRow)*height);
	
	Mat src(height, width, CV_8UC1, data_copy, bytesPerRow);
	
	Mat detected_edges;
	
	/// Reduce noise with a kernel 3x3
	blur( src, detected_edges, cv::Size(3,3) );
	
	/// Canny detector
	Canny( detected_edges, detected_edges, lowThreshold, lowThreshold*ratio, kernel_size );
	
	/// Using Canny's output as a mask, we display our result
	image = Scalar::all(0);
	
	src.copyTo( image, detected_edges);
}


@end
