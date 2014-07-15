//
//  SocketManager.m
//  SSL
//
//  Created by Ilter Cengiz on 15/07/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "SocketManager.h"

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
        
        _manager.socket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@"<#string#>"]];
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
    [self.delegate socketManagerDidDisconnect:self];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"Socket failed!");
    [self.delegate socketManager:self didFailWithError:error];
}

@end
