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

@property (nonatomic, weak) IBOutlet UIButton *goOnBtn;

@property (nonatomic, weak) IBOutlet UIView *contentView;

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
    _isFinish = NO;
}

/// 用户加入
- (void)insertUser:(MenaAppUserInfo *)user {
    
    if (!_users) {
        _users = [NSMutableArray array];
    }
    [_users addObject:user];
    [self updateTurntable];
}

- (void)deleteUserWithIndex:(NSInteger)index {
    
    if (_users.count <= index || _users.count == 1) {
        return;
    }
    
    NSString *title = [NSString stringWithFormat:@"%@ Out", _users[index].nickname];
    
    __weak typeof(self) weakSelf = self;
    [self userAnimatetionWithTitle:title finish:^{
        
        // 胜利者
        if (weakSelf.users.count == 1) {
            
            NSString *title = [NSString stringWithFormat:@"%@ Win ~", weakSelf.users[0].nickname];
            [self userAnimatetionWithTitle:title finish:nil];
        }
    }];
    
    [_users removeObjectAtIndex:index];
    _isFinish = _users.count == 1;
    [self updateTurntable];
}

/// 用户Out动画
- (void)userAnimatetionWithTitle:(NSString *)title finish:(void (^)(void))finish {
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = _contentView.bounds;
    label.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.alpha = 0.1;
    [_contentView addSubview:label];
    
    [UIView animateWithDuration:0.2 animations:^{
        // 渐显
        label.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 delay:1.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            // 渐隐
            label.alpha = 0.1;
            
        } completion:^(BOOL finished) {
            
            [label removeFromSuperview];
            if (finish) {
                finish();
            }
        }];
    }];
}

/// 更新转盘
- (void)updateTurntable {
    
    [_turntable removeFromSuperview];
    _turntable = [[TurntableView alloc] initWithFrame:_centerView.bounds];
    [_centerView insertSubview:_turntable atIndex:0];

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
    if (urls.count == 1 && _isFinish) {
        [_turntable setWinUserWithURL:urls.firstObject];
    } else {
        [_turntable setUsersWithUrls:urls];
    }
}

- (void)reloadData {

    _isMini = NO;
}

- (IBAction)firstTipBtnClick:(UIButton *)sender {
    
    // TODO 跳转游戏介绍H5
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
    
    if (_users.count == _joinMaxCount) {
        [self HUDToastWithString:@"本局游戏人数已达上限"];
        return;
    }
    
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
            [weakSelf start];
        }]];
        [self showDetailViewController:alert sender:nil];
        return;
    }
    [self start];
}

/// 继续转盘
- (IBAction)goOnBtnClick:(id)sender {
    
    // TODO 请求接口 告诉后台继续
    
    // 动画
    __weak typeof(self) weakSelf = self;
    [_turntable startAnimation:[self getOutUserIndex] finish:^(NSInteger targetIndex) {
        [weakSelf deleteUserWithIndex:targetIndex];
    }];
}

/// 开始转盘
- (void)start {
    
    // TODO 请求接口 告诉后台开始游戏
    
    // 动画
    __weak typeof(self) weakSelf = self;
    [_turntable startAnimation:[self getOutUserIndex] finish:^(NSInteger targetIndex) {
        [weakSelf deleteUserWithIndex:targetIndex];
    }];
}

- (NSInteger)getOutUserIndex {
    return arc4random()%_users.count;
}

@end
