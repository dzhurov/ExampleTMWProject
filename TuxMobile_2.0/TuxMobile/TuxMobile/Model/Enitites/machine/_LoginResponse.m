//
//  _LoginResponse.m
//
//  Generated by wadl2objc 2013.09.03 12:23:39.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_LoginResponse.h"

@implementation _LoginResponse

#pragma mark - Mapping

+ (NSArray*)mappedKays
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"expirationDate", @"token", @"user"];
    }
    return keys;
}

+ (NSString *)entityNameForMappedField:(NSString*)fieldName
{

    return [super entityNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{

    return [super classNameOfMembersForMappedField:fieldName];
}

@end