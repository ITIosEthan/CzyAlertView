//  CzyAlertView.h
//  CzyAlterView
//  Created by macOfEthan on 17/9/26.
//  Copyright © 2017年 macOfEthan. All rights reserved.
//  Github:https://github.com/ITIosEthan
//  简书：http://www.jianshu.com/u/1d52648daace
/**
 *   █████▒█    ██  ▄████▄   ██ ▄█▀   ██████╗ ██╗   ██╗ ██████╗
 * ▓██   ▒ ██  ▓██▒▒██▀ ▀█   ██▄█▒    ██╔══██╗██║   ██║██╔════╝
 * ▒████ ░▓██  ▒██░▒▓█    ▄ ▓███▄░    ██████╔╝██║   ██║██║  ███╗
 * ░▓█▒  ░▓▓█  ░██░▒▓▓▄ ▄██▒▓██ █▄    ██╔══██╗██║   ██║██║   ██║
 * ░▒█░   ▒▒█████▓ ▒ ▓███▀ ░▒██▒ █▄   ██████╔╝╚██████╔╝╚██████╔╝
 *  ▒ ░   ░▒▓▒ ▒ ▒ ░ ░▒ ▒  ░▒ ▒▒ ▓▒   ╚═════╝  ╚═════╝  ╚═════╝
 */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CzyCancel)(void);
typedef void(^CzyChooseFunction)(NSInteger tag);

@interface CzyAlertView : NSObject

/**单例对象*/
+ (instancetype)shareInstance;

/**背景视图颜色 默认表示black 0.2*/
@property (nonatomic, strong) UIColor *maskViewColor;


/**
 弹框

 @param alertTitle 弹框提示
 @param alertTitleColor 弹框提示颜色
 @param alertTitleFont 弹框提示字体
 @param titleH 弹框提示高度 写0表示默认的44
 @param buttonNames 功能按钮名称字符串列表 或者属性字符串
 @param chooseFunction 选择功能回调
 @param cancel 取消回调
 */
- (void)showAlertWithTitle:(NSString *)alertTitle andAlertTitleColor:(UIColor *)alertTitleColor andAlertTitleFont:(UIFont *)alertTitleFont andAlertTitleH:(CGFloat)titleH andButtonNames:(NSArray *)buttonNames andChooseFunction:(CzyChooseFunction)chooseFunction andCancel:(CzyCancel)cancel;


@end
