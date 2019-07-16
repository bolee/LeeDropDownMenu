//
//  LeeDDMenuCell.h
//  DOPdemo
//
//  Created by Lee on 2019/7/16.
//  Copyright © 2019 tanyang. All rights reserved.
//
// 显示cell，只要实现协议即可，这里协议暂为空
#import <UIKit/UIKit.h>

#import "LeeDDMenuAppearance.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LeeDDMenuCellProtocol <NSObject>
@property (nonatomic, assign) LeeDDMenuTitleAlignment titleAlignment;
@property (nonatomic, assign) CGFloat leftMargin; //LeeDDMenuTitleAlignmentLeft才有效
+ (NSString *)cellReuseIdentifier;
+ (NSString *)cellReuseIdentifierWithTag:(NSInteger)tag;
@end

@interface LeeDDMenuCell : UITableViewCell<LeeDDMenuCellProtocol>
@end

NS_ASSUME_NONNULL_END
