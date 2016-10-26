//
//  GuidePagesViewController.m
//  USApp2.0
//
//  Created by ss on 2016/10/17.
//  Copyright © 2016年  门皓. All rights reserved.
//

#import "GuidePagesViewController.h"
#import "CHRollView.h"

@interface GuidePagesViewController ()<ABCIntroViewDelegate>
{
    CGFloat s_w;
    CGFloat s_h;
}
@property (nonatomic, strong)UIPageControl * pageControl;
@end

@implementation GuidePagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    s_w = [UIScreen mainScreen].bounds.size.width ;
    s_h = [UIScreen mainScreen].bounds.size.height;
    self.view.backgroundColor =[UIColor cyanColor];
}

+ (instancetype)shareXTGuideVC
{
    static GuidePagesViewController *x = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        x = [[GuidePagesViewController alloc] init];
    });
    return x;
}


- (void)initWithXTGuideView:(NSArray *)images
{
    NSArray * items = images;
    
    // 摆放的位置
    CGRect rollFrame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    // 创建对象
    CHRollView * rollView = [[CHRollView alloc]initWithFrame:rollFrame andItems:items];
    rollView.delegate = self;
    // 加入父视图
    [self.view addSubview:rollView];
}

//- (void)clickEnter
//{
//    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(click)]) {
//        [self.delegate click];
//    }
//}

-(void)onDoneButtonPressed
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(click)]) {
        [self.delegate click];
    }
}
#define VERSION_INFO_CURRENT @"VERSION_INFO_CURRENT"
- (BOOL)isShow
{
    // 读取版本信息
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *localVersion = [user objectForKey:VERSION_INFO_CURRENT];
    NSString *currentVersion =[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSLog(@"L ===%@", localVersion);
//    NSLog(@"C ===%@", currentVersion);
    if (localVersion == nil || ![currentVersion isEqualToString:localVersion]) {
        [self saveCurrentVersion];
        return YES;
    }else
    {
        return NO;
    }
}

// 保存版本信息
- (void)saveCurrentVersion
{
    NSString *version =[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:version forKey:VERSION_INFO_CURRENT];
    [user synchronize];
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
