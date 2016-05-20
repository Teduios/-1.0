//
//  authorTableViewController.m
//  汉诺塔
//
//  Created by tarena311🐟 on 16/3/13.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "AuthorTableViewController.h"
#import "ShareObject.h"

@interface AuthorTableViewController ()

@end

@implementation AuthorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//强制横屏
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *targetPath = [documentPath stringByAppendingPathComponent:@"userData"];
        NSInteger boxCountMax = BOX_MIN;
        NSDictionary *dic = @{@"name":@"user",
                              @"score":@(3000),
                              @"hellpTimeCount": @(30),
                              @"hellpStepCount":@(30),
                              @"boxCountMax":@(boxCountMax),
                              @"isHaveGestureRecognizer":@(NO),
                              @"isSound":@(YES)};
        //默认文件plist格式
        [dic writeToFile:targetPath atomically:YES];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.text = @"清除成功:软件重启生效";
    }else{
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//- (void)viewWillAppear:(BOOL)animated{
//    [[ShareObject sharedShareObject] soundPlaying];
//}
//- (void)viewDidDisappear:(BOOL)animated{
//    [[ShareObject sharedShareObject] soundPause];
//}
@end
