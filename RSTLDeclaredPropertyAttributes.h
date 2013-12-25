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

typedef NS_ENUM(NSUInteger, RSTLPropertyStorageMethod) {
	RSTLPropertyAssignStorage,
	RSTLPropertyStrongStorage,
	RSTLPropertyCopyStorage,
	RSTLPropertyReadOnlyStorage,
};

extern NSString *RSTLStringForPropertyStorageMethod(RSTLPropertyStorageMethod);

// Not going to try to support
// enum, struct, union, int *, void *, long, short, signed, unsigned, etc
typedef NS_ENUM(NSUInteger, RSTLPropertyStorageType) {
	RSTLPropertyIDType,
	RSTLPropertyObjectType,
	RSTLPropertyBoolType, // We assume that chars are BOOLs
	RSTLPropertyDoubleType,
	RSTLPropertyFloatType,
	RSTLPropertyIntType,
	RSTLPropertyUnsupportedType,
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
