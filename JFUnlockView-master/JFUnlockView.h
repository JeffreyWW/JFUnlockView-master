//
//  JFUnlockView.h
//  JFUnlockView-master
//
//  Created by wwww on 16/2/26.
//  Copyright © 2016年 WeiJeffrey. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JFUnlockViewDelegate <NSObject>

@optional
//滑动完成以后的代理方法，pwd为返回的点击按钮的字符串,为0-9连续数字,两种状态均会走次方法
- (void)touchesDoneWithPassWord:(NSString*)pwd;

//JFUnlockPwdSet设置密码状态下的回调方法
- (void)registerFirstTimeWithPwd:(NSString*)pwd;//第一次滑动密码
- (void)registerSecondTimeWithPwd:(NSString*)pwd;//第二次滑动密码
- (void)registerFaildWithPwd:(NSString*)pwd;//注册失败即两次输入不一致后的回调方法
- (void)registerSucceedWithPwd:(NSString*)pwd;//注册成功,即两次输入一致后的方法,成功后会给JFUnlockView类的passowrd赋值


//JFUnlockLogin状态,即登录状态下的回调方法
- (void)loginSucceedWithPwd:(NSString*)pwd;
- (void)loginFaildWithPwd:(NSString*)pwd;
@end


@interface JFUnlockView : UIView
typedef NS_ENUM(NSInteger, JFUnlockState){
    JFUnlockLogin,
    JFUnlockPwdSet
};
//解锁类的代理
@property(nonatomic,weak)id<JFUnlockViewDelegate>delegate;

//当前的状态是设置手势密码还是解锁
@property(nonatomic,assign)JFUnlockState unlockState;

//保存的密码,可赋值,用于后期判断,此密码最好先经过加密.
@property(nonatomic,strong)NSString *password;



@end
