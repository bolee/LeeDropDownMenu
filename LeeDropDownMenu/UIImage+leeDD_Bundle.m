//
//  UIImage+leeDD_Bundle.m
//  LeeDropDownMenuDemo
//
//  Created by Lee on 2019/7/17.
//  Copyright © 2019 Lee. All rights reserved.
//

#import "UIImage+leeDD_Bundle.h"
#import "LeeDDMenuView.h"

@implementation UIImage (leeDD_Bundle)

+ (UIImage *)LeeDD_imageNamed:(NSString *)name {
    static NSBundle * resourceBunle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString * bundlePath = [[NSBundle bundleForClass:[LeeDDMenuView class]].resourcePath stringByAppendingPathComponent:@"/LeeDropDownMenu.bundle"];
        resourceBunle = [NSBundle bundleWithPath:bundlePath];
    });
    return [UIImage imageNamed:@"arrow_down" inBundle:resourceBunle compatibleWithTraitCollection:nil];
}
@end
