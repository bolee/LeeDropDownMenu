//
//  LeeDDMenuView.h
//  DOPdemo
//
//  Created by Lee on 2019/7/16.
//  Copyright © 2019 tanyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LeeDDMenuView : UIView
@property (nonatomic, weak) id <LeeDDMenuAppearance> appearance;
@property (nonatomic, weak) id <LeeDDMenuDelegate>  delegate;
@property (nonatomic, weak) id <LeeDDMenuDataSource> dataSource;

- (void)hiddenDropMenuView;
@end

NS_ASSUME_NONNULL_END
