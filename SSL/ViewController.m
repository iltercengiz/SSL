//
//  ViewController.m
//  SSL
//
//  Created by Ilter Cengiz on 15/07/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "ViewController.h"

#import "NetworkManager.h"
#import "SocketManager.h"

@interface ViewController () <SocketManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *apiButton;
@property (weak, nonatomic) IBOutlet UIButton *socketButton;

@property (weak, nonatomic) IBOutlet UILabel *apiLabel;
@property (weak, nonatomic) IBOutlet UILabel *socketLabel;

@property (nonatomic) NetworkManager *networkManager;
@property (nonatomic) SocketManager *socketManager;

@end

@implementation ViewController

#pragma mark - Init
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _networkManager = [NetworkManager manager];
        _socketManager = [SocketManager manager];
        _socketManager.delegate = self;
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (IBAction)sendAPIRequest:(id)sender {
    [self.networkManager GET:@"/"
                  parameters:nil
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         [self.apiLabel setText:[NSString stringWithFormat:@"API response: %@", responseObject]];
                     } failure:^(NSURLSessionDataTask *task, NSError *error) {
                         [self.apiLabel setText:[NSString stringWithFormat:@"API error: %@", error.description]];
                     }];
}

- (IBAction)toggleSocketState:(id)sender {
    [self.socketButton setTitle:@"Connecting..." forState:UIControlStateNormal];

    [_socketManager connect];
}

#pragma mark - SocketManagerDelegate

- (void)socketManager:(SocketManager *)manager didReceiveMessage:(id)message {
    [self.socketLabel setText:[NSString stringWithFormat:@"Socket received message: %@", message]];
}

- (void)socketManagerDidConnect:(SocketManager *)manager {
    [self.socketButton setTitle:@"Disconnect" forState:UIControlStateNormal];
    [self.socketLabel setText:@"Socket connected!"];
}

- (void)socketManagerDidDisconnect:(SocketManager *)manager {
    [self.socketButton setTitle:@"Connect" forState:UIControlStateNormal];
    [self.socketLabel setText:@"Socket disconnected!"];
}

- (void)socketManager:(SocketManager *)manager didFailWithError:(NSError *)error {
    [self.socketButton setTitle:@"Failed" forState:UIControlStateNormal];
    [self.socketLabel setText:[NSString stringWithFormat:@"Socket failed with error: %@", error.description]];
}

@end
