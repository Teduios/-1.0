//
//  Message.m
//  汉诺塔
//
//  Created by tarena311🐟 on 16/3/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "Message.h"
#import "ShareObject.h"
#import "PlayViewController.h"

@interface Message()
@end

@implementation Message
- (IBAction)clickGiveUp:(id)sender {
    [[SomeAnimat sharedSomeAnimat] animationView:self To:self.normalPoint];
    [self.delegate giveUp];
}
- (IBAction)clickAgain:(id)sender {
    [[SomeAnimat sharedSomeAnimat] animationView:self To:self.normalPoint];
    [self.delegate again];
}
- (IBAction)clickChanel:(UIButton *)sender {
    [[SomeAnimat sharedSomeAnimat] animationView:self To:self.normalPoint];
    if ([sender.titleLabel.text isEqualToString:@"下一关"] || [sender.titleLabel.text isEqualToString:@"已通关"]) [self.delegate nextOne];
}


@end
