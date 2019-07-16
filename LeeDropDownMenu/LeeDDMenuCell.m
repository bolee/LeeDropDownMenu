//
//  LeeDDMenuCell.m
//  DOPdemo
//
//  Created by Lee on 2019/7/16.
//  Copyright © 2019 tanyang. All rights reserved.
//

#import "LeeDDMenuCell.h"
#import "UIView+leeDDExtension.h"

@implementation LeeDDMenuCell
{
    LeeDDMenuTitleAlignment _titleAligment;
    CGFloat _leftMargin;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = self.contentView.frame;
    if (LeeDDMenuTitleAlignmentLeft == self.titleAlignment) {
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.frame = CGRectMake(self.leftMargin, 0, self.contentView.leeDD_width - self.leftMargin, self.contentView.leeDD_height);
    } else if (LeeDDMenuTitleAlignmentCenter == self.titleAlignment) {
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        self.textLabel.textAlignment = NSTextAlignmentRight;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - protocol
- (void)setLeftMargin:(CGFloat)leftMargin {
    _leftMargin = leftMargin;
}
- (CGFloat)leftMargin {
    return _leftMargin;
}
- (void)setTitleAlignment:(LeeDDMenuTitleAlignment)titleAlignment {
    _titleAligment = titleAlignment;
}
- (LeeDDMenuTitleAlignment)titleAlignment {
    return _titleAligment;
}

+ (NSString *)cellReuseIdentifierWithTag:(NSInteger)tag {
    return [@"lee.dropdown.menu.cell.identifier-" stringByAppendingFormat:@"%tu", tag];
}
+ (NSString *)cellReuseIdentifier {
    return [self cellReuseIdentifierWithTag:0];
}

@end
