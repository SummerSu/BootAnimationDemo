//
//  HomePageViewModel.h
//  EBusiness
//
//  Created by xlx on 16/4/13.
//  Copyright © 2016年 yeecolor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewUserGuide : NSObject

@property (nonatomic, strong)NSString * imgName;

- (void)addguideImageWithImgName:(NSString * )imgName;
+ (instancetype)shared;

@end
