//
//  LeeDDMenuIndexPath.m
//  DOPdemo
//
//  Created by Lee on 2019/7/16.
//  Copyright © 2019 tanyang. All rights reserved.
//

#import "LeeDDMenuIndexPath.h"

@implementation LeeDDMenuIndexPath
- (instancetype)initPathWithColumn:(NSInteger)column withRow:(NSInteger)row
{
    self = [super init];
    if (self) {
        self.column = column;
        self.row = row;
    }
    return self;
}
+ (instancetype)initPathWithColumn:(NSInteger)column withRow:(NSInteger)row
{
    return [[self alloc] initPathWithColumn:column withRow:row];
}
@end
