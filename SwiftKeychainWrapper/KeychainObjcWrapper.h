//
//  KeychainObjcWrapper.h
//  SwiftKeychainWrapper
//
//  Created by Jason Rendel on 1/13/15.
//
//

#import <Foundation/Foundation.h>

// This class is meant to be a temporary workaround to a known issue with keychain data retrieval and Swift.
// See here for more info on the issue
// https://github.com/jrendel/KeychainWrapper/issues/4
// http://stackoverflow.com/questions/26355630/swift-keychain-and-provisioning-profiles
@interface KeychainObjcWrapper : NSObject

+ (NSData *)dataForDictionary: (NSDictionary *)queryDictionary;

@end
