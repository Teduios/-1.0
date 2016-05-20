//
//  PlayView.h
//  汉诺塔
//
//  Created by tarena311🐟 on 16/3/15.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface PlayView : UIView
@property (nonatomic, strong) Message *messageView;
@property (nonatomic, strong) UIView *boxView;

- (void)clearAllBox;
- (void)start;
- (void)refrashBoxPlace;
@end
