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

@end

NS_ASSUME_NONNULL_END
