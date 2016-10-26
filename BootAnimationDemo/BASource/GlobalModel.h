//
//  GlobalModel.h
//  EBusiness
//
//  Created by xlx on 16/4/7.
//  Copyright © 2016年 yeecolor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface GlobalModel : NSObject
/**
 *  获取顶层控制器
 *
 */
+(UIViewController *)getCurrentVC;
/**
 *  push到登陆界面
 *
 */
+(void)targetLogin:(id)target;
/**
 *  计算文子的高度和宽度
 */
+(CGSize)calculateTextSize:(NSString *)text font:(CGFloat)font width:(CGFloat)width;
/**
 *  返回启动视屏的路径
 */
+(NSString *)returnVideoURL;
@end
