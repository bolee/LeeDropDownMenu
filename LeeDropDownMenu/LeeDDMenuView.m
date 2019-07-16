//
//  LeeDDMenuView.m
//  DOPdemo
//
//  Created by Lee on 2019/7/16.
//  Copyright © 2019 tanyang. All rights reserved.
//

#import "LeeDDMenuView.h"
#import "LeeDDMenuCell.h"

#define kLeeDDScreeWidth UIApplication.sharedApplication.keyWindow.frame.size.width

#define kLeeDDDefaultTitleHeight 50 //menu默认高度
#define kLeeDDDefaultViewHeight 300 //下拉选择界面默认高度
#define kLeeDDRowHeight 44

@interface LeeDDMenuView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSHashTable * tableViews;
@property (nonatomic, assign) CGRect titleFrame; //menu
@property (nonatomic, assign) CGRect viewFrame; //选择项高度
@property (nonatomic, strong) UIView * dropView;
@property (nonatomic, strong) NSMutableArray<LeeDDMenuIndexPath *> * selectIndexPath;

@end

@implementation LeeDDMenuView

#pragma mark - Init
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _initData];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initData];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _initData];
    }
    return self;
}
- (void)_initData {
    if (self.frame.size.width <= 0 || self.frame.size.height <= 0) {
        self.titleFrame = CGRectMake(0, 0, kLeeDDScreeWidth, kLeeDDDefaultTitleHeight);
    }
    CGFloat vHeight = kLeeDDDefaultViewHeight;
    CGFloat vWidth = self.leeDD_width;
    if (self.delegate && [self.delegate respondsToSelector:@selector(heightForDropView:)]) {
        vHeight = [self.delegate heightForDropView:self];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(widthForDropView:)]) {
        vWidth = [self.delegate widthForDropView:self];
    }
    self.viewFrame = CGRectMake(0, self.leeDD_bottom, vWidth, vHeight);
    
    // init tableview
    NSInteger column = 1;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfColumns:)]) {
        column = [self.dataSource numberOfColumns:self];
    }
    CGFloat defaultWidth = self.viewFrame.size.width / column; //默认选项列表平等分
    CGFloat originX = 0;
    for (NSInteger i = 0; i < column; i++) {
        CGFloat tblWidth = defaultWidth;
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:widthForRowAtColumn:)]) {
            tblWidth = [self.delegate menu:self widthForRowAtColumn:i];
        }
        UITableView * tblView = [[UITableView alloc] initWithFrame:CGRectMake(0, originX, tblWidth, self.dropView.leeDD_height) style:UITableViewStylePlain];
        tblView.showsVerticalScrollIndicator = NO;
        tblView.showsHorizontalScrollIndicator = NO;
        tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tblView.delegate = self;
        tblView.dataSource = self;
        tblView.tag = i + 1;
//        if (self.dataSource && [self.dataSource respondsToSelector:@selector(menu:cellIdentifier:)] && [self.dataSource respondsToSelector:@selector(menu:cellIdentifier:)]) {
//            [tblView registerClass:[self.dataSource menu:self cellClass:i] forCellReuseIdentifier:[self.dataSource menu:self cellIdentifier:i]];
//        }
//        [tblView registerClass:LeeDDMenuCell.class forCellReuseIdentifier:[LeeDDMenuCell cellReuseIdentifier]];
        [self.dropView addSubview:tblView];
        [self.tableViews addObject:tblView];
    }
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource numberOfRows:self column:tableView.tag - 1];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = kLeeDDRowHeight;
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:heightForRowAtColumn:)]) {
        height = [self.delegate menu:self heightForRowAtColumn:tableView.tag - 1];
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(menu:withTableView:cellForIndexPath:)]) {
        return [self.dataSource menu:self withTableView:tableView cellForIndexPath:[LeeDDMenuIndexPath initPathWithColumn:tableView.tag - 1 withRow:indexPath.row]];
    }
    LeeDDMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:[LeeDDMenuCell cellReuseIdentifier]];
    if (!cell) {
        cell = [[LeeDDMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[LeeDDMenuCell cellReuseIdentifier]];
        if (self.appearance && [self.appearance respondsToSelector:@selector(menu:cellTitleFont:)]) {
            cell.textLabel.textColor = [self.appearance menu:self cellTitleColor:tableView.tag - 1];
        }
        if (self.appearance && [self.appearance respondsToSelector:@selector(menu:cellTitleFont:)]) {
            cell.textLabel.font = [self.appearance menu:self cellTitleFont:tableView.tag - 1];
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:willDisplayCell:indexPath:)]) {
        [self.delegate menu:self willDisplayCell:(id<LeeDDMenuCellProtocol>)cell indexPath:[LeeDDMenuIndexPath initPathWithColumn:tableView.tag - 1 withRow:indexPath.row]];
    }
    cell.textLabel.text = [self.dataSource menu:self titleForRowAtColumn:tableView.tag - 1];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:didSelectCell:indexPath:)]) {
        [self.delegate menu:self didSelectCell:(id<LeeDDMenuCellProtocol>)[tableView cellForRowAtIndexPath:indexPath] indexPath:[LeeDDMenuIndexPath initPathWithColumn:tableView.tag - 1 withRow:indexPath.row]];
    }
    // 点击最后一个需要隐藏掉
    if (tableView.tag == self.tableViews.count) {
        [self hiddenDropMenuView];
    } else {
        // 显示下一个
        
    }
}

#pragma mark - Action
- (void)hiddenDropMenuView {
    self.dropView.hidden = YES;
}

#pragma mark - Var
- (NSHashTable *)tableViews {
    if (!_tableViews) {
        _tableViews = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPersonality capacity:0];
    }
    return _tableViews;
}
- (UIView *)dropView {
    if (!_dropView) {
        _dropView = [[UIView alloc] initWithFrame:self.viewFrame];
        _dropView.backgroundColor = UIColor.whiteColor;
    }
    return _dropView;
}
- (NSMutableArray<LeeDDMenuIndexPath *> *)selectIndexPath {
    if (!_selectIndexPath) {
        _selectIndexPath = @[].mutableCopy;
    }
    return _selectIndexPath;
}
@end
