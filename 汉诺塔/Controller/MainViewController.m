//
//  MainViewController.m
//  汉诺塔
//
//  Created by tarena311🐟 on 16/3/16.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "MainViewController.h"
#import "ShareObject.h"
#import "ShopView.h"
#import "SomeAnimat.h"

@interface MainViewController ()<UIPopoverPresentationControllerDelegate >

@property (weak, nonatomic) IBOutlet UIButton *simpleButton;
@property (weak, nonatomic) IBOutlet UIButton *generalButton;
@property (weak, nonatomic) IBOutlet UIButton *hardButton;
@property (weak, nonatomic) IBOutlet UIStepper *boxCountStepper;
@property (weak, nonatomic) IBOutlet UITextField *boxCountTextField;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UIButton *shopButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewLayout;
@property (nonatomic, strong) ShopView *shopView;
//传参属性
@property (nonatomic) NSInteger difficulty;
@property (nonatomic) BOOL isRandom;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //获取数据文件的源路径
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"userData" ofType:nil];
    //拼接拷贝到的目标的路径(/Documents/sqlite.db)
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *targetPath = [documentPath stringByAppendingPathComponent:@"userData"];
    //拷贝
    NSError *error = nil;
    //如果拷贝过了，直接创建对象
    if (![[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:targetPath error:&error];
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
    }
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:targetPath];
    ShareObject *shareObject = [ShareObject sharedShareObject];
    shareObject.score = [dic[@"score"] integerValue];
    shareObject.hellpTimeCount = [dic[@"hellpTimeCount"] integerValue];
    shareObject.hellpStepCount = [dic[@"hellpStepCount"] integerValue];
    if ([dic[@"boxCountMax"] integerValue] > BOX_MAX) {
        shareObject.boxCountMax = BOX_MAX;
    }else{
        shareObject.boxCountMax = [dic[@"boxCountMax"] integerValue];
    }
    shareObject.isHaveGestureRecognizer = [dic[@"isHaveGestureRecognizer"] boolValue];
    shareObject.isSound = [dic[@"isSound"] boolValue];
    [shareObject soundPlay];
    self.difficulty = SIMPLE;
    self.boxCountStepper.minimumValue = BOX_MIN;
    self.boxCountStepper.maximumValue = shareObject.boxCountMax;
    self.boxCountStepper.value = shareObject.boxCountMax;
    self.boxCountTextField.text = TEXT(self.boxCountStepper.value);
}

//强制横屏
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickSimple:(UIButton *)sender {
    sender.selected = YES;
    self.generalButton.selected = NO;
    self.hardButton.selected = NO;
    self.difficulty = SIMPLE;
}
- (IBAction)clickGeneral:(UIButton *)sender {
    sender.selected = YES;
    self.simpleButton.selected = NO;
    self.hardButton.selected = NO;
    self.difficulty = GENERAL;
}
- (IBAction)clickHard:(UIButton *)sender {
    sender.selected = YES;
    self.generalButton.selected = NO;
    self.simpleButton.selected = NO;
    self.difficulty = HARD;
}
- (IBAction)clickStart:(id)sender {
    self.isRandom = NO;
}
- (IBAction)clickRandom:(id)sender {
    self.isRandom = YES;
}
//配置输入
- (IBAction)clickBoxCountTextField:(id)sender {
    [self.boxCountTextField becomeFirstResponder];
    self.boxCountTextField.text = TEXT([self.boxCountTextField.text integerValue] % 10);
    if ([self.boxCountTextField.text integerValue] < BOX_MIN) {
        self.boxCountTextField.text = TEXT(BOX_MIN);
    }else if ([self.boxCountTextField.text integerValue] > [ShareObject sharedShareObject].boxCountMax){
        self.boxCountTextField.text = TEXT([ShareObject sharedShareObject].boxCountMax);
    }
    self.boxCountStepper.value = [self.boxCountTextField.text integerValue];
}
- (IBAction)clickBoxCountStepper:(UIStepper *)sender {
    self.boxCountTextField.text = TEXT(sender.value);
}
- (IBAction)shopping:(UIButton *)sender {
    [self.shopView reflashView];
    [[SomeAnimat sharedSomeAnimat] animationView:self.shopView To:self.shopView.targetPoint];
}

-(ShopView *)shopView{
    if (!_shopView) {
        _shopView = [[NSBundle mainBundle] loadNibNamed:@"ShopView" owner:nil options:nil].firstObject;
        _shopView.autoresizingMask = NO;
        //配置大小
        CGRect frame = _shopView.frame;
        frame.size.width = self.view.frame.size.width - 40;
        _shopView.frame = frame;
        MYLog(@"%f,%f",frame.size.height,frame.size.width);
        //配置中心位置
        CGPoint center = self.view.center;
        center.y += self.view.frame.size.height / 2 + _shopView.frame.size.height / 2;
        _shopView.center = center;
        _shopView.normalPoint = center;
        center.y -= _shopView.frame.size.height;
        _shopView.targetPoint = center;
        _shopView.moreScore = 0;
        [self.view addSubview:_shopView];
    }
    return _shopView;
}
#pragma mark - 键盘配置
//键盘弹出设置
-(void)viewWillAppear:(BOOL)animated{
    self.score.text = [NSString stringWithFormat:@"Hanoi"];
    self.boxCountStepper.maximumValue = [ShareObject sharedShareObject].boxCountMax;
    self.boxCountStepper.value = self.boxCountStepper.maximumValue;
    self.boxCountTextField.text = TEXT([ShareObject sharedShareObject].boxCountMax);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)showKeyboard:(NSNotification *)notification{
    // 读取userInfo中的动画种类
    NSInteger option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    // 读取userInfo中的动画时长
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //获取弹起的键盘的frame中的左顶点位置的y
    CGFloat height = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.bottomViewLayout.constant = height;
    [UIView animateWithDuration:duration    delay:0 options:option animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}
-(void)closeKeyboard:(NSNotification *)notification{
    self.bottomViewLayout.constant = 0;
    [self.view layoutIfNeeded];
}
//键盘收回设置
-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ShareObject *shareObject = [ShareObject sharedShareObject];
    shareObject.difficulty = self.difficulty;
    shareObject.isRandom = self.isRandom;
    shareObject.boxCount = [self.boxCountTextField.text integerValue];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.boxCountTextField resignFirstResponder];
    [[SomeAnimat sharedSomeAnimat] animationView:self.shopView To:self.shopView.normalPoint];
}
@end
