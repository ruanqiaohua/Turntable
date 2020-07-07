//
//  LuckyStarReadyViewController.m
//  Demo
//
//  Created by 阮巧华 on 2020/7/6.
//  Copyright © 2020 阮巧华. All rights reserved.
//

#import "LuckyStarReadyViewController.h"
#import "UIViewController+HUD.h"
#import "MenaPopMenuView.h"

@interface LuckyStarReadyViewController ()

@property (nonatomic, weak) IBOutlet UIButton *userBtn;
@property (nonatomic, weak) IBOutlet UIButton *moneyBtn;
@property (nonatomic, assign) NSUInteger defaultUserCount;
@property (nonatomic, assign) NSUInteger defaultMoneyCount;
@property (nonatomic, strong) NSArray *userCounts;
@property (nonatomic, strong) NSArray *moneyCounts;

@end

@implementation LuckyStarReadyViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _defaultUserCount = 3;
        _defaultMoneyCount = 100;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_userBtn setTitle:[NSString stringWithFormat:@"%@", @(_defaultUserCount)] forState:UIControlStateNormal];
    [_moneyBtn setTitle:[NSString stringWithFormat:@"%@", @(_defaultMoneyCount)] forState:UIControlStateNormal];
}

- (NSArray *)userCounts {
    if (!_userCounts) {
        _userCounts = @[@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    }
    return _userCounts;
}

- (NSArray *)moneyCounts {
    if (!_moneyCounts) {
        _moneyCounts = @[@"50",@"100",@"300",@"500"];
    }
    return _moneyCounts;
}

- (IBAction)firstTipBtnClick:(UIButton *)sender {
    
    [self HUDToastWithString:@"设置最多可参与游戏的人数"];
}

- (IBAction)userBtnClick:(UIButton *)sender {
    
    CGRect frame = [sender.superview convertRect:sender.frame toView:self.view];
    MenaPopMenuView *view = [[MenaPopMenuView alloc] initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMaxY(frame), CGRectGetWidth(frame), 44)];
    view.titleList = [self userCounts];
    [self.view addSubview:view];
    
    __weak typeof(self) weakSelf = self;
    [view setItemDidClick:^(NSInteger index) {
        [weakSelf.userBtn setTitle:[NSString stringWithFormat:@"%@", weakSelf.userCounts[index]] forState:UIControlStateNormal];
    }];
}

- (IBAction)secondTipBtnClick:(UIButton *)sender {
    
    [self HUDToastWithString:@"设置每次参与游戏的钻石"];
}

- (IBAction)moneyBtnClick:(UIButton *)sender {
    
    CGRect frame = [sender.superview convertRect:sender.frame toView:self.view];
    MenaPopMenuView *view = [[MenaPopMenuView alloc] initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMaxY(frame), CGRectGetWidth(frame), 44)];
    view.titleList = [self moneyCounts];
    [self.view addSubview:view];
    
    __weak typeof(self) weakSelf = self;
    [view setItemDidClick:^(NSInteger index) {
        [weakSelf.moneyBtn setTitle:[NSString stringWithFormat:@"%@", weakSelf.moneyCounts[index]] forState:UIControlStateNormal];
    }];
}

- (IBAction)closeBtnClick:(UIButton *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)startBtnClick:(UIButton *)sender {
    
    if (_startBtnDidClick) {
        _startBtnDidClick(self, sender);
    }
}

@end
