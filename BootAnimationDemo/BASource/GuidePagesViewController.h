//
//  GuidePagesViewController.h
//  USApp2.0
//
//  Created by ss on 2016/10/17.
//  Copyright © 2016年  门皓. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GuidePagesViewControllerDelegate <NSObject>
- (void)click;
@end

@interface GuidePagesViewController : UIViewController
@property (nonatomic, strong) UIButton *btnEnter;
// 初始化引导页
- (void)initWithXTGuideView:(NSArray *)images;
// 版本信息判断
- (BOOL)isShow;
@property (nonatomic, weak) id<GuidePagesViewControllerDelegate> delegate;
// 创建单利类
+ (instancetype)shareXTGuideVC;
@end
