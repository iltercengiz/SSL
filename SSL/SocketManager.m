//
//  SocketManager.m
//  SSL
//
//  Created by Ilter Cengiz on 15/07/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "SocketManager.h"
#import "NetworkManager.h"
#import <SocketRocket/SRWebSocket.h>

@interface SocketManager () <SRWebSocketDelegate>

@property (nonatomic) SRWebSocket *socket;

@end

@implementation SocketManager

#pragma mark - Initialization

+ (instancetype)manager {
    
    static SocketManager *_manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _manager = [SocketManager new];

        NSData *certificateData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"certificate" ofType:@"der"]];
        CFDataRef inDERData = (__bridge CFDataRef)certificateData;
        SecCertificateRef cert = SecCertificateCreateWithData(NULL, inDERData);

//        NSData *certificateData2 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"certificate" ofType:@"der"]];
//        CFDataRef inDERData2 = (__bridge CFDataRef)certificateData2;
//        SecCertificateRef cert2 = SecCertificateCreateWithData(NULL, inDERData2);

        NSArray *certs = [NSArray arrayWithObject:(id) (__bridge id) cert];

        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://localhost:1337/"]];
        [request setSR_SSLPinnedCertificates:certs];

        _manager.socket = [[SRWebSocket alloc] initWithURLRequest:request];
        _manager.socket.delegate = _manager;

    });
    
    return _manager;
    
}

#pragma mark - Public methods

- (void)connect {
    [self.socket open];
}

- (void)disconnect {
    [self.socket close];
}

#pragma mark - SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"Message: %@", message);
    [self.delegate socketManager:self didReceiveMessage:message];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"Socket connected!");
    [self.delegate socketManagerDidConnect:self];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"Socket disconnected!");
    NSLog(@"Reason: %@", reason);
    NSLog(@"Code: %d", (int)code);
    [self.delegate socketManagerDidDisconnect:self];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"Socket failed!");
    [self.delegate socketManager:self didFailWithError:error];
}

@end
