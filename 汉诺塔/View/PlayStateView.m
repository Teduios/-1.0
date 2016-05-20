//
//  PlayStateView.m
//  汉诺塔
//
//  Created by tarena311🐟 on 16/3/15.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "PlayStateView.h"
#import "SomeAnimat.h"
#import "ShareObject.h"

@interface PlayStateView ()
@property (nonatomic, weak) IBOutlet UILabel *score;
@property (nonatomic, weak) IBOutlet UIButton *hellpTimeButton;
@property (nonatomic, weak) IBOutlet UIButton *hellpStepButton;
@property (nonatomic, weak) IBOutlet UILabel *remainTime;
@property (nonatomic, weak) IBOutlet UIProgressView *progressTime;
@property (nonatomic, weak) ShareObject *shareObject;
@property (nonatomic) NSInteger sumTime;
@property (nonatomic) NSInteger saftyTime;
@property (nonatomic) NSInteger tempTime;
@property (nonatomic) BOOL runTimeGoing;
@property (nonatomic, strong) NSTimer *hellpTimeCirculateTimer;
@property (nonatomic, strong) NSTimer *hellpStepCirculateTimer;
@property (nonatomic, strong) NSTimer *runTimer;
@end
@implementation PlayStateView

//开始计时
- (void)timeGoing {
    //传值
    self.shareObject = [ShareObject sharedShareObject];
    self.sumTime = self.shareObject.difficulty * self.shareObject.stepCount + PREPARESECONDS;
    self.tempTime = self.sumTime;
    self.saftyTime = (self.sumTime / 3) * 2;
    self.hellpTimeButton.userInteractionEnabled = YES;
    self.hellpStepButton.userInteractionEnabled = YES;
    //是否使用手势
    if (self.shareObject.isHaveGestureRecognizer) [self addStateViewGestureRecognizer];
    //监听胜利通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAllTimers:) name:@"Win" object:nil];
    MYLog(@"监听Win通知");
    //计时
    self.runTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeValue) userInfo:nil repeats:YES];
    [self reflashStateView];
    self.runTimeGoing = YES;
}

#pragma mark 与计时相关
- (void)changeValue{
    if (self.tempTime <= 0) {//结束
        [self stopAllTimers:nil];
        self.progressTime.trackTintColor = [UIColor redColor];
    }else if (self.tempTime <= 30){//警报
        self.remainTime.textColor = [UIColor redColor];
        self.progressTime.trackTintColor = [UIColor redColor];
        [[SomeAnimat sharedSomeAnimat] animationLabel:self.remainTime];
    }else if (self.tempTime <= self.saftyTime){//可使用hellpTime的时间
        self.remainTime.textColor = [UIColor yellowColor];
        self.progressTime.trackTintColor = [UIColor greenColor];
    }else{//正常
        self.remainTime.textColor = [UIColor whiteColor];
        self.progressTime.trackTintColor = [UIColor blueColor];
    }
    self.remainTime.text = [self changeTimeFormat:self.tempTime];
    self.tempTime --;
    self.progressTime.progress = 1 - (CGFloat)self.tempTime / self.sumTime;
}
//停止所有计时器
- (void)stopAllTimers:(NSNotification *)notification{
    self.runTimeGoing = NO;
    if (self.hellpTimeCirculateTimer) {
        [self.hellpTimeCirculateTimer invalidate];
        self.hellpTimeCirculateTimer = nil;
    }
    if (self.hellpStepCirculateTimer) {
        [self.hellpStepCirculateTimer invalidate];
        self.hellpStepCirculateTimer = nil;
    }
    if (self.runTimer) [self.runTimer invalidate];
    self.runTimer = nil;
    //关闭交互
    self.hellpTimeButton.userInteractionEnabled = NO;
    self.hellpStepButton.userInteractionEnabled = NO;
    //传值
    ShareObject *shareObject = [ShareObject sharedShareObject];
    shareObject.hellpTimeCount = NUMBEROFBUTTON(self.hellpTimeButton);
    shareObject.hellpStepCount = NUMBEROFBUTTON(self.hellpStepButton);
    if (notification.userInfo[@"reward"]) {
        shareObject.hellpStepCount += [notification.userInfo[@"reward"] integerValue];
        [self.hellpStepButton setTitle:TEXT(shareObject.hellpStepCount) forState:UIControlStateNormal];
    }
    //发送时间状态通知
    NSDictionary *timeDic = @{@"sumTime":@(self.sumTime),@"tempTime":@(self.tempTime)};
    MYLog(@"发送时间结束TimeStop通知");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TimeStop" object:self userInfo:timeDic];
    //取消胜利监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Win" object:nil];
    MYLog(@"取消监听Win");
}




#pragma mark 点击事件
- (IBAction)clickHellpTime:(id)sender{
    if (self.saftyTime < self.tempTime) {
        if (self.hellpTimeCirculateTimer) [self.hellpTimeCirculateTimer invalidate];
        return;
    }
    if ([self decreaseButtomTextNumber:self.hellpTimeButton]){
        self.tempTime += ADDSENCONDS;//加时
        NSString *showInfo = [NSString stringWithFormat:@"+%ds",ADDSENCONDS];//加时显示信息
        CGPoint center = CGPointMake(self.center.x, self.center.y * 5);
        [[SomeAnimat sharedSomeAnimat] popTempMessage:showInfo from:center to:self.remainTime.center at:self completion:^{
            self.remainTime.text = [self changeTimeFormat:self.tempTime];
            self.progressTime.progress = 1 - (CGFloat)self.tempTime / self.sumTime;
        }];
    }else{
        if (self.hellpTimeCirculateTimer) [self.hellpTimeCirculateTimer invalidate];
    }
}
- (IBAction)clickHellpStep:(id)sender{
    if ([self decreaseButtomTextNumber:self.hellpStepButton]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AutoRunStep" object:self userInfo:nil];
        MYLog(@"发送AutoRunStep通知");
        [[SomeAnimat sharedSomeAnimat] buttonBlink:self.hellpStepButton];
    }else{
        if (self.hellpStepCirculateTimer) [self.hellpStepCirculateTimer invalidate];
    }
}
- (IBAction)clickPause:(id)sender{
    if (self.hellpTimeCirculateTimer) {
        [self.hellpTimeCirculateTimer invalidate];
        self.hellpTimeCirculateTimer = nil;
    }
    if (self.hellpStepCirculateTimer) {
        [self.hellpStepCirculateTimer invalidate];
        self.hellpStepCirculateTimer = nil;
    }
}


#pragma mark 手势
- (void)addStateViewGestureRecognizer{
    UISwipeGestureRecognizer *hellpTimeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHellpTime:)];
    hellpTimeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.hellpTimeButton addGestureRecognizer:hellpTimeGesture];
    UISwipeGestureRecognizer *hellpStepGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHellpStep:)];
    hellpStepGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.hellpStepButton addGestureRecognizer:hellpStepGesture];
}
//加到安全时间
- (void)swipeHellpTime:(UIButton *)button{
    //如果上一次手势事件没结束，那么停止事件
    if (self.hellpTimeCirculateTimer) {
        [self.hellpTimeCirculateTimer invalidate];
        self.hellpTimeCirculateTimer = nil;
    }else{
        self.hellpTimeCirculateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(clickHellpTime:) userInfo:nil repeats:YES];
    }
}
//连续自动运行
- (void)swipeHellpStep:(UIButton *)button{
    if (self.hellpStepCirculateTimer) {
        [self.hellpStepCirculateTimer invalidate];
        self.hellpStepCirculateTimer = nil;
    }else{
        self.hellpStepCirculateTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(clickHellpStep:) userInfo:nil repeats:YES];
    }
}



//- (void)viewWillAppear{
//    if (self.runTimeGoing && !self.runTimer) {
//    self.runTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeValue) userInfo:nil repeats:YES];
//    }
//}
//- (void)viewDidDisappear{
//    if (self.runTimer) {
//        [self.runTimer invalidate];
//        self.runTimer = nil;
//    }
//}

#pragma mark 封装方法
- (void)reflashStateView{
    self.score.text = TEXT(self.shareObject.score);
    [self.hellpTimeButton setTitle:TEXT(self.shareObject.hellpTimeCount) forState:UIControlStateNormal];
    [self.hellpStepButton setTitle:TEXT(self.shareObject.hellpStepCount) forState:UIControlStateNormal];
}

//button显示的数字减一（返回是否减成功）
- (BOOL)decreaseButtomTextNumber:(UIButton *)button{
    NSInteger buttomTextNumber = NUMBEROFBUTTON(button);
    if (buttomTextNumber > 0) {
        buttomTextNumber --;
        [button setTitle:TEXT(buttomTextNumber) forState:UIControlStateNormal];
        [self decreaseScore];//减分
        return YES;
    }
    return NO;
}
//减分
- (void)decreaseScore{
    NSInteger score = NUMBEROFLABEL(score);
    if (score) {
        score -= DECREASESCORE;
        self.score.text = TEXT(score);
        self.shareObject.score = score;
    }
}
//时间格式转换
- (NSString *)changeTimeFormat:(NSInteger)time{
    if (time < 60) {
        return TEXT(time);
    }else if (time >= 60 && time < 3600){
        return [NSString stringWithFormat:@"%02ld:%02ld", time / 60, time % 60];
    }else{
        return [NSString stringWithFormat:@"%ld:%02ld:%02ld", time / 3600, (time % 3600) / 60, time % 60];
    }
}



@end
