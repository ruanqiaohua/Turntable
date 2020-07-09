//
//  MenaPopMenuView.h
//  Demo
//
//  Created by 阮巧华 on 2020/7/7.
//  Copyright © 2020 阮巧华. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MenaPopMenuView : UIView

@property (nonatomic, assign) NSUInteger defaultItemHeight;

@property (nonatomic, strong) UIStackView *stackView;

@property (nonatomic, strong) NSArray *titleList;

@property (nonatomic, copy) void(^itemDidClick)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
