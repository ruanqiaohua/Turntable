//
//  GameFuctionViewController.m
//  Demo
//
//  Created by 阮巧华 on 2020/7/6.
//  Copyright © 2020 阮巧华. All rights reserved.
//

#import "GameFuctionViewController.h"

@interface GameFuctionViewController ()

@end

@implementation GameFuctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self reloadData];
}

- (void)setGameFuctionList:(NSArray *)gameFuctionList {
    _gameFuctionList = gameFuctionList;
    [self reloadData];
}

- (void)reloadData {
    
    for (UIView *view in _stackView.arrangedSubviews) {
        [view removeFromSuperview];
    }
    for (NSString *title in _gameFuctionList) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_stackView addArrangedSubview:btn];
    }
}

- (void)itemBtnClick:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(gameFuction:itemDidClick:)]) {
        [self.delegate gameFuction:self itemDidClick:sender];
    };
}

- (IBAction)backgroundBtnClick:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(gameFuction:backgroundDidClick:)]) {
        [self.delegate gameFuction:self backgroundDidClick:sender];
    };
}

@end
