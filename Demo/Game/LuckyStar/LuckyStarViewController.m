//
//  LuckyStarViewController.m
//  Demo
//
//  Created by 阮巧华 on 2020/7/6.
//  Copyright © 2020 阮巧华. All rights reserved.
//

#import "LuckyStarViewController.h"
#import "UIViewController+HUD.h"
#import "TurntableView.h"
#import <Masonry/Masonry.h>

@interface LuckyStarViewController ()

@property (nonatomic, weak) IBOutlet UIButton *closeBtn;

@property (nonatomic, weak) IBOutlet UIButton *joinBtn;

@property (nonatomic, weak) IBOutlet UIButton *starBtn;

@property (nonatomic, weak) IBOutlet UIView *centerView;

@property (nonatomic, strong) TurntableView *turntable;

@end

@implementation LuckyStarViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _joinMinCount = 2;
        _joinMaxCount = 9;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if (_isHost) {
//        _closeBtn.hidden = NO;
//        _joinBtn.hidden = YES;
//        _starBtn.hidden = NO;
//    } else {
//        _closeBtn.hidden = YES;
//        _joinBtn.hidden = NO;
//        _starBtn.hidden = YES;
//    }
    
    _isMini = NO;
    
    [self createTurntable];
}

/// 创建转盘
- (void)createTurntable {
    
    _turntable = [[TurntableView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    [_centerView insertSubview:_turntable atIndex:0];
    [_turntable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

/// 用户加入
- (void)insertUser:(MenaAppUserInfo *)user {
    
    if (!_users) {
        _users = [NSMutableArray array];
    }
    [_users addObject:user];

    NSMutableArray *colors = [NSMutableArray array];
    for (int i=0; i<_users.count; i++) {
        CGFloat red = arc4random()%100*0.01;
        CGFloat green = arc4random()%100*0.01;
        CGFloat blue = arc4random()%100*0.01;
        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        [colors addObject:color];
    }
    [_turntable setBackgroundWithColors:colors];
    
    NSMutableArray *urls = [NSMutableArray array];
    for (MenaAppUserInfo *user in _users) {
        [urls addObject:user.nickname];
    }
    [_turntable setUsersWithUrls:urls];
}

- (void)reloadData {

    _isMini = NO;
}

- (IBAction)firstTipBtnClick:(UIButton *)sender {
    
    // TODO H5
}

- (IBAction)minimizeBtnClick:(UIButton *)sender {
    
    _isMini = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(luckyStar:minimizeDidClick:)]) {
        [_delegate luckyStar:self minimizeDidClick:sender];
    }
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"关闭当前游戏，钻石将原路返还给参与者。是否确定关闭？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    __weak typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(luckyStar:closeDidClick:)]) {
            [weakSelf.delegate luckyStar:weakSelf closeDidClick:sender];
        }
    }]];
    [self showDetailViewController:alert sender:nil];
}

- (IBAction)joinBtnClick:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"本次参与将消耗xxx钻石。游戏获胜者将获得所有参与者总花费的90%钻石奖励。" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    __weak typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MenaAppUserInfo *user = [MenaAppUserInfo new];
        user.nickname = @"test";
        user.avatarurl = @"https://sdfdsf";
        [weakSelf insertUser:user];
    }]];
    [self showDetailViewController:alert sender:nil];
}

- (IBAction)startBtnClick:(id)sender {
    
    if (_users.count < _joinMinCount) {
        [self HUDToastWithString:@"当前参与人数不足，游戏无法开启"];
        return;
    }
    
    if (_users.count < _joinMaxCount) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前人数未达到人数上限，是否马上开始？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        __weak typeof(self) weakSelf = self;
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.turntable startAnimationWithTargetIndex:arc4random()%weakSelf.users.count];
        }]];
        [self showDetailViewController:alert sender:nil];
        return;
    }
    [_turntable startAnimationWithTargetIndex:arc4random()%_users.count];
    
}

@end
