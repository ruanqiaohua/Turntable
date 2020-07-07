//
//  MenaPopMenuView.m
//  Demo
//
//  Created by 阮巧华 on 2020/7/7.
//  Copyright © 2020 阮巧华. All rights reserved.
//

#import "MenaPopMenuView.h"

@implementation MenaPopMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _defaultItemHeight = 30;
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        [self addSubview:_stackView];
    }
    return self;
}

- (void)setTitleList:(NSArray *)titleList {
    
    _titleList = titleList;
    
    int i = 0;
    for (NSString *title in _titleList) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [_stackView addArrangedSubview:btn];
        i++;
    }
    
    _stackView.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), self.frame.size.width, _defaultItemHeight*_titleList.count);
    
    self.frame = [UIScreen mainScreen].bounds;
    
}

- (void)itemBtnClick:(UIButton *)sender {
    
    [self removeFromSuperview];

    if (_itemDidClick) {
        _itemDidClick(sender.tag);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self removeFromSuperview];
}

@end
