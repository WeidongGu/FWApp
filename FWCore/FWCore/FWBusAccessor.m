//
//  FWBusAccessor.m
//  FWCore
//
//  Created by Weidong Gu  on 20/04/2017.
//  Copyright © 2017 tw. All rights reserved.
//

#import "FWBusAccessor.h"
#import <AFNetworking/AFNetworking.h>
#import <ZipArchive/ZipArchive.h>

@implementation FWBusAccessor

+ (instancetype)defaultBusAccessor {
    return [[self alloc]initBusAccessor];
}

- (instancetype)initBusAccessor {
    if (self = [super init]) {
        
    }
    return self;
}

- (id)loadFrameworksDelegateWithIdentifier:(NSString *)identifier {
    NSString *frameworkName = [self.class getFrameworkNameFromPlistWithIdentifier:identifier];

    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = nil;
    if ([paths count] != 0) {
        documentDirectory = paths[0];
    }
    
    NSString *bundlePath = [documentDirectory stringByAppendingPathComponent:[frameworkName stringByAppendingString:@".framework"]];
    
    // 检查framework是不是在Documents
    if (![manager fileExistsAtPath:bundlePath]) {
        NSLog(@"No framework in documents");
        bundlePath = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"Embedded/%@",frameworkName] ofType:@"framework"];
        
        // 检查framework是不是在mainBundle
        if (![manager fileExistsAtPath:bundlePath]) {
            
            return nil;
        }
    }
    
    // 加载Framework
    NSError *error = nil;
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:bundlePath];
    if (frameworkBundle && [frameworkBundle loadAndReturnError:&error]) {
        NSLog(@"Load framework successfully");
    }else {
        NSLog(@"Failed to load framework : %@",error);
        return nil;
    }
    
    // 加载class
    Class delegateClass = NSClassFromString([NSString stringWithFormat:@"%@Delegate",frameworkName]);
    if (!delegateClass) {
        NSLog(@"Unable to load class");
        return nil;
    }
    
    return [delegateClass new];
}

- (id)resourceWithURI:(FWURI *)uri {
    id delegateObject = [self loadFrameworksDelegateWithIdentifier:uri.identifier];
    return [delegateObject performSelector:@selector(resourceWithURI:) withObject:uri];
}

+ (NSString *)getFrameworkNameFromPlistWithIdentifier:(NSString *)identifier {
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"Embedded/Embedded" ofType:@"plist"];
    NSArray *frameworkInfos = [[NSArray alloc]initWithContentsOfFile:plistPath];
    for (NSDictionary *frameworkInfo in frameworkInfos) {
        if ([identifier isEqualToString:frameworkInfo[@"identifier"]]) {
            return frameworkInfo[@"frameworkName"];
        }
    }
    return nil;
}

+ (NSString *)getFrameworkDownloadPathFromPlistWithIdentifier:(NSString *)identifier {
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"Embedded/Embedded" ofType:@"plist"];
    NSArray *frameworkInfos = [[NSArray alloc]initWithContentsOfFile:plistPath];
    for (NSDictionary *frameworkInfo in frameworkInfos) {
        if ([identifier isEqualToString:frameworkInfo[@"identifier"]]) {
            return frameworkInfo[@"downloadPath"];
        }
    }
    return nil;
}

+ (void)downloadFrameworkWithIdentifier:(NSString *)identifier{
    // 1、 设置请求
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.class getFrameworkDownloadPathFromPlistWithIdentifier:identifier]]];
    // 2、初始化
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager * manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    // 3、开始下载
    NSURLSessionDownloadTask * task = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
        NSLog(@"%lf",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //这里要返回一个NSURL，其实就是文件的位置路径
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        //使用建议的路径
        path = [path stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        //下载成功
        if (error == nil) {
            NSLog(@"下载完成:%@",[filePath path]);
        }else{//下载失败的时候，只列举判断了两种错误状态码
            NSString * message = nil;
            if (error.code == - 1005) {
                message = @"网络异常";
            }else if (error.code == -1001){
                message = @"请求超时";
            }else{
                message = @"未知错误";
            }
            NSLog(@"%@",message);
        }
        //解压
        NSString *filePathString = filePath.path;
        NSLog(@"解压文件：%@",filePathString);
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSLog(@"解压到：%@",path);
        if ([SSZipArchive unzipFileAtPath:filePathString toDestination:path]) {
            NSLog(@"解压成功");
        }
    }];
    
    //开始启动任务
    [task resume];
}
@end
