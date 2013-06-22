//
//  ViewController.m
//  ColorSpaceConersion
//


#import "ViewController.h"

#include <list>

typedef unsigned char uchar;

//olive dispenser fork

@interface ViewController ()
@end

@implementation ViewController

#pragma mark - 
#pragma mark Properties
@synthesize thresholdSlider;
@synthesize imageView;
@synthesize hsvButton;
@synthesize grayButton;
@synthesize binaryButton;
@synthesize inputMat;
@synthesize hsvImage;
@synthesize imageHistory;

int currentImageIndex = 0;
int nextImageIndex = (currentImageIndex - 1) % 10;
int previousImageIndex = (10 + currentImageIndex - 1) % 10;


#pragma mark - 
#pragma mark Managing Views
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *imageName = [[NSBundle mainBundle] pathForResource:@"hand_skin_test_3_back_1" ofType:@"jpg"];
    imageView.image = [UIImage imageWithContentsOfFile:imageName];
    inputMat =[self cvMatFromUIImage:imageView.image];
    cv::Mat hsvImage;
    
    NSArray * imageHistory = [[NSArray alloc]initWithObjects:inputMat,inputMat,inputMat,inputMat,inputMat,inputMat,inputMat,inputMat,inputMat,inputMat];

    thresholdSlider.hidden = YES;

}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setHsvButton:nil];
    [self setGrayButton:nil];
    [self setBinaryButton:nil];
    [self setThresholdSlider:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - 
#pragma mark button action

/*
-(IBAction)hsvImageAction:(id)sender
{
    threshol.hidden = YES;
    cv::Mat hsvImage;
    cv::cvtColor (inputMat, hsvImage, CV_BGR2HSV); 
    // convert cvMat to UIImage
    imageView.image = [self UIImageFromCVMat:hsvImage];
    hsvImage.release();
    
}
 
 
 std::string f_str = std::to_string(f);
*/
-(void)sVecPrint:(cv::sVec<uint8_t, 3>)vec{
    printf("Test sVec \n");
    printf("    / %u \\  / %f \\ \n", vec[0],    vec(0));
    printf("%4.1f| %u |= | %f | \n",  vec.scale, vec[1], vec(1));
    printf("    \\ %u /  \\ %f / \n", vec[2],    vec(2));
}
-(void)printDataInfo:(int)type{
    printf("CV_DEPTH_BITS_MAGIC = %llu \n",CV_DEPTH_BITS_MAGIC);
    printf("To get back the information put into CV_MAKETYPE( depth_Type, cn) use.\n");
    printf("int depth_Type = CV_MAT_DEPTH(type) = %u\n", CV_MAT_DEPTH(type));
    printf("int CV_ELEM_SIZE(type) = %u\n", CV_ELEM_SIZE(type));
    printf("int cn = CV_MAT_CN(type) = %u\n", CV_MAT_CN(type));
    printf("To get info on the type itself use:\n");
    printf("int bit_Depth  = CV_MAT_DEPTH_BITS(type) = %u \n",   CV_MAT_DEPTH_BITS(type));
    printf("int byte_Depth = CV_MAT_DEPTH_BYTES(type) = %u \n", CV_MAT_DEPTH_BYTES(type));
    printf("int channels = CV_MAT_CN(type) = %u \n",  CV_MAT_CN(type));
    printf("The internals:\n");
    printf("In case the channels are packed into fewer than one byte each we calculate : bits_used = channels * bits_per_channel\n");
    printf("CV_ELEM_SIZE_BITS(type) [= %u]  ( CV_MAT_CN(type) [= %u] * CV_DEPTH_BITS(type) [= %u] )\n", CV_ELEM_SIZE_BITS(type), CV_MAT_CN(type), CV_DEPTH_BITS(type));
    printf("then bytes = Ceiling( bits_used / 8)\n");
    printf("CV_ELEM_SIZE_BYTES(type) [= %u] ((CV_ELEM_SIZE_BITS(type) >> 3) [= %u] + ( (CV_ELEM_SIZE_BITS(type) & 7) ? 1 : 0 ) [= %u])\n", CV_ELEM_SIZE_BYTES(type), (CV_ELEM_SIZE_BITS(type) >> 3), ((CV_ELEM_SIZE_BITS(type) & 7) ? 1 : 0 ));
    printf("CV_ELEM_SIZE CV_ELEM_SIZE_BYTES\n");
}


/* f : number to convert.
 * num, denom: returned parts of the rational.
 * max_denom: max denominator value.  Note that machine floating point number
 *     has a finite resolution (10e-16 ish for 64 bit double), so specifying
 *     a "best match with minimal error" is often wrong, because one can
 *     always just retrieve the significand and return that divided by
 *     2**52, which is in a sense accurate, but generally not very useful:
 *     1.0/7.0 would be "2573485501354569/18014398509481984", for example.
 */

/*
void rat_approx(double f, int64_t max_denom, int64_t *num, int64_t *denom)
{
	//  a: continued fraction coefficients.

	int64_t a, h[3] = { 0, 1, 0 }, k[3] = { 1, 0, 0 };
	int64_t x, d, n = 1;
	int i, neg = 0;
    
	if (max_denom <= 1) { *denom = 1; *num = (int64_t) f; return; }
    
	if (f < 0) { neg = 1; f = -f; }
    
	while (f != floor(f)) { n <<= 1; f *= 2; }
	d = f;
    
	// continued fraction and check denominator each step 
	for (i = 0; i < 64; i++) {
		a = n ? d / n : 0;
		if (i && !a) break;
        
		x = d; d = n; n = x % n;
        
		x = a;
		if (k[1] * a + k[0] >= max_denom) {
			x = (max_denom - k[0]) / k[1];
			if (x * 2 >= a || k[1] >= max_denom)
				i = 65;
			else
				break;
		}
        
		h[2] = x * h[1] + h[0]; h[0] = h[1]; h[1] = h[2];
		k[2] = x * k[1] + k[0]; k[0] = k[1]; k[1] = k[2];
	}
	*denom = k[1];
	*num = neg ? -h[1] : h[1];
}
*/


cv::Matx<int64_t, 3, 2> rational_decomposition(cv::Matx<float, 3, 1> vec, int64_t max_denom){
    cv::Matx<int64_t, 3, 2> output;
    int64_t out_num, out_denom;
    double float_in;
    for (int i=0; i<3; i++) {
        float_in = (double) vec(i);
        cv::rat_approx(float_in, max_denom, &out_num, &out_denom );
        output(i,0) = out_num;
        output(i,1) = out_denom;
    }
    return output;
}


template<typename _Tp, int m, int n> std::string toString(_Tp mat[m][n]){
    std::string output="";
    std::string temp="";
    for (int i=0; i<m; i++) {
    output += "| ";
    for (int j=0; j<n-1; j++) {
        temp = std::to_string(mat[i][j]);
        temp.resize(8,' ');
        output += temp + ", ";
    }
        temp = std::to_string(mat[i][n-1]);
        temp.resize(8,' ');
        output += temp + " |\n";
    }
    return output;
}

template<typename _Tp, int m> std::string toString(_Tp mat[m]){
    std::string output="";
    for (int i=0; i<m; i++) {
            output += "| " + std::to_string(mat[i]) + " |\n";
        }
    return output;
}

template<typename _Tp, int cn> std::string toString(cv::sVec<_Tp, cn> vec){
     std::string output = std::to_string(vec.scale) + "  / " + std::to_string(vec[0]) + " \\  / " + std::to_string(vec(0)) + " \\ \n";
     for (int i=1; i<cn-1; i++) {
         output += "          | " + std::to_string(vec[i]) + " |= | " + std::to_string(vec(i)) + " | \n";
     }
     output += "          \\ " + std::to_string(vec[cn-1]) + " /  \\ " + std::to_string(vec(cn-1)) + " / \n";
     return output;
}


template<typename _Tp, int cn> inline cv::sVec<_Tp, cn> sVecRat(const cv::Matx<float, cn, 1>& vec, int64_t max_denom)
{
    cv::sVec<_Tp, cn> output;
    cv::sVec<int64_t, cn> output_num; output_num.scale = 1.0;
    cv::sVec<int64_t, cn> output_den; output_den.scale = 1.0;
    int64_t out_num, out_den;
    double float_in;
    for (int i=0; i<cn; i++) {
        float_in = (double) vec(i);
        cv::rat_approx(float_in, max_denom, &out_num, &out_den );
        output_num[i] = out_num;
        output_den[i] = out_den;
    }
    printf("output_num\n");
    std::cout << toString<int64_t, cn>(output_num);
    printf("output_den\n");
    std::cout << toString<int64_t, cn>(output_den);

    output_num.factor();
    output_den.factor();
    printf("output_num\n");
    std::cout << toString<int64_t, cn>(output_num);
    printf("output_den\n");
    std::cout << toString<int64_t, cn>(output_den);
    int64_t den_prod = output_den[0];
    for(int i=1;i<cn;i++){
        den_prod *= output_den[i];
    }
    
    printf("den_prod = %lli\n",den_prod);

    for(int i=0;i<cn;i++){
        output_num[i] *= den_prod/output_den[i];
    }
    output_num.scale *= 1.0/(output_den.scale * den_prod);
    output_num.factor();
    
    const uint64_t saturateType = (((1 << ((sizeof(_Tp) << 3)-1)) -1 ) << 1) + 1;
    int exposure = (int) (output_num.max() / saturateType);
    output.scale = output_num.scale * (exposure + 1);
    for(int i=0;i<cn;i++){
        output.val[i] = (_Tp) (output_num[i]/(exposure + 1)) ;
    }
    return output;
}


template<typename _Tp, int m, int n> inline cv::Matx<_Tp, m, 1> MaxInRow(cv::Matx<_Tp, m, n> src){
    cv::Matx<_Tp, m, 1> dst;
    for( int i = 0; i < m; i++ ){
        dst(i,0) = src(i,0);
        for( int j = 1; j < n; j++ )
        {
            if (dst(i,0) < src(i,j)) {
                dst(i,0) = src(i,j);
            }
        }
    }
    return dst;
}


template<typename _Tp, int m, int n> inline cv::Matx<_Tp, m, 1> MinInRow(cv::Matx<_Tp, m, n> src){
    cv::Matx<_Tp, m, 1> dst;
    for( int i = 0; i < m; i++ ){
        dst(i,0) = src(i,0);
        for( int j = 1; j < n; j++ )
        {
            if (dst(i,0) > src(i,j)) {
                dst(i,0) = src(i,j);
            }
        }
    }
    return dst;
}

-(void)sVecTest{
    cv::sVec<uint8_t, 3> a{1.5,3,6,9};
    cv::sVec<uint8_t, 3> b{1.5,15,20,10};
    [self sVecPrint:a];
    [self sVecPrint:b];
    a.factor();b.factor();
    [self sVecPrint:a];
    [self sVecPrint:b];
    cv::sVec<uint8_t, 1> ab = a * b ;
    cv::sVec<uint8_t, 1> ba = b * a;
    printf("a . b = %f %u = %f \n", ab.scale, ab[0], ab(0));
    printf("a . b = %f %u = %f \n", ba.scale, ba[0], ab(0));
    cv::Matx<float, 3, 1> mx{1.2, 2.2, 3.2};
    printf("Matx{ %f %f %f }\n", mx(0), mx(1), mx(2));
    cv::sVec<uint8_t, 3> aM(mx);
    [self sVecPrint:aM];
    
    cv::sVec<uint8_t, 3> aV = sVecRat<uint8_t, 3>(mx, 255);
    [self sVecPrint:aV];

    
    const unsigned long long int saturateType = (1 << (sizeof(uint8_t) << 3))-1;
    float maxVal = mx(0,0);
    for (int i=1; i<3; i++) { if (mx(i,0) > maxVal) maxVal = mx(i,0);}
    float scale = maxVal/saturateType;
    printf("saturateType %llu maxVal %f scale %f \n", saturateType, maxVal, scale);
    cv::Matx<uint8_t,3,1> vm(mx, saturateType/maxVal, cv::Matx_ScaleOp());
    printf("Matx{ %u %u %u }\n", vm(0), vm(1), vm(2));
    cv::Matx<int64_t, 3, 2> rdMat = rational_decomposition(mx, 255);
    printf("rdMat{ %lli %lli %lli }\n", rdMat(0,0), rdMat(1,0), rdMat(2,0));
    printf("rdMat{ %lli %lli %lli }\n", rdMat(0,1), rdMat(1,1), rdMat(2,1));

    
    cv::Matx<float, 3, 1> fMa{1.2, 2.2, 3.2};
    cv::sVec<uint8_t, 3> fVa(fMa);
    printf("fVa\n");
    [self sVecPrint:fVa];

 //   std::string disp = fVa.toString();
 //   std::cout << disp;
    cv::Matx<float, 3, 1> fMb{2.2, 2.2, 1.1};
    cv::sVec<uint8_t, 3> fVb(fMb);
    printf("fVb\n");
    [self sVecPrint:fVb];

    cv::Matx<float, 3, 1> fMc{1.2, 2.3, 3.7};
    cv::sVec<uint8_t, 3> fVc(fMc);
    printf("fVc\n");
    [self sVecPrint:fVc];


    
}

-(IBAction)hsvImageAction:(id)sender
{
    thresholdSlider.hidden = YES;
    // R:239, G:208, B:207
   // cv::Vec<int, 3> sp0(0, 0, 0);
   // cv::Vec<int, 3> sp1(255, 0, 0);
   // cv::Vec<int, 3> sp2(0, 255, 0);
    
    
   // cv::Vec<int, 3> sp0(0, 0, 0);
   // cv::Vec<int, 3> sp1(1, 0, 0);
   // cv::Vec<int, 3> sp2(0, 1, 0);
    
   // cv::Vec<int, 3> sp0(0, 0, 0);
   // cv::Vec<int, 3> sp1(0, 1, 0);
   // cv::Vec<int, 3> sp2(1, 0, 0);
    
     cv::Vec<int, 3> sp0(0, 0, 0);
     cv::Vec<int, 3> sp1(255, 255, 255);
     cv::Vec<int, 3> sp2(118, 131, 139);
    
    // cv::Vec<typename cv::depthConverter<CV_8UC4, CV_8UC3>::srcType, 3> c(240, 128, 128);
    cv::Vec<typename cv::depthConverter<CV_8UC4, CV_8UC3>::srcType, 3> c(148, 119, 111);
    // cv::Vec<typename cv::depthConverter<CV_8UC4, CV_8UC3>::srcType, 3> c(180, 50, 128);
    cv::Vec<double, 3> g(1, 125, 35);
    cv::RGB2Rot<CV_8UC4,CV_8UC3> colSpace( sp0, sp1, sp2, g, c);

 //   cv::cvtColor (inputMat, hsvImage, CV_BGR2HSV);
    printf("Mat : inputMat :  rows = %d, cols = %d \n", inputMat.rows, inputMat.rows);
    printf("Mat : inputMat :  elemSize = %lu     \n", inputMat.elemSize());
    printf("Mat : inputMat :  elemSize1() = %lu  \n", inputMat.elemSize1());
    printf("Mat : inputMat :  type() = %d  \n", inputMat.type());
    printf("Mat : inputMat :  depth() = %d  \n", inputMat.depth());
    printf("Mat : inputMat :  channels() = %d  \n", inputMat.channels());
    printf("Mat : inputMat :  step1(0) = %lu  \n", inputMat.step1(0));
    printf("Mat : inputMat :  step[0] = %lu  \n", inputMat.step[0]);
    /*
    printf("------ CV_2UC4 --------\n");
    [self printDataInfo:CV_2UC4 ];
    printf("\n ------ CV_4UC4 --------\n");
    [self printDataInfo:(CV_4UC4)];
    printf("\n ------ CV_8UC4 --------\n");
     [self printDataInfo:(CV_8UC4)];
    printf("\n ------ CV_8SC4 --------\n");
    [self printDataInfo:(CV_8SC4)];
    printf("\n ------ CV_16UC4 --------\n");
    [self printDataInfo:(CV_16UC4)];
    printf("\n ------ CV_16SC4 --------\n");
    [self printDataInfo:(CV_16SC4)];
    printf("\n ------ CV_32UC4 --------\n");
    [self printDataInfo:(CV_32UC4)];
    printf("\n ------ CV_32SC4 --------\n");
    [self printDataInfo:(CV_32SC4)];
    printf("\n ------ CV_64UC4 --------\n");
    [self printDataInfo:(CV_64UC4)];
    printf("\n ------ CV_64SC4 --------\n");
    [self printDataInfo:(CV_64SC4)];
    printf("\n ------ CV_32FC4 --------\n");
    [self printDataInfo:(CV_32FC4)];
    printf("\n ------ CV_64FC4 --------\n");
    [self printDataInfo:(CV_64FC4)];
    
    [self sVecTest];
     */

  //  RGB2RotTest(sp0, sp1, sp2);
    //  cv::cvtColor(inputMat, hsvImage, CV_RGB2Rot);
    //cv::Vec<typename cv::depthConverter<CV_8UC4, CV_8UC3>::srcType, 3> c(128, 128, 128);
    //cv::Vec<double, 3> g(1, 1, 1);
    //cv::RGB2Rot<CV_8UC4,CV_8UC3> colSpace( sp0, sp1, sp2, g, c);
    
    
   /*
    printf("constexpr static int src_Bit_Depth  = %i \n", colSpace.src_Bit_Depth);
    printf("constexpr static int src_Byte_Depth = %i \n", colSpace.src_Byte_Depth);
    printf("constexpr static int src_Channels   = %i \n", colSpace.src_Channels);
    printf("constexpr static int dst_Bit_Depth  = %i \n", colSpace.dst_Bit_Depth);
    printf("constexpr static int dst_Byte_Depth = %i \n", colSpace.dst_Byte_Depth);
    printf("constexpr static int dst_Channels   = %i \n", colSpace.dst_Channels);
    printf("using src_channel_type     = %u\n", cv::DataType<cv::RGB2Rot<CV_8UC4,CV_8UC3>::src_channel_type>::type);
    printf("using dst_channel_type     = %u\n", cv::DataType<cv::RGB2Rot<CV_8UC4,CV_8UC3>::dst_channel_type>::type);
    printf("const uint64_t targetScale = %u \n", colSpace.targetScale);
    printf("int M[dst_Channels][src_Channels]\n");
    std::cout << toString<int,cv::RGB2Rot<CV_8UC4,CV_8UC3>::dst_Channels, cv::RGB2Rot<CV_8UC4,CV_8UC3>::src_Channels>(colSpace.M);
    printf("int TRange[dst_Channels]\n");
    std::cout << toString<int,cv::RGB2Rot<CV_8UC4,CV_8UC3>::dst_Channels>(colSpace.TRange);
    printf("int TMin[dst_Channels]\n");
    std::cout << toString<int,cv::RGB2Rot<CV_8UC4,CV_8UC3>::dst_Channels>(colSpace.TMin);
 //   printf("int TRange[dst_Channels], TMin[dst_Channels]\n", colSpace.);
    printf("int redScale   :  %i \n", colSpace.redScale);
    printf("int greenScale :  %i \n", colSpace.greenScale);
    printf("int blueScale  :  %i \n", colSpace.blueScale);
    */
    const int ro = 121;
    const int co = 23;
    
    printf("Mat : inputMat :  rows = %d, cols = %d \n", inputMat.rows, inputMat.cols);
    printf("Mat : inputMat :  elemSize = %lu     \n", inputMat.elemSize());
    printf("Mat : inputMat :  elemSize1() = %lu  \n", inputMat.elemSize1());
    printf("Mat : inputMat :  type() = %d  \n", inputMat.type());
    printf("Mat : inputMat :  depth() = %d  \n", inputMat.depth());
    printf("Mat : inputMat :  channels() = %d  \n", inputMat.channels());
    printf("Mat : inputMat :  step1(0) = %lu  \n", inputMat.step1(0));
    printf("Mat : inputMat :  step[0] = %lu  \n", inputMat.step[0]);
    printf("Mat : hsvImage :  point = ( %" PRIu8 " ) ( %" PRIu8 " ) ( %" PRIu8 " ) \n", inputMat.at<cv::Vec3b>(ro,co)[0], inputMat.at<cv::Vec3b>(ro,co)[1], inputMat.at<cv::Vec3b>(ro,co)[2]);
    
    cv::convertColor<CV_8UC4,CV_8UC3>(inputMat, hsvImage, colSpace);
    
    printf("Mat : hsvImage :  rows = %d, cols = %d \n", hsvImage.rows, hsvImage.cols);
    printf("Mat : hsvImage :  elemSize = %lu     \n", hsvImage.elemSize());
    printf("Mat : hsvImage :  elemSize1() = %lu  \n", hsvImage.elemSize1());
    printf("Mat : hsvImage :  type() = %d  \n", hsvImage.type());
    printf("Mat : hsvImage :  depth() = %d  \n", hsvImage.depth());
    printf("Mat : hsvImage :  channels() = %d  \n", hsvImage.channels());
    printf("Mat : hsvImage :  step1(0) = %lu  \n", hsvImage.step1(0));
    printf("Mat : hsvImage :  step[0] = %lu  \n", hsvImage.step[0]);
    printf("Mat : hsvImage :  point = ( %" PRIu8 " ) ( %" PRIu8 " ) ( %" PRIu8 " ) \n", hsvImage.at<cv::Vec3b>(ro,co)[0], hsvImage.at<cv::Vec3b>(ro,co)[1], hsvImage.at<cv::Vec3b>(ro,co)[2]);
    
    // convert cvMat to UIImage
    imageView.image = [self UIImageFromCVMat:hsvImage];    
}


-(IBAction)grayImageAction:(id)sender
{
    thresholdSlider.hidden = YES;
    cv::Mat greyMat;
    
    
    printf("Mat : inputMat :  rows = %d, cols = %d \n", inputMat.rows, inputMat.cols);
    printf("Mat : inputMat :  elemSize = %lu     \n", inputMat.elemSize());
    printf("Mat : inputMat :  elemSize1() = %lu  \n", inputMat.elemSize1());
    printf("Mat : inputMat :  type() = %d  \n", inputMat.type());
    printf("Mat : inputMat :  depth() = %d  \n", inputMat.depth());
    printf("Mat : inputMat :  channels() = %d  \n", inputMat.channels());
    printf("Mat : inputMat :  step1(0) = %lu  \n", inputMat.step1(0));
    printf("Mat : inputMat :  step[0] = %lu  \n", inputMat.step[0]);
    
    cv::cvtColor(inputMat, greyMat, CV_BGR2GRAY);
        
    printf("Mat : inputMat :  rows = %d, cols = %d \n", greyMat.rows, greyMat.cols);
    printf("Mat : inputMat :  elemSize = %lu     \n", greyMat.elemSize());
    printf("Mat : inputMat :  elemSize1() = %lu  \n", greyMat.elemSize1());
    printf("Mat : inputMat :  type() = %d  \n", greyMat.type());
    printf("Mat : inputMat :  depth() = %d  \n", greyMat.depth());
    printf("Mat : inputMat :  channels() = %d  \n", greyMat.channels());
    printf("Mat : inputMat :  step1(0) = %lu  \n", greyMat.step1(0));
    printf("Mat : inputMat :  step[0] = %lu  \n", greyMat.step[0]);
  /*  cv::SimpleBlobDetector::Params params;
    params.minDistBetweenBlobs = 50.0f;
    params.filterByInertia = false;
    params.filterByConvexity = false;
    params.filterByColor = false;
    params.filterByCircularity = false;
    params.filterByArea = true;
    params.minArea = 20.0f;
    params.maxArea = 500.0f;
    
    cv::Ptr<cv::FeatureDetector> blob_detector = new cv::SimpleBlobDetector(params);
    blob_detector->create("SimpleBlob");
    
    cv::vector<cv::KeyPoint> keypoints;
    blob_detector->detect(greyMat, keypoints);
    */
    

    // convert cvMat to UIImage
    
    NSLog(@"Convert cvMat to UIImage");
    
    self.imageView.image = [self UIImageFromCVMat:inputMat];
  //  [self UIImageFromCVMat:greyMat];
 //   NSLog(@"Convert cvMat to UIImage");
    
 //   self.imageView.image = [self UIImageFromCVMat:greyMat];
 //   NSLog(@"Converted cvMat to UIImage");
    greyMat.release();
}
-(IBAction)binaryImageAction:(id)sender
{
    cv::Mat binaryMatU, binaryMatL, greyMat;
    thresholdSlider.hidden = NO;
    thresholdSlider.continuous = YES;
    float threshold = thresholdSlider.value;
    cv::cvtColor(hsvImage, greyMat, CV_BGR2GRAY);
    cv::threshold(greyMat,binaryMatL,threshold,0,cv::THRESH_TOZERO);
    cv::threshold(binaryMatL,binaryMatU,255-threshold,0,cv::THRESH_TOZERO_INV);
    greyMat.release();
    binaryMatL.release();
    // convert cvMat to UIImage
    imageView.image = [self UIImageFromCVMat:binaryMatU];
    binaryMatU.release();
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8 * cvMat.elemSize1(),                      //bits per component
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
- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
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
- (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
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

#pragma mark - SettingsViewControllerDelegate
- (void)settingsViewControllerDidCancel:(SettingsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)settingsViewControllerDidSave:(SettingsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Settings"])
    {
        UINavigationController *navigationController =
        segue.destinationViewController;
        SettingsViewController *settingsViewController = [[navigationController viewControllers] objectAtIndex:0];
        settingsViewController.delegate = self;
    }
}

@end
