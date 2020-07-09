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

        UILabel *label = [self userView];
        label.frame = CGRectMake(0, 0, M_PI * CGRectGetHeight(self.frame)/count,CGRectGetHeight(self.frame)*3/5);
        label.center = CGPointMake(CGRectGetHeight(self.frame)/2, CGRectGetHeight(self.frame)/2);
        label.text = [NSString stringWithFormat:@"%@", urls[i]];
        CGFloat rowAngle = M_PI*2/count;
        CGFloat angle = rowAngle *i + rowAngle/2;
        label.transform = CGAffineTransformMakeRotation(angle);
        [self addSubview:label];
    }
}

- (UILabel *)userView {
    
    UILabel *label = [[UILabel alloc] init];
    label.layer.anchorPoint = CGPointMake(0.5, 1.0);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:14];
    return label;
}

- (void)setWinUserWithURL:(NSString *)url {
    
    UILabel *label = [self userView];
    label.frame = CGRectMake(0, 0, M_PI * CGRectGetHeight(self.frame)/2,CGRectGetHeight(self.frame)*3/5);
    label.center = CGPointMake(CGRectGetHeight(self.frame)/2, CGRectGetHeight(self.frame)/2);
    label.text = url;
    [self addSubview:label];
}

- (void)startAnimation:(NSInteger)index finish:(TurntableFinishBlock)finish {
    
    [self startAnimation:index waitStop:NO finish:finish];
}

- (void)startAnimation:(NSInteger)index waitStop:(BOOL)stop finish:(TurntableFinishBlock _Nullable)finish {
        
    //判断是否正在转
    if (_isAnimation) {
        return;
    }
    _targetIndex = index;
    _finishBlock = finish;
    _isAnimation = YES;
    
    [self.layer removeAllAnimations];
    
    //设置转圈的圈数
    NSUInteger count = _colors.count;
    NSInteger circleNum = 6;
    CGFloat rowAngle = M_PI*2/count;
    CGFloat angle = rowAngle * (count-1-index) + rowAngle/2;
    CGFloat perAngle = M_PI/180.0;
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:angle + 360 * perAngle * circleNum];
    rotationAnimation.cumulative = YES;
    
    //由快变慢
    if (stop == NO) {
        rotationAnimation.duration = 3.0f;
        rotationAnimation.delegate = self;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        rotationAnimation.fillMode=kCAFillModeForwards;
        rotationAnimation.removedOnCompletion = NO;
    } else {
        rotationAnimation.duration = 2.0f;
        rotationAnimation.repeatCount = CGFLOAT_MAX;
    }
    
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)start {
    
    //判断是否正在转
    if (_isAnimation) {
        return;
    }
    _isAnimation = YES;

    [self.layer removeAllAnimations];
    
    //设置转圈的圈数
    NSInteger circleNum = 6;
    CGFloat perAngle = M_PI/180.0;

    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:360 * perAngle * circleNum];
    rotationAnimation.duration = 3.0f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.delegate = self;
    rotationAnimation.repeatCount = CGFLOAT_MAX;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stop {
    
    _isAnimation = NO;
    [self startAnimation:_targetIndex finish:_finishBlock];
}

#pragma mark 动画结束

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    _isAnimation = NO;
    if (_finishBlock) {
        _finishBlock(_targetIndex);
    }
}

@end
