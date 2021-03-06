//
//  S9Client.m
//  SlanissueToolkit
//
//  Created by Moky on 14-6-7.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "S9Device.h"
#import "S9Object.h"
#import "S9Client.h"

@interface S9Client ()

@property(nonatomic, retain) NSString * hardware;
@property(nonatomic, retain) NSString * deviceIdentifier;
@property(nonatomic, retain) NSString * deviceModel;
@property(nonatomic, retain) NSString * systemName;
@property(nonatomic, retain) NSString * systemVersion;

// app bundle
@property(nonatomic, retain) NSString * name;
@property(nonatomic, retain) NSString * displayName;
@property(nonatomic, retain) NSString * version;

// DOS
@property(nonatomic, retain) NSString * applicationDirectory;
@property(nonatomic, retain) NSString * documentDirectory;
@property(nonatomic, retain) NSString * cachesDirectory;
@property(nonatomic, retain) NSString * temporaryDirectory;

@end

@implementation S9Client

@synthesize screenSize = _screenSize;
@synthesize screenScale = _screenScale;
@synthesize windowSize = _windowSize;
@synthesize statusBarHeight = _statusBarHeight;

@synthesize hardware = _hardware;
@synthesize deviceIdentifier = _deviceIdentifier;
@synthesize deviceModel = _deviceModel;
@synthesize systemName = _systemName;
@synthesize systemVersion = _systemVersion;

@synthesize name = _name;
@synthesize displayName = _displayName;
@synthesize version = _version;

// DOS
@synthesize applicationDirectory = _applicationDirectory;
@synthesize documentDirectory = _documentDirectory;
@synthesize cachesDirectory = _cachesDirectory;
@synthesize temporaryDirectory = _temporaryDirectory;

- (void) dealloc
{
	[_hardware release];
	[_deviceIdentifier release];
	[_deviceModel release];
	[_systemName release];
	[_systemVersion release];
	
	[_name release];
	[_displayName release];
	[_version release];
	
	// DOS
	[_applicationDirectory release];
	[_documentDirectory release];
	[_cachesDirectory release];
	[_temporaryDirectory release];
	
	[super dealloc];
}

- (instancetype) init
{
	self = [super init];
	if (self) {
#if TARGET_OS_WATCH
		WKInterfaceDevice * iWatch = [WKInterfaceDevice currentDevice];
		
		_screenSize = iWatch.screenBounds.size;
		_screenScale = iWatch.screenScale;
		
		_windowSize = iWatch.screenBounds.size;
		
		_statusBarHeight = 0.0f;
#else
		UIScreen * screen = [UIScreen mainScreen];
		
		_screenSize = screen.bounds.size;
		_screenScale = [screen respondsToSelector:@selector(scale)] ? screen.scale : 1.0f;
		
		_windowSize = screen.bounds.size;
		
#	if TARGET_OS_TV
		_statusBarHeight = 0.0f;
#	else
		//_windowSize = screen.applicationFrame.size;
		UIApplication * app = [UIApplication sharedApplication];
		_statusBarHeight = app.statusBarFrame.size.height;
#	endif
#endif
		
		self.hardware = nil;
		self.deviceIdentifier = nil;
		self.deviceModel = nil;
		self.systemName = nil;
		self.systemVersion = nil;
		
		self.name = nil;
		self.displayName = nil;
		self.version = nil;
		
		// DOS
		self.applicationDirectory = nil;
		self.documentDirectory = nil;
		self.cachesDirectory = nil;
		self.temporaryDirectory = nil;
	}
	return self;
}

// singleton implementations
S9_IMPLEMENT_SINGLETON_FUNCTIONS(getInstance)

#pragma mark -

- (NSString *) hardware
{
	if (!_hardware) {
#if TARGET_OS_WATCH
		self.hardware = [[WKInterfaceDevice currentDevice] machine];
#else
		self.hardware = [[UIDevice currentDevice] machine];
#endif
	}
	return _hardware;
}

- (NSString *) deviceIdentifier
{
	if (!_deviceIdentifier) {
#if TARGET_OS_WATCH
		self.deviceIdentifier = [[WKInterfaceDevice currentDevice] UUIDString];
#else
		self.deviceIdentifier = [[UIDevice currentDevice] UUIDString];
#endif
	}
	return _deviceIdentifier;
}

- (NSString *) deviceModel
{
	if (!_deviceModel) {
#if TARGET_OS_WATCH
		self.deviceModel = [[WKInterfaceDevice currentDevice] model];
#else
		self.deviceModel = [[UIDevice currentDevice] model];
#endif
	}
	return _deviceModel;
}

- (NSString *) systemName
{
	if (!_systemName) {
#if TARGET_OS_WATCH
		self.systemName = [[WKInterfaceDevice currentDevice] systemName];
#else
		self.systemName = [[UIDevice currentDevice] systemName];
#endif
	}
	return _systemName;
}

- (NSString *) systemVersion
{
	if (!_systemVersion) {
#if TARGET_OS_WATCH
		self.systemVersion = [[WKInterfaceDevice currentDevice] systemVersion];
#else
		self.systemVersion = [[UIDevice currentDevice] systemVersion];
#endif
	}
	return _systemVersion;
}

- (NSString *) name
{
	if (!_name) {
		self.name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
	}
	return _name;
}

- (NSString *) displayName
{
	if (!_displayName) {
		self.displayName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
	}
	return _displayName;
}

- (NSString *) version
{
	if (!_version) {
		NSDictionary * dict = [[NSBundle mainBundle] infoDictionary];
		NSString * build = [dict objectForKey:@"CFBundleVersion"];
		NSString * version = [dict objectForKey:@"CFBundleShortVersionString"];
		if (version) {
			if (build && ![build isEqualToString:version]) {
				self.version = [NSString stringWithFormat:@"%@(%@)", version, build];
			} else {
				self.version = version;
			}
		} else {
			self.version = build;
		}
	}
	return _version;
}

#pragma mark DOS

- (NSString *) applicationDirectory
{
	if (!_applicationDirectory) {
		self.applicationDirectory = [[NSBundle mainBundle] resourcePath];
	}
	return _applicationDirectory;
}

- (NSString *) documentDirectory
{
	if (!_documentDirectory) {
		NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSAssert([paths count] > 0, @"failed to locate document directory");
		self.documentDirectory = [paths firstObject];
	}
	return _documentDirectory;
}

- (NSString *) cachesDirectory
{
	if (!_cachesDirectory) {
		NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		NSAssert([paths count] > 0, @"failed to locate caches directory");
		self.cachesDirectory = [paths firstObject];
	}
	return _cachesDirectory;
}

- (NSString *) temporaryDirectory
{
	if (!_temporaryDirectory) {
		self.temporaryDirectory = NSTemporaryDirectory();
	}
	return _temporaryDirectory;
}

#pragma mark Checkup

- (BOOL) isPad
{
	return [self.deviceModel rangeOfString:@"iPad"].location != NSNotFound;
}

- (BOOL) isRetina
{
	return self.screenScale > 1.5f;
}

@end
