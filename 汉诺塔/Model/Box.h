//
//  Box.h
//  汉诺塔
//
//  Created by tarena311🐟 on 16/3/16.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pillar.h"

@interface Box : UIButton
@property (nonatomic) Pillar *inWhichPillar;
@end
