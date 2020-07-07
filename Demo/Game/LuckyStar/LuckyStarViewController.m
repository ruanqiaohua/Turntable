//
//  LuckyStarViewController.m
//  Demo
//
//  Created by 阮巧华 on 2020/7/6.
//  Copyright © 2020 阮巧华. All rights reserved.
//

#import "LuckyStarViewController.h"

@interface LuckyStarViewController ()

@property (nonatomic, weak) IBOutlet UIButton *closeBtn;

@end

@implementation LuckyStarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isHost) {
        _closeBtn.hidden = NO;
    } else {
        _closeBtn.hidden = YES;
    }
    
    _isMini = NO;
}

- (void)reloadData {

    _isMini = NO;
}

- (IBAction)minimizeBtnClick:(UIButton *)sender {
    
    _isMini = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(luckyStar:minimizeDidClick:)]) {
        [_delegate luckyStar:self minimizeDidClick:sender];
    }
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(luckyStar:closeDidClick:)]) {
        [_delegate luckyStar:self closeDidClick:sender];
    }
}

@end
