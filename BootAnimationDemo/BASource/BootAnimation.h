//
//  BootAnimation.h
//  USApp2.0
//
//  Created by ss on 2016/10/17.
//  Copyright © 2016年  门皓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface BootAnimation : NSObject

+ (instancetype)shared;

-(void)starVideo:(NSString *)url;

@end
