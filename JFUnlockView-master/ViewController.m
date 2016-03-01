//
//  ViewController.m
//  JFUnlockView-master
//
//  Created by wwww on 16/2/26.
//  Copyright © 2016年 WeiJeffrey. All rights reserved.
//

#import "ViewController.h"
#import "JFUnlockView.h"
@interface ViewController ()<JFUnlockViewDelegate>
@property(nonatomic,strong)UIView *v;
@property (weak, nonatomic) IBOutlet JFUnlockView *unlockView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segUnloackState;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       NSLog(@"已进入主界面,初始密码是%@",self.unlockView.password);
    self.unlockView.delegate = self;
    [self.segUnloackState addTarget:self action:@selector(unlockStateConfig) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)unlockStateConfig {
    switch (self.segUnloackState.selectedSegmentIndex) {
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
#pragma mark --- 解锁类的回调方法
//只要滑动结束,都会执行
- (void)touchesDoneWithPassWord:(NSString *)pwd {
       NSLog(@"滑动后得到的指令密码是%@,真实密码是%@",pwd,self.unlockView.password);
}

//注册时候的第一次输入
-(void)registerFirstTimeWithPwd:(NSString *)pwd {
       NSLog(@"注册,第一次,指令密码是%@,真实密码是%@",pwd,self.unlockView.password);
}

//注册时候的第二次输入
-(void)registerSecondTimeWithPwd:(NSString *)pwd {
       NSLog(@"注册,第二次,指令密码是%@,真实密码是%@",pwd,self.unlockView.password);
}

//注册成功
- (void)registerSucceedWithPwd:(NSString *)pwd {
       NSLog(@"注册成功,指令密码是%@,真实密码是%@",pwd,self.unlockView.password);
}

//注册失败
- (void)registerFaildWithPwd:(NSString *)pwd {
        NSLog(@"注册失败,指令密码是%@,真实密码是%@",pwd,self.unlockView.password);
}

//登录成功
- (void)loginSucceedWithPwd:(NSString *)pwd {
       NSLog(@"登录成功,指令密码是%@,真实密码是%@",pwd,self.unlockView.password);
}

//登录失败
- (void)loginFaildWithPwd:(NSString *)pwd {
       NSLog(@"登录失败,指令密码是%@,真实密码是%@",pwd,self.unlockView.password);
}




@end
