//
//  ServerConfig.m
//  VeChat
//
//  Created by 柴胜杰 on 2018/1/16.
//  Copyright © 2018年 csj. All rights reserved.
//

#import "ServerConfig.h"

static NSString *host = @"www.xmpp.jp";

static NSString *port = @"5222";

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
    }
    return self;
}

@end
