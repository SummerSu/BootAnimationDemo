//
//  BootAnimation.m
//  USApp2.0
//
//  Created by ss on 2016/10/17.
//  Copyright © 2016年  门皓. All rights reserved.
//

#import "BootAnimation.h"
#import "GuidePagesViewController.h"
#import "ViewController.h"
#import "NewUserGuide.h"

@interface BootAnimation ()<GuidePagesViewControllerDelegate>
{
    MPMoviePlayerViewController *startPlayerViewController;
//    ViewController * mainTabController;
}
//@property (nonatomic, strong) MPMoviePlayerViewController *startPlayerViewController;
@end


@implementation BootAnimation

+ (instancetype)shared{
    static id __staticBootAnimation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __staticBootAnimation = [[BootAnimation alloc]init];
    });
    return __staticBootAnimation;
}

#pragma mark 开机动画
-(void)starVideo:(NSString *)url //andWindow:(UIWindow *)window
{
    NSURL *Path = [NSURL fileURLWithPath:url];
    if (!Path) {
        Path = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"EDIT HERE3" ofType:@"mp4"]];
    }
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    startPlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:Path];
    startPlayerViewController.moviePlayer.view.frame = window.bounds;
    startPlayerViewController.moviePlayer.controlStyle = MPMovieControlStyleNone;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(movieFinishedCallback:)
                                                name:MPMoviePlayerPlaybackDidFinishNotification
                                              object:[startPlayerViewController moviePlayer]];
    [window addSubview:startPlayerViewController.view];
    [startPlayerViewController.moviePlayer play];
    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"firstLaungh"];
}


- (void)movieFinishedCallback:(NSNotification*) aNotification {
    [startPlayerViewController.view removeFromSuperview];
    UIImageView *screenImage = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    screenImage.image = [self snapshot:startPlayerViewController.view];
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:screenImage];
    
    [UIView animateWithDuration:1.0 animations:^{
        screenImage.alpha = 0;
        startPlayerViewController.view.alpha = 0;
       
    } completion:^(BOOL finished) {
        [screenImage removeFromSuperview];
        [startPlayerViewController.view removeFromSuperview];
    }];
     [self startGuidePages];
}

- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark 开机引导图
-(void)startGuidePages
{
    //进入引导图
    NSArray *images = @[@"151.jpg", @"152.jpeg", @"153.jpg"];
    if ([[GuidePagesViewController shareXTGuideVC] isShow]) {
        GuidePagesViewController *guideVC = [GuidePagesViewController shareXTGuideVC];
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        window.rootViewController = guideVC;
        guideVC.view.alpha = 1;
        [guideVC initWithXTGuideView:images];
        guideVC.delegate = self;
        
    }else{
        [self click];
    }
}

- (void)click
{
//    [UIView animateWithDuration:0.5 animations:^{
//    } completion:^(BOOL finished) {
//        [self goHomePages];
//    }];
    
    [self goHomePages];
}

-(void)goHomePages
{
    //新手引导页
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    ViewController * vc = [[ViewController alloc]init];
    UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:vc];
    window.rootViewController = navi;

    
    [[GuidePagesViewController shareXTGuideVC].view removeFromSuperview];
    [[GuidePagesViewController shareXTGuideVC] removeFromParentViewController];
    vc.view.alpha = 1;
    [[NewUserGuide shared] addguideImageWithImgName:@"HomeGuide"];
}

/**
 *  获取当前最上面活动的控制器
 */
- (UIViewController*)topViewController {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return [self topViewControllerWithRootViewController:result];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    }
    else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    }
    else {
        return rootViewController;
    }
}
@end
