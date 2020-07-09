//
//  LuckyStarReadyViewController.h
//  Demo
//
//  Created by 阮巧华 on 2020/7/6.
//  Copyright © 2020 阮巧华. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LuckyStarReadyViewController : UIViewController

@property (nonatomic, copy) void(^startBtnDidClick)(LuckyStarReadyViewController *, NSUInteger userCount, NSUInteger moneyCount);

@end

NS_ASSUME_NONNULL_END
