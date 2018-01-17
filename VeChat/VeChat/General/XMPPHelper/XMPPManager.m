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

//自动重连对象
@property (nonatomic, strong) XMPPReconnect *reconnect;

//花名册对象
@property (nonatomic, strong) XMPPRoster *roaster;

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
    self.reconnect = [[XMPPReconnect alloc] init];
    self.reconnect.autoReconnect = YES;
    self.reconnect.reconnectTimerInterval = 3;
    [self.reconnect activate:self.stream];
    
    //自动获取花名册
    XMPPRosterCoreDataStorage *storage = [XMPPRosterCoreDataStorage sharedInstance];
    self.roaster = [[XMPPRoster alloc] initWithRosterStorage:storage dispatchQueue:dispatch_get_main_queue()];
    self.roaster.autoFetchRoster = YES;
    self.roaster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    [self.roaster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.roaster activate:self.stream];
    
    //链接
    NSError *error;
    if ([self.stream connectWithTimeout:10 error:&error]) {
    }
}

- (void)xmppStreamWillConnect:(XMPPStream *)sender{
    NSLog(@"开始链接....");
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"链接成功");
    NSError *error;
    if ([sender authenticateWithPassword:@"123456" error:&error]) {
        if (!error) {
            NSLog(@"正在验证...");
        } else {
            NSLog(@"%@",error);
        }
    }
}

- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    NSLog(@"连接超时");
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    NSLog(@"断开链接");
    NSLog(@"%@",error);
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"验证成功...");
    //发送上线现状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [sender sendElement:presence];
    [self.roaster fetchRoster];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
    NSLog(@"验证失败...");
}


//获取到一个好友节点
- (void)xmppRoster:(XMPPRoster *)sender didRecieveRosterItem:(NSXMLElement *)item{
    NSLog(@"%@",[item stringValue]);
}

//获取完好友列表
- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender{
    NSLog(@"获取完好友列表");
}


@end
