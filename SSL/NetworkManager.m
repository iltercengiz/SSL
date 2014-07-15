//
//  NetworkManager.m
//  SSL
//
//  Created by Ilter Cengiz on 15/07/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager ()

@end

@implementation NetworkManager

+ (instancetype)manager {
    
    static NetworkManager *_manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _manager = [[NetworkManager alloc] initWithBaseURL:[NSURL URLWithString:@"<#string#>"]];
        
//        // SSL Pinning
//        NSString *certifiactePath = [[NSBundle mainBundle] pathForResource:@"Certificate" ofType:@"der"];
//        NSData *certificateData = [NSData dataWithContentsOfFile:certifiactePath];
//        
//        AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
//        [securityPolicy setAllowInvalidCertificates:NO];
//        [securityPolicy setPinnedCertificates:@[certificateData]];
//        [securityPolicy setSSLPinningMode:AFSSLPinningModeCertificate];
//        
//        [_manager setSecurityPolicy:securityPolicy];
        
    });
    
    return _manager;
    
}

@end
