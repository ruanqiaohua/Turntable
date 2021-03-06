//
//  ViewController.m
//  Demo
//
//  Created by 阮巧华 on 2020/7/6.
//  Copyright © 2020 阮巧华. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "GameFuctionViewController.h"
#import "LuckyStarReadyViewController.h"
#import "LuckyStarViewController.h"

@interface ViewController ()<GameFuctionViewDelegate, LuckyStarDelegate>

@property (weak, nonatomic) IBOutlet UIButton *gameBtn;
@property (weak, nonatomic) IBOutlet UIButton *luckyStarBtn;
@property (weak, nonatomic) IBOutlet UIView *gameBadgeView;
@property (weak, nonatomic) GameFuctionViewController *gameFuction;
@property (weak, nonatomic) LuckyStarViewController *luckyStar;
@property (nonatomic, strong) NSArray *gameFuctionList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _luckyStarBtn.hidden = YES;

    [self getGameFuctionList];
}

- (BOOL)isHost {
    return YES;
}

/// 获取功能列表
- (void)getGameFuctionList {
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.gameFuctionList = @[@"幸运星", @"PK", @"石头剪刀布"];
        weakSelf.gameFuction.gameFuctionList = weakSelf.gameFuctionList;
    });
}

/// 游戏功能页面
- (GameFuctionViewController *)gameFuction {
    if (!_gameFuction) {
        GameFuctionViewController *vc = [[GameFuctionViewController alloc] init];
        vc.view.hidden = YES;
        vc.delegate = self;
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        _gameFuction = vc;
    }
    return _gameFuction;
}

/// 幸运星页面
- (LuckyStarViewController *)luckyStar {
    if (!_luckyStar) {
        LuckyStarViewController *vc = [[LuckyStarViewController alloc] init];
        vc.delegate = self;
        vc.isHost = [self isHost];
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        _luckyStar = vc;
    }
    return _luckyStar;
}

- (IBAction)gameBtnClick:(UIButton *)sender {
    
    _gameBadgeView.hidden = YES;
    if (!_gameFuction) {
        [self gameFuction];
    }
    _gameFuction.view.hidden = NO;
    [self.view bringSubviewToFront:_gameFuction.view];
}

#pragma mark - GameFuctionViewDelegate

- (void)gameFuction:(GameFuctionViewController *)gameFuction backgroundDidClick:(UIButton *)sender {
    
    gameFuction.view.hidden = YES;
}

- (void)gameFuction:(GameFuctionViewController *)gameFuction itemDidClick:(UIButton *)sender {
    
    if (_luckyStar.isMini) {
        [self showLuckyStar];
        return;
    }
    
    gameFuction.view.hidden = YES;
    LuckyStarReadyViewController *vc = [[LuckyStarReadyViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self showDetailViewController:vc sender:nil];
    
    __weak typeof(self) weakSelf = self;
    [vc setStartBtnDidClick:^(LuckyStarReadyViewController * vc, NSUInteger userCount, NSUInteger moneyCount) {
        [vc dismissViewControllerAnimated:NO completion:nil];
        weakSelf.luckyStar.joinMaxCount = userCount;
        weakSelf.luckyStar.needMoney = moneyCount;
        [weakSelf showLuckyStar];
        
        // test data
        MenaAppUserInfo *user = [MenaAppUserInfo new];
        user.nickname = @"1";
        MenaAppUserInfo *user1 = [MenaAppUserInfo new];
        user1.nickname = @"2";
        MenaAppUserInfo *user2 = [MenaAppUserInfo new];
        user2.nickname = @"3";
        MenaAppUserInfo *user3 = [MenaAppUserInfo new];
        user3.nickname = @"4";
        [weakSelf.luckyStar setUsers:[@[user, user1, user2, user3] mutableCopy]];
        [weakSelf.luckyStar reloadData];

    }];
}

#pragma mark - super lucky Star

- (void)showLuckyStar {
    
    if (!_luckyStar) {
        [self luckyStar];
    }
    _luckyStar.isMini = NO;
    _luckyStar.view.hidden = NO;
    [self.view bringSubviewToFront:_luckyStar.view];
}

#pragma mark LuckyStarDelegate

- (void)luckyStar:(LuckyStarViewController *)luckyStar minimizeDidClick:(nonnull UIButton *)sender {
    
    _luckyStar.view.hidden = YES;
    _luckyStarBtn.hidden = NO;
}

- (void)didClose:(LuckyStarViewController *)luckyStar {
    
    _luckyStarBtn.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.luckyStar.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.luckyStar.view removeFromSuperview];
        [self.luckyStar removeFromParentViewController];
        self.luckyStar = nil;
    }];
}

- (IBAction)luckyStarBtnClick:(UIButton *)sender {
    
    [self showLuckyStar];
}

@end
