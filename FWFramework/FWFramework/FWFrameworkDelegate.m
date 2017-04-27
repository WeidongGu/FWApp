//
// Created by Weidong Gu  on 17/04/2017.
// Copyright (c) 2017 tw. All rights reserved.
//

#import "FWFrameworkDelegate.h"
#import "FWFrameworkViewController.h"

@implementation FWFrameworkDelegate

- (id)resourceWithURI:(FWURI *)uri {
    if ([uri.resourcePath isEqualToString:@"/main"]){
        FWFrameworkViewController *viewController = [[FWFrameworkViewController alloc]initWithNibName:@"FWFrameworkViewController" bundle:_FrameworkBundle_];
        viewController.showText = uri.parameters[@"showText"];
        return viewController;
    }
    return nil;
}
@end
