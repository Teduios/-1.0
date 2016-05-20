//
//  PlayViewController.m
//  汉诺塔
//
//  Created by tarena311🐟 on 16/3/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "PlayViewController.h"
#import "ShareObject.h"
#import "Message.h"
#import "PlayView.h"
#import "PlayStateView.h"

@interface PlayViewController ()<MessageDelegate>
@property (weak, nonatomic) IBOutlet PlayView *playView;
@property (weak, nonatomic) IBOutlet PlayStateView *playStateView;
@property (nonatomic, weak) ShareObject *shareObject;
@property (nonatomic, strong) Message *messageView;
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shareObject = [ShareObject sharedShareObject];
    [self addStartButton];
}
//强制横屏
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
//添加按钮
- (void)addStartButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = self.view.frame;
    [button setBackgroundColor:[UIColor lightGrayColor]];
    [button setTitle:@"点击         开始" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickStartButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.playView addSubview:button];
    [self.playStateView reflashStateView];
    MYLog(@"self.playStateView%p",self.playStateView);
}
//按钮事件
- (void)clickStartButton:(UIButton *)button{
    self.messageView = [[NSBundle mainBundle] loadNibNamed:@"Message" owner:nil options:nil].firstObject;
    self.messageView.delegate = self;
    self.messageView.autoresizingMask = NO;//少这步可能信息框太大
    self.playView.messageView = self.messageView;
    //处理事件
    [self.playView start];
    [self.playView addSubview:self.messageView];
    [self.playStateView timeGoing];
    //移除按钮
    [button removeFromSuperview];
}
//清除上一次所有事件
- (void)clearAllObjects{
    [self.playView clearAllBox];
    [self.playStateView stopAllTimers:nil];
}



#pragma mark MessageDelegate
- (void)giveUp{
    [self clearAllObjects];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)again{
    [self clearAllObjects];
    [self.playView start];
    [self.playStateView timeGoing];
}
- (void)nextOne{
    if (self.shareObject.boxCount < self.shareObject.boxCountMax) {
        self.shareObject.boxCount ++;
    }else{
        self.shareObject.boxCount = self.shareObject.boxCountMax;
    }
    [self again];
}

//- (void)viewDidAppear:(BOOL)animated{
//    [self.playStateView timeGoing];
//}

//- (void)viewWillDisappear:(BOOL)animated{
//    [self.playStateView stopAllTimers];
//}
//- (void)viewWillAppear:(BOOL)animated{
//    [[ShareObject sharedShareObject] soundPlaying];
//}
//
//- (void)viewDidDisappear:(BOOL)animated{
//    [[ShareObject sharedShareObject] soundPause];
//}
@end
