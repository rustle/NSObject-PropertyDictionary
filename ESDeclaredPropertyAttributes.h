//
//  ESDeclaredPropertyAttributes.h
//
//  Created by Doug Russell
//  Copyright (c) 2011 Doug Russell. All rights reserved.
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

typedef enum {
	AssignStorage, // assign is the default declared property setter type
	StrongStorage,
	CopyStorage,
	ReadOnlyStorage
} PropertyStorageMethod;

// Not going to try to support
// enum, struct, union, int *, void *, long, short, signed, unsigned, etc
typedef enum
{
	IDType,
	ObjectType,
	BoolType, // We assume that chars are BOOLs
	DoubleType,
	FloatType,
	IntType,
	UnsupportedType
} PropertyStorageType;

@interface ESDeclaredPropertyAttributes : NSObject

@property (strong, nonatomic) NSString *classString;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) PropertyStorageType storageType;
@property (nonatomic) SEL getter;
@property (nonatomic) SEL setter;
@property (nonatomic) PropertyStorageMethod storageMethod;
@property (nonatomic) BOOL readOnly;
@property (nonatomic) BOOL nonatomic;
@property (nonatomic) BOOL dynamic;

@end
