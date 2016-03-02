//
//  JFUnlockViewController.m
//  JFUnlockView-master
//
//  Created by Jeffrey on 16/3/2.
//  Copyright © 2016年 WeiJeffrey. All rights reserved.
//


#import "JFUnlockViewController.h"
#import "JFUnlockView.h"
@interface JFUnlockViewController ()<JFUnlockViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segUnlock;
@property (weak, nonatomic) IBOutlet JFUnlockView *unlockView;
@property (weak, nonatomic) IBOutlet UILabel *lbAlert;
@end

@implementation JFUnlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置UISegmentedControl
    [self.segUnlock addTarget:self action:@selector(stateChange) forControlEvents:UIControlEventValueChanged];
    //设置代理
    self.unlockView.delegate = self;
    //警告提示初始为nil
    self.lbAlert.text = nil;
    
    //以下属性均有默认值,但可根据需求随意更改
    
    //设置最小应该滑动的个数为4
    self.unlockView.minBtCount = 4;
    //设置线条颜色
    self.unlockView.lineColor = [UIColor redColor];
    //设置出现错误情况下的线条颜色
    self.unlockView.lineErroeColor = [UIColor blackColor];
    //按钮的宽度
    self.unlockView.buttonW = 74;
    // Do any additional setup after loading the view.
}
//
- (void)stateChange {
    self.lbAlert.text = nil;
    switch (self.segUnlock.selectedSegmentIndex) {
        case 0:
            self.unlockView.unlockState = JFUnlockLogin;
            break;
        case 1:
            self.unlockView.unlockState = JFUnlockPwdSet;
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickReRegister:(UIButton *)sender {
    [self.unlockView reRegister];
    self.lbAlert.text = nil;
}
#pragma mark --- unlock代理
//只要抬起,均会回掉这个方法读取回调的密码
- (void)touchesDoneWithPassWord:(NSString *)pwd {
       NSLog(@"输入的密码为%@",pwd);
}


//注册状态的相关代理
- (void)registerFirstTimeWithPwd:(NSString *)pwd {
    self.lbAlert.text = nil;
}
- (void)registerSucceedWithPwd:(NSString *)pwd {
    NSString *alert = [NSString stringWithFormat:@"设置成功,密码是%@",self.unlockView.password];
    self.lbAlert.text = alert;
    
}
- (void)registerFaildWithPwd:(NSString *)pwd {
    NSString *alert = @"和上次输入不一致,请重试";
    self.lbAlert.text = alert;
}
- (void)registerFaildwithWrongCount:(NSInteger)count {
    NSString *alert = [NSString stringWithFormat:@"请至少链接%ld个点,您当前仅链接了%ld个点",(long)self.unlockView.minBtCount,(long)count];
    self.lbAlert.text = alert;
}
//登录状态的相关代理,在此之前请先设置密码(可以手动给password赋值)
- (void)loginSucceedWithPwd:(NSString *)pwd {
    NSString *alert  = @"登录成功";
    self.lbAlert.text = alert;
}
- (void)loginFaildWithPwd:(NSString *)pwd {
    NSString *alert = @"登录失败";
    self.lbAlert.text = alert;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end