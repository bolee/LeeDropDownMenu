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
- (UIColor *)menu:(LeeDDMenuView *)menu textColor:(NSInteger)menuIndex;
- (UIFont *)menu:(LeeDDMenuView *)menu textFont:(NSInteger)menuIndex;
- (UIColor *)menu:(LeeDDMenuView *)menu selectTextColor:(NSInteger)menuIndex;
- (UIFont *)menu:(LeeDDMenuView *)menu selectTextFont:(NSInteger)menuIndex;
- (LeeDDMenuTitleAlignment)menu:(LeeDDMenuView *)menu textAlignment:(NSInteger)menuIndex;
- (CGFloat)menu:(LeeDDMenuView *)menu indicatorSpace:(NSInteger)menuIndex; //标题右边小箭头和标题的间距
- (UIColor *)menu:(LeeDDMenuView *)menu indicatorColor:(NSInteger)menuIndex;//标题右边小箭头颜色
- (UIColor *)menu:(LeeDDMenuView *)menu lineColor:(NSInteger)menuIndex;
- (UIEdgeInsets)menu:(LeeDDMenuView *)menu lineEdgeInsets:(NSInteger)menuIndex;

// cell，选项表格属性
- (UIColor *)menu:(LeeDDMenuView *)menu cellTitleColor:(NSInteger)column menuIndex:(NSInteger)menuIndex;
- (UIFont *)menu:(LeeDDMenuView *)menu cellTitleFont:(NSInteger)column menuIndex:(NSInteger)menuIndex;
- (UIColor *)menu:(LeeDDMenuView *)menu cellSelectTitleColor:(NSInteger)column menuIndex:(NSInteger)menuIndex;
- (UIFont *)menu:(LeeDDMenuView *)menu cellSelectTitleFont:(NSInteger)column menuIndex:(NSInteger)menuIndex;
- (LeeDDMenuTitleAlignment)menu:(LeeDDMenuView *)menu cellTitleAlignment:(NSInteger)column menuIndex:(NSInteger)menuIndex;
- (CGFloat)menu:(LeeDDMenuView *)menu leftMargin:(LeeDDMenuIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
