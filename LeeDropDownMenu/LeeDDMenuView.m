//
//  LeeDDMenuView.m
//  DOPdemo
//
//  Created by Lee on 2019/7/16.
//  Copyright © 2019 tanyang. All rights reserved.
//

#import "LeeDDMenuView.h"
#import "LeeDDMenuCell.h"
#import "UIView+leeDDExtension.h"
#import "UIButton+leeDD_ImageTitle.h"
#import "LeeDDMenuIndexPath.h"
#import "UIImage+leeDD_Bundle.h"
#import "UIImage+pp_TintColor.h"

#define kLeeDDScreeWidth UIApplication.sharedApplication.keyWindow.frame.size.width

#define kLeeDDDefaultTitleHeight 50 //menu默认高度
#define kLeeDDDefaultViewHeight 300 //下拉选择界面默认高度
#define kLeeDDRowHeight 44

@interface LeeDDMenuView () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
//@property (nonatomic, strong) NSHashTable * tableViews;
// TODO: 目前用UITableView实现，暂时支持一个和两个，不支持无限个，
//      如果需要无限个，则不能使用taleView实现
@property (nonatomic, strong) UITableView * leftTableView;
@property (nonatomic, strong) UITableView * rightTableView;
@property (nonatomic, strong) UILabel * menuUpLine; //菜单上面的线
@property (nonatomic, strong) UILabel * menuDownLine; //菜单下面的线
@property (nonatomic, assign) CGRect titleFrame; //menu
@property (nonatomic, assign) CGRect viewFrame; //选择项高度
@property (nonatomic, strong) UIView * dropView;
@property (nonatomic, strong) NSMutableDictionary<NSString *, LeeDDMenuIndexPath *> * selectIndexPath;
@property (nonatomic, assign) NSInteger currentMenuIndex; //
@property (nonatomic, strong, readwrite) UIView * backgroundView;
@property (nonatomic, weak) UIView * dropDownSuperView; //显示下拉选项的父视图
@end

@implementation LeeDDMenuView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleFrame = frame;
    }
    return self;
}
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.titleFrame = frame;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    // 识别是否初始化
    if (!_leftTableView) {
        @synchronized (self) {
            [self _initData];
        }
    }
}

#pragma mark - init

- (void)_initData {
    self.hiddenRepeatClick = YES;
    self.hiddenTapBackground = YES;
    if (self.frame.size.width <= 0 || self.frame.size.height <= 0) {
        self.titleFrame = CGRectMake(0, 0, kLeeDDScreeWidth, kLeeDDDefaultTitleHeight);
    }
    CGFloat vHeight = kLeeDDDefaultViewHeight;
    CGFloat vWidth = self.leeDD_width;
    if (self.delegate && [self.delegate respondsToSelector:@selector(heightForSelectView:menuIndex:)]) {
        vHeight = [self.delegate heightForSelectView:self menuIndex:self.currentMenuIndex];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(widthForSelectView:menuIndex:)]) {
        vWidth = [self.delegate widthForSelectView:self menuIndex:self.currentMenuIndex];
    }
    self.viewFrame = CGRectMake(0, self.leeDD_bottom, vWidth, vHeight);
    
    // menu count
    NSInteger menuCount = 1;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfMenus:)]) {
        menuCount = [self.dataSource numberOfMenus:self];
    }
    
    // init menu view
    CGFloat defaultMenuWidth = self.viewFrame.size.width / menuCount; //默认选项列表平等分
    CGFloat lastRight = 0;
    for (NSInteger i = 0; i < menuCount; i++) {
        CGFloat menuWidth = defaultMenuWidth;
        if (self.delegate && [self.delegate respondsToSelector:@selector(menu:widthForMenu:)]) {
            menuWidth = [self.delegate menu:self widthForMenu:i];
        }
        UIButton * menuButton = [[UIButton alloc] initWithFrame:CGRectMake(lastRight, 0, menuWidth, self.titleFrame.size.height)];
        [menuButton setTitle:[self.dataSource menu:self menuTitleForMenu:i] forState:UIControlStateNormal];
        [menuButton setImage:[self _setIndicatorTintColor: [UIImage LeeDD_imageNamed:@"arrow_down"]] forState:UIControlStateNormal];
        UIColor * textColor = UIColor.blackColor;
        if (self.appearance && [self.appearance respondsToSelector:@selector(menu:textColor:)]) {
            textColor = [self.appearance menu:self textColor:i];
        }
        if (self.appearance && [self.appearance respondsToSelector:@selector(menu:textFont:)]) {
            menuButton.titleLabel.font = [self.appearance menu:self textFont:self.currentMenuIndex];
        }
        [menuButton setTitleColor:textColor forState:UIControlStateNormal];
        
        menuButton.tag = i + 1; //
        
        [menuButton leeDD_setLayoutStyle:LeeDDButtonLayoutStyleImageRight spacing:[self _menuIndicatorSpace:i]];
        [menuButton addTarget:self action:@selector(_menuAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuButton];
        lastRight = menuButton.right;
    }
    // 上下的线
    [self addSubview:self.menuUpLine];
    [self addSubview:self.menuDownLine];
    if (self.appearance && [self.appearance respondsToSelector:@selector(menu:lineColor:)]) {
        self.menuUpLine.backgroundColor = [self.appearance menu:self lineColor:self.currentMenuIndex];
        self.menuDownLine.backgroundColor = [self.appearance menu:self lineColor:self.currentMenuIndex];
    }
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    if (self.appearance && [self.appearance respondsToSelector:@selector(menu:lineEdgeInsets:)]) {
       edgeInsets = [self.appearance menu:self lineEdgeInsets:self.currentMenuIndex];
    }
    self.menuUpLine.frame = CGRectMake(edgeInsets.left, edgeInsets.top, self.leeDD_width - edgeInsets.left - edgeInsets.right, 1);
    self.menuDownLine.frame = CGRectMake(edgeInsets.left, self.leeDD_height - edgeInsets.bottom - 1, self.leeDD_width - edgeInsets.left - edgeInsets.right, 1);
    
    [self.dropView addSubview:self.backgroundView];
    CGFloat bgHeight = self.dropView.leeDD_height;
    if (self.delegate && [self.delegate respondsToSelector:@selector(heightForBackground)]) {
        bgHeight = [self.delegate heightForBackground];
    }
    self.backgroundView.frame = CGRectMake(0, 0, self.dropView.leeDD_width, bgHeight);
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapGesture:)];
    tapGesture.delegate = self;
    [self.backgroundView addGestureRecognizer:tapGesture];
    
    [self.dropView addSubview:self.leftTableView];
    [self.dropView addSubview:self.rightTableView];
    // 初始化表格和dropView一样高，默认有2列，需要点击menu按钮时候才重新设置尺寸
    self.leftTableView.frame = CGRectMake(0, 0, self.leeDD_width / 2.0, self.viewFrame.size.height);
    self.rightTableView.frame = CGRectMake(self.leftTableView.leeDD_right, 0, self.leftTableView.leeDD_width, self.leftTableView.leeDD_height);
    // add drop view
    if (self.dropDownSuperView) {
        [self.dropDownSuperView addSubview:self.dropView];
    } else {
        UIView * superView = self.superview;
        [superView addSubview:self.dropView];
    }
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource numberOfRows:self column:tableView.tag - 1 menu:self.currentMenuIndex];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = kLeeDDRowHeight;
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:heightForRowAtColumn:menuIndex:)]) {
        height = [self.delegate menu:self heightForRowAtColumn:tableView.tag - 1 menuIndex:self.currentMenuIndex];
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(menu:withTableView:cellForIndexPath:)]) {
        return [self.dataSource menu:self withTableView:tableView cellForIndexPath:[LeeDDMenuIndexPath initPathWithColumn:tableView.tag - 1 withRow:indexPath.row withMenuIndex:self.currentMenuIndex]];
    }
    LeeDDMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:[LeeDDMenuCell cellReuseIdentifier]];
    if (!cell) {
        cell = [[LeeDDMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[LeeDDMenuCell cellReuseIdentifier]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:willDisplayCell:indexPath:)]) {
        [self.delegate menu:self willDisplayCell:(id<LeeDDMenuCellProtocol>)cell indexPath:[LeeDDMenuIndexPath initPathWithColumn:tableView.tag - 1 withRow:indexPath.row withMenuIndex:self.currentMenuIndex]];
    }
    cell.textLabel.text = [self.dataSource menu:self titleForRowAtIndexPath:[LeeDDMenuIndexPath initPathWithColumn:tableView.tag - 1 withRow:indexPath.row withMenuIndex:self.currentMenuIndex]];
    
    //set cell
    id<LeeDDMenuCellProtocol> dCell = (id<LeeDDMenuCellProtocol>)cell;
    if (self.appearance && [self.appearance respondsToSelector:@selector(menu:cellTitleColor:menuIndex:)]) {
        cell.textLabel.textColor = [self.appearance menu:self cellTitleColor:tableView.tag - 1 menuIndex:self.currentMenuIndex];
    }
    if (self.appearance && [self.appearance respondsToSelector:@selector(menu:cellTitleFont:menuIndex:)]) {
        cell.textLabel.font = [self.appearance menu:self cellTitleFont:tableView.tag - 1 menuIndex:self.currentMenuIndex];
    }
    if (self.appearance && [self.appearance respondsToSelector:@selector(menu:cellTitleAlignment:menuIndex:)]) {
        dCell.titleAlignment = [self.appearance menu:self cellTitleAlignment:tableView.tag - 1 menuIndex:self.currentMenuIndex];
    }
    if (self.appearance && [self.appearance respondsToSelector:@selector(menu:leftMargin:)]) {
        dCell.leftMargin = [self.appearance menu:self leftMargin:[LeeDDMenuIndexPath initPathWithColumn:tableView.tag - 1 withRow:indexPath.row withMenuIndex:self.currentMenuIndex]];
    }
    
    // 代理设置是否选中
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:setSelect:)]) {
        BOOL isSelect = [self.delegate menu:self setSelect:[LeeDDMenuIndexPath initPathWithColumn:tableView.tag - 1 withRow:indexPath.row withMenuIndex:self.currentMenuIndex]];
        if (isSelect && self.appearance && [self.appearance respondsToSelector:@selector(menu:cellSelectTitleColor:menuIndex:)]) {
            cell.textLabel.textColor = [self.appearance menu:self cellSelectTitleColor:tableView.tag - 1 menuIndex:self.currentMenuIndex];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:didSelectCell:indexPath:)]) {
        [self.delegate menu:self didSelectCell:(id<LeeDDMenuCellProtocol>)[tableView cellForRowAtIndexPath:indexPath] indexPath:[LeeDDMenuIndexPath initPathWithColumn:tableView.tag - 1 withRow:indexPath.row withMenuIndex:self.currentMenuIndex]];
    }
    // 点击右边一个需要隐藏掉
    if (self.rightTableView.hidden || self.rightTableView == tableView) {
        [self hiddenDropMenuView];
        
    } else {
        // 显示下一个
        [self.rightTableView reloadData];
    }
    NSString * selectIndex = [NSString stringWithFormat:@"Menu:%tu-Column:%tu", self.currentMenuIndex, tableView.tag - 1];
    LeeDDMenuIndexPath * lastIndexPath = [self.selectIndexPath objectForKey:selectIndex];
    if (lastIndexPath && self.appearance && [self.appearance respondsToSelector:@selector(menu:cellTitleColor:menuIndex:)]) {
        UITableViewCell * lastCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:lastIndexPath.row inSection:0]];
        lastCell.textLabel.textColor = [self.appearance menu:self cellTitleColor:tableView.tag - 1 menuIndex:self.currentMenuIndex];
    }
    // 保存选中索引
    [self.selectIndexPath setObject:[LeeDDMenuIndexPath initPathWithColumn:tableView.tag - 1 withRow:indexPath.row withMenuIndex:self.currentMenuIndex] forKey:selectIndex];
    if (self.appearance && [self.appearance respondsToSelector:@selector(menu:cellTitleColor:menuIndex:)]) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = [self.appearance menu:self cellSelectTitleColor:tableView.tag - 1 menuIndex:self.currentMenuIndex];
    }
}

#pragma mark - private method
- (CGFloat)_menuIndicatorSpace:(NSInteger)menuIndex {
    CGFloat space = 3;
    if (self.appearance && [self.appearance respondsToSelector:@selector(menu:indicatorSpace:)]) {
        space = [self.appearance menu:self indicatorSpace:menuIndex];
    }
    return space;
}
- (void)_tapGesture:(UITapGestureRecognizer *)gesture {
    if (self.hiddenTapBackground) {
        [self hiddenDropMenuView];
    }
}
- (void)_showDropView {
    self.dropView.hidden = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:selectViewStatus:)]) {
        [self.delegate menu:self selectViewStatus:YES];
    }
}
- (UIImage *)_setIndicatorTintColor:(UIImage *)img {
    UIColor * tintColor = nil;
    if (self.appearance && [self.appearance respondsToSelector:@selector(menu:indicatorColor:)]) {
        tintColor = [self.appearance menu:self indicatorColor:self.currentMenuIndex];
    }
    if (tintColor) {
        return [img LeeDD_imageByTintColor:tintColor];
    }
    return img;
}

- (void)_setDropViewFrame {
    // 判断是否加载其他view上
    CGFloat bgHeight = self.dropView.leeDD_height;
    if (self.delegate && [self.delegate respondsToSelector:@selector(heightForBackground)]) {
        bgHeight = [self.delegate heightForBackground];
    }
    if (self.dropDownSuperView && self.superview != self.dropDownSuperView) {
        // 需要映射位置
        CGRect sFrame = [self.dropDownSuperView convertRect:self.frame fromView:self.superview];
        self.dropView.frame= CGRectMake(0, sFrame.origin.y + sFrame.size.height, sFrame.size.width, bgHeight);
    } else {
        self.dropView.frame = CGRectMake(0, self.leeDD_bottom, self.leeDD_width, bgHeight);
    }
}

#pragma mark - Method
- (UIView *)selectView {
    return self.dropView;
}
- (void)showToView:(UIView *)toView {
    self.dropDownSuperView = toView;
    if (!_leftTableView) {
        @synchronized (self) {
            [self _initData];
        }
    }
}
- (void)reloadMenuData {
    CGFloat menuIndicatorSpace = 3;
    if (self.appearance && [self.appearance respondsToSelector:@selector(menu:indicatorSpace:)]) {
        menuIndicatorSpace = [self.appearance menu:self indicatorSpace:self.currentMenuIndex];
    }
    for (UIView * sv in self.subviews) {
        if ([sv isKindOfClass:UIButton.class]) {
            UIButton * menuButton = (UIButton *)sv;
            [menuButton setTitle:[self.dataSource menu:self menuTitleForMenu:menuButton.tag - 1] forState:UIControlStateNormal];
            [menuButton leeDD_setLayoutStyle:LeeDDButtonLayoutStyleImageRight spacing:menuIndicatorSpace];
        }
    }
}
#pragma mark - private action
- (void)_menuAction:(UIButton *)sender {
    // TODO: 回调的menuIndex和self.currentMenuIndex不一致
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:didSelectMenu:menuButton:)]) {
        [self.delegate menu:self didSelectMenu:sender.tag - 1 menuButton:sender];
    }
    if (!self.dropView.isHidden) {
        [self hiddenDropMenuView];
        if (self.hiddenRepeatClick) {
            // 重复点击，是否隐藏
            // TODO: 图片显示错误
            UIButton * lastButton = [self viewWithTag:self.currentMenuIndex + 1];
            [lastButton setImage:[self _setIndicatorTintColor:[UIImage LeeDD_imageNamed:@"arrow_down"]] forState:UIControlStateNormal];
            [lastButton leeDD_setLayoutStyle:LeeDDButtonLayoutStyleImageRight spacing:[self _menuIndicatorSpace:self.currentMenuIndex]];
            return;
        }
    }
    if (!self.dropView.isHidden && sender.tag - 1 == self.currentMenuIndex) {
        // 点击同一个不做操作
        return;
    }
    if (self.currentMenuIndex != sender.tag - 1) {
        UIButton * lastButton = [self viewWithTag:self.currentMenuIndex + 1];
        [lastButton setImage:[self _setIndicatorTintColor:[UIImage LeeDD_imageNamed:@"arrow_down"]] forState:UIControlStateNormal];
        [lastButton leeDD_setLayoutStyle:LeeDDButtonLayoutStyleImageRight spacing:[self _menuIndicatorSpace:self.currentMenuIndex]];
    }
    
    [sender setImage:[self _setIndicatorTintColor:[UIImage LeeDD_imageNamed:@"arrow_up"]] forState:UIControlStateNormal];
    [sender leeDD_setLayoutStyle:LeeDDButtonLayoutStyleImageRight spacing:[self _menuIndicatorSpace:sender.tag - 1]];
    self.currentMenuIndex = sender.tag - 1;
    
    // 检测列数
    NSInteger column = 2;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfColumns:menu:)]) {
        column = [self.dataSource numberOfColumns:self menu:self.currentMenuIndex];
    }
    if (column <= 0) {
        return;
    } else if (column <= 1) {
        self.rightTableView.hidden = YES;
    } else {
        self.rightTableView.hidden = NO;
    }
    
    // 高度
    CGFloat tblHeight = self.viewFrame.size.height;
    if (self.delegate && [self.delegate respondsToSelector:@selector(heightForSelectView:menuIndex:)]) {
        tblHeight = [self.delegate heightForSelectView:self menuIndex:self.currentMenuIndex];
    }
    // 宽度
    CGFloat leftWidth = self.rightTableView.isHidden ? self.leeDD_width : self.leeDD_width / 2.0;
    CGFloat rightWidth = self.rightTableView.isHidden ? 0 : leftWidth;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:widthForRowAtColumn:menuIndex:)]) {
        leftWidth = [self.delegate menu:self widthForRowAtColumn:0 menuIndex:self.currentMenuIndex];
        rightWidth = [self.delegate menu:self widthForRowAtColumn:1 menuIndex:self.currentMenuIndex];
    }
    self.leftTableView.frame = CGRectMake(0, 0, leftWidth, tblHeight);
    
    if (!self.rightTableView.hidden) {
        self.rightTableView.frame = CGRectMake(self.leftTableView.leeDD_right, self.leftTableView.leeDD_top, rightWidth, self.leftTableView.leeDD_height);
    }
    [self.leftTableView reloadData];
    if (!self.rightTableView.isHidden) {
        [self.rightTableView reloadData];
    }
    [self _setDropViewFrame];
    [self _showDropView];
}

#pragma mark - Action
- (void)hiddenDropMenuView {
    self.dropView.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:selectViewStatus:)]) {
        [self.delegate menu:self selectViewStatus:NO];
    }
    // 还原menu图标
    PPBaseButton * button = [self viewWithTag:self.currentMenuIndex + 1];
    [button setImage:[self _setIndicatorTintColor:[UIImage LeeDD_imageNamed:@"arrow_down"]] forState:UIControlStateNormal];
    [button leeDD_setLayoutStyle:LeeDDButtonLayoutStyleImageRight spacing:[self _menuIndicatorSpace:self.currentMenuIndex]];
}


#pragma mark - Var
- (BOOL)showSelectView {
    return !self.dropView.isHidden;
}
- (UIView *)dropView {
    if (!_dropView) {
        _dropView = [[UIView alloc] initWithFrame:self.viewFrame];
        _dropView.backgroundColor = UIColor.clearColor;
        _dropView.hidden = YES;
    }
    return _dropView;
}
- (NSMutableDictionary<NSString *,LeeDDMenuIndexPath *> *)selectIndexPath {
    if (!_selectIndexPath) {
        _selectIndexPath = [@{} mutableCopy];
    }
    return _selectIndexPath;
}
- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [self _generateTableView];
        _leftTableView.tag = 1;
    }
    return _leftTableView;
}
- (UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView = [self _generateTableView];
        _rightTableView.tag = 2;
    }
    return _rightTableView;
}
- (UITableView *)_generateTableView {
    UITableView * tblView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tblView.showsVerticalScrollIndicator = NO;
    tblView.showsHorizontalScrollIndicator = NO;
    tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblView.delegate = self;
    tblView.dataSource = self;
    return tblView;
}
- (UILabel *)menuUpLine {
    if (!_menuUpLine) {
        _menuUpLine = [UILabel new];
        _menuUpLine.backgroundColor = UIColor.lightGrayColor;
    }
    return _menuUpLine;
}
- (UILabel *)menuDownLine {
    if (!_menuDownLine) {
        _menuDownLine = [UILabel new];
        _menuDownLine.backgroundColor = UIColor.lightGrayColor;
    }
    return _menuDownLine;
}
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    }
    return _backgroundView;
}
@end
