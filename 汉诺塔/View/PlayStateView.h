//
//  PlayStateView.h
//  汉诺塔
//
//  Created by tarena311🐟 on 16/3/15.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PlayStateView : UIView
- (void)reflashStateView;
- (void)timeGoing;
//- (void)viewWillAppear;
//- (void)viewDidDisappear;
- (void)stopAllTimers:(NSNotification *)notification;
@end
