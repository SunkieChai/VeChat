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

static XMPPManager *manager;

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
    XMPPStream *stream = [[XMPPStream alloc] init];
    stream.hostName = serverConfig.serverHost;
    stream.hostPort = [serverConfig.serverHost intValue];
    stream.myJID = [XMPPJID jidWithString:@"chai"];
    //添加代理
    [stream addDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    
    //创建重连
    XMPPReconnect *reconnect = [[XMPPReconnect alloc] init];
    reconnect.autoReconnect = YES;
    reconnect.reconnectTimerInterval = 3;
    
    //链接
    NSError *error;
    if ([stream connectWithTimeout:10 error:&error]) {
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
