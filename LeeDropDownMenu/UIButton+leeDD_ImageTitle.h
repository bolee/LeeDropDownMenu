//
//  UIButton+leeDD_ImageTitle.h
//  LeeDropDownMenuDemo
//
//  Created by Lee on 2019/7/16.
//  Copyright © 2019 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, LeeDDButtonLayoutStyle) {
    LeeDDButtonLayoutStyleImageLeft,
    LeeDDButtonLayoutStyleImageRight,
    LeeDDButtonLayoutStyleImageTop,
    LeeDDButtonLayoutStyleImageBottom,
    LeeDDButtonLayoutStyleReset,
};
@interface UIButton (leeDD_ImageTitle)
- (void)leeDD_setLayoutStyle:(LeeDDButtonLayoutStyle)style spacing:(CGFloat)spacing;

@end

NS_ASSUME_NONNULL_END
