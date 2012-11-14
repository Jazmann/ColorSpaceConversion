//
// ColorSpaceMaker.cpp
// OpenCViPhoneApplication1
//
// Created by NBTB on 10/22/12.
//

#include "ColorSpaceMaker.h"
#include <opencv2/core/mat.hpp>

using namespace cv;

typedef Matx<float, 3, 3> Matx33f;
typedef Matx<int, 3, 3> Matx33i;

typedef Vec<float, 3>Vec3f;
typedef Vec<int, 3>Vec3i;

int gcd(int a, int b, int c){
    return gcd(gcd(a, b), c);
};

int gcd(int u, int v) {
    if (v)
        return gcd(v, u % v);
    else
        return u < 0 ? -u : u; /* abs(u) */
};


// A data structure which allows a vector to be expressed as a float scalar times an integer vector.
struct Vec3fi{
    float scale;
    Vec3i vec;
    
    Vec3fi(float scaleInit, Vec3i vecInit) : scale(scaleInit), vec(vecInit){};
    
    Vec3fi operator* (float a){
        return Vec3fi(a * scale, vec);
    };
    Vec3fi operator* (int a){
        return Vec3fi(a * scale, vec);
    };
    int vecDot( Vec3fi vecB){
        return this->vec[0] * vecB.vec[0] + this->vec[1] * vecB.vec[1] + this->vec[2] * vecB.vec[2];
    };
    int vecDot( Vec3i vecB){
        return this->vec[0] * vecB[0] + this->vec[1] * vecB[1] + this->vec[2] * vecB[2];
    };
    float scaleDot( Vec3fi vecB){
        return this->scale * vecB.scale;
    };
    float scaleDot( Vec3i vecB){
        return this->scale;
    };
    float dot( Vec3fi vecB){
        return scaleDot(vecB) * vecDot(vecB);
    };
    float dot( Vec3i vecB){
        return this->scale * vecDot(vecB);
    };
    Vec3fi cross( Vec3fi vecB){
        return Vec3fi(this->scale * vecB.scale, Vec3i((this->vec[1] * vecB.vec[2]) - (this->vec[2] * vecB.vec[1]),  (this->vec[2] * vecB.vec[0]) - (this->vec[0] * vecB.vec[2]),  (this->vec[0] * vecB.vec[1]) - (this->vec[1] * vecB.vec[0])));
    };
    Vec3fi cross( Vec3i vecB){
        return Vec3fi(this->scale , Vec3i((this->vec[1] * vecB[2]) - (this->vec[2] * vecB[1]),  (this->vec[2] * vecB[0]) - (this->vec[0] * vecB[2]),  (this->vec[0] * vecB[1]) - (this->vec[1] * vecB[0])));
    };

    void factor(){
        // Test for all negative.
        if (vec[0]<0 && vec[1]<0 && vec[2] < 0) {
            vec   = -1   * vec;
            scale = -1.0 * scale;
        }
        int common = gcd(this->vec[0],this->vec[1],this->vec[2]);
        if (common>1){
            Vec3i vecTemp(this->vec[0]/common,this->vec[1]/common,this->vec[2]/common);
            vec = vecTemp;
            scale = scale*common;
        };
    };
    
    int max(){
        return std::max(std::max(vec[0],vec[1]),vec[2]);
    };
    int min(){
        return std::min(std::min(vec[0],vec[1]),vec[2]);
    };
    
    
};




class ColorSpace {
    
    Matx33i Ti;
    Vec3f scale;
    Vec3i TMin; // The minimum value in each row of Ti. This is the lowest component in the new axial vectors expressed in RGB space.
    Vec3i TRange; // TMax - TMin. The highest minus the lowest components of the new axial vectors.
    
    // The transform to the new color space is (Ti vec - 255 TMin)/TRange. 255 is the range of 8bit RGB and can be replaced directly with a different range for 16 and 32 bit RGB spaces. The division by TRange is the direct element wise division and can safely be rounded to recast in the required bit depth.
    
    
    public: ColorSpace(Vec3i, Vec3i, Vec3i);
    
    
    template <typename T> void MaxInRow(InputArray _src, OutputArray _dst){
        // get Mat headers for input array. This is O(1) operation, unless _src is a matrix expressions.
        Mat src = _src.getMat();
        // CV_Assert( src.type() == T);
        
        // [re]create the output array so that it has the proper size and type.
        // In case of Mat it calls Mat::create, in case of STL vector it calls vector::resize.
        _dst.create(src.rows, 1, src.type());
        Mat dst = _dst.getMat();
        dst = src.col(0);
        
        for( int i = 0; i < src.rows; i++ ){
            const T* srcRow = src.ptr<T>(i);
            for( int j = 1; j < src.cols; j++ )
            {
                dst.at<T>(i,0) = std::max(dst.at<T>(i,0),srcRow[j]);
            }
        }

    }
    
    template <typename T> void MinInRow(InputArray _src, OutputArray _dst){
        // get Mat headers for input array. This is O(1) operation, unless _src is a matrix expressions.
        Mat src = _src.getMat();
        // CV_Assert( src.type() == T);
        
        // [re]create the output array so that it has the proper size and type.
        // In case of Mat it calls Mat::create, in case of STL vector it calls vector::resize.
        _dst.create(src.rows, 1, src.type());
        Mat dst = _dst.getMat();
        dst = src.col(0);
        
        for( int i = 0; i < src.rows; i++ ){
            const T* srcRow = src.ptr<T>(i);
            for( int j = 1; j < src.cols; j++ )
            {
                dst.at<T>(i,0) = std::min(dst.at<T>(i,0),srcRow[j]);
            }
        }
        
    }

    
};                       
                

 ColorSpace::ColorSpace(Vec3i sp0, Vec3i sp1, Vec3i sp2){
            
    Vec3fi v1(1.0, sp1 - sp0);
    Vec3fi v2(1.0, sp2 - sp0);
     v1.factor(); v1.scale=1.0;
     v2.factor(); v2.scale=1.0;
    
     int v1Norm2 = v1.vecDot(v1); // (v1[0] * v1[0]) + (v1[1] * v1[1]) + (v1[2] * v1[2]);
     int v2Norm2 = v2.vecDot(v2); // (v2[0] * v2[0]) + (v2[1] * v2[1]) + (v2[2] * v2[2]);
     int v2DotV1 = v2.vecDot(v1); // v1[0] * v2[0] + v1[1] * v2[1] + v1[2] * v2[2];
     float v1V2Sin = sqrtf((float)(v1Norm2 * v2Norm2 - v2DotV1 * v2DotV1));
    
     Vec3fi a1(1.0 / sqrtf((float)v1Norm2), v1.vec);
     Vec3fi a2(1.0 / (v1Norm2 * v1V2Sin),   v1Norm2 * v2.vec - v2DotV1 * v1.vec);
     Vec3fi a3 = v1.cross(v2);
     a3.scale = 1.0/v1V2Sin;
     // Remove common factors
     a1.factor();
     a2.factor();
     a3.factor();
     // Reorder as a rigt handed coordinate system with a1 in RGB. If a1 is in RGB the all components are positive.
     if (a1.vec[0] > 0 && a1.vec[1] > 0 && a1.vec[2] > 0) {
         
         // Then a1.vec is in RGB. Do nothing.
         if (a1.scale < 0.0) {
             // a1 is pointing in the wrong direction flip the sign and correct the product a1 x a2 = a3.
             a1.scale = a1.scale * -1.0;
             a3.vec = -1 * a3.vec;
         }
         
     }else if (a2.vec[0] > 0 && a2.vec[1] > 0 && a2.vec[2] > 0){
         
         // Then a2.vec is in RGB. Make a2 -> a1, a1 -> a2 and flip sign of a3 to preserve a1 x a2 = a3.
         if (a2.scale < 0.0) {
             // a2 is pointing in the wrong direction flip the sign and correct the product a1 x a2 = a3.
             a2.scale = a2.scale * -1.0;
             a3.vec = -1 * a3.vec;
         }
         std::swap(a1, a2);    // Make a2 -> a1, a1 -> a2.
         a3.vec = -1 * a3.vec; // Flip sign of a3 to preserve a1 x a2 = a3.
         
     }else if (a3.vec[0] > 0 && a3.vec[1] > 0 && a3.vec[2] > 0){
         
         // Then a3.vec is in RGB. Perform cyclic permutation of the vectors. a3 -> a1, a1 -> a2, a2 -> a3.
         if (a3.scale < 0.0) {
             // a3 is pointing in the wrong direction flip the sign and correct the product a1 x a2 = a3.
             a3.scale = a3.scale * -1.0;
             a2.vec = -1 * a2.vec; // a2 chosen arbitarily for sign reversal.
         }
         std::swap(a1, a3);    // Now : a3,a2,a1
         std::swap(a2, a3);    // Now : a3,a1,a2 As desired.

     }
     // Setup internal data
     Ti = Matx33i(a1.vec[0],a1.vec[1],a1.vec[2],a2.vec[0],a2.vec[1],a2.vec[2],a3.vec[0],a3.vec[1],a3.vec[2]);
     
     const int tempBox[] = {0, 1, 0, 0, 0, 1, 1, 1,
                            0, 0, 1, 0, 1, 0, 1, 1,
                            0, 0, 0, 1, 1, 1, 0, 1};
     
     Matx<int, 3, 8> RGBBox(tempBox);
     
     Matx<int, 3, 8> RGBBoxInNew = Ti * RGBBox;
     
     Mat RGBCubeMax, RGBCubeMin;
     
     MaxInRow<int>(RGBBoxInNew, RGBCubeMax);
     MinInRow<int>(RGBBoxInNew, RGBCubeMin);
     
     Matx<int, 3, 1> RGBCubeMax = cv::max(cv::max(cv::max(cv::max(cv::max(cv::max(cv::max(RGBBoxInNew.col(0), RGBBoxInNew.col(1)), RGBBoxInNew.col(2)), RGBBoxInNew.col(3)), RGBBoxInNew.col(4)), RGBBoxInNew.col(5)), RGBBoxInNew.col(6)), RGBBoxInNew.col(7));
     
     Matx<int, 3, 1> RGBCubeMin = cv::min(cv::min(cv::min(cv::min(cv::min(cv::min(cv::min(RGBBoxInNew.col(0), RGBBoxInNew.col(1)), RGBBoxInNew.col(2)), RGBBoxInNew.col(3)), RGBBoxInNew.col(4)), RGBBoxInNew.col(5)), RGBBoxInNew.col(6)), RGBBoxInNew.col(7));
     
     Matx<int, 3, 1> RGBCubeRange = RGBCubeMax - RGBCubeMin;
     
     TMin[0]   = RGBCubeMin(0,0);   TMin[1]   = RGBCubeMin(1,0);   TMin[2]   = RGBCubeMin(2,0);
     TRange[0] = RGBCubeRange(0,0); TRange[1] = RGBCubeRange(1,0); TRange[2] = RGBCubeRange(2,0);
     
    
 }
