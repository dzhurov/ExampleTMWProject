
//
//  ServerInteractionManager.m
//  GroupManager
//
//  Created by Dmitry Zhurov on 14.09.12.
//  Copyright (c) 2012 The Mens Wearhouse. All rights reserved.
//

#import "ServerInteractionManager.h"
#include <execinfo.h>
#import "AFNetworking.h"
#import "JSONKit.h"

#define LogRequest(url, body) NSLogBlue(@"%s\nRequest: %@\nbody: %@\n", __PRETTY_FUNCTION__, url, body)
#define LogError(requestOperation, error) NSLogRed(@"Request failed:%@ ERROR: %@", [requestOperation request], error);

#define kResponseStatusKey          @"status"
#define kResponseErrorMessagePath   @"error/message"
#define kResponseErrorCodePath      @"error/code"
#define kResponseTargetObjectKey    @"data"

#define kResponseStatusDone         @"DONE"
#define kResponseStatusError        @"ERROR"

@interface ServerInteractionManager (Private)

- (void)parseResponseData: (NSData*)data forURLRequest: (NSURLRequest*)request callBlock:(ResponseBlock)responseBlock invocation:(NSInvocation*)invocation;
- (AFHTTPRequestOperation*)makeGETRequestForURLPath: (NSString *)urlPath useToken: (BOOL)useToken inputParameters: (NSDictionary*)parameters responseBlock:(void (^)(id, NSError *))responseBlock;
- (AFHTTPRequestOperation*)makePOSTRequestForURLPath: (NSString *)urlPath useToken: (BOOL)useToken HTTPBody: (NSData*)body responseBlock:(void (^)(id, NSError *))responseBlock;

@end

@implementation ServerInteractionManager


CWL_SYNTHESIZE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(ServerInteractionManager, sharedManager);

- (id)init
{
    self = [super init];
    if (self) {
        _httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kServerURL]];
    }
    return self;
}

- (void)dealloc
{
    _httpClient = nil;
}


#pragma mark - Private methods

- (NSURLRequest *)postRequestWithPath:(NSString *)urlString httpBody:(NSData *)data
{
    NSMutableURLRequest *theRequest = [_httpClient requestWithMethod:@"POST" path:urlString parameters:nil];
    [theRequest setTimeoutInterval:kRequestTimeoutInterval];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [theRequest setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPBody: data];
    return theRequest;
}

- (NSURLRequest *)getRequestWithPath:(NSString *)urlString parameters: (NSDictionary *)parameters
{
    NSMutableURLRequest *theRequest = [_httpClient requestWithMethod:@"GET" path:urlString parameters:parameters];
    [theRequest setTimeoutInterval:kRequestTimeoutInterval];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return theRequest;
}

- (void)parseResponseData:(NSData *)data forURLRequest:(NSURLRequest *)request callBlock:(ResponseBlock)responseBlock invocation:(NSInvocation*)invocation
{
    NSError *error = nil;
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    
    NSDictionary *responseDict = [[JSONDecoder decoder] objectWithData:data error: &error];
    if (error){
        if( !responseString){
            DDLogError(@"%s\nresponseString = nil!", __PRETTY_FUNCTION__);
            return;
        }
        NSString *eDescription = responseString;
        
        NSDictionary *eDict = [NSDictionary dictionaryWithObjectsAndKeys:eDescription,  NSLocalizedDescriptionKey, nil];
        error = [NSError errorWithDomain:@"ServerInteractionManager" code:0 userInfo:eDict];
        
        DDLogError(@"Parsing string: %@\nERROR: %@", responseString, error);
        if (responseBlock)
            responseBlock(nil, error);
        return;
    }
    NSString *status = [responseDict objectForKey:kResponseStatusKey];
    if ([status isEqualToString: kResponseStatusError]){
        DDLogResponseError(@"<<<< %@\n\n%@",request.URL, responseString);
        NSString *errorCode = [[responseDict objectForKey:@"error"] objectForKey:@"code"];
        NSString *errorDomain = [errorCode stringByTrimmingCharactersInSet:[[NSCharacterSet letterCharacterSet] invertedSet]];
        int eCode = [[errorCode stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] intValue];
        if ([errorDomain isEqualToString:kAuthErrorPrefix]){
            if (eCode == AUTH_ERROR_TOKEN_IS_INVALID){
                if ([_accountManager reloginSynchronous: &error]){
                    [invocation invoke];
                    return;
                }
            }
        }
        
        NSString *eDescription = [[responseDict objectForKey:@"error"] objectForKeyOrNilIfNotExists:@"message"];
        NSDictionary *eDict = [NSDictionary dictionaryWithObjectsAndKeys:eDescription,  NSLocalizedDescriptionKey, nil];
        error = [NSError errorWithDomain:errorDomain code:eCode userInfo:eDict];
        if (responseBlock)
            responseBlock (nil, error);
        return;
    }
    else{
        DDLogResponseOk(@"<<<< %@\n\n%@",request.URL, responseString);
        id responseObject = [responseDict objectForKey:kResponseTargetObjectKey];
        if (![responseObject isKindOfClass: [NSNull class]]){
            if (responseBlock)
                responseBlock(responseObject, error);
            return;
        }
    }
    if (responseBlock)
        responseBlock(nil, error);
}

- (AFHTTPRequestOperation*)makeGETRequestForURLPath: (NSString *)urlPath useToken: (BOOL)useToken inputParameters: (NSDictionary*)parameters responseBlock:(void (^)(id, NSError *))responseBlock ;
{
    NSMutableDictionary *requestParameters = [[NSMutableDictionary alloc] initWithDictionary: parameters ? parameters : @{}];
    if (useToken){
        NSString *aToken;
        NSError *anError = nil;
        aToken = [_accountManager token: &anError];
        if (anError){
            responseBlock(nil, anError);
            return nil;
        }
        [requestParameters setObject:aToken forKey:@"token"];
    }
    
    NSURLRequest *request = [self getRequestWithPath:urlPath parameters: requestParameters];
    
    DDLogRequest(@">>>> %@", request.URL);
    
    // This part of code takes a name of funcion/method where was called current method.
    // If this method has been called from another method of ServerInteracionManager, NSInvocation (see part B) will be created.
    // Otherwhise if thos methos has been invoked (caller sctring contains "__invoking___"), variable isInvoked will be YES.
    // It means that this method has been called after token error and synchronous login.
    //{
    BOOL isInvoked = NO;
    void *addr[2];
    int nframes = backtrace(addr, sizeof(addr)/sizeof(*addr));
    if (nframes > 1) {
        char **syms = backtrace_symbols(addr, nframes); // equal to [[NSThread  callStackSymbols] objectAtIndex:1]
        NSString *caller = [NSString stringWithUTF8String:syms[1]];
        static NSString *invokeMarker = @"__invoking___";
        isInvoked = [caller rangeOfString:invokeMarker].location != NSNotFound;
        
        free(syms);
    }
    else {
        DDLogError(@"%s: *** Failed to generate backtrace.", __func__);
        return nil;
    }
    //}
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Part B
        NSInvocation * invocation = nil;
        if (useToken && !isInvoked){
            NSMethodSignature * signature = [ServerInteractionManager instanceMethodSignatureForSelector:_cmd];
            invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector: _cmd];
            [invocation setArgument:(void *)(&urlPath) atIndex:2];
            [invocation setArgument:(void *)(&useToken) atIndex:3];
            [invocation setArgument:(void *)(&parameters) atIndex:4];
            [invocation setArgument:(void *)(&responseBlock) atIndex:5];
        }
        [self parseResponseData:responseObject forURLRequest:request callBlock:responseBlock invocation:invocation];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogError(@"<<<< RESPONSE: %@\n\nERROR: %@",request.URL, error);
//        NSLogRed(@"<<<< RESPONSE: %@\n\nERROR: %@",request.URL, error);
        if (responseBlock)
            responseBlock(nil, error);
    }];
    [requestOperation start];
    return requestOperation ;
}

- (AFHTTPRequestOperation*)makePOSTRequestForURLPath: (NSString *)urlPath useToken: (BOOL)useToken HTTPBody: (NSData*)body responseBlock:(void (^)(id, NSError *))responseBlock
{
    NSString *urlPathWithToken = urlPath;
    if (useToken){
        NSString *aToken;
        NSError *anError = nil;
        aToken = [_accountManager token: &anError];
        if (anError){
            responseBlock(nil, anError);
            return nil;
        }
        urlPathWithToken = [urlPath stringByAppendingPathComponent:aToken];
    }
    
    NSURLRequest *request = [self postRequestWithPath:urlPathWithToken httpBody:body];
    
    NSString *bodyString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    DDLogRequest(@">>>> %@\nbody:\n%@", request.URL, bodyString);
    
    // This part of code takes a name of funcion/method where was called current method.
    // If this method has been called from another method of ServerInteracionManager, NSInvocation (see part B) will be created.
    // Otherwhise if thos methos has been invoked (caller sctring contains "__invoking___"), variable isInvoked will be YES.
    // It means that this method has been called after token error and synchronous login.
    //{
    BOOL isInvoked = NO;
    void *addr[2];
    int nframes = backtrace(addr, sizeof(addr)/sizeof(*addr));
    if (nframes > 1) {
        char **syms = backtrace_symbols(addr, nframes); // equal to [[NSThread  callStackSymbols] objectAtIndex:1]
        NSString *caller = [NSString stringWithUTF8String:syms[1]];
        static NSString *invokeMarker = @"__invoking___";
        isInvoked = [caller rangeOfString:invokeMarker].location != NSNotFound;
        
        free(syms);
    }
    else {
        DDLogError(@"%s: *** Failed to generate backtrace.", __PRETTY_FUNCTION__);
        return nil;
    }
    //}
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // Part B
        NSInvocation * invocation = nil;
        if (useToken && !isInvoked){
            NSMethodSignature * signature = [ServerInteractionManager instanceMethodSignatureForSelector:_cmd];
            invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector: _cmd];
            [invocation setArgument:(void *)(&urlPath) atIndex:2];
            [invocation setArgument:(void *)(&useToken) atIndex:3];
            [invocation setArgument:(void *)(&body) atIndex:4];
            [invocation setArgument:(void *)(&responseBlock) atIndex:5];
        }
        [self parseResponseData:responseObject forURLRequest:request callBlock:responseBlock invocation:invocation];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogError(@"%@\n\nERROR: %@",request.URL, error);
        if (responseBlock)
            responseBlock(nil, error);
    }];
    [requestOperation start];
    return requestOperation ;
}



#pragma mark - Public methods
#pragma mark Accont services

//- (NSOperation *)createAccountForUser:(MWEntity*)inputObject storeId:(NSString*)storeId responseBlock:(void (^)(NSDictionary *, NSError *))responseBlock
//{
//    NSString *urlPath = [NSString stringWithFormat:@"%@/%@",  kPOSTCreateAccountURLPath, storeId];
//    
//    return [self makePOSTRequestForURLPath:urlPath
//                                  useToken:NO
//                                  HTTPBody:[inputObject JSONData]
//                             responseBlock:responseBlock];
//}
//
//- (NSDictionary *)synchronousLogin:(MWEntity*)login error:(NSError **)error
//{
//    NSString *urlString = [kServerURL stringByAppendingPathComponent: kPOSTUserLoginURLPath];
//    DDLogInfo(@"Start synchronous login");
//    NSData *jsonData = [login JSONData];
//    NSString *bodyString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSURLRequest *request = [self postRequestWithPath:urlString httpBody:jsonData];
//    
////    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:request.URL.host];
//    
//    NSURLResponse* response;
//    //Capturing server response
//    DDLogRequest(@">>>> %@\nbody:\n%@", request.URL, bodyString);
//    NSData* responseData = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:error];
//    if (*error){
//        DDLogError(@"%s\nERROR: %@", __PRETTY_FUNCTION__, *error);
//        return nil;
//    }
//    else{
//        DDLogInfo(@"Success synchronous login");
//       
//        NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//        DDLogResponseOk(@"<<<< %@\n\n%@",request.URL, responseStr);
//        [responseStr release];
//       
//        NSDictionary *responseDict = [[JSONDecoder decoder] objectWithData:responseData error: error];
//        if (*error){
//            return nil;
//        }
//        NSString *status = [responseDict objectForKey:kResponseStatusKey];
//        if ([status isEqualToString: kResponseStatusError]){
//            NSString *eDescription = [responseDict valueForKeyPath:kResponseErrorMessagePath];
//            int eCode = [[responseDict valueForKeyPath:kResponseErrorCodePath] intValue];
//            NSDictionary *eDict = [NSDictionary dictionaryWithObjectsAndKeys:eDescription,  NSLocalizedDescriptionKey, kErrorTitle, kErrorTitleKey, nil];
//            *error = [NSError errorWithDomain:@"ServerInteractionManager" code:eCode userInfo:eDict];
//            return nil;
//        }
//        id responseObject = [responseDict objectForKey:kResponseTargetObjectKey];
//        if (responseObject && ![responseObject isKindOfClass: [NSNull class]]){
//            *error = nil;
//            return responseObject;
//        }
//    }
//    *error = nil;
//    return nil;
//}
//
//- (NSOperation *)userLogin:(MWEntity<MWJSONData> *)inputObject responseBlock:(void (^)(NSDictionary *, NSError *))responseBlock
//{
//    
//    return [self makePOSTRequestForURLPath:kPOSTUserLoginURLPath
//                                  useToken:NO
//                                  HTTPBody:[inputObject JSONData]
//                             responseBlock:responseBlock];
//    
//}


@end
