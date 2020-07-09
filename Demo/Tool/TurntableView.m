//
//  TurntableView.m
//  Demo
//
//  Created by 阮巧华 on 2020/7/8.
//  Copyright © 2020 阮巧华. All rights reserved.
//

#import "TurntableView.h"

@interface TurntableView ()

@property (nonatomic, assign) NSInteger targetIndex;
@property (nonatomic, copy) TurntableFinishBlock finishBlock;

@end

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

- (void)startAnimation:(NSInteger)index finish:(TurntableFinishBlock _Nullable)finish {
        
    //判断是否正在转
    if (_isAnimation) {
        return;
    }
    _targetIndex = index;
    _finishBlock = finish;
    _isAnimation = YES;
    
    [self.layer removeAllAnimations];
    
    //设置转圈的圈数
    NSInteger circleNum = 6;
    CGFloat rowAngle = M_PI*2/_colors.count;
    CGFloat angle = rowAngle *index + rowAngle/2;
    CGFloat perAngle = M_PI/180.0;
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:angle + 360 * perAngle * circleNum];
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
    
    _isAnimation = NO;
    if (_finishBlock) {
        _finishBlock(_targetIndex);
    }
}

@end
