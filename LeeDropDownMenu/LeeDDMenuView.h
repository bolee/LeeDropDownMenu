//
//  LeeDDMenuView.h
//  DOPdemo
//
//  Created by Lee on 2019/7/16.
//  Copyright © 2019 tanyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeeDDMenuAppearance.h"
#import "LeeDDMenuDelegate.h"
#import "LeeDDMenuDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface LeeDDMenuView : UIView
@property (nonatomic, weak) id <LeeDDMenuAppearance> appearance;
@property (nonatomic, weak) id <LeeDDMenuDelegate>  delegate;
@property (nonatomic, weak) id <LeeDDMenuDataSource> dataSource;
@property (nonatomic, strong, readonly) UIView * backgroundView;
@property (nonatomic, assign) BOOL hiddenTapBackground;
@property (nonatomic, assign) BOOL showSelectView; //是否显示选择框
/**
 重复点击按钮是否隐藏，默认YES
 */
@property (nonatomic, assign) BOOL hiddenRepeatClick;


/**
 隐藏下拉选项
 */
- (void)hiddenDropMenuView;

/**
 下面选项列表view

 @return uiview
 */
- (UIView *)selectView;


/**
 下拉选项列表显示位置，默认显示到menuView的子控件

 @param toView 显示父view
 */
- (void)showToView:(UIView *)toView;


/**
 刷新menu
 */
- (void)reloadMenuData;

@end

NS_ASSUME_NONNULL_END
