//
//  LeeDDMenuAppearance.h
//  DOPdemo
//
//  Created by Lee on 2019/7/16.
//  Copyright © 2019 tanyang. All rights reserved.
//
// UI界面配置
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LeeDDMenuTitleAlignment) {
    LeeDDMenuTitleAlignmentLeft,
    LeeDDMenuTitleAlignmentCenter,
    LeeDDMenuTitleAlignmentRight,
};

@class LeeDDMenuView;
@protocol LeeDDMenuAppearance <NSObject>
@optional
// title：标题显示属性
- (UIColor *)menu:(LeeDDMenuView *)menu textColor:(NSInteger)column;
- (UIFont *)menu:(LeeDDMenuView *)menu textFont:(NSInteger)column;
- (UIColor *)menu:(LeeDDMenuView *)menu selectTextColor:(NSInteger)column;
- (UIFont *)menu:(LeeDDMenuView *)menu selectTextFont:(NSInteger)column;
- (LeeDDMenuTitleAlignment)menu:(LeeDDMenuView *)menu textAlignment:(NSInteger)column;
- (CGFloat)menu:(LeeDDMenuView *)menu indicatorSpace:(NSInteger)column; //标题右边小箭头和标题的间距
- (UIColor *)menu:(LeeDDMenuView *)menu indicatorColor:(NSInteger)column;//标题右边小箭头颜色

// cell，选项表格属性
- (UIColor *)menu:(LeeDDMenuView *)menu cellTitleColor:(NSInteger)column;
- (UIFont *)menu:(LeeDDMenuView *)menu cellTitleFont:(NSInteger)column;
- (UIColor *)menu:(LeeDDMenuView *)menu cellSelectTitleColor:(NSInteger)column;
- (UIFont *)menu:(LeeDDMenuView *)menu cellSelectTitleFont:(NSInteger)column;
- (LeeDDMenuTitleAlignment)menu:(LeeDDMenuTitleAlignment *)menu cellTitleAlignment:(NSInteger)column;

@end

NS_ASSUME_NONNULL_END
