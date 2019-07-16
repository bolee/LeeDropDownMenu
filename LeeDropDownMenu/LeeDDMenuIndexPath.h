//
//  LeeDDMenuIndexPath.h
//  DOPdemo
//
//  Created by Lee on 2019/7/16.
//  Copyright © 2019 tanyang. All rights reserved.
//
// 选择项索引
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LeeDDMenuIndexPath : NSObject
@property (nonatomic, assign) NSInteger column; //列
@property (nonatomic, assign) NSInteger row; //行

- (instancetype)initPathWithColumn:(NSInteger)column withRow:(NSInteger)row;
+ (instancetype)initPathWithColumn:(NSInteger)column withRow:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
