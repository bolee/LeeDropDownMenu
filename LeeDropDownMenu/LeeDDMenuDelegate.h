//
//  LeeDDMenuDelegate.h
//  DOPdemo
//
//  Created by Lee on 2019/7/16.
//  Copyright © 2019 tanyang. All rights reserved.
//
// 事件代理
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LeeDDMenuView;
@class LeeDDMenuIndexPath;
@protocol LeeDDMenuCellProtocol;

@protocol LeeDDMenuDelegate <NSObject>
@optional
- (CGFloat)menu:(LeeDDMenuView *)menu heightForRowAtColumn:(NSInteger)column menuIndex:(NSInteger)menuIndex;
- (CGFloat)menu:(LeeDDMenuView *)menu widthForRowAtColumn:(NSInteger)column menuIndex:(NSInteger)menuIndex;
- (CGFloat)heightForDropView:(LeeDDMenuView *)menu; //下拉选项高度
- (CGFloat)widthForDropView:(LeeDDMenuView *)menu; //下拉选项宽度，默认屏幕宽度
- (CGFloat)heightForBackground; //选择区的背景高度
- (void)menu:(LeeDDMenuView *)menu willDisplayCell:(id<LeeDDMenuCellProtocol>)cell indexPath:(LeeDDMenuIndexPath *)indexPath;
- (void)menu:(LeeDDMenuView *)menu didSelectCell:(id<LeeDDMenuCellProtocol>)cell indexPath:(LeeDDMenuIndexPath* )indexPath;
- (BOOL)menu:(LeeDDMenuView *)menu setSelect:(LeeDDMenuIndexPath *)indexPath; //设置选项
- (void)menu:(LeeDDMenuView *)menu didSelectMenu:(NSInteger)menuIndex menuButton:(UIButton *)button; //点击menu

@end

NS_ASSUME_NONNULL_END
