//
//  ViewController.m
//  LeeDropDownMenuDemo
//
//  Created by Lee on 2019/7/16.
//  Copyright © 2019 Lee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<LeeDDMenuDelegate, LeeDDMenuAppearance, LeeDDMenuDataSource>
@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong) NSArray * menuTitles;
@property (nonatomic, strong) NSArray * sortTitles;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    LeeDDMenuView * menuView = [[LeeDDMenuView alloc] initWithFrame:CGRectMake(0, 100, self.view.leeDD_width, 40)];
    [self.view addSubview:menuView];
    menuView.delegate = self;
    menuView.dataSource = self;
    menuView.appearance = self;
    menuView.backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    menuView.hiddenTapBackground = YES;
    
    NSArray * menu1Data = @[@"下单", @"店铺总数", @"GMV"];
    NSArray * menu2Data = @[@"全国", @"杭州", @"苏州", @"武汉"];
    self.dataSource = @[menu1Data, menu2Data];
    self.menuTitles = @[@"筛选", @"城市"];
    self.sortTitles = @[@"升序", @"降序"];
    
    
    UIView * blueView = [[UIView alloc] initWithFrame:CGRectMake(10, 150, 200, 300)];
    blueView.backgroundColor = UIColor.blueColor;
    [self.view addSubview:blueView];
    
    UIView * redView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 100, 200)];
    redView.backgroundColor = UIColor.redColor;
    [blueView addSubview:redView];
    
    UIView * pupView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    pupView.backgroundColor = UIColor.purpleColor;
    [redView addSubview:pupView];
    
    CGPoint p = [pupView convertPoint:pupView.LeeDD_origin toView:self.view];
    NSLog(@"pppp=%@", NSStringFromCGPoint(p));
}

#pragma mark - LeeDD datasource
- (NSInteger)numberOfMenus:(LeeDDMenuView *)menu {
    return self.dataSource.count;
}
- (NSInteger)numberOfColumns:(LeeDDMenuView *)menu menu:(NSInteger)menuIndex {
    return 0 == menuIndex ? 2 : 1;
}

- (NSInteger)numberOfRows:(LeeDDMenuView *)menu column:(NSInteger)column menu:(NSInteger)menuIndex {
    if (1 == column) {
        return 0 == menuIndex ? 2 : 0;
    }
    return [[self.dataSource objectAtIndex:menuIndex] count];
}

- (NSString *)menu:(LeeDDMenuView *)menu menuTitleForMenu:(NSInteger)menuIndex {
//    return [@"标题" stringByAppendingFormat:@"%tu", menuIndex];
    return [self.menuTitles objectAtIndex:menuIndex];
}

- (NSString *)menu:(LeeDDMenuView *)menu titleForRowAtIndexPath:(LeeDDMenuIndexPath *)indexPath {
//    return [@"menu" stringByAppendingFormat:@":%tu,column:%tu,cell:%tu", indexPath.menu, indexPath.column, indexPath.row];
    if (1 == indexPath.column) {
        return [self.sortTitles objectAtIndex:indexPath.row];
    }
    return [[self.dataSource objectAtIndex:indexPath.menu] objectAtIndex:indexPath.row];
}
- (LeeDDMenuTitleAlignment)menu:(LeeDDMenuView *)menu cellTitleAlignment:(NSInteger)column menuIndex:(NSInteger)menuIndex {
//    return 0 == menuIndex ? LeeDDMenuTitleAlignmentLeft : LeeDDMenuTitleAlignmentCenter;
    return LeeDDMenuTitleAlignmentLeft;
}
- (UIColor *)menu:(LeeDDMenuView *)menu cellTitleColor:(NSInteger)column menuIndex:(NSInteger)menuIndex {
    return UIColor.blackColor;
}
- (UIColor *)menu:(LeeDDMenuView *)menu cellSelectTitleColor:(NSInteger)column menuIndex:(NSInteger)menuIndex {
    return UIColor.blueColor;
}
- (UIFont *)menu:(LeeDDMenuView *)menu textFont:(NSInteger)menuIndex {
    return [UIFont boldSystemFontOfSize:16];
}
- (UIColor *)menu:(LeeDDMenuView *)menu textColor:(NSInteger)menuIndex {
    return UIColor.blueColor;
}
- (UIColor *)menu:(LeeDDMenuView *)menu indicatorColor:(NSInteger)menuIndex {
    return UIColor.blueColor;
}
- (CGFloat)menu:(LeeDDMenuView *)menu leftMargin:(LeeDDMenuIndexPath *)indexPath {
    return 0 == indexPath.column ? 16 : 0;
}
- (BOOL)menu:(LeeDDMenuView *)menu setSelect:(LeeDDMenuIndexPath *)indexPath {
    if (0 == indexPath.row) {
        return YES;
    }
    return NO;
}
- (CGFloat)heightForBackground {
    return self.view.leeDD_height;
}
- (CGFloat)menu:(LeeDDMenuView *)menu heightForRowAtColumn:(NSInteger)column menuIndex:(NSInteger)menuIndex {
    return 40;
}
- (CGFloat)heightForDropView:(LeeDDMenuView *)menu {
    return 160;
}

@end
