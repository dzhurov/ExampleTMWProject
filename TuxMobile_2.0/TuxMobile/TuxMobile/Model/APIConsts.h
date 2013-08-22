//
//  APIConsts.h
//  TuxMobile
//
//  Created by DZhurov on 8/22/13.
//  Copyright (c) 2013 The Men's Wearhouse. All rights reserved.
//

#ifndef TuxMobile_APIConsts_h
#define TuxMobile_APIConsts_h

#define TEST_SERVER_URL                                   @"https://test.tmw.com:8443/"
static NSString*  kServerURL = TEST_SERVER_URL;

static NSString* const kPOSTLoginURLPath = @"auth/login";
//static NSString* const k<#Method(GET/POST)#><#name#>URLPath = @"/<#path#>";

static NSString* const kAuthErrorPrefix =       @"AUTH";
static const int AUTH_ERROR_TOKEN_IS_INVALID = 1001;


#define kResponseStatusKey          @"status"
#define kResponseErrorMessagePath   @"error/message"
#define kResponseErrorCodePath      @"error/code"
#define kResponseTargetObjectKey    @"data"

#define kResponseStatusDone         @"DONE"
#define kResponseStatusError        @"ERROR"


#endif
