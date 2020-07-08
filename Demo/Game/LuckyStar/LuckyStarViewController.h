//
//  LuckyStarViewController.h
//  Demo
//
//  Created by 阮巧华 on 2020/7/6.
//  Copyright © 2020 阮巧华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenaAppUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@class LuckyStarViewController;
@protocol LuckyStarDelegate <NSObject>

- (void)luckyStar:(LuckyStarViewController *)luckyStar minimizeDidClick:(UIButton *)sender;

- (void)luckyStar:(LuckyStarViewController *)luckyStar closeDidClick:(UIButton *)sender;

@end

@interface LuckyStarViewController : UIViewController

@property (nonatomic, assign) BOOL isHost;
@property (nonatomic, assign) BOOL isMini;
@property (nonatomic, assign) NSUInteger joinMinCount;
@property (nonatomic, assign) NSUInteger joinMaxCount;
@property (nonatomic, strong) NSMutableArray<MenaAppUserInfo *> *users;
@property (nonatomic, weak) id<LuckyStarDelegate> delegate;

- (void)insertUser:(MenaAppUserInfo *)user;
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
