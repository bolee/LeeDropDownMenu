//
//  LeeDDMenuDataSource.h
//  DOPdemo
//
//  Created by Lee on 2019/7/16.
//  Copyright © 2019 tanyang. All rights reserved.
//
// 数据源代理
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LeeDDMenuView;
@class LeeDDMenuIndexPath;
@protocol LeeDDMenuCellProtocol;

@protocol LeeDDMenuDataSource <NSObject>

@required
- (NSInteger)numberOfRows:(LeeDDMenuView *)menu column:(NSInteger)column menu:(NSInteger)menuIndex;
- (NSString *)menu:(LeeDDMenuView *)menu titleForRowAtIndexPath:(LeeDDMenuIndexPath *)indexPath; // cell标题
- (NSString *)menu:(LeeDDMenuView *)menu menuTitleForMenu:(NSInteger)menuIndex; //menu标题

@optional
- (NSInteger)numberOfMenus:(LeeDDMenuView *)menu; //menu个数
- (NSInteger)numberOfColumns:(LeeDDMenuView *)menu menu:(NSInteger)menuIndex; // menu->column
// tableView 没有调用registerClass，所以不能使用:- (__kindof UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
- (UITableViewCell *)menu:(LeeDDMenuView *)menu withTableView:(UITableView *)tableView cellForIndexPath:(LeeDDMenuIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
