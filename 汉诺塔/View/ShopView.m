//
//  shopView.m
//  汉诺塔
//
//  Created by tarena311🐟 on 16/3/21.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "shopView.h"
#import "ShareObject.h"
#import "SomeAnimat.h"
#define EACHHELLPTIMESCORE 100
#define EACHHELLPSTEPSCORE 120
@interface ShopView()
@property (weak, nonatomic) IBOutlet UILabel *hellpTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hellpStepLabel;
@property (weak, nonatomic) IBOutlet UISlider *hellpTimeSlider;
@property (weak, nonatomic) IBOutlet UISlider *hellpStepSlider;
@property (weak, nonatomic) IBOutlet UILabel *scoreCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UIButton *stepButton;
@property (weak, nonatomic) IBOutlet UILabel *sumScoreLabel;
@property (nonatomic) NSInteger scoreCount;
@end
@implementation ShopView
- (IBAction)timeSlider:(UISlider *)sender {
    NSInteger maxCount = ([ShareObject sharedShareObject].score - NUMBEROFLABEL(hellpStepLabel) * EACHHELLPSTEPSCORE) / EACHHELLPTIMESCORE;
    [self changeSliderValue:sender and:maxCount];
}
- (IBAction)stepSlider:(UISlider *)sender {
    NSInteger maxCount = ([ShareObject sharedShareObject].score - NUMBEROFLABEL(hellpTimeLabel) * EACHHELLPTIMESCORE) / EACHHELLPSTEPSCORE;
    [self changeSliderValue:sender and:maxCount];
}

- (IBAction)clickHellpTimeButton:(UIButton *)sender {
    if (self.moreScore > 0 && self.moreScore < 9 && self.hellpTimeSlider.value == 0) {
        self.moreScore ++;
    }else{
        self.moreScore = 0;
    }
    ShareObject *shareObject = [ShareObject sharedShareObject];
    shareObject.hellpTimeCount += self.hellpTimeSlider.value;
    shareObject.score -= (NSInteger)self.hellpTimeSlider.value * EACHHELLPTIMESCORE;
    [self timeSlider:self.hellpTimeSlider];
}

- (IBAction)clickHellpStepButton:(UIButton *)sender {
    if (self.moreScore == 0 && self.hellpStepSlider.value == 0) {
        self.moreScore = 1;
    }else{
        self.moreScore = 0;
    }
    ShareObject *shareObject = [ShareObject sharedShareObject];
    shareObject.hellpStepCount += self.hellpStepSlider.value;
    shareObject.score -= (NSInteger)self.hellpStepSlider.value * EACHHELLPSTEPSCORE;
    [self stepSlider:self.hellpStepSlider];
}
- (IBAction)clickOK:(UIButton *)sender {
    if (self.moreScore == 9 && self.hellpTimeSlider.value == 0 && self.hellpStepSlider.value == 0) {
        self.moreScore = 0;
        [ShareObject sharedShareObject].score += 10000;
        self.sumScoreLabel.text = TEXT([ShareObject sharedShareObject].score);
    }
    [self clickHellpTimeButton:nil];
    [self clickHellpStepButton:nil];
}

- (void)changeSliderValue:(UISlider *)sender and:(NSInteger)maxCount{
    if(sender.maximumValue > maxCount && sender.value > maxCount){
        sender.value = maxCount;
    }
    [self reflashView];
}

- (void)reflashView{
    self.hellpTimeLabel.text = TEXT(self.hellpTimeSlider.value);
    self.hellpStepLabel.text = TEXT(self.hellpStepSlider.value);
    self.scoreCount = (NUMBEROFLABEL(hellpTimeLabel) * EACHHELLPTIMESCORE) + (NUMBEROFLABEL(hellpStepLabel) * EACHHELLPSTEPSCORE);
    self.scoreCountLabel.text = TEXT(self.scoreCount);
    self.sumScoreLabel.text = TEXT([ShareObject sharedShareObject].score);
    [self.timeButton setTitle:TEXT([ShareObject sharedShareObject].hellpTimeCount) forState:UIControlStateNormal];
    [self.stepButton setTitle:TEXT([ShareObject sharedShareObject].hellpStepCount) forState:UIControlStateNormal];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
