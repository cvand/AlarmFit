//
//  KeychainWrapper.h
//  Simple-OAuth1
//
//  Created by Chrysanthi Vandera on 2/18/15.
//  Copyright (c) 2015 Christian-Hansen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainWrapper : NSObject {
    
    NSMutableDictionary        *keychainData;
    NSMutableDictionary        *genericPasswordQuery;
    
}

@property (nonatomic, strong) NSMutableDictionary *keychainData;
@property (nonatomic, strong) NSMutableDictionary *genericPasswordQuery;


- (void)mySetObject:(id)inObject forKey:(id)key;
- (id)myObjectForKey:(id)key;
- (void)resetKeychainItem;

@end


static const UInt8 kKeychainItemIdentifier[]    = "com.cvandera.fitbitAlarm.Key";

@interface KeychainWrapper (PrivateMethods)

- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert;
- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert;
- (void)writeToKeychain;

@end

