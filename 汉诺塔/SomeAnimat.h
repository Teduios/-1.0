//
//  SomeAnimat.h
//  汉诺塔
//
//  Created by tarena311🐟 on 16/3/15.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "Box.h"
@interface SomeAnimat : UIView
singleton_interface(SomeAnimat)
typedef void(^finish)(void);
/** 把视图中心移动到目标点 */
- (void)animationView:(UIView *)view To:(CGPoint)targetPoin;
/** label具有瞬间变大发黄效果 */
- (void)animationLabel:(UILabel *)label;
/** 弹出临时显示内容 */
- (void)popTempMessage:(NSString *)string from:(CGPoint) beforePoint to:(CGPoint) aftherPoint at:(UIView *)view completion:(finish)block;
/** label文字闪烁 */
- (void)buttonBlink:(UIButton *)button;

/** 箱子动画效果 */
- (void)animationWithBox:(Box *)box from:(CGPoint)beforeCenter to:(CGPoint)aftherCenter top:(CGFloat)topX completion:(finish)block;
/** 胜利动画 */
- (void)winAnimationAt:(UIView *)view;
@end
