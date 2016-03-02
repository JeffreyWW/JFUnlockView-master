//
//  JFUnlockView.m
//  JFUnlockView-master
//
//  Created by wwww on 16/2/26.
//  Copyright © 2016年 WeiJeffrey. All rights reserved.
//  九宫格为正方形排布，以界面的宽度为基准，所以本类设置的时候最好设置成为正方形大小，其他内容在控制器里面定值，会相对比较灵活

//注意:此demo请不要在设置手势密码第一次的情况下切换至解锁状态,因实际应用中不会出现这种情况,所以没有对应做出优化


#import "JFUnlockView.h"
@interface JFUnlockView ()

//保存按钮
@property(nonatomic,strong)NSArray *buttons;

//保存所有触摸过的按钮
@property(nonatomic,strong)NSMutableArray * selectedButtons;



//记录当前触摸过的点
@property(nonatomic,assign)CGPoint currentPoint;



//临时密码,用于设置密码
@property(nonatomic,strong)NSString *tempPassword;



@end


@implementation JFUnlockView
//懒加载三种状态按钮的图片
-(UIImage *)imgHighlighted {
    if (!_imgHighlighted) {
        _imgHighlighted = [UIImage imageNamed:@"highlighted"];
    }
    return _imgHighlighted;
}
- (UIImage *)imgNormal {
    if (!_imgNormal) {
        _imgNormal = [UIImage imageNamed:@"normal"];
    }
    return _imgNormal;
}

-(UIImage *)imgError {
    if (!_imgError) {
        _imgError = [UIImage imageNamed:@"error"];
    }
    return _imgError;
}
//懒加载触摸过的按钮
- (NSMutableArray *)selectedButtons {
    if (!_selectedButtons) {
        _selectedButtons = [NSMutableArray array];
    }
    return _selectedButtons;
}

//懒加载线条的颜色,设置默认为红色
- (UIColor *)lineColor {
    if (!_lineColor) {
        _lineColor = [UIColor redColor];
    }
    return _lineColor;
}
- (UIColor *)lineErroeColor {
    if (!_lineErroeColor) {
        _lineErroeColor = [UIColor blueColor];
    }
    return _lineErroeColor;
}
- (CGFloat)buttonW {
    if (_buttonW <= 0) {
        _buttonW = 74.0f;
    }
    return _buttonW;
}
//懒加载按钮数组
- (NSArray *)buttons {
    if (!_buttons) {
        NSMutableArray *arrM = [NSMutableArray array];
        for (int i = 0; i < 9 ; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag  = i;
            button.userInteractionEnabled = NO;
            //设置按钮的图片
            [button setBackgroundImage:self.imgNormal forState:UIControlStateNormal];
            [button setBackgroundImage:self.imgHighlighted forState:UIControlStateSelected];
            [button setBackgroundImage:self.imgError forState:UIControlStateDisabled];
            [self addSubview:button];
            [arrM addObject:button];
        }
        self.buttons = arrM.copy;
    }
    return _buttons;
}

//设置按钮的frame
- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    //设置按钮的宽度和高度
    CGFloat buttonW = self.buttonW;
    CGFloat buttonH = buttonW;
    //列数
    NSInteger col = 3;
    //间距,View的整体宽度,减去所有按钮的宽度除以几个间距
    CGFloat margin = (self.bounds.size.width - col * buttonW) / (col - 1);
    //设置按钮的frame
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton *button = self.buttons[i];
        CGFloat buttonX = (buttonW + margin) * (i % col);
        CGFloat buttonY = (buttonH + margin) * (i / col);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    }
}
#pragma mark --- 触摸的一些方法
//触摸开始
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //获取当前按下的点
    UITouch *touch = touches.anyObject;
    CGPoint spot = [touch locationInView:touch.view];
    //判断开始按下的点是否在button的frame里,一旦在,就跳出循环
    for (UIButton *button in self.buttons) {
        if (CGRectContainsPoint(button.frame, spot) && !button.isSelected) {
            [self.selectedButtons addObject:button];
            button.selected = YES;
            break;
        }
    }
}
//正在触摸

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //获取当前按下的点
    UITouch *touch = touches.anyObject;
    CGPoint spot = [touch locationInView:touch.view];
    //记录当前触摸的点
    self.currentPoint = spot;
    //判断开始按下的点是否在button的frame里,一旦在,就跳出循环
    for (UIButton *button in self.buttons) {
        if (CGRectContainsPoint(button.frame, spot) && !button.isSelected) {
            [self.selectedButtons addObject:button];
            button.selected = YES;
            break;
        }
    }
    //重绘
    [self setNeedsDisplay];
}

//触摸结束(手指抬起事件)
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //防止出错无法让currentPoint变成按钮的中心点
    self.currentPoint = [[self.selectedButtons lastObject] center];
    
    //获取用户密码
    NSMutableString *password = [NSMutableString string];
    for (UIButton *button in self.selectedButtons) {
        [password appendFormat:@"%@",@(button.tag)];
    }
    
    //代理调用密码,以便外部可以使用
    if ([self.delegate respondsToSelector:@selector(touchesDoneWithPassWord:)]) {
        [self.delegate touchesDoneWithPassWord:password];
    }
    //不同状态下抬起以后界面效果不同,解锁状态下如果输入的和密码不匹配,将会显示进入对应的情形.
    
    switch (self.unlockState) {
            //解锁状态
        case JFUnlockLogin:
            //判断密码是否正确,之后:
            if ([password isEqualToString:self.password]) {
                [self clearLockView];
                if ([self.delegate respondsToSelector:@selector(loginSucceedWithPwd:)]) {
                     [self.delegate loginSucceedWithPwd:password];
                }
            } else {
                [self errorState];
                if ([self.delegate respondsToSelector:@selector(loginFaildWithPwd:)]) {
                     [self.delegate loginFaildWithPwd:password];
                }
            }
            break;
            
            //设置手势密码的状态下:
        case JFUnlockPwdSet:
            //如果临时密码不存在,那么设置其为刚刚滑动的密码,反之如果存在,则直接对比,正确则把密码赋值给正式密码,错误则显示对应的情形
            if (!self.tempPassword) {
                //如果设置了最小设置数量,那么需要相符
                if (self.minBtCount > 0) {
                    if (self.selectedButtons.count < self.minBtCount) {
                        [self errorState];
                        if ([self.delegate respondsToSelector:@selector(registerFaildwithWrongCount:)]) {
                            [self.delegate registerFaildwithWrongCount:self.selectedButtons.count];
                        }
                        return;
                    }
                }
                //设置第一次滑动密码
                self.tempPassword = password;
                [self dismissState];
                if ([self.delegate respondsToSelector:@selector(registerFirstTimeWithPwd:)]) {
                    [self.delegate registerFirstTimeWithPwd:password];
                }
            } else {
                if ([self.tempPassword isEqualToString:password]) {
                    self.password = password;
                    [self dismissState];
                    if ([self.delegate respondsToSelector:@selector(registerSecondTimeWithPwd:)]) {
                        [self.delegate registerSecondTimeWithPwd:password];
                    }
                    if ([self.delegate respondsToSelector:@selector(registerSucceedWithPwd:)]) {
                         [self.delegate registerSucceedWithPwd:password];
                    }
                } else {
//                    self.tempPassword = nil;//临时密码清空,重新开始输入
                    [self errorState];
                    if ([self.delegate respondsToSelector:@selector(registerFaildWithPwd:)]) {
                        [self.delegate registerFaildWithPwd:password];
                    }
                }
            }
            break;
            
        default:
            break;
    }
    
}
//重置临时密码,之后可以重新开始注册
- (void)reRegister {
    self.tempPassword = nil;
}
//密码输入错误,或者两次密码输入不一致的情形
- (void)errorState {
    //颜色变成红色
    self.lineColor = self.lineErroeColor;
    
    //禁止用户交互
    self.userInteractionEnabled = NO;
    
    //设置所有按钮为禁用的状态
    for (UIButton *button in self.selectedButtons) {
        button.selected = NO;
        button.enabled = NO;
    }
    //重绘
    [self setNeedsDisplay];
    //设置某段时间之后回到默认状态
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self clearLockView];
        //开启用户交互
        self.userInteractionEnabled = YES;
    });
}
//常规消失状态(可优化)
-(void)dismissState {
    //颜色变成红色
//    self.lineColor = [UIColor blueColor];
    
    //禁止用户交互
    self.userInteractionEnabled = NO;
    
    //设置所有按钮为禁用的状态
    for (UIButton *button in self.selectedButtons) {
        button.selected = NO;
//        button.enabled = NO;
    }
    //重绘
    [self setNeedsDisplay];
    //设置某段时间之后回到默认状态
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self clearLockView];
        //开启用户交互
        self.userInteractionEnabled = YES;
    });
    
}
//回到默认状态
- (void)clearLockView {
    for (UIButton *button in self.selectedButtons) {
        button.selected = NO;
        button.enabled = YES;
    }
    //清空线条(应该要把线条完全清除,这里只是清除了颜色)
    self.lineColor = nil;
    //删除所有状态
    [self.selectedButtons removeAllObjects];
    //当前点归零
    self.currentPoint = CGPointZero;
    //重绘
    [self setNeedsDisplay];
 
}

//绘图
- (void)drawRect:(CGRect)rect {
    //获取上下文
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //绘制路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:8];
    
    for (int i = 0; i < self.selectedButtons.count; i ++) {
        UIButton *button = self.selectedButtons[i];
        if (i == 0) {//如果是第一个,那么先移动到这个点
            [path moveToPoint:button.center];
        } else {//如果移动的到第二个或者别的点了,增加一条直线到这个点
            [path addLineToPoint:button.center];
        }
        
    }
    if (!CGPointEqualToPoint(self.currentPoint, CGPointZero)) {
        [path addLineToPoint:self.currentPoint];//多余的线条画出来
    }
    //起始点是第一个,然后如果有多个
    //把路径添加到上下文
//    CGContextAddPath(ctx, path.CGPath);
    //设置颜色
    [self.lineColor set];
    //渲染
//    CGContextDrawPath(ctx, kCGPathStroke);
    [path stroke];
}



@end
