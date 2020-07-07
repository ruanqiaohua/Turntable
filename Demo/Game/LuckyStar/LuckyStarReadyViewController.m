//
//  LuckyStarReadyViewController.m
//  Demo
//
//  Created by 阮巧华 on 2020/7/6.
//  Copyright © 2020 阮巧华. All rights reserved.
//

#import "LuckyStarReadyViewController.h"

@interface LuckyStarReadyViewController ()

@end

@implementation LuckyStarReadyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
