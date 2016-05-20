//
//  PlayView.m
//  汉诺塔
//
//  Created by tarena311🐟 on 16/3/15.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "PlayView.h"
#import "ShareObject.h"
#import "Pillar.h"
#import "Box.h"
@interface PlayView()
@property (weak, nonatomic) IBOutlet UILabel *stepCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepCountSinceNowLabel;
@property (weak, nonatomic) IBOutlet UILabel *userStepCountLabel;
@property (weak, nonatomic) Pillar *leftPillar;
@property (weak, nonatomic) Pillar *middlePillar;
@property (weak, nonatomic) Pillar *rightPillar;
@property (nonatomic, weak) ShareObject *shareObject;
//传参属性
@property (nonatomic) NSInteger difficulty;
@property (nonatomic) NSInteger boxCount;
@property (nonatomic) BOOL isRandom;


@property (nonatomic) NSInteger tempBoxCount;
@property (nonatomic) NSInteger boxHeight;
//运行所用属性
@property (nonatomic, weak) Box *selectBox;
@property (nonatomic, weak) Pillar *clickOnWhichPillar;
@property (nonatomic) BOOL isWin;
@property (nonatomic) BOOL move;
@property (nonatomic) NSInteger stepCount;
@property (nonatomic) NSInteger stepCountSinceNow;
@property (nonatomic) NSInteger userStepCount;
//自动运行属性
@property (nonatomic) NSInteger targetPillarTag;
@property (nonatomic) NSInteger smallerBoxTargetPillarTag;
@property (nonatomic) Box *targetBox;
@end



@implementation PlayView


- (void)start{
    //传入参数
    self.shareObject = [ShareObject sharedShareObject];
    self.difficulty = self.shareObject.difficulty;
    self.boxCount = self.shareObject.boxCount;
    self.isRandom = self.shareObject.isRandom;
    //获取柱子
    self.leftPillar = [self viewWithTag:LEFTPILLAR];
    self.middlePillar = [self viewWithTag:MIDDLEPILLAR];
    self.rightPillar = [self viewWithTag:RIGHTPILLAR];
    //配置信息框
    self.messageView.normalPoint = CGPointMake(self.frame.size.width/2, -self.messageView.frame.size.height/2);
    self.messageView.targetPoint = CGPointMake(self.frame.size.width/2, self.messageView.frame.size.height/2);
    self.messageView.center = self.messageView.normalPoint;
    [self.messageView.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    self.tempBoxCount = self.boxCount;
    self.boxView = [[UIView alloc] initWithFrame:self.bounds];//易错，不能用frame,必须是bounds.否则箱子偏下
    [self insertSubview:self.boxView belowSubview:self.messageView];
    [self setUpBox];
    self.isWin = NO;
    self.stepCount = 0;
    self.stepCountSinceNow = 0;
    self.userStepCount = 0;
    self.userStepCountLabel.text = @"第0步";
    [self analysis];
    self.shareObject.stepCount = self.stepCount;
    self.stepCountLabel.text = TEXT(self.stepCount);
    self.stepCountSinceNowLabel.text = TEXT(self.stepCountSinceNow);
    //监听时间是否停止
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeStop:) name:@"TimeStop" object:nil];
    MYLog(@"监听时间停止TimeStop通知");
    //监听是否要自动运行
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analysis) name:@"AutoRunStep" object:nil];
    MYLog(@"监听AutoRunStep通知");
}

//点击暂停
- (IBAction)clickPause:(id)sender {
    self.messageView.topLabel.text = [NSString stringWithFormat:@"目前在G%ld",self.boxCount];
    self.messageView.secondLabel.text = @" ";
    self.messageView.reward.hidden = YES;
    [[SomeAnimat sharedSomeAnimat] animationView:self.messageView To:self.messageView.targetPoint];
}
#pragma mark 配置信息
//配置箱子
- (void)setUpBox{
    MYLog(@"配置box");
    NSInteger pillarTag = LEFTPILLAR;
    CGRect frame = self.leftPillar.frame;
    frame.size.height = ((self.leftPillar.frame.size.height-BOX_INTERVAL)/self.boxCount)-BOX_INTERVAL;
    self.boxHeight = frame.size.height;
    frame.size.width = self.boxView.bounds.size.width / 4;
    NSInteger boxMaxWidth = frame.size.width;
    NSInteger boxMinWidth = 50;
    while (self.tempBoxCount) {
        if (self.isRandom) {
            pillarTag = arc4random()%3 + LEFTPILLAR;
        }
        Pillar *pillar = [self viewWithTag:pillarTag];
        Box *box = [Box buttonWithType:UIButtonTypeCustom];
        [self.boxView addSubview:box];
        [pillar.boxHear addObject:box];
        [box setBackgroundImage:[UIImage imageNamed:@"箱子"] forState:UIControlStateNormal];
        [box setBackgroundImage:[UIImage imageNamed:@"按钮"] forState:UIControlStateSelected];
        box.tag = self.tempBoxCount + BOX_TAG;
        box.userInteractionEnabled = NO;
        //根据不同难度配置箱子数字显示方式
        switch (self.difficulty) {
            case SIMPLE:[box setTitle:TEXT(self.tempBoxCount) forState:UIControlStateNormal]; break;
            case GENERAL:[box setTitle:TEXT(self.tempBoxCount) forState:UIControlStateNormal]; break;
            default: break;
        }
        //box的位置大小
        frame.size.width -= ((boxMaxWidth - boxMinWidth))/self.boxCount;
        box.frame = frame;
        self.tempBoxCount --;
    }
    [self refrashBoxPlace];
}

- (void)timeStop:(NSNotification *)notification{
    if (self.isWin) {
        NSInteger score = [self scoring:[notification.userInfo[@"sumTime"] integerValue] and:[notification.userInfo[@"tempTime"] integerValue]];
        self.messageView.topLabel.text = [NSString stringWithFormat:@"通过G%ld   最高分%ld",self.boxCount,self.self.stepCount * (SIMPLE - self.difficulty + 1) * 2];
        self.messageView.secondLabel.text = [NSString stringWithFormat:@"超出%ld步  得分%ld",self.userStepCount - self.stepCount, score];
        self.messageView.reward.hidden = NO;
        self.shareObject.score += score;
        [self.messageView.reward setTitle:[NSString stringWithFormat:@"x%ld",self.stepCount / 10] forState:UIControlStateNormal];
        MYLog(@"取消TimeStop监听");
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TimeStop" object:nil];
        MYLog(@"取消AutoRunStep监听");
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AutoRunStep" object:nil];

        if (self.boxCount == BOX_MAX) {
            [self.messageView.cancelButton setTitle:@"已通关" forState:UIControlStateNormal];
        }else{
            [self.messageView.cancelButton setTitle:@"下一关" forState:UIControlStateNormal];
            if (self.boxCount == self.shareObject.boxCountMax && self.shareObject.isRandom == NO) {
                self.shareObject.boxCountMax = self.boxCount + 1;
            }
        }
    }else{
        self.messageView.topLabel.text = [NSString stringWithFormat:@"G%ld Over~~~~~",self.boxCount];
        self.messageView.secondLabel.text = @"状态不好，出去呼吸新鲜空气再试试。";
        self.messageView.reward.hidden = YES;
    }
    MYLog(@"弹出信息框%p",self.messageView);
    [[SomeAnimat sharedSomeAnimat] animationView:self.messageView To:self.messageView.targetPoint];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *targetPath = [documentPath stringByAppendingPathComponent:@"userData"];
    //默认文件plist格式
    [[self.shareObject dataInDictionary] writeToFile:targetPath atomically:YES];
}

-(void)refrashBoxPlace{
    for (NSInteger i = LEFTPILLAR; i <= RIGHTPILLAR; i++) {//3根柱子
        Pillar *pillar = [self viewWithTag:i];
        CGPoint center = pillar.center;
        center.y += (pillar.frame.size.height + self.boxHeight) / 2;
        if (pillar.boxHear.count) {
            for (Box *box in pillar.boxHear) {
                center.y -= (self.boxHeight + BOX_INTERVAL);
                box.center = center;
                box.inWhichPillar = pillar;
            }
        }
        pillar.targetCenter = center;
    }
}

#pragma mark - 运行相关
//点击范围
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获取点击坐标
    CGPoint End = [touches.anyObject  locationInView:self.boxView];
    if (End.x < (self.boxView.center.x - self.boxView.frame.size.width/6)){
        self.clickOnWhichPillar = self.leftPillar;
    }else if (End.x > (self.boxView.center.x + self.boxView.frame.size.width/6)){
        self.clickOnWhichPillar = self.rightPillar;
    }else{
        self.clickOnWhichPillar = self.middlePillar;
    }
    [self selectBoxOnPillar];
    self.move = NO;
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.shareObject.isHaveGestureRecognizer && self.move == NO && self.selectBox != nil) {
        self.move = YES;
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.shareObject.isHaveGestureRecognizer && self.move == YES) {
        [self touchesBegan:touches withEvent:event];
    }
}

-(void)selectBoxOnPillar{
    if (self.selectBox == nil) {
        if (self.clickOnWhichPillar.boxHear.count <= 0) {
            return;
        }else{
            self.selectBox = [self.clickOnWhichPillar.boxHear lastObject];
            [self.selectBox setBackgroundImage:[UIImage imageNamed:@"按钮"] forState:UIControlStateNormal];
        }
    }else{
        [self moveBox];
    }
}

-(void)moveBox{
    MYLog(@"移动箱子");
    if (self.clickOnWhichPillar.boxHear.count > 0) {
        Box *box = [self.clickOnWhichPillar.boxHear lastObject];
        if (box.tag < self.selectBox.tag) {
            [self.selectBox setBackgroundImage:[UIImage imageNamed:@"箱子"] forState:UIControlStateNormal];
            self.selectBox = nil;
            return;
        }
    }
    [self.selectBox.inWhichPillar.boxHear removeLastObject];;
    [self.clickOnWhichPillar.boxHear addObject:self.selectBox];
    self.selectBox.inWhichPillar = self.clickOnWhichPillar;//易错，if少了这句,点击太快箱子出错。
    [self.selectBox setBackgroundImage:[UIImage imageNamed:@"箱子"] forState:UIControlStateNormal];
    self.userStepCount ++;
    self.userStepCountLabel.text = [NSString stringWithFormat:@"第%ld步",self.userStepCount];
    CGFloat y = self.clickOnWhichPillar.frame.origin.y - self.selectBox.frame.size.height - BOX_INTERVAL;
    [[SomeAnimat sharedSomeAnimat] animationWithBox:self.selectBox from:self.selectBox.center to:self.clickOnWhichPillar.targetCenter top:y completion:^{
        [self refrashBoxPlace];
    }];
    self.selectBox = nil;
    self.clickOnWhichPillar = nil;
    [self isWinOrNot];
}

- (void)isWinOrNot{
    if (self.rightPillar.boxHear.count == [ShareObject sharedShareObject].boxCount) {
        self.stepCountSinceNowLabel.text = @"0";
        self.isWin = YES;
        MYLog(@"发送Win通知");
        NSDictionary *winDic = @{@"reward":@(self.stepCount / 10)};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Win" object:nil userInfo:winDic];
    }else{
        self.isWin = NO;
    }
}

#pragma mark 自动运行部分
//分析状态
- (void)analysis{
    MYLog(@"开始分析");
    //获取最大箱子tag值
    NSInteger boxTag = self.boxCount + BOX_TAG;
    self.selectBox = [self.boxView viewWithTag:boxTag];
    self.smallerBoxTargetPillarTag = RIGHTPILLAR;
    self.targetPillarTag = RIGHTPILLAR;
    self.clickOnWhichPillar = [self viewWithTag:self.targetPillarTag];
    BOOL isBiggestAtRightPillar = YES;
    NSInteger count = [self squareNumber:2 howMuch:self.boxCount] - 1;
    MYLog(@"self.boxCount = %ld  count = %ld",self.boxCount,count);
    boxTag ++;
    for (NSInteger i = [ShareObject sharedShareObject].boxCount; i > 0; i--) {
        boxTag--;
        self.targetBox = [self.boxView viewWithTag:boxTag];
        //排除大箱子在右边的情况
        if (isBiggestAtRightPillar && self.targetBox.inWhichPillar.tag == RIGHTPILLAR) {
            count -= [self squareNumber:2 howMuch:i - 1];
            continue;
        }
        isBiggestAtRightPillar = NO;
        if (self.targetBox.inWhichPillar.tag == self.smallerBoxTargetPillarTag) {
            count -= [self squareNumber:2 howMuch:i - 1];
            continue;
        }else{
            self.targetPillarTag = self.smallerBoxTargetPillarTag;
            NSInteger pillarTag = [self otherPillarTag:self.targetBox.inWhichPillar.tag and:self.targetPillarTag];
            //判断小箱子目的地是否变化
            if (self.smallerBoxTargetPillarTag != pillarTag){
                self.smallerBoxTargetPillarTag = pillarTag;
                self.selectBox = self.targetBox;
                self.clickOnWhichPillar = [self viewWithTag:self.targetPillarTag];
            }
        }
    }
    self.stepCountSinceNow = count;
    MYLog(@"self.stepCountSinceNow = %ld",self.stepCountSinceNow);
    MYLog(@"分析结束");
    if (self.stepCount == 0) {
        self.stepCount = self.stepCountSinceNow;
        self.selectBox = nil;
        self.clickOnWhichPillar = nil;
        MYLog(@"self.stepCount == %ld",self.stepCount);
        return;
    }
    [self moveBox];
    self.stepCountSinceNowLabel.text = TEXT(self.stepCountSinceNow - 1);
}

#pragma mark 封装方法
//otherPillar
- (NSInteger)otherPillarTag:(NSInteger)oneTag and:(NSInteger)twoTag{
    NSInteger i;
    for (i = LEFTPILLAR ; i < RIGHTPILLAR; i++) {
        if (oneTag != i && twoTag != i) {
            return i;
        }
    }
    return i;
}
- (NSInteger)squareNumber:(NSInteger)number howMuch:(NSInteger)count{
    NSInteger returnNumber = number;
    for (NSInteger i = 1; i < count; i++) {
        returnNumber *= number;
    }
    if (count < 1) return 1;
    return returnNumber;
}
//计分
- (NSInteger)scoring:(NSInteger)sumTime and:(NSInteger)tempTime{
    NSInteger stepScore = self.userStepCount < self.stepCount ? 100 : (self.stepCount * 100) / self.userStepCount;
    NSInteger timeScore = (tempTime * 100) / (sumTime * 0.6);
    timeScore = timeScore > 100 ? 100 : timeScore;
    NSInteger score = self.stepCount * (SIMPLE - self.difficulty + 1);
    score += ((stepScore * timeScore) * score ) / 10000 ;
    MYLog(@"-------------defen%p",self.shareObject);
    return score;
}
- (void)clearAllBox{
    if (self.boxView) [self.boxView removeFromSuperview];
    [self.leftPillar.boxHear removeAllObjects];
    [self.middlePillar.boxHear removeAllObjects];
    [self.rightPillar.boxHear removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TimeStop" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AutoRunStep" object:nil];
}
@end
