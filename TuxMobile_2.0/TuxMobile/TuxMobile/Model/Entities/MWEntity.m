//
//  MWEntity.m
//  Tailoring
//
//  Created by Dmitry Zhurov on 26.10.12.
//  Copyright (c) 2012 Dmitry Zhurov. All rights reserved.
//

#import "MWEntity.h"
#import <objc/runtime.h>
#import "NSDateFormatter+MWFormats.h"
#import "JSONKit.h"

@implementation MWEntity

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@ %p>(", NSStringFromClass([self class]), self];
    [self propertiesEnumeration:^(NSString *propertyName, NSArray *attributes) {
        BOOL strongReference = ! [[attributes objectAtIndex:0] hasPrefix:@"T@"]; // if attribute has prefix T@ it is a obj-C object ( id )
        if (! strongReference){
            for (NSString *oneAttribute in attributes) {
                if (([oneAttribute isEqualToString:@"C"] || [oneAttribute isEqualToString:@"&"])){ // Copy or Retain property
                    strongReference = YES;
                    break;
                }
            }
        }
        id value = [self valueForKey:propertyName];
        if (strongReference)
            [description appendFormat:@"\n\t%@ = %@", propertyName, value];
        else
            [description appendFormat:@"\n\t%@ = <%@ %p>(",  propertyName,NSStringFromClass([value class]), value];
    }];
    
    [description appendFormat:@"\n)"];
    return description;
}

- (void) propertiesEnumeration: (void(^)(NSString *propertyName, NSArray *attributes))iterationBlock
{
    if (!iterationBlock){
        return;
    }
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
    	objc_property_t property = properties[i];
    	const char *propName = property_getName(property);
        const char *propertyAttributes = property_getAttributes(property);
    	if(propName) {
            NSString *propertyName = [NSString stringWithUTF8String: propName];
            NSArray *attributes = [[NSString stringWithUTF8String:propertyAttributes] componentsSeparatedByString:@","];
            iterationBlock(propertyName, attributes);
        }
    }
    free(properties);
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
    	objc_property_t property = properties[i];
    	const char *propName = property_getName(property);
    	if(propName) {
            NSString *propertyName = [NSString stringWithUTF8String: propName];
            id value = [self valueForKey:propertyName];
            [encoder encodeObject:value forKey:propertyName];
    	}
    }
    free(properties);
}


- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList([self class], &outCount);
        for(i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char *propName = property_getName(property);
            if(propName) {
                NSString *propertyName = [NSString stringWithUTF8String: propName];
                id value = [decoder decodeObjectForKey:propertyName];
                [self setValue:value forKey:propertyName];
            }
        }
        free(properties);
    }
    return self;
}

#pragma mark - NSCopyng

- (id)copyWithZone:(NSZone*)zone
{
	MWEntity* copy = [[self class] new];
    return copy;
}

- (NSMutableDictionary *)dictionaryInfoForKeys:(NSString*)firstObject, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableDictionary *dictInfo = nil;
    NSString* eachObject;
    va_list argumentList;
    if (firstObject)
    {
        dictInfo = [NSMutableDictionary dictionary];
        va_start(argumentList, firstObject);
        eachObject = firstObject;
        do {
            id valueForKey = [self valueForKey:eachObject];
            
            if ([valueForKey isKindOfClass:[MWEntity class]]){
                valueForKey = [(MWEntity*)valueForKey JSONDictionary];
            }else if ([valueForKey isKindOfClass:[NSDate class]]){
                NSDateFormatter *dateFormatter = [NSDateFormatter yearMonthDayAndTimeDateFormatter];
                valueForKey = [dateFormatter stringFromDate:valueForKey];
            }
            if (valueForKey && ![valueForKey isKindOfClass:[NSNull class]]){
                [dictInfo setObject:valueForKey forKey:eachObject];
            }
            eachObject = va_arg(argumentList, NSString*);
        } while (eachObject);
        va_end(argumentList);
    }
    
    return dictInfo;
}

- (void)setDictionaryInfo:(NSDictionary *)dictInfo forKeys:(NSString*)firstObject, ... NS_REQUIRES_NIL_TERMINATION
{
    NSString* eachObject;
    va_list argumentList;
    if (firstObject)
    {
        id valueForKey = [dictInfo objectForKey:firstObject];
        if (valueForKey && ![valueForKey isKindOfClass:[NSNull class]]){
            [self setValue:valueForKey forKey:firstObject];
        }
        va_start(argumentList, firstObject);
        do {
            eachObject = va_arg(argumentList, NSString*);
            id valueForKey = [dictInfo objectForKey:eachObject];
            if (valueForKey && ![valueForKey isKindOfClass:[NSNull class]])
            {
                objc_property_t property = class_getProperty([self class], [eachObject UTF8String]);
                const char *propertyAttributes = property_getAttributes(property);
                NSArray *attributes = [[NSString stringWithUTF8String:propertyAttributes] componentsSeparatedByString:@","];
                NSString *propertyTypeStr = attributes[0];
                NSString *className = [propertyTypeStr substringFromIndex:2]; // 2 is length of "T@""
                className = [className stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                Class propClass = NSClassFromString(className);
                
                if ([propClass isSubclassOfClass:[MWEntity class]]){
                    MWEntity *entity = [[propClass alloc] initWithJSONDictionary:valueForKey];
                    [self setValue:entity forKey: eachObject];
                }
                else if ([propClass isSubclassOfClass:[NSDate class]]){
                    NSDateFormatter *dateFormatter = [NSDateFormatter yearMonthDayAndTimeDateFormatter];
                    NSDate *date = [dateFormatter dateFromString:valueForKey];
                    [self setValue:date forKey: eachObject];
                }
                else{
                    [self setValue:valueForKey forKey:eachObject];
                }
            }
        } while (eachObject);
        va_end(argumentList);
    }
}

- (NSMutableDictionary*)JSONDictionary
{
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    [self propertiesEnumeration:^(NSString *propertyName, NSArray *attributes) {
        BOOL isReadOnly = [attributes containsObject:@"R"];
        if (!isReadOnly){
            id object = [self valueForKey:propertyName];
            id value = object;
            if ([object isKindOfClass:[MWEntity class]]){
                value = [(MWEntity*)object JSONDictionary];
            }
            [jsonDict setObject:value forKey:propertyName];
        }
    }];
    return jsonDict;
}

- (void)setJSONDictionary:(NSDictionary *)JSONDictionary
{
    [self propertiesEnumeration:^(NSString *propertyName, NSArray *attributes) {
        BOOL isReadOnly = [attributes containsObject:@"R"];
        
        if ( !isReadOnly ){
            NSString *propertyTypeStr = attributes[0];
            BOOL isPrimitive = [propertyTypeStr characterAtIndex:1] != '@'; // is it class
            NSString *className = nil;
            id object = [JSONDictionary objectForKey:propertyName];
            while ( !isPrimitive){
                className = [propertyTypeStr substringFromIndex:2]; // 2 is length of "T@""
                className = [className stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                Class propClass = NSClassFromString(className);
                if ( propClass == Nil ){
                    DDLogError(@"");
                    return;
                }
                if ( [propClass isSubclassOfClass:[MWEntity class]] ){
                    // initialize an object
                    NSDictionary *dictObj = object;
                    MWEntity *entity = [[propClass alloc] initWithJSONDictionary:dictObj];
                    [self setValue:entity forKey: propertyName];
                    return;
                }
                else if ( [propClass isSubclassOfClass:[NSArray class]] ){
                    // do something with it
                    break;
                }
                break;
            }
            [self setValue:object forKey: propertyName];
        }
    }];
}

- (NSData *)JSONData
{
    NSDictionary *jsonDict = self.JSONDictionary;
    NSError *error = nil;
    NSData *result = [jsonDict JSONDataWithOptions:JKSerializeOptionNone error: &error];
    if (error) {
        NSLog(@"%s\nERROR: %@", __PRETTY_FUNCTION__, error);
    }
    return result;
}

@end
/*
 
 
 
 */

@implementation MWEntity (MWEntity)

- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary
{
    self = [super init];
    if (self){
        self.JSONDictionary = jsonDictionary;
    }
    return self;
}

+ (NSMutableArray *)objectsWithJSONArray:(NSArray *)array
{
    if (array.count){
        NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:array.count];
        for (NSDictionary *dictionary in array) {
            MWEntity *entity = [[self alloc] initWithJSONDictionary:dictionary];
            [resultArray addObject:entity];
        }
        return resultArray;
    }
    return nil;
}

@end