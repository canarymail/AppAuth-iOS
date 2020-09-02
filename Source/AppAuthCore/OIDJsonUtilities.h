//
//  OIDJsonUtilities.h
//  AppAuth
//
//  Created by Dev on 01/09/20.
//  Copyright © 2020 OpenID Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kJsonSet(dict, anObject, aKey) [dict setJsonObject:anObject forKey:aKey]
#define kJsonUrl(x) [OIDJsonUtilities urlFromJson:x]

NS_ASSUME_NONNULL_BEGIN

@protocol OIDJsonable <NSObject>

- (nonnull instancetype)initWithJson:(nonnull NSDictionary *)dict;

- (nonnull NSDictionary *)toJson;

@end

@interface OIDJsonUtilities : NSObject

+ (id)jsonSafeObject:(id)object;

+ (NSURL *)urlFromJson:(id)object;

+ (NSArray<NSURL *> *)urlsFromJson:(NSArray *)objects;

@end

@interface NSMutableDictionary (JsonSafety)

- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey;

- (void)setJsonObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end

NS_ASSUME_NONNULL_END
