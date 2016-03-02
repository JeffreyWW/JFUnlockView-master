//
//  JFUnlockView.h
//  JFUnlockView-master
//
//  Created by wwww on 16/2/26.
//  Copyright © 2016年 WeiJeffrey. All rights reserved.
////  九宫格为正方形排布，以界面的宽度为基准，所以本类设置的时候最好设置成为正方形大小，其他内容在控制器里面定值，会相对比较灵活

//注意:此demo请不要在设置手势密码第一次的情况下切换至解锁状态,因实际应用中不会出现这种情况,所以没有对应做出优化

#import <UIKit/UIKit.h>
@protocol JFUnlockViewDelegate <NSObject>

@optional
//滑动完成以后的代理方法，pwd为返回的点击按钮的字符串,为0-9连续数字,两种状态均会走次方法
- (void)touchesDoneWithPassWord:(NSString*)pwd;

//JFUnlockPwdSet设置密码状态下的回调方法
- (void)registerFirstTimeWithPwd:(NSString*)pwd;//第一次滑动密码
- (void)registerSecondTimeWithPwd:(NSString*)pwd;//第二次滑动密码
- (void)registerFaildWithPwd:(NSString*)pwd;//注册失败即两次输入不一致后的回调方法
- (void)registerFaildwithWrongCount:(NSInteger)count;//注册失败,设置的个数小于了预期
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
//解锁类的代理,一般设置为当前控制器即可
@property(nonatomic,weak)id<JFUnlockViewDelegate>delegate;

//当前的状态是设置手势密码还是解锁,注册设置为JFUnlockPwdSet,登录设置为JFUnlockLogin即可
@property(nonatomic,assign)JFUnlockState unlockState;

//保存的密码,可赋值,用于后期判断,此密码最好先经过加密.
@property(nonatomic,strong)NSString *password;

//最小需要滑动的按钮数,如果小于该设置,将会触发registerFaildwithWrongCount:(NSInteger)count方法
@property(nonatomic,assign)NSInteger minBtCount;

//线条颜色,默认为红色,可更改
@property(nonatomic,strong)UIColor *lineColor;

//滑动结束时候错误的颜色,默认是蓝色,可更改,如登录中密码输入错误,或者注册时候第二次输入和第一次不一致或者滑动按钮数小于设置的最小个数的情况
@property(nonatomic,strong)UIColor *lineErroeColor;

//里面按钮的宽度(边长),默认是74
@property(nonatomic,assign)CGFloat buttonW;

//所有按钮三种状态的图片,默认为对应的三个图片,如果需要使用默认图片,需要导入,如果使用自定义图片,初始化以后赋值即可(不能为空)
@property(nonatomic,strong)UIImage *imgHighlighted;
@property(nonatomic,strong)UIImage *imgError;
@property(nonatomic,strong)UIImage *imgNormal;

#pragma mark --- methods
//重置临时密码,之后可以重新注册手势密码
-(void)reRegister;


@end
