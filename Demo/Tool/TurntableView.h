//
//  TurntableView.h
//  Demo
//
//  Created by 阮巧华 on 2020/7/8.
//  Copyright © 2020 阮巧华. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TurntableView : UIView<CAAnimationDelegate>

@property (nonatomic, assign) BOOL isAnimation;
@property (nonatomic, assign) CGFloat circleAngle;
@property (nonatomic, strong) NSArray *colors;

- (void)setBackgroundWithColors:(NSArray *)colors;
- (void)setUsersWithUrls:(NSArray *)urls;
- (void)startAnimationWithTargetIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
