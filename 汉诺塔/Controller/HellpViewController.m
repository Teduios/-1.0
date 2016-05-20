//
//  HellpViewController.m
//  汉诺塔
//
//  Created by tarena311🐟 on 16/3/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HellpViewController.h"
#import "authorTableViewController.h"
#import "ShareObject.h"

@interface HellpViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *seniorSwitch;

@end

@implementation HellpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.soundSwitch.on = [ShareObject sharedShareObject].isSound;
    self.seniorSwitch.on = [ShareObject sharedShareObject].isHaveGestureRecognizer;
}
//强制横屏
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)clickSoundSwitch:(UISwitch *)sender {
    [ShareObject sharedShareObject].isSound = sender.on;
    [[ShareObject sharedShareObject] soundPlay];
}
- (IBAction)clickSeniorSwitch:(UISwitch *)sender {
    [ShareObject sharedShareObject].isHaveGestureRecognizer = sender.on;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)viewWillAppear:(BOOL)animated{
//    [[ShareObject sharedShareObject] soundPlaying];
//}
//- (void)viewDidDisappear:(BOOL)animated{
//    [[ShareObject sharedShareObject] soundPause];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    AuthorTableViewController *authorVC = segue.destinationViewController;
    authorVC.transitioningDelegate = self.transitioningDelegate;
    
}
@end
