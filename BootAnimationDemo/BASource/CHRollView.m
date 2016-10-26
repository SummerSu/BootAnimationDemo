//
//  CHRollView.m
//  Demo_ScrollView_Cycle
//
//  Created by 扶不起的阿斗 on 15/5/15.
//  Copyright (c) 2015年 扶不起的阿斗. All rights reserved.
//

#import "CHRollView.h"

/** 参数设置区域 */
// 页标指示器的纵向位置 //
#define PAGE_Y 20
// 自动滚动时间 //
#define AUTO_SCROLL_TIME 3

// 宏定值
#define ITEM_WIDTH self.scrollView.frame.size.width

@interface CHRollView()<UIScrollViewDelegate>

/** 数据源 */
@property(nonatomic, strong)NSMutableArray * items;
/** 滚动视图 */
@property(nonatomic, strong)UIScrollView * scrollView;
/** 页面指示器 */
@property(nonatomic, strong)UIPageControl * pageControl;
//完成button
@property (strong, nonatomic) UIButton *doneButton;

@end

@implementation CHRollView

/**
 *  初始化调用
 *
 *  @param frame    在父视图中的Frame
 *  @param items    要展示的内容
 *  @param autoRoll 自动滚动
 *
 *  @return CHRollView
 */
- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray *)items{
    
    if (self = [super initWithFrame:frame]) {
        
        // 处理items
        [self handleItems:items];
        
        // 初始化控件
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];        
    }
    return self;
}


/**
 *  处理items
 */
- (void)handleItems:(NSArray *)items{
    
    NSMutableArray * tempItem = [items mutableCopy];
    self.items = tempItem;
}


/**
 *  初始化控件
 */
-(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.bounces = NO;
    }
    return _scrollView;
}

-(UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-80, self.frame.size.width, 10)];
        self.pageControl.numberOfPages = self.items.count;
        self.pageControl.enabled = YES;
        self.pageControl.currentPage = 0;
        self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];

    }
    return _pageControl;
}

-(UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 60)];
        
        [_doneButton setTintColor:[UIColor whiteColor]];
        [_doneButton setTitle:@"Let's Go!" forState:UIControlStateNormal];
        [_doneButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
        [_doneButton setBackgroundColor:[UIColor colorWithRed:0.129 green:0.588 blue:0.953 alpha:1.000]];
        [_doneButton addTarget:self action:@selector(onDoneButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

-(void)onDoneButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onDoneButtonPressed)]) {
        [self.delegate onDoneButtonPressed];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = CGRectGetWidth(self.bounds);
    CGFloat pageFraction = self.scrollView.contentOffset.x / pageWidth;
    self.pageControl.currentPage = roundf(pageFraction);
}

/**
 *  布局子控件
 */
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat pageW = 100;
    CGFloat pageH = 20;
    
    self.pageControl.frame = CGRectMake(0, 0, pageW, pageH);
    self.pageControl.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height - 50);
    self.scrollView.frame = self.bounds;
    
    // 添加展示Items
    [self addItems];
}


/**
 *  添加展示Items
 */
- (void)addItems{
    int i= 0;
    for (NSString * imageName in self.items) {
        
        UIImageView * showView = [[UIImageView alloc]init];
        showView.image = [UIImage imageNamed:imageName];

        showView.frame = CGRectMake(
                                    self.scrollView.contentSize.width,
                                    self.scrollView.bounds.origin.y,
                                    self.scrollView.frame.size.width,
                                    self.scrollView.frame.size.height);
        
            self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width + self.scrollView.frame.size.width,self.scrollView.frame.size.height);
        [self.scrollView addSubview:showView];
        
        i++;
        if (i == self.items.count) {
            [showView addSubview:self.doneButton];
            showView.userInteractionEnabled = YES;
            _doneButton.center = CGPointMake(showView.frame.size.width * 0.5,showView.frame.size.height-self.doneButton.frame.size.height-50);
        }
    }
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    
}

@end
