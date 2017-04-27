//
//  FWURI.h
//  FWCore
//
//  Created by Weidong Gu  on 18/04/2017.
//  Copyright © 2017 tw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWURI : NSObject

+ (instancetype)URIWithString:(NSString *)uriString;

@property (nonatomic, copy) NSString *scheme;

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSString *resourcePath;

@property (nonatomic, strong) NSDictionary  *parameters;

@end
