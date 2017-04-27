//
//  FWBusAccessor.h
//  FWCore
//
//  Created by Weidong Gu  on 20/04/2017.
//  Copyright © 2017 tw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWURI.h"

@interface FWBusAccessor : NSObject

+ (instancetype)defaultBusAccessor;

- (id)resourceWithURI:(FWURI *)uri;

@end
