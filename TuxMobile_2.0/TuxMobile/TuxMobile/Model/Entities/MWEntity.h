//
//  MWEntity.h
//  Tailoring
//
//  Created by Dmitry Zhurov on 26.10.12.
//  Copyright (c) 2012 Dmitry Zhurov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MWJSONData <NSObject>
- (NSData*)JSONData;
@end


@interface MWEntity : NSObject <NSCopying, NSCoding, MWJSONData>
- (NSMutableDictionary*)dictionaryInfoForKeys: (id) firstObject, ... NS_REQUIRES_NIL_TERMINATION;
- (void) setDictionaryInfo:(NSDictionary*)dictInfo forKeys: (id) firstObject, ... NS_REQUIRES_NIL_TERMINATION;

- (void)setJSONDictionary:(NSDictionary *)JSONDictionary;
- (NSMutableDictionary*)JSONDictionary;

@end


@interface MWEntity (MWEntity)
- (id)initWithJSONDictionary:(NSDictionary*)jsonDictionary;
+ (NSMutableArray*)objectsWithJSONArray:(NSArray*)array;
@end



