//
//  ServerConfig.m
//  VeChat
//
//  Created by 柴胜杰 on 2018/1/16.
//  Copyright © 2018年 csj. All rights reserved.
//

#import "ServerConfig.h"

//static NSString *host = @"www.sunkiechat.com";
//
//static NSString *port = @"5222";
//
//static NSString *jid = @"chai@sunkiechat.com";


static NSString *host = @"vetech.store";

static NSString *port = @"5222";

static NSString *jid = @"8400@vetech.store";

@implementation ServerConfig


/**
 初始化服务器配置

 @return 配置实例
 */
- (instancetype)init{
    self = [super init];
    if (self) {
        self.serverHost = host;
        self.serverPort = port;
        self.defaultJid = jid;
    }
    return self;
}

@end
