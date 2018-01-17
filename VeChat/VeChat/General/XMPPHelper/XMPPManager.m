//
//  XMPPManager.m
//  VeChat
//
//  Created by 柴胜杰 on 2018/1/16.
//  Copyright © 2018年 csj. All rights reserved.
//

#import "XMPPManager.h"
#import "ServerConfig.h"
#import "XMPPStream.h"
#import "XMPPReconnect.h"
#import "XMPPJID.h"
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"

static XMPPManager *manager;

@interface XMPPManager ()

//xmpp链接流
@property (nonatomic, strong) XMPPStream *stream;

@end

@implementation XMPPManager

/**
 创建XMPP管理实例

 @return manager实例
 */
+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XMPPManager alloc] init];
        [manager connectToServer];
    });

    return manager;
}

- (void)connectToServer{
    //初始化配置
    ServerConfig *serverConfig = [[ServerConfig alloc] init];
    
    //初始化XMPP流
    self.stream = [[XMPPStream alloc] init];
    self.stream.hostName = serverConfig.serverHost;
    self.stream.hostPort = [serverConfig.serverPort intValue];
    self.stream.myJID = [XMPPJID jidWithString:serverConfig.defaultJid];
    //添加代理
    [self.stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //创建重连
    XMPPReconnect *reconnect = [[XMPPReconnect alloc] init];
    reconnect.autoReconnect = YES;
    reconnect.reconnectTimerInterval = 3;
    [reconnect activate:self.stream];
    
    //自动获取花名册
    XMPPRosterCoreDataStorage *storage = [XMPPRosterCoreDataStorage sharedInstance];
    XMPPRoster *roster = [[XMPPRoster alloc] initWithRosterStorage:storage dispatchQueue:dispatch_get_main_queue()];
    roster.autoFetchRoster = YES;
    roster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    [roster activate:self.stream];
    
    //链接
    NSError *error;
    if ([self.stream connectWithTimeout:10 error:&error]) {
        NSLog(@".....");
    }
}

- (void)xmppStreamWillConnect:(XMPPStream *)sender{
    NSLog(@"开始链接....");
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"链接成功");
}

- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    NSLog(@"连接超时");
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    NSLog(@"断开链接");
    NSLog(@"%@",error);
}
@end
