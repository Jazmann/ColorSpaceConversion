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
        int common = gcd(this->vec[0],this->vec[1],this->vec[2]);
        if (common>1){
            Vec3i vecTemp(this->vec[0]/common,this->vec[1]/common,this->vec[2]/common);
            this->vec = vecTemp;
                scale = scale*common;
        };
    }
    
};




class ColorSpace {
    
    Matx33i Ti;
    Vec3f scale;
    Vec3i TMin; // The minimum value in each row of Ti. This is the lowest component in the new axial vectors expressed in RGB space.
    Vec3i TRange; // TMax - TMin. The highest minus the lowest components of the new axial vectors.
    
    // The transform to the new color space is (Ti vec - 255 TMin)/TRange. 255 is the range of 8bit RGB and can be replaced directly with a different range for 16 and 32 bit RGB spaces. The division by TRange is the direct element wise division and can safely be rounded to recast in the required bit depth.
    
    
    public: ColorSpace(Vec3i, Vec3i, Vec3i);
    
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
    

    
};



 ColorSpace::ColorSpace(Vec3i sp0, Vec3i sp1, Vec3i sp2){
        
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
    
    }
