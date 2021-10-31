#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#import <opencv2/highgui.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "OpenCVManager.h"
#endif
#import <Foundation/Foundation.h>

@implementation OpenCVManager : NSObject

+ (UIImage*)gray:(UIImage*)image {
   cv::Mat img_Mat;  // 配列（Matrix）を用意
   UIImageToMat(image, img_Mat); // UIImageを配列（Matrix）へ変換
   cv::cvtColor(img_Mat, img_Mat, cv::COLOR_BGR2GRAY); // OpenCVメソッドで処理
   return MatToUIImage(img_Mat); // 配列（Matrix）をUIImageに戻す
}

@end
