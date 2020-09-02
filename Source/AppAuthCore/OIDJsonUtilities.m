//
//  OIDJsonUtilities.m
//  AppAuth
//
//  Created by Dev on 01/09/20.
//  Copyright © 2020 OpenID Foundation. All rights reserved.
//

#import "OIDJsonUtilities.h"

@implementation OIDJsonUtilities

+ (NSSet *)jsonSafeClasses {
  static NSSet *_jsonSafe;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSMutableSet *classes = [[NSMutableSet alloc] init];
    [classes addObject:NSDictionary.class];
    [classes addObject:NSArray.class];
    [classes addObject:NSNumber.class];
    [classes addObject:NSString.class];
    [classes addObject:NSNull.class];
    _jsonSafe = classes;
  });
  return _jsonSafe;
}

+ (id)jsonSafeObject:(id)object {
  if ([object conformsToProtocol:@protocol(OIDJsonable)]) {
    id<OIDJsonable> jsonable = object;
    return jsonable.toJson;
  } else if ([object isKindOfClass:[NSURL class]]) {
    return [object absoluteString];
  } else {
    for (Class klass in [self jsonSafeClasses]) {
      if ([object isKindOfClass:klass]) {
        return object;
      }
    }
    return nil;
  }
}

+ (NSURL *)urlFromJson:(id)object {
  if ([object isKindOfClass:[NSURL class]]) {
    return object;
  } else if ([object isKindOfClass:[NSString class]]) {
    return [NSURL URLWithString:object];
  } else {
    return nil;
  }
}

+ (NSArray<NSURL *> *)urlsFromJson:(NSArray *)objects {
  NSMutableArray *ret = [[NSMutableArray alloc] init];
  for (id object in objects) {
    NSURL *url = [self urlFromJson:object];
    if (url) {
      [ret addObject:url];
    }
  }
  return ret;
}

@end

@implementation NSMutableDictionary (JsonSafety)

- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey {
  if (anObject && aKey) {
    [self setObject:anObject forKey:aKey];
  }
}

- (void)setJsonObject:(id)anObject forKey:(id<NSCopying>)aKey {
  if (anObject && aKey) {
    id safeObject = [OIDJsonUtilities jsonSafeObject:anObject];
    if (safeObject) {
      [self setObject:safeObject forKey:aKey];
    }
  }
}

@end
