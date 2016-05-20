//
//  Pillar.m
//  汉诺塔
//
//  Created by tarena311🐟 on 16/3/16.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "Pillar.h"

@implementation Pillar

- (NSMutableArray *)boxHear{
    if (!_boxHear) {
        MYLog(@"- (NSMutableArray *)boxHear");
        _boxHear = [NSMutableArray array];
    }
    return _boxHear;
}

@end
