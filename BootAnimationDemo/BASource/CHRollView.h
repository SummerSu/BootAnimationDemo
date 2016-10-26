//
//  CHRollView.h
//  Demo_ScrollView_Cycle
//
//  Created by 扶不起的阿斗 on 15/5/15.
//  Copyright (c) 2015年 扶不起的阿斗. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ABCIntroViewDelegate <NSObject>
-(void)onDoneButtonPressed;
@end

@interface CHRollView : UIView
@property(nonatomic, weak) id<ABCIntroViewDelegate> delegate;
/* 点击广告后回调 */
//@property(nonatomic, copy)void (^clickItem)(NSNumber * index);

/**
 *  初始化调用
 *
 *  @param frame    在父视图中的Frame
 *  @param items    要展示的内容
 *  @param autoRoll 自动滚动
 *
 *  @return CHRollView
 */
//
- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray *)items;

@end
