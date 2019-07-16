//
//  LeeDDMenuCell.m
//  DOPdemo
//
//  Created by Lee on 2019/7/16.
//  Copyright © 2019 tanyang. All rights reserved.
//

#import "LeeDDMenuCell.h"

@implementation LeeDDMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)cellReuseIdentifierWithTag:(NSInteger)tag {
    return [@"lee.dropdown.menu.cell.identifier-" stringByAppendingFormat:@"%tu", tag];
}
+ (NSString *)cellReuseIdentifier {
    return [self cellReuseIdentifierWithTag:0];
}

@end
