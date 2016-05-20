//
//  SomeAnimat.m
//  汉诺塔
//
//  Created by tarena311🐟 on 16/3/15.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "SomeAnimat.h"


@implementation SomeAnimat
singleton_implementation(SomeAnimat)
/** 把视图中心移动到目标点 */
- (void)animationView:(UIView *)view To:(CGPoint)targetPoin {
    [UIView animateWithDuration:0.5 animations:^{
        view.center = targetPoin;
    } completion:^(BOOL finished) {
        if (targetPoin.y < 0) {
            [self removeFromSuperview];
        }
    }];
}
/** label具有瞬间变大发黄效果 */
- (void)animationLabel:(UILabel *)label{
    UIColor *color = label.textColor;
    [UILabel animateWithDuration:0.5 animations:^{
        label.textColor = [UIColor yellowColor];
        label.transform = CGAffineTransformMakeScale(2.0, 2.0);
    } completion:^(BOOL finished) {
        label.textColor = color;
        label.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
/** 弹出临时显示内容 */
-(void)popTempMessage:(NSString *)string from:(CGPoint)beforePoint to:(CGPoint)aftherPoint at:(UIView *)view completion:(finish)block{
    MYLog(@"block0");
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
    label.text = string;
    label.font = [UIFont systemFontOfSize:50];
    label.center = beforePoint;
    label.textColor = [UIColor greenColor];
    [view addSubview:label];
    [UILabel animateWithDuration:1 animations:^{
        label.center = aftherPoint;
        label.alpha = 0.5;
        label.transform = CGAffineTransformMakeScale(0.2, 0.2);
    } completion:^(BOOL finished) {
        MYLog(@"block1");
        [label removeFromSuperview];
        block();
    }];
}
/** label文字闪烁 */
-(void)buttonBlink:(UIButton *)button{
    UIColor *color = button.titleLabel.textColor;
    [UILabel animateWithDuration:0.2 animations:^{
        button.titleLabel.textColor = [UIColor yellowColor];
        button.alpha = 0.7;
        button.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        button.titleLabel.textColor = color;
        button.alpha = 1;
        button.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
/** 箱子动画效果 */
-(void)animationWithBox:(Box *)box from:(CGPoint)beforeCenter to:(CGPoint)aftherCenter top:(CGFloat)topY completion:(finish)block; {
    CGPoint firstCenter = CGPointMake(beforeCenter.x, topY);
    CGPoint secondCenter = CGPointMake(aftherCenter.x, topY);
    CGPoint thirdCenter = CGPointMake(aftherCenter.x, aftherCenter.y - box.frame.size.height);
    [UIView animateWithDuration:0.1 delay:0 options:0 animations:^{
        box.center = firstCenter;
    } completion:nil];
    [UIView animateWithDuration:0.1 delay:0.1 options:0 animations:^{
        box.center = secondCenter;
    } completion:nil];
    [UIView animateWithDuration:0.2 delay:0.2 options:0 animations:^{
        box.center = thirdCenter;
    } completion:^(BOOL finished){
        block();
    }];
}
/** 胜利动画 */
- (void)winAnimationAt:(UIView *)view{
    
}
@end
