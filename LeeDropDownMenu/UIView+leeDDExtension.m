//
//  UIView+leeDDExtension.m
//  DOPdemo
//
//  Created by Lee on 2019/7/16.
//  Copyright © 2019 tanyang. All rights reserved.
//

#import "UIView+leeDDExtension.h"

@implementation UIView (leeDDExtension)
- (CGFloat)leeDD_left {
    return self.frame.origin.x;
}

- (CGFloat)leeDD_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)leeDD_top {
    return self.frame.origin.y;
}

- (CGFloat)leeDD_bottom {
    return self.frame.origin.y + self.frame.size.height;
}
- (CGFloat)leeDD_width {
    return self.frame.size.width;
}
- (CGFloat)leeDD_height {
    return self.frame.size.height;
}
- (CGFloat)LeeDD_x {
    return self.frame.origin.x;
}
- (CGFloat)LeeDD_y {
    return self.frame.origin.y;
}
- (CGPoint)LeeDD_origin {
    return self.frame.origin;
}
@end
