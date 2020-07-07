//
//  LuckyStarViewController.m
//  Demo
//
//  Created by 阮巧华 on 2020/7/6.
//  Copyright © 2020 阮巧华. All rights reserved.
//

#import "LuckyStarViewController.h"
#import "UIViewController+HUD.h"

@interface LuckyStarViewController ()

@property (nonatomic, weak) IBOutlet UIButton *closeBtn;

@property (nonatomic, weak) IBOutlet UIButton *joinBtn;

@property (nonatomic, weak) IBOutlet UIButton *starBtn;

@end

@implementation LuckyStarViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _joinMinCount = 2;
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
    
    _isMini = NO;
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
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self showDetailViewController:alert sender:nil];
}

- (IBAction)startBtnClick:(id)sender {
    
    if (_users.count < _joinMinCount) {
        [self HUDToastWithString:@"当前参与人数不足，游戏无法开启"];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前人数未达到人数上限，是否马上开始？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self showDetailViewController:alert sender:nil];
}

@end
