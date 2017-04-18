//
// Created by Weidong Gu  on 17/04/2017.
// Copyright (c) 2017 tw. All rights reserved.
//

#import "FWFrameworkDelegate.h"
#import "FWFrameworkViewController.h"

@implementation FWFrameworkDelegate

- (id)resourceWithURI:(NSString *)uri {
    if ([uri isEqualToString:@"UI://FWFrameworkViewController"]){
        FWFrameworkViewController *viewController = [[FWFrameworkViewController alloc]initWithNibName:@"FWFrameworkViewController" bundle:_FrameworkBundle_];
        return viewController;
    }
    return nil;
}
@end
