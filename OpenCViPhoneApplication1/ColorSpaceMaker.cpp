//
//  ColorSpaceMaker.cpp
//  OpenCViPhoneApplication1
//
//  Created by NBTB on 10/22/12.
//

#include "ColorSpaceMaker.h"
#include <opencv2/core/mat.hpp>

using namespace cv;

typedef Matx<float, 3, 3> Matx33f;
typedef Matx<int, 3, 3> Matx33i;

typedef Vec<float, 3>Vec3f;
typedef Vec<int, 3>Vec3i;


static Matx33f Orthonormalise(Vec3i sp0, Vec3i sp1, Vec3i sp2){
    
    Matx33f test;
    
    Vec3f a1, a2, a3;
    
    Vec3i v1 = sp1 - sp0;
    Vec3i v2 = sp2 - sp0;
    
    int v1Norm2 = (v1[0] * v1[0]) + (v1[1] * v1[1]) + (v1[2] * v1[2]);
    int v2Norm2 = (v2[0] * v2[0]) + (v2[1] * v2[1]) + (v2[2] * v2[2]);
    int v2DotV1 = v1[0] * v2[0] + v1[1] * v2[1] + v1[2] * v2[2];
    
    Vec3i a1Vec = v1;
    Vec3i a2Vec = v1Norm2 * v2 - v2DotV1 * v1;
    Vec3i a3Vec ((v1[1] * v2[2]) - (v1[2] * v2[1]), (v1[2] * v2[0]) - (v1[0] * v2[2]), (v1[0] * v2[1]) - (v1[1] * v2[0]));
    
    float v1V2Sin = sqrtf((float)(v1Norm2 * v2Norm2 - v2DotV1 * v2DotV1));
    
    float a1Scale = 1 / v1Norm2;
    float a2Scale = 1 / (v1Norm2 * v1V2Sin);
    float a3Scale = 1 / v1Norm2 * v2Norm2 - v2DotV1;
    
    
    
    return test;
}

