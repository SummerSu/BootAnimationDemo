//
//  HomePageViewModel.m
//  EBusiness
//
//  Created by xlx on 16/4/13.
//  Copyright © 2016年 yeecolor. All rights reserved.
//

#import "NewUserGuide.h"
#import <UIKit/UIKit.h>

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation NewUserGuide

+ (instancetype)shared{
    static id __staticBootAnimation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __staticBootAnimation = [[NewUserGuide alloc]init];
    });
    return __staticBootAnimation;
}

-(void)addguideImageWithImgName:(NSString * )imgName{
    self.imgName = imgName;
    NSString* guiDeData = [[NSUserDefaults standardUserDefaults] objectForKey:imgName];
    UIImageView* item = [[UIImageView alloc] init];
    item.userInteractionEnabled = YES;
    
    if([guiDeData  isEqual: @""]||guiDeData == nil)
    {
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        if(SCREEN_WIDTH == 320&&SCREEN_HEIGHT == 568)
        {
            item.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@5",imgName]];
        }else if(SCREEN_WIDTH == 375&&SCREEN_HEIGHT == 667)
        {
            item.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imgName]];
        }else if(SCREEN_WIDTH == 414&&SCREEN_HEIGHT == 736){
            item.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imgName]];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [item addGestureRecognizer:tap];
        item.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [window addSubview:item];
    }
}

-(void)tap:(UITapGestureRecognizer*)tap
{
    [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:self.imgName];
    [tap.view removeFromSuperview];
    
    
    
    //    UIImageView *guidevView = (UIImageView *) tap.view;
    //    [guidevView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//移除所有子视图
    //    [guidevView removeGestureRecognizer:tap]; //移除手势
}

//-(void)setImgName:(NSString *)imgName
//{
//    _imgName = imgName;
//}

@end
