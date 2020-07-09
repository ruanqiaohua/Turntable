//
//  MenaAppUserInfo.h
//  Demo
//
//  Created by 阮巧华 on 2020/7/8.
//  Copyright © 2020 阮巧华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MenaAppUserInfo : NSObject

@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, retain) NSString *avatarurl;
@property (nonatomic, strong) UIColor *color;

@end

NS_ASSUME_NONNULL_END
