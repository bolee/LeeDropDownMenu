//
//  UIButton+leeDD_ImageTitle.m
//  LeeDropDownMenuDemo
//
//  Created by Lee on 2019/7/16.
//  Copyright © 2019 Lee. All rights reserved.
//

#import "UIButton+leeDD_ImageTitle.h"

@implementation UIButton (leeDD_ImageTitle)
- (void)leeDD_setLayoutStyle:(LeeDDButtonLayoutStyle)style spacing:(CGFloat)spacing {
    self.imageEdgeInsets = UIEdgeInsetsZero;
    self.titleEdgeInsets = UIEdgeInsetsZero;
    // 强制更新布局，以获得最新的 imageView 和 titleLabel 的 frame
    [self layoutIfNeeded];
    CGRect titleFrame = self.titleLabel.frame;
    CGRect imageFrame = self.imageView.frame;
    
    switch (style) {
        case LeeDDButtonLayoutStyleImageLeft: {
            // 计算默认的图片文字间距
            CGFloat originalSpacing = titleFrame.origin.x - (imageFrame.origin.x + imageFrame.size.width);
            // 调整文字的位置
            self.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                    -(originalSpacing - spacing),
                                                    0,
                                                    (originalSpacing - spacing));
            
        }
            break;
            
        case LeeDDButtonLayoutStyleImageRight: {
            // 图片右移
            self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                    titleFrame.size.width + spacing,
                                                    0,
                                                    -(titleFrame.size.width + spacing));
            // 文字左移
            self.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                    -(titleFrame.origin.x - imageFrame.origin.x),
                                                    0,
                                                    titleFrame.origin.x - imageFrame.origin.x);
        }
            break;
            
        case LeeDDButtonLayoutStyleImageTop: {
            // 图片上移，右移
            self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                    0,
                                                    titleFrame.size.height + spacing,
                                                    -(titleFrame.size.width));
            
            // 文字下移，左移
            self.titleEdgeInsets = UIEdgeInsetsMake(imageFrame.size.height + spacing,
                                                    -(imageFrame.size.width),
                                                    0,
                                                    0);
            
        }
            break;
            
        case LeeDDButtonLayoutStyleImageBottom: {
            // 图片下移，右移
            self.imageEdgeInsets = UIEdgeInsetsMake(titleFrame.size.height + spacing,
                                                    0,
                                                    0,
                                                    -(titleFrame.size.width));
            
            // 文字上移，左移
            self.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                    -(imageFrame.size.width),
                                                    imageFrame.size.height + spacing,
                                                    0);
            
        }
            break;
            
        default:
        {
            self.imageEdgeInsets = UIEdgeInsetsZero;
            self.titleEdgeInsets = UIEdgeInsetsZero;
        }
            break;
    }
}
@end
