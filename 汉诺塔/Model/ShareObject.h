//
//  ShareObject.h
//  汉诺塔
//
//  Created by tarena311🐟 on 16/3/17.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface ShareObject : NSObject
singleton_interface(ShareObject)
//基本参数
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger hellpTimeCount;
@property (nonatomic) NSInteger hellpStepCount;
@property (nonatomic) NSInteger boxCountMax;
//MainViewController传来参数
@property (nonatomic) NSInteger difficulty;
@property (nonatomic) BOOL isRandom;
@property (nonatomic) NSInteger boxCount;
//PlayViewController传来参数
@property (nonatomic) NSInteger stepCount;
@property (nonatomic) NSInteger stepCountSinceNow;
//HellpViewController传来参数
@property (nonatomic) BOOL isHaveGestureRecognizer;
@property (nonatomic) BOOL isSound;

- (void)soundPlay;
- (void)soundPause;
- (void)soundPlaying;
- (NSDictionary *)dataInDictionary;
@end
