//
//  TurntableView.m
//  Demo
//
//  Created by 阮巧华 on 2020/7/8.
//  Copyright © 2020 阮巧华. All rights reserved.
//

#import "TurntableView.h"

@implementation TurntableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setBackgroundWithColors:(NSArray *)colors {
    
    _colors = colors;
    NSUInteger count = colors.count;
    for (int i=0; i<count; i++) {

        UIColor *color = colors[i];
        
        CGFloat rowAngle = M_PI*2/count;
        CGFloat startAngle = -M_PI_2 + rowAngle * i;
        CGFloat endAngle = startAngle + rowAngle;

        CGPoint center = self.center;
        CGFloat radius = CGRectGetWidth(self.frame)/2;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        //添加一根线到圆心
        [path addLineToPoint:center];
        //关闭路径，是从终点到起点
        [path closePath];
        [path stroke];
        
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = path.CGPath;
        layer.fillColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
}

- (void)setUsersWithUrls:(NSArray *)urls {
    
    NSUInteger count = urls.count;
    for (int i=0; i<count; i++) {

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,M_PI * CGRectGetHeight(self.frame)/count,CGRectGetHeight(self.frame)*3/5)];
        label.layer.anchorPoint = CGPointMake(0.5, 1.0);
        label.center = CGPointMake(CGRectGetHeight(self.frame)/2, CGRectGetHeight(self.frame)/2);
        label.text = [NSString stringWithFormat:@"%@", urls[i]];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:14];
        CGFloat rowAngle = M_PI*2/count;
        CGFloat angle = rowAngle *i + rowAngle/2;
        label.transform = CGAffineTransformMakeRotation(angle);
        [self addSubview:label];
    }
}

- (void)startAnimationWithTargetIndex:(NSInteger)index {
        
    //判断是否正在转
    if (_isAnimation) {
        return;
    }
    _isAnimation = YES;

    [self.layer removeAllAnimations];
    //控制概率[0,80)
    NSInteger lotteryPro = arc4random()%80;
    //设置转圈的圈数
    NSInteger circleNum = 6;
    
    if (lotteryPro < 10) {
        _circleAngle = 0;
    }else if (lotteryPro < 20){
        _circleAngle = 45;
    }else if (lotteryPro < 30){
        _circleAngle = 90;
    }else if (lotteryPro < 40){
        _circleAngle = 135;
    }else if (lotteryPro < 50){
        _circleAngle = 180;
    }else if (lotteryPro < 60){
        _circleAngle = 225;
    }else if (lotteryPro < 70){
        _circleAngle = 270;
    }else if (lotteryPro < 80){
        _circleAngle = 315;
    }
    
    CGFloat rowAngle = M_PI*2/_colors.count;
    CGFloat angle = rowAngle *index + rowAngle/2;
    _circleAngle = angle * (180.0 / M_PI);
    
    CGFloat perAngle = M_PI/180.0;
    
    NSLog(@"turnAngle = %ld",(long)_circleAngle);
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:_circleAngle * perAngle + 360 * perAngle * circleNum];
    rotationAnimation.duration = 3.0f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.delegate = self;
    
    
    //由快变慢
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    rotationAnimation.fillMode=kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}

#pragma mark 动画结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    NSLog(@"动画停止");
    NSString *title;
    if (_circleAngle == 0) {
        title = @"谢谢参与!";
    }else if (_circleAngle == 45){
        title = @"恭喜你，获得特等奖！";
    }else if (_circleAngle == 90){
        title = @"谢谢参与!";
    }else if (_circleAngle == 135){
        title = @"恭喜你，获得三等奖！";
    }else if (_circleAngle == 180){
        title = @"谢谢参与!";
    }else if (_circleAngle == 225){
        title = @"恭喜你，获得二等奖！";
    }else if (_circleAngle == 270){
        title = @"谢谢参与!";
    }else if (_circleAngle == 315){
        title = @"恭喜你，获得一等奖！";
    }
    _isAnimation = NO;
}

@end
