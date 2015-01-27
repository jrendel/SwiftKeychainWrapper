//
//  KeychainObjcWrapper.m
//  SwiftKeychainWrapper
//
//  Created by Jason Rendel on 1/13/15.
//
//

#import "KeychainObjcWrapper.h"
//#import <Security/Security.h>

@implementation KeychainObjcWrapper

+ (NSData *)dataForDictionary: (NSDictionary *)queryDictionary {
    
    CFTypeRef searchResultRef = NULL;
    OSStatus err = SecItemCopyMatching((__bridge CFDictionaryRef)queryDictionary, &searchResultRef);
    
    NSData *result = nil;
    if(err == noErr) {
        // transfer ownership so ARC will take care of releasing underlying CF object
        result = (__bridge_transfer id)searchResultRef;
    }
    
    return result;
}
@end
