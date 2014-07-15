//
//  NetworkManager.m
//  SSL
//
//  Created by Ilter Cengiz on 15/07/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "NetworkManager.h"
#import <AFURLConnectionOperation.h>

@interface NetworkManager ()

@end

@implementation NetworkManager

+ (instancetype)manager {
    
    static NetworkManager *_manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _manager = [[NetworkManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://localhost:1337"]];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];

        // SSL Pinning
        NSString *certificatePath = [[NSBundle mainBundle] pathForResource:@"certificate" ofType:@"der"];
        NSData *certificateData = [NSData dataWithContentsOfFile:certificatePath];

        AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
        [securityPolicy setAllowInvalidCertificates:YES];
        [securityPolicy setPinnedCertificates:@[certificateData]];
        [securityPolicy setSSLPinningMode:AFSSLPinningModeCertificate];
        
        [_manager setSecurityPolicy:securityPolicy];
    });
    
    return _manager;
    
}

@end
