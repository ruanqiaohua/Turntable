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

static CGFloat animationTime = 1.5;
static CGFloat winAnimationTime = 2.5;

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
    
    if (_isHost) {
        _closeBtn.hidden = NO;
        _joinBtn.hidden = YES;
        _starBtn.hidden = NO;
    } else {
        _closeBtn.hidden = YES;
        _joinBtn.hidden = NO;
        _starBtn.hidden = YES;
    }
    _goOnBtn.hidden = YES;

    _isMini = NO;
    _isFinish = NO;
}

- (void)setIsFinish:(BOOL)isFinish {
    _isFinish = isFinish;
    _goOnBtn.hidden = YES;
    [self performSelector:@selector(close) withObject:nil afterDelay:winAnimationTime];
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
    
    __weak typeof(self) weakSelf = self;
    // 延迟0.4秒显示谁被淘汰
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *title = [NSString stringWithFormat:@"%@ Out", weakSelf.users[index].nickname];
        
        [weakSelf userAnimation:title time:animationTime finish:^{
            
            // 胜利者
            if (weakSelf.users.count == 1) {
                
                NSString *title = [NSString stringWithFormat:@"%@ Win ~", weakSelf.users[0].nickname];
                [weakSelf userAnimation:title time:winAnimationTime finish:nil];
                // 指针指向用户
                weakSelf.isFinish = weakSelf.users.count == 1;
                [weakSelf updateTurntable];
            }
        }];
        
        [weakSelf.users removeObjectAtIndex:index];
        [weakSelf updateTurntable];
    });
}

- (UIColor *)getColor:(NSInteger)index {
    
    if (!_colorSpaces) {
        _colorSpaces = [NSMutableArray array];
    }
    UIColor *color;
    if (_colorSpaces.count > index) {
        color = _colorSpaces[index];
    } else {
        CGFloat red = arc4random()%100*0.01;
        CGFloat green = arc4random()%100*0.01;
        CGFloat blue = arc4random()%100*0.01;
        color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        [_colorSpaces addObject:color];
    }
    return color;
}

/// 更新转盘
- (void)updateTurntable {
    
    [_turntable removeFromSuperview];
    _turntable = [[TurntableView alloc] initWithFrame:_centerView.bounds];
    [_centerView insertSubview:_turntable atIndex:0];

    NSMutableArray *colors = [NSMutableArray array];
    NSMutableArray *urls = [NSMutableArray array];

    for (int i=0; i<_users.count; i++) {
        MenaAppUserInfo *user = _users[i];
        UIColor *color;
        if (user.color) {
            color = user.color;
        } else {
            color = [self getColor:i];
            user.color = color;
        }
        [colors addObject:color];
        [urls addObject:user.nickname];
    }
    
    [_turntable setBackgroundWithColors:colors];

    if (_isFinish && urls.count == 1) {
        [_turntable setWinUserWithURL:urls.firstObject];
    } else {
        [_turntable setUsersWithUrls:urls];
    }
}

- (void)reloadData {
    
    if (_users.count > 0) {
        [self updateTurntable];
    }
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
        // TODO 请求接口 告诉后台强制关闭游戏
        [weakSelf close];
    }]];
    [self showDetailViewController:alert sender:nil];
}

- (void)close {
    
    if (_delegate && [_delegate respondsToSelector:@selector(didClose:)]) {
        [_delegate didClose:self];
    }
}

- (IBAction)joinBtnClick:(id)sender {
    
    if (_users.count == _joinMaxCount) {
        [self HUDToastWithString:@"本局游戏人数已达上限"];
        return;
    }
    
    NSString *message = [NSString stringWithFormat:@"本次参与将消耗%@钻石。游戏获胜者将获得所有参与者总花费的90%%钻石奖励。", @(_needMoney)];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
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
    
    // 转盘动画
    __weak typeof(self) weakSelf = self;
    [_turntable startAnimation:[self getOutUserIndex] finish:^(NSInteger targetIndex) {
        [weakSelf deleteUserWithIndex:targetIndex];
    }];
}

/// 开始转盘
- (void)start {
    
    _starBtn.hidden = YES;
    _goOnBtn.hidden = NO;
    __weak typeof(self) weakSelf = self;
    // TODO 请求接口 告诉后台开始游戏
    // 倒计时动画
    [self countDownAnimation:3 finish:^{
        
        // 转盘动画
        [weakSelf.turntable startAnimation:[weakSelf getOutUserIndex] finish:^(NSInteger targetIndex) {
            [weakSelf deleteUserWithIndex:targetIndex];
        }];
    }];
}

- (NSInteger)getOutUserIndex {
    return arc4random()%_users.count;
}

#pragma mark 动画

/// 用户Out动画
- (void)userAnimation:(NSString *)title time:(CGFloat)time finish:(void (^)(void))finish {
    
    UILabel *label = [[UILabel alloc] init];
    label.userInteractionEnabled = YES;
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
        
        [UIView animateWithDuration:0.2 delay:time-0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
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

/// 321倒计时动画
- (void)countDownAnimation:(NSUInteger)time finish:(void (^)(void))finish {
    
    __block NSUInteger countDownTime = time;
    
    UIView *view = [_contentView viewWithTag:1000];
    if (view == nil) {
        view = [[UIView alloc] init];
        view.userInteractionEnabled = YES;
        view.frame = _contentView.bounds;
        view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        view.tag = 1000;
        [_contentView addSubview:view];
    }
    
    UILabel *label = [view viewWithTag:1001];

    if (label == nil) {
        
        label = [[UILabel alloc] init];
        label.frame = view.bounds;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:100];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 1001;
        [view addSubview:label];
    }
    label.text = [NSString stringWithFormat:@"%@", @(time)];

    [UIView animateWithDuration:1 animations:^{
        // 缩小
        label.transform = CGAffineTransformScale(label.transform, 0.4, 0.4);

    } completion:^(BOOL finished) {
        
        label.transform = view.transform;
        countDownTime -= 1;
        if (finish && countDownTime == 0) {
            [view removeFromSuperview];
            finish();
        } else {
            [self countDownAnimation:countDownTime finish:finish];
        }
    }];
}

@end
