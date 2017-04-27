//
//  FWURI.m
//  FWCore
//
//  Created by Weidong Gu  on 18/04/2017.
//  Copyright © 2017 tw. All rights reserved.
//

#import "FWURI.h"

@implementation FWURI
- (instancetype)initWithString:(NSString *)uriString {
    if (self = [super init]) {
        NSURL *url = [NSURL URLWithString:uriString];
        self.scheme = url.scheme;
        self.identifier = url.host;
        self.resourcePath = url.path;
        self.parameters = [self.class decodeQueryParametersWithQueryString:url.query];
    }
    return self;
}

+ (instancetype)URIWithString:(NSString *)uriString  {
    return [[self alloc]initWithString:uriString];
}

+ (NSDictionary *)decodeQueryParametersWithQueryString:(NSString *)query {
    NSArray *parametersStringArray = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    for (NSString *parametersString in parametersStringArray) {
        NSArray *parametersArray = [parametersString componentsSeparatedByString:@"="];
        [parameters setValue:parametersArray[1] forKey:parametersArray[0]];
    }
    return parameters;
}
@end
