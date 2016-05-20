//
//  ShareObject.m
//  汉诺塔
//
//  Created by tarena311🐟 on 16/3/17.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ShareObject.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
@interface ShareObject()
//音频(本地音频)
@property (nonatomic, strong) AVAudioPlayer *player;

@end
@implementation ShareObject
singleton_implementation(ShareObject)
- (void)soundPlay{
    //1.音频文件路径
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"If I Were A Bird" ofType:@"m4a"];
    //2.创建对象(执行文件)
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:audioPath] error:nil];
    //3.播放
    if (self.isSound) {
        [self.player play];
        [self.player setNumberOfLoops:999999];
    }else{
        [self.player stop];
    }
}

- (void)soundPause{
    if (self.isSound && [UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        [self.player pause];
    }
}

- (void)soundPlaying{
    if (self.isSound) {
        [self.player play];
        [self.player setNumberOfLoops:999999];
    }
}

- (NSDictionary *)dataInDictionary{
    return @{@"name":@"user",
            @"score":@(self.score),
            @"hellpTimeCount": @(self.hellpTimeCount),
            @"hellpStepCount":@(self.hellpStepCount),
            @"boxCountMax":@(self.boxCountMax),
            @"isHaveGestureRecognizer":@(self.isHaveGestureRecognizer),
            @"isSound":@(self.isSound)};
}
@end
