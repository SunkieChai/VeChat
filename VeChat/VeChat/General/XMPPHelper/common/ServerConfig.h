//
//  ServerConfig.h
//  VeChat
//
//  Created by 柴胜杰 on 2018/1/16.
//  Copyright © 2018年 csj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerConfig : NSObject

/**
 服务器地址
 */
@property (nonatomic, copy) NSString *serverHost;

/**
 端口，默认5222，
 */
@property (nonatomic, copy) NSString *serverPort;

@end
