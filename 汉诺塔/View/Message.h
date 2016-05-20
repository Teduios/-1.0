//
//  Message.h
//  汉诺塔
//
//  Created by tarena311🐟 on 16/3/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SomeAnimat.h"

@class MessageDelegate;
@protocol MessageDelegate <NSObject>
- (void)giveUp;
- (void)again;
- (void)nextOne;
@end
@interface Message : UIView
@property (nonatomic) CGPoint normalPoint;
@property (nonatomic) CGPoint targetPoint;
@property (nonatomic, weak) id<MessageDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UIButton *reward;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end
