//
//  UIImage+pp_TintColor.m
//  Pinpin
//
//  Created by Lee on 2019/7/17.
//  Copyright © 2019 杭州拼便宜网络科技有限公司. All rights reserved.
//

#import "UIImage+pp_TintColor.h"

@implementation UIImage (pp_TintColor)
- (UIImage *)LeeDD_imageByTintColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    [color set];
    UIRectFill(rect);
    [self drawAtPoint:CGPointMake(0, 0) blendMode:kCGBlendModeDestinationIn alpha:1];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
