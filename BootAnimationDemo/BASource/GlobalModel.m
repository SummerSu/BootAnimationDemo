//
//  GlobalModel.m
//  EBusiness
//
//  Created by xlx on 16/4/7.
//  Copyright © 2016年 yeecolor. All rights reserved.
//

#import "GlobalModel.h"
//#import "LoginViewController.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"

@implementation GlobalModel

+ (UIViewController *)getCurrentVC{
    
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
    return result;
}

+(void)targetLogin:(id)target{
//    LoginViewController *vc = [[LoginViewController alloc]init];
//    vc.hidesBottomBarWhenPushed = true;
//    [((UIViewController *)target).navigationController pushViewController:vc animated:true];
}

+(CGSize)calculateTextSize:(NSString *)text font:(CGFloat)font width:(CGFloat)width{
    NSString *commentText = text;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    CGSize size = [commentText boundingRectWithSize:CGSizeMake(width, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size;
}

+(NSString *)returnVideoURL{
    [GlobalModel updateVideo];

    NSData *hashData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Library/Video/hash.txt",NSHomeDirectory()]]];
    NSString *hashString = [[NSString alloc]initWithData:hashData encoding:NSUTF8StringEncoding];
    NSArray *fileArray = [hashString componentsSeparatedByString:@"|"];
    if (fileArray.count == 0) {
        return [[NSBundle mainBundle] pathForResource:@"EDIT HERE3" ofType:@"mp4"];
    }else{
        
        NSInteger index = arc4random()%fileArray.count;
        //概率
        if (index == 0) {
            return [[NSBundle mainBundle] pathForResource:@"EDIT HERE3" ofType:@"mp4"];
        }else{
            return [NSString stringWithFormat:@"%@/Library/Video/%@",NSHomeDirectory(),fileArray[index]];
        }
        
    }
}

/**
 *  返回目录下的所有子目录
 */
+(NSArray *)returnFileArray:(NSString *)url{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath :url]) {
        [fileManager createDirectoryAtPath:url withIntermediateDirectories:true attributes:nil error:nil];
        return @[];
    }
    
    NSEnumerator *childFilesEnumerator = [[fileManager subpathsAtPath :url] objectEnumerator];
    NSString *fileName;
    NSMutableArray *fileArray = [@[] mutableCopy];
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [url stringByAppendingPathComponent :fileName];
        [fileArray addObject:fileAbsolutePath];
    }
    return fileArray;
}

/**
 *  更新本地Video文件
 */
+(void)updateVideo{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath :[NSString stringWithFormat:@"%@/Library/Video",NSHomeDirectory()]]) {
        [fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/Library/Video",NSHomeDirectory()] withIntermediateDirectories:true attributes:nil error:nil];
    }
    
//  根据借口获取视频资源，资源名和返回的url的视频名称要一样
//    [USNetworkRequest getRequest:@"/service/video/findtest" params:nil success:^(id responseObj) {
//        if ( [responseObj[@"success"]boolValue]==1) {
//            NSDictionary * dict = responseObj[@"content"];
//            NSMutableArray * datas = [NSMutableArray array];
//            [datas addObject:dict];
//            [GlobalModel downLoadVideo:datas];
//            NSLog(@"obj=%@",responseObj);
//        }
//    } failure:^(NSError *error) {
//        
//    }];
    
    
}
+(void)downLoadVideo:(NSArray *)datas{
    NSData *hashData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Library/Video/hash.txt",NSHomeDirectory()]]];
    NSLog(@"path =%@,",[NSString stringWithFormat:@"%@/Library/Video/hash.txt",NSHomeDirectory()]);
    NSString *hashString = [[NSString alloc]initWithData:hashData encoding:NSUTF8StringEncoding];
    NSMutableString *newHashString = [@"" mutableCopy];
    for (NSDictionary *dict in datas) {
        if ([hashString containsString:dict[@"name"]]) {
        }else{
            [GlobalModel downFileWithUrl:dict[@"url"] ouputPath:[NSString stringWithFormat:@"%@/Library/Video/%@.mp4",NSHomeDirectory(),dict[@"name"]]];
        }
        [newHashString appendFormat:@"|%@.mp4",dict[@"name"]];
    }
    NSMutableArray *fileArray = [[hashString componentsSeparatedByString:@"|"] mutableCopy];
    NSMutableArray *temp = [fileArray mutableCopy];
    for (NSString *str in fileArray) {
        if (![newHashString containsString:str] && ![str isEqualToString:@""]) {
            [temp removeObject:str];
        }
    }
    fileArray = temp;
    hashString = @"";
    for (NSString *str in fileArray) {
        if ([str isEqualToString:@""]) {
            continue;
        }
        hashString = [NSString stringWithFormat:@"%@|%@",hashString,str];
    }
    
    hashData = [hashString dataUsingEncoding:NSUTF8StringEncoding];
    [hashData writeToFile:[NSString stringWithFormat:@"%@/Library/Video/hash.txt",NSHomeDirectory()] atomically:true];

}
+(void)downFileWithUrl:(NSString *)url ouputPath:(NSString *)ouputPath{
//    开始下载;
    
    
//    下载附件
    NSURL *downurl = [[NSURL alloc] initWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:downurl];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.inputStream   = [NSInputStream inputStreamWithURL:downurl];
    operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:ouputPath append:NO];

    //下载进度控制
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSLog(@"%@",[NSString stringWithFormat:@"%.f%%",(float)totalBytesRead/totalBytesExpectedToRead*100]);
    }];

    
    //已完成下载
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //将下载完成的url保存到本地的目录
        NSURL *completeURL = operation.request.URL;
        NSArray *array = [completeURL.absoluteString componentsSeparatedByString:@"/"];
        
        NSData *hashData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Library/Video/hash.txt",NSHomeDirectory()]]];
        NSString *hashString = [[NSString alloc]initWithData:hashData encoding:NSUTF8StringEncoding];
        hashString = [NSString stringWithFormat:@"%@|%@",hashString,array.lastObject];
        hashData = [hashString dataUsingEncoding:NSUTF8StringEncoding];
        [hashData writeToFile:[NSString stringWithFormat:@"%@/Library/Video/hash.txt",NSHomeDirectory()] atomically:true];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //下载失败
    }];
    
    [operation start];
}

//+(void)downFileWithUrl:(NSString *)url ouputPath:(NSString *)ouputPath{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSURL *downurl = [[NSURL alloc] initWithString:url];
//    NSURLRequest *request = [NSURLRequest requestWithURL:downurl];
//    NSURLSessionDownloadTask *task =
//    [manager downloadTaskWithRequest:request
//                            progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//                                
//                                return [NSURL fileURLWithPath:url];
//                            }
//                   completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//                       
//    }];
//    [task resume];
//}

@end
