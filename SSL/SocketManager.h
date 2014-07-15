//
//  SocketManager.h
//  SSL
//
//  Created by Ilter Cengiz on 15/07/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SocketManagerDelegate;

@interface SocketManager : NSObject

+ (instancetype)manager;

- (void)connect;
- (void)disconnect;

@property (nonatomic, weak) id<SocketManagerDelegate> delegate;

@end

@protocol SocketManagerDelegate <NSObject>

- (void)socketManager:(SocketManager *)manager didReceiveMessage:(id)message;

- (void)socketManagerDidConnect:(SocketManager *)manager;
- (void)socketManagerDidDisconnect:(SocketManager *)manager;
- (void)socketManager:(SocketManager *)manager didFailWithError:(NSError *)error;

@end
