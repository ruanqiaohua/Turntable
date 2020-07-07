//
//  LuckyStarViewController.h
//  Demo
//
//  Created by 阮巧华 on 2020/7/6.
//  Copyright © 2020 阮巧华. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LuckyStarViewController;
@protocol LuckyStarDelegate <NSObject>

- (void)luckyStar:(LuckyStarViewController *)luckyStar minimizeDidClick:(UIButton *)sender;

- (void)luckyStar:(LuckyStarViewController *)luckyStar closeDidClick:(UIButton *)sender;

@end

@interface LuckyStarViewController : UIViewController

@property (nonatomic, assign) BOOL isHost;
@property (nonatomic, assign) BOOL isMini;
@property (nonatomic, weak) id<LuckyStarDelegate> delegate;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
