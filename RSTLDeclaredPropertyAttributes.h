//
//  RSTLDeclaredPropertyAttributes.h
//
//  Created by Doug Russell
//  Copyright (c) 2011, 2013 Doug Russell. All rights reserved.
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//  http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  

#import <Foundation/Foundation.h>

#define __RSTL64__ __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
#define __RSTL64iOS__ !defined(OBJC_HIDE_64) && TARGET_OS_IPHONE && __LP64__

typedef NS_ENUM(NSUInteger, RSTLPropertyStorageMethod) {
	RSTLPropertyAssignStorage,
	RSTLPropertyStrongStorage,
	RSTLPropertyCopyStorage,
	RSTLPropertyReadOnlyStorage,
};

extern NSString *RSTLStringForPropertyStorageMethod(RSTLPropertyStorageMethod);

// Not going to try to support several type
// enum, struct, union, int *, void *, etc
typedef NS_ENUM(NSUInteger, RSTLPropertyStorageType) {
	RSTLPropertyIDType,
	RSTLPropertyObjectType,
	RSTLPropertyBoolType, // Real C99 bool
	RSTLPropertyCharType, // Probably a BOOL
	RSTLPropertyDoubleType,
	RSTLPropertyFloatType,
	RSTLPropertyIntType,
	RSTLPropertyUnsignedIntType,
	RSTLPropertyLongType,
	RSTLPropertyUnsignedLongType,
	RSTLPropertyLongLongType,
	RSTLPropertyUnsignedLongLongType,
	RSTLPRopertySelectorType,
	RSTLPropertyUnsupportedType,
#if __RSTL64iOS__
	RSTLPropertyObjCBoolType = RSTLPropertyBoolType,
#else
	RSTLPropertyObjCBoolType = RSTLPropertyCharType,
#endif
#if __RSTL64__
	RSTLPropertyNSIntegerType = RSTLPropertyLongLongType,
	RSTLPropertyNSUIntegerType = RSTLPropertyUnsignedLongLongType,
#else
	RSTLPropertyNSIntegerType = RSTLPropertyIntType,
	RSTLPropertyNSUIntegerType = RSTLPropertyUnsignedIntType,
#endif
};

extern NSString *RSTLStringForPropertyStorageType(RSTLPropertyStorageType type);

@interface RSTLDeclaredPropertyAttributes : NSObject

@property (nonatomic) NSString *className;
@property (nonatomic) NSString *name;
@property (nonatomic) RSTLPropertyStorageType storageType;
@property (nonatomic) SEL getter;
@property (nonatomic) SEL setter;
@property (nonatomic) RSTLPropertyStorageMethod storageMethod;
@property (nonatomic) BOOL readOnly;
@property (nonatomic) BOOL nonatomic;
@property (nonatomic) BOOL dynamic;

@end
