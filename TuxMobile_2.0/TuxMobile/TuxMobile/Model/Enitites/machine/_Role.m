//
//  _Role.m
//
//  Generated by wadl2objc 2013.09.03 14:51:56.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_Role.h"

@implementation _Role

#pragma mark - Mapping

+ (NSArray*)mappedKays
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"id", @"roleName", @"type"];
    }
    return keys;
}

+ (NSString *)entityNameForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"type"]) return @"RoleType";

    return [super entityNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
