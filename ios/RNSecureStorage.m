#import <Security/Security.h>
#import <React/RCTConvert.h>
#import <React/RCTBridge.h>
#import <React/RCTUtils.h>
#import "RNSecureStorage.h"

@implementation RNSecureStorage

@synthesize bridge = _bridge;
RCT_EXPORT_MODULE();

// Messages from the comments in <Security/SecBase.h>
NSString *messageForError(NSError *error)
{
	switch (error.code) {
		case errSecUnimplemented:
			return @"Function or operation not implemented.";
			
		case errSecIO:
			return @"I/O error.";
			
		case errSecOpWr:
			return @"File already open with with write permission.";
			
		case errSecParam:
			return @"One or more parameters passed to a function where not valid.";
			
		case errSecAllocate:
			return @"Failed to allocate memory.";
			
		case errSecUserCanceled:
			return @"User canceled the operation.";
			
		case errSecBadReq:
			return @"Bad parameter or invalid state for operation.";
			
		case errSecNotAvailable:
			return @"No keychain is available. You may need to restart your computer.";
			
		case errSecDuplicateItem:
			return @"The specified item already exists in the keychain.";
			
		case errSecItemNotFound:
			return @"The specified item could not be found in the keychain.";
			
		case errSecInteractionNotAllowed:
			return @"User interaction is not allowed.";
			
		case errSecDecode:
			return @"Unable to decode the provided data.";
			
		case errSecAuthFailed:
			return @"The user name or passphrase you entered is not correct.";
			
		default:
			return error.localizedDescription;
	}
}

NSString *codeForError(NSError *error)
{
	return [NSString stringWithFormat:@"%li", (long)error.code];
}


void rejectWithError(RCTPromiseRejectBlock reject, NSError *error)
{
	return reject(codeForError(error), messageForError(error), nil);
}

RCT_EXPORT_METHOD(setItem:(NSString*)key value:(NSString*)value options:(NSDictionary *)options){
	
	NSString * keychainService = [RCTConvert NSString:options[@"keychainService"]];
	if (keychainService == NULL) {
		keychainService = @"app";
	}
	
	NSData* valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
	NSDictionary* query = [NSDictionary dictionaryWithObjectsAndKeys:
						   (__bridge id)(kSecClassGenericPassword), kSecClass,
						   keychainService, kSecAttrService,
						   valueData, kSecValueData,
						   key, kSecAttrAccount, nil];
	
	OSStatus osStatus = SecItemDelete((__bridge CFDictionaryRef) query);
	osStatus = SecItemAdd((__bridge CFDictionaryRef) query, NULL);
}

RCT_EXPORT_METHOD(getItem:(NSString *)key options:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
	
	
	NSString * keychainService = [RCTConvert NSString:options[@"keychainService"]];
	if (keychainService == NULL) {
		keychainService = @"app";
	}
	
	
	// Create dictionary of search parameters
	NSDictionary* query = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)(kSecClassGenericPassword), kSecClass,
						   keychainService, kSecAttrService,
						   key, kSecAttrAccount,
						   kCFBooleanTrue, kSecReturnAttributes,
						   kCFBooleanTrue, kSecReturnData,
						   nil];
	
	// Look up server in the keychain
	NSDictionary* found = nil;
	CFTypeRef foundTypeRef = NULL;
	OSStatus osStatus = SecItemCopyMatching((__bridge CFDictionaryRef) query, (CFTypeRef*)&foundTypeRef);
	
	if (osStatus != noErr && osStatus != errSecItemNotFound) {
		NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:osStatus userInfo:nil];
		rejectWithError(reject, error);
	}
	
	found = (__bridge NSDictionary*)(foundTypeRef);
	if (!found) {
		resolve(nil);
	} else {
		// Found
		NSString* value = [[NSString alloc] initWithData:[found objectForKey:(__bridge id)(kSecValueData)] encoding:NSUTF8StringEncoding];
		resolve(value);
		
	}
	
}

RCT_EXPORT_METHOD(getAllItems:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
	
	NSString * keychainService = [RCTConvert NSString:options[@"keychainService"]];
	
	NSMutableArray* finalResult = [[NSMutableArray alloc] init];
	NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								  (__bridge id)kCFBooleanTrue, (__bridge id)kSecReturnAttributes,
								  (__bridge id)kSecMatchLimitAll, (__bridge id)kSecMatchLimit,
								  (__bridge id)kCFBooleanTrue, (__bridge id)kSecReturnData,
								  nil];
	
	if (keychainService) {
		[query setObject:keychainService forKey:(NSString*)kSecAttrService];
	}
	
	[query setObject:(NSString*)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	
	CFTypeRef result = NULL;
	SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
	
	if (result != NULL){
		for (NSDictionary* item in (__bridge id)result) {
			NSString* key = item[(NSString*)kSecAttrAccount];
			NSString* value = item[(NSString*)kSecValueData];
			[finalResult addObject:@{key: value}];
		}
	}
	
	if (finalResult != nil){
		resolve(finalResult);
	} else {
		reject(@"no_events", @"There were no events", nil);
	}
}


RCT_EXPORT_METHOD(deleteItem:(NSString *)key options:(NSDictionary *)options){
	
	NSString * keychainService = [RCTConvert NSString:options[@"keychainService"]];
	if (keychainService == NULL) {
		keychainService = @"app";
	}
	
	// Create dictionary of search parameters
	NSDictionary* query = [NSDictionary dictionaryWithObjectsAndKeys:
						   (__bridge id)(kSecClassGenericPassword), kSecClass,
						   keychainService, kSecAttrService,
						   key, kSecAttrAccount,
						   kCFBooleanTrue, kSecReturnAttributes,
						   kCFBooleanTrue, kSecReturnData, nil];
	
	// Remove any old values from the keychain
	OSStatus osStatus = SecItemDelete((__bridge CFDictionaryRef) query);
}
@end
