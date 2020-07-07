//
//  GameFuctionViewController.h
//  Demo
//
//  Created by 阮巧华 on 2020/7/6.
//  Copyright © 2020 阮巧华. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GameFuctionViewController;
@protocol GameFuctionViewDelegate <NSObject>

- (void)gameFuction:(GameFuctionViewController *)gameFuction backgroundDidClick:(UIButton *)sender;

- (void)gameFuction:(GameFuctionViewController *)gameFuction itemDidClick:(UIButton *)sender;

@end

@interface GameFuctionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@property (nonatomic, strong) NSArray *gameFuctionList;

@property (nonatomic, weak) id<GameFuctionViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
