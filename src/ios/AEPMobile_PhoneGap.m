/*************************************************************************
 *
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2016 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 *
 **************************************************************************/

#import <CoreLocation/CoreLocation.h>
#import "AEPMobile_PhoneGap.h"
#import "AppDelegate.h"
#import <ACPCore/ACPCore.h>
#import <ACPUserProfile/ACPUserProfile.h>
#import <ACPCore/ACPLifecycle.h>
#import <ACPCore/ACPSignal.h>
//#import "ACPSignal.h"
#import <ACPAnalytics/ACPAnalytics.h>
#import <ACPTarget/ACPTarget.h>
#import <ACPCampaign/ACPCampaign.h>
#import <ACPTarget/ACPTargetRequestObject.h>
#import <ACPTarget/ACPTargetPrefetchObject.h>
#import <ACPPlacesMonitor/ACPPlacesMonitor.h>
#import <ACPPlaces/ACPPlaces.h>
#import <ACPCore/ACPIdentity.h>
#define STRING [NSString class]
#define NUMBER [NSNumber class]
#define DICTIONARY [NSDictionary class]

@interface ADBBeacon : NSObject
@property (nonatomic, strong) NSUUID *proximityUUID;
@property (nonatomic, strong) NSNumber *major;
@property (nonatomic, strong) NSNumber *minor;
@property (nonatomic) CLProximity proximity;
@end

@implementation ADBBeacon : NSObject
@end

@implementation AEPMobile_PhoneGap

NSString *const VisitorId_Id = @"id";
NSString *const VisitorId_IdType = @"idType";
NSString *const VisitorId_AuthenticationState = @"authenticationState";
NSString * environmentID;
static NSString * const POI = @"POI";
static NSString * const LATITUDE = @"Latitude";
static NSString * const LONGITUDE = @"Longitude";
static NSString * const LOWERCASE_LATITUDE = @"latitude";
static NSString * const LOWERCASE_LONGITUDE = @"longitude";
static NSString * const IDENTIFIER = @"Identifier";
static NSString * const CENTER = @"center";
static NSString * const RADIUS = @"radius";
static NSString * const REQUEST_ID = @"requestId";
static NSString * const CIRCULAR_REGION = @"circularRegion";
static NSString * const EMPTY_ARRAY_STRING = @"[]";

- (void)pluginInitialize {
    [super pluginInitialize];
     environmentID = [self.commandDelegate.settings objectForKey:[@"environmentIDValue" lowercaseString]];
    [ACPCore setLogLevel:ACPMobileLogLevelDebug];
    [ACPCore configureWithAppId:environmentID];
    [ACPUserProfile registerExtension];
    [ACPIdentity registerExtension];
    [ACPLifecycle registerExtension];
    [ACPSignal registerExtension];
    [ACPAnalytics registerExtension];
    [ACPTarget registerExtension];
    [ACPCampaign registerExtension];
    [ACPPlaces registerExtension];
    [ACPPlacesMonitor registerExtension];
    const UIApplicationState appState = [[UIApplication sharedApplication] applicationState];
    [ACPCore start:^{
     [ACPCore updateConfiguration:@{@"places.membershipttl":@(30)}];
        // only start lifecycle if the application is not in the background
        if (appState != UIApplicationStateBackground) {
            [ACPCore lifecycleStart:nil];
        }
    }];
    
    //Become Active Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    //App moved to background
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    NSLog(@"did become active notification");
   
}

- (void)appWillEnterForeground:(NSNotification *)notification {
    NSLog(@"will enter foreground notification");
     [ACPCore lifecycleStart:nil];
}

- (void)appDidEnterBackground:(NSNotification *)notification {
    NSLog(@"Application enter background");
     [ACPCore lifecyclePause];
}

- (void)trackState:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        if(!checkArgsWithTypes(command.arguments, @[@[STRING, DICTIONARY], @[STRING, DICTIONARY]])
           || ([command.arguments[0] isKindOfClass:DICTIONARY] && command.arguments[1] != (id)[NSNull null])
           || [command.arguments[1] isKindOfClass:STRING]) {
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
            return;
        }

        id firstArg = getArg(command.arguments[0]);
        id secondArg = getArg(command.arguments[1]);

        //allows the ADB.trackState(cData) call
        if([firstArg isKindOfClass:DICTIONARY]) {
             [ACPCore trackState:nil data:firstArg];
        }
        else {
             [ACPCore trackState:firstArg data:secondArg];
        }

        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
    }];
}


- (void)trackAction:(CDVInvokedUrlCommand*)command {
    NSLog(@"Track Action is being called up !!");
    [self.commandDelegate runInBackground:^{
        if(!checkArgsWithTypes(command.arguments, @[@[STRING, DICTIONARY], @[STRING, DICTIONARY]])
           || ([command.arguments[0] isKindOfClass:DICTIONARY] && command.arguments[1] != (id)[NSNull null])
           || [command.arguments[1] isKindOfClass:STRING]) {
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
            return;
        }

        id firstArg = getArg(command.arguments[0]);
        id secondArg = getArg(command.arguments[1]);

        //allows the ADB.trackAction(cData) call
        if([firstArg isKindOfClass:DICTIONARY]) {
            NSLog(@"Track Action with dictionary !!");
             [ACPCore trackAction:nil data:firstArg];
        }
        else {
            NSLog(@"Track Action without dictionary !!");
             [ACPCore trackAction:firstArg data:secondArg];
        }

        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
    }];
}


static BOOL checkArgsWithTypes(NSArray* arguments, NSArray* types) {
    if(!arguments || !types || [arguments count] != [types count]) {
        return NO;
    }

    int types_index = 0;
    for(id argument in arguments) {
        if(argument == (id)[NSNull null]) {
            types_index++;
            continue;
        }

        NSArray* allowedTypesForArgument = types[types_index];
        BOOL foundTypeMatch = NO;
        for(id allowedType in allowedTypesForArgument) {
            foundTypeMatch |= [argument isKindOfClass:allowedType];
            if(foundTypeMatch) { break; }
        }

        if(!foundTypeMatch) { return NO; }
        types_index++;
    }

    return YES;
}


- (void)setPushIdentifier:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        if(!checkArgsWithTypes(command.arguments, @[@[STRING]])) {
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
            return;
        }

        NSString* pushIdStr = getArg(command.arguments[0]);
        NSData* pushIdentifier = nil;

        //hex NSString to NSData
        if(pushIdStr != nil && [pushIdStr length]/2 == 32) {
            char buffer[3];
            buffer[2] = '\0';
            char *bytes = malloc([pushIdStr length]/2);
            char *bytes_ptr = bytes;
            for (int i = 0; i < [pushIdStr length]; i += 2) {
                buffer[0] = [pushIdStr characterAtIndex: i];
                buffer[1] = [pushIdStr characterAtIndex: i+1];
                char *b2 = NULL;
                *bytes_ptr++ = strtol(buffer, &b2, 16);
            }

            pushIdentifier = [NSData dataWithBytesNoCopy:bytes length:[pushIdStr length]/2 freeWhenDone:YES];
        }

        [ACPCore setPushIdentifier:pushIdentifier];

        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
    }];
}

- (void)collectPII:(CDVInvokedUrlCommand*)command{

    [self.commandDelegate runInBackground:^{

        if(!checkArgsWithTypes(command.arguments, @[@[DICTIONARY]])) {
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
            return;
        }

        NSDictionary *piiData = command.arguments[0];
        //ToDo(Prerna): test for individual fields data type
        [ACPCore collectPii:piiData];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Collecting Pii"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}



- (void)targetLoadRequest:(CDVInvokedUrlCommand*)command {

    [self.commandDelegate runInBackground:^{

        if(!checkArgsWithTypes(command.arguments, @[@[STRING], @[STRING], @[DICTIONARY]]) )
        {
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
            return;
        }

        NSString* name = getArg(command.arguments[0]);
        


        ACPTargetParameters *params1 = [ACPTargetParameters targetParametersWithParameters:nil
                                                            profileParameters:nil
                                                                      product:nil
                                                                        order:nil];
        ACPTargetRequestObject *request1 = [ACPTargetRequestObject targetRequestObjectWithName:name targetParameters:params1
        defaultContent:@"defaultContent1" callback:^(NSString * _Nullable content) {
            // do something with the received content
                       CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:content];
                       [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
          }];

        
        // Create request object array
        NSArray *requestArray = @[request1];
        ACPTargetParameters *targetParameters = [ACPTargetParameters targetParametersWithParameters:nil
                                                            profileParameters:nil
                                                                      product:nil
                                                                        order:nil];

        // Call the API
        [ACPTarget retrieveLocationContent:requestArray withParameters:targetParameters];
        
        
        
        
        
       
        
    }];
}


- (void)setRequestLocationPermission:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        ACPPlacesMonitorRequestAuthorizationLevel authorizationLevel = [self convertToAuthorizationLevel:[self getCommandArg:command.arguments[0]]];
        [ACPPlacesMonitor setRequestAuthorizationLevel:authorizationLevel];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)setPlacesMonitorMode:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        ACPPlacesMonitorMode mode = [self convertToMonitorMode:[self getCommandArg:command.arguments[0]]];
        [ACPPlacesMonitor setPlacesMonitorMode:mode];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)getNearbyPointsOfInterest:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        NSDictionary* locationDict = [self getCommandArg:command.arguments[0]];
        CLLocationDegrees latitude = [[locationDict valueForKey:LOWERCASE_LATITUDE] doubleValue];
        CLLocationDegrees longitude = [[locationDict valueForKey:LOWERCASE_LONGITUDE] doubleValue];
        CLLocation* currentLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        NSUInteger limit = [[self getCommandArg:command.arguments[1]] integerValue];
        __block NSString* currentPoisString = EMPTY_ARRAY_STRING;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [ACPPlaces getNearbyPointsOfInterest:currentLocation limit:limit callback:^(NSArray<ACPPlacesPoi *> * _Nullable retrievedPois) {
                currentPoisString = [self generatePOIString:retrievedPois];
                dispatch_semaphore_signal(semaphore);
            }
                errorCallback:^(ACPPlacesRequestError error) {
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"Places request error code: %lu", error]] callbackId:command.callbackId];
        }];
        dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, ((int64_t)1 * NSEC_PER_SEC)));
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:currentPoisString];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}


- (NSString*) generatePOIString:(NSArray<ACPPlacesPoi *> *) retrievedPois {
    NSMutableArray* retrievedPoisArray = [[NSMutableArray alloc]init];
    if(retrievedPois != nil && retrievedPois.count != 0) {
        for (int index = 0; index < retrievedPois.count; index++) {
            NSMutableDictionary* tempDict = [[NSMutableDictionary alloc]init];
            ACPPlacesPoi* currentPoi = retrievedPois[index];
            [tempDict setValue:currentPoi.name forKey:POI];
            [tempDict setValue:[NSNumber numberWithDouble:currentPoi.latitude] forKey:LATITUDE];
            [tempDict setValue:[NSNumber numberWithDouble:currentPoi.longitude] forKey:LONGITUDE];
            [tempDict setValue:currentPoi.identifier forKey:IDENTIFIER];
            retrievedPoisArray[index] = tempDict;
        }
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:retrievedPoisArray options:0 error:nil];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return EMPTY_ARRAY_STRING;
}

- (void)getCurrentPointsOfInterest:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        __block NSString* currentPoisString = EMPTY_ARRAY_STRING;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [ACPPlaces getCurrentPointsOfInterest:^(NSArray<ACPPlacesPoi *> * _Nullable retrievedPois) {
            if(retrievedPois != nil && retrievedPois.count != 0) {
                currentPoisString = [self generatePOIString:retrievedPois];
                dispatch_semaphore_signal(semaphore);
            }
        }];
        dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, ((int64_t)1 * NSEC_PER_SEC)));
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:currentPoisString];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)extensionVersion:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = nil;
        NSString* extensionVersion = [ACPPlaces extensionVersion];

        if (extensionVersion != nil && [extensionVersion length] > 0) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:extensionVersion];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

/*
 * Helper functions
 */

- (id) getCommandArg:(id) argument {
    return argument == (id)[NSNull null] ? nil : argument;
}

- (ACPPlacesMonitorRequestAuthorizationLevel) convertToAuthorizationLevel:(NSNumber*) authorization {
    if(authorization.integerValue == 1){
        return ACPPlacesRequestMonitorAuthorizationLevelAlways;
    } else {
        return ACPPlacesMonitorRequestAuthorizationLevelWhenInUse;
    }
}

- (ACPPlacesMonitorMode) convertToMonitorMode:(NSNumber*) monitorMode {
    if(monitorMode.integerValue == 1){
        return ACPPlacesMonitorModeSignificantChanges;
    } else {
        return ACPPlacesMonitorModeContinuous;
    }
}

- (void)clear:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        [ACPPlaces clear];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}
- (void)getLastKnownLocation:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        [ACPPlaces getLastKnownLocation:^(CLLocation * _Nullable lastLocation) {
            NSMutableDictionary* tempDict = [[NSMutableDictionary alloc]init];
            [tempDict setValue:[NSNumber numberWithDouble:lastLocation.coordinate.latitude] forKey:LATITUDE];
            [tempDict setValue:[NSNumber numberWithDouble:lastLocation.coordinate.longitude] forKey:LONGITUDE];
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:tempDict options:0 error:nil];
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }];
}

- (void) getExperienceCloudId:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        [ACPIdentity getExperienceCloudId:^(NSString * _Nullable experienceCloudId) {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:experienceCloudId];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }];
}


- (void)processGeofence:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        NSDictionary* geofenceDict = [self getCommandArg:command.arguments[0]];
        NSDictionary* regionDict = [geofenceDict valueForKey:CIRCULAR_REGION];
        ACPRegionEventType eventType = [[self getCommandArg:command.arguments[1]] integerValue];
        CLLocationDegrees latitude = [[regionDict valueForKey:LOWERCASE_LATITUDE] doubleValue];
        CLLocationDegrees longitude = [[regionDict valueForKey:LOWERCASE_LONGITUDE] doubleValue];
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude,longitude);
        NSUInteger radius = [[regionDict valueForKey:RADIUS] integerValue];
        NSString* identifier = [geofenceDict valueForKey:REQUEST_ID];
        CLRegion* region = [[CLCircularRegion alloc] initWithCenter:center radius:radius identifier:identifier];
        [ACPPlaces processRegionEvent:region forRegionEventType:eventType];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)setAuthorizationStatus:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        int status = [[self getCommandArg:command.arguments[0]] integerValue];
        [ACPPlaces setAuthorizationStatus:[self convertToCLAuthorizationStatus:status]];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}



- (CLAuthorizationStatus) convertToCLAuthorizationStatus:(int) status {
    switch (status) {
    case 0:
        return kCLAuthorizationStatusDenied;
        break;

    case 1:
        return kCLAuthorizationStatusAuthorizedAlways;
        break;

    case 2:
        return kCLAuthorizationStatusNotDetermined;
        break;

    case 3:
        return kCLAuthorizationStatusRestricted;
        break;

    case 4:
    default:
        return kCLAuthorizationStatusAuthorizedWhenInUse;
        break;
    }
}


- (void)start:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        [ACPPlacesMonitor start];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)stop:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        [ACPPlacesMonitor stop:true];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)updateLocation:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        [ACPPlacesMonitor updateLocationNow];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void) getSdkIdentities:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        [ACPCore getSdkIdentities:^(NSString * _Nullable content) {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:content];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }];
}

- (void) getIdentifiers:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        [ACPIdentity getIdentifiers:^(NSArray<ACPMobileVisitorId *> * _Nullable visitorIDs) {
            NSString *visitorIdsString = @"";
            if (!visitorIDs) {
                visitorIdsString = @"nil";
            } else if ([visitorIDs count] == 0) {
                visitorIdsString = @"[]";
            } else {
                for (ACPMobileVisitorId *visitorId in visitorIDs) {
                    // visitorIdsString = [visitorIdsString stringByAppendingFormat:@"[Id: %@, Type: %@, Origin: %@, Authentication: %@] ", [visitorId identifier], [visitorId idType], [visitorId idOrigin], stateStrings[(unsigned long)[visitorId authenticationState]]];
                }
            }
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:visitorIdsString];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }];
}

- (void) getUrlVariables:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        [ACPIdentity getUrlVariables:^(NSString * _Nullable urlVariables) {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:urlVariables];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }];
}

- (void)handleTracking:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        if(!checkArgsWithTypes(command.arguments, @[@[STRING, STRING], @[STRING, STRING]])
           || ([command.arguments[0] isKindOfClass:STRING] && command.arguments[1] != (id)[NSNull null])
           || [command.arguments[1] isKindOfClass:STRING]) {
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
            return;
        }

        id firstArg = getArg(command.arguments[0]);
        id secondArg = getArg(command.arguments[1]);
        

        //allows the ADB.handleTracking() call
            // Send Click Tracking since the user did click on the notification
        [ACPCore collectMessageInfo:@{
                                       @"broadlogId" : secondArg,
                                       @"deliveryId": firstArg,
                                       @"action": @"2"
                                       }];
        // Send Open Tracking since the user opened the app
        [ACPCore collectMessageInfo:@{
                                       @"broadlogId" : secondArg,
                                       @"deliveryId": firstArg,
                                       @"action": @"1"
                                       }];

        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
    }];
}


//- (void)getVersion:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		CDVPluginResult* pluginResult = nil;
//
//		NSString *version = [ADBMobile version];
//
//		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:version];
//		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//	}];
//}
//
//- (void)getPrivacyStatus:(CDVInvokedUrlCommand*)command; {
//	[self.commandDelegate runInBackground:^{
//		CDVPluginResult* pluginResult = nil;
//
//		int privacyStatus = [ADBMobile privacyStatus];
//		switch (privacyStatus) {
//			case ADBMobilePrivacyStatusOptIn:
//				pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Opted In"];
//				break;
//			case ADBMobilePrivacyStatusOptOut:
//				pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Opted Out"];
//				break;
//			case ADBMobilePrivacyStatusUnknown:
//				pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Opt Unknown"];
//				break;
//			default:
//				pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT messageAsString:@"Privacy Status was an unknown value"];
//				break;
//		}
//
//		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//	}];
//}
//
//- (void)setPrivacyStatus:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		if(!checkArgsWithTypes(command.arguments, @[@[NUMBER]])) {
//			[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//			return;
//		}
//
//		NSString *privacyStatusString = getArg(command.arguments[0]);
//		int privacyStatus = [privacyStatusString intValue];
//		CDVPluginResult* pluginResult = nil;
//
//		if (privacyStatus >= 1 && privacyStatus <= 3) {
//			[ADBMobile setPrivacyStatus:privacyStatus];
//			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Set Opt Status"];
//		} else {
//			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Privacy Status was an unknown value"];
//		}
//
//		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//	}];
//}
//
//- (void)getLifetimeValue:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		double lifetimeValue = [[ADBMobile lifetimeValue] doubleValue];
//
//		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:lifetimeValue];
//		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//	}];
//}
//
//- (void)getUserIdentifier:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		NSString *userIdentifier = [ADBMobile userIdentifier];
//
//		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:userIdentifier];
//		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//	}];
//}
//
//- (void)setUserIdentifier:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		if(!checkArgsWithTypes(command.arguments, @[@[STRING]])) {
//			[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//			return;
//		}
//
//		NSString* userIdentifier = getArg(command.arguments[0]);
//		[ADBMobile setUserIdentifier:userIdentifier];
//
//		[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//	}];
//}

//- (void)setPushIdentifier:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		if(!checkArgsWithTypes(command.arguments, @[@[STRING]])) {
//			[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//			return;
//		}
//
//		NSString* pushIdStr = getArg(command.arguments[0]);
//		NSData* pushIdentifier = nil;
//
//		//hex NSString to NSData
//		if(pushIdStr != nil && [pushIdStr length]/2 == 32) {
//			char buffer[3];
//			buffer[2] = '\0';
//			char *bytes = malloc([pushIdStr length]/2);
//			char *bytes_ptr = bytes;
//			for (int i = 0; i < [pushIdStr length]; i += 2) {
//				buffer[0] = [pushIdStr characterAtIndex: i];
//				buffer[1] = [pushIdStr characterAtIndex: i+1];
//				char *b2 = NULL;
//				*bytes_ptr++ = strtol(buffer, &b2, 16);
//			}
//
//			pushIdentifier = [NSData dataWithBytesNoCopy:bytes length:[pushIdStr length]/2 freeWhenDone:YES];
//		}
//
//		[ADBMobile setPushIdentifier:pushIdentifier];
//
//		[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//	}];
//}
//
//- (void)trackPushMessageClickthrough:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		if(!checkArgsWithTypes(command.arguments, @[@[DICTIONARY]])) {
//			[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//			return;
//		}
//
//		NSDictionary * userInfo = getArg(command.arguments[0]);
//		[ADBMobile trackPushMessageClickThrough:userInfo];
//
//		[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//	}];
//}
//
//- (void)trackLocalNotificationClickThrough:(CDVInvokedUrlCommand*)command{
//    [self.commandDelegate runInBackground:^{
//        if(!checkArgsWithTypes(command.arguments, @[@[DICTIONARY]])) {
//            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//            return;
//        }
//
//        NSDictionary * userInfo = getArg(command.arguments[0]);
//        [ADBMobile trackLocalNotificationClickThrough:userInfo];
//
//        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//    }];
//}
//
//- (void)trackAdobeDeepLink:(CDVInvokedUrlCommand*)command{
//
//    [self.commandDelegate runInBackground:^{
//        if(!checkArgsWithTypes(command.arguments, @[@[STRING]])) {
//            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//            return;
//        }
//        NSString *urlString = getArg(command.arguments[0]);
//        NSURL *url = [NSURL URLWithString:urlString];
//        [ADBMobile trackAdobeDeepLink:url];
//
//        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//    }];
//}
//
//- (void)getDebugLogging:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		BOOL debugLogging = [ADBMobile debugLogging];
//
//		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:debugLogging];
//		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//	}];
//}
//
//- (void)setDebugLogging:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		if(!checkArgsWithTypes(command.arguments, @[@[STRING, NUMBER]])) {
//			[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//			return;
//		}
//
//		id debugLoggingString = getArg(command.arguments[0]);
//		[ADBMobile setDebugLogging:[debugLoggingString boolValue]];
//
//		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Set DebugLogging"];
//		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//	}];
//}
//
//- (void)keepLifecycleSessionAlive:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		[ADBMobile keepLifecycleSessionAlive];
//
//		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Keeping lifecycle session alive"];
//		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//	}];
//}
//
//- (void)collectLifecycleData:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//        [ADBMobile collectLifecycleData];
//		[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Collecting Lifecycle"] callbackId:command.callbackId];
//	}];
//}
//
//- (void)setAppGroup:(CDVInvokedUrlCommand*)command {
//    [self.commandDelegate runInBackground:^{
//        if(!checkArgsWithTypes(command.arguments, @[@[STRING]])) {
//            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//            return;
//        }
//        NSString* appGroup = getArg(command.arguments[0]);
//        [ADBMobile setAppGroup:appGroup];
//        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//    }];
//}
//
//- (void)syncSettings:(CDVInvokedUrlCommand*)command {
//    [self.commandDelegate runInBackground:^{
//        if(!checkArgsWithTypes(command.arguments, @[@[DICTIONARY]])) {
//            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//            return;
//        }
//        NSDictionary *settings = getArg(command.arguments[0]);
//        BOOL syncSettingsResult = [ADBMobile syncSettings:settings];
//
//        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:syncSettingsResult];
//        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//    }];
//}
//
//- (void)initializeWatch:(CDVInvokedUrlCommand*)command {
//    [self.commandDelegate runInBackground:^{
//        [ADBMobile initializeWatch];
//        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//    }];
//}
//
//- (void)collectPII:(CDVInvokedUrlCommand*)command{
//
//    [self.commandDelegate runInBackground:^{
//
//        if(!checkArgsWithTypes(command.arguments, @[@[DICTIONARY]])) {
//            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//            return;
//        }
//
//        NSDictionary *piiData = command.arguments[0];
//        //ToDo(Prerna): test for individual fields data type
//        [ADBMobile collectPII:piiData];
//        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Collecting Pii"];
//        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//    }];
//}
//
//- (void)trackState:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		if(!checkArgsWithTypes(command.arguments, @[@[STRING, DICTIONARY], @[STRING, DICTIONARY]])
//		   || ([command.arguments[0] isKindOfClass:DICTIONARY] && command.arguments[1] != (id)[NSNull null])
//		   || [command.arguments[1] isKindOfClass:STRING]) {
//			[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//			return;
//		}
//
//		id firstArg = getArg(command.arguments[0]);
//		id secondArg = getArg(command.arguments[1]);
//
//		//allows the ADB.trackState(cData) call
//		if([firstArg isKindOfClass:DICTIONARY]) {
//			[ADBMobile trackState:nil data:firstArg];
//		}
//		else {
//			[ADBMobile trackState:firstArg data:secondArg];
//		}
//
//		[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//	}];
//}
//

//
//- (void)trackActionFromBackground:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		if(!checkArgsWithTypes(command.arguments, @[@[STRING, DICTIONARY], @[STRING, DICTIONARY]])
//		   || ([command.arguments[0] isKindOfClass:DICTIONARY] && command.arguments[1] != (id)[NSNull null])
//		   || [command.arguments[1] isKindOfClass:STRING]) {
//			[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//			return;
//		}
//
//		id firstArg = getArg(command.arguments[0]);
//		id secondArg = getArg(command.arguments[1]);
//
//		//allows the ADB.trackActionFromBackground(cData) call
//		if([firstArg isKindOfClass:DICTIONARY]) {
//			[ADBMobile trackActionFromBackground:nil data:firstArg];
//		}
//		else {
//			[ADBMobile trackActionFromBackground:firstArg data:secondArg];
//		}
//
//		[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//	}];
//}
//
//- (void)trackLocation:(CDVInvokedUrlCommand *)command {
//	[self.commandDelegate runInBackground:^{
//		if(!checkArgsWithTypes(command.arguments, @[@[STRING, NUMBER], @[STRING, NUMBER], @[DICTIONARY]])) {
//			[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//			return;
//		}
//
//		double latitude = [getArg(command.arguments[0]) doubleValue];
//		double longitude = [getArg(command.arguments[1]) doubleValue];
//		NSDictionary *cData = getArg(command.arguments[2]);
//
//		CDVPluginResult* pluginResult = nil;
//
//		if(NSClassFromString(@"CLLocation")) {
//			id location = [[NSClassFromString(@"CLLocation") alloc] initWithLatitude: latitude longitude: longitude];
//			[ADBMobile trackLocation:location data:cData];
//
//			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//		} else {
//			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"CLLocation could not be found"];
//		}
//
//		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//	}];
//}
//
//- (void)trackBeacon:(CDVInvokedUrlCommand *)command {
//	[self.commandDelegate runInBackground:^{
//		CDVPluginResult* pluginResult = nil;
//		if(!NSClassFromString(@"CLLocation")) {
//			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"CLLocation could not be found"];
//			[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//			return;
//		}
//
//		if(!checkArgsWithTypes(command.arguments, @[@[STRING], @[STRING, NUMBER], @[STRING, NUMBER], @[NUMBER], @[DICTIONARY]])) {
//			[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//			return;
//		}
//
//		NSString* uuid = getArg(command.arguments[0]);
//		NSNumber* major = getArg(command.arguments[1]);
//		NSNumber* minor = getArg(command.arguments[2]);
//		NSNumber* proximity = getArg(command.arguments[3]);
//		NSDictionary* cData = getArg(command.arguments[4]);
//
//		ADBBeacon *beacon = [[ADBBeacon alloc] init];
//
//		NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
//		[formatter setNumberStyle:NSNumberFormatterNoStyle];
//
//		[beacon setProximityUUID:[[NSUUID alloc] initWithUUIDString:uuid]];
//		[beacon setProximity:(CLProximity)((NSNumber*)proximity).intValue];
//		[beacon setMajor: [major isKindOfClass: STRING] ? [formatter numberFromString:(NSString*)major] : major];
//		[beacon setMinor: [minor isKindOfClass: STRING] ? [formatter numberFromString:(NSString*)minor] : minor];
//
//		[ADBMobile trackBeacon:(CLBeacon *)beacon data:cData];
//
//		[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//	}];
//}
//
//- (void)trackingClearCurrentBeacon:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		[ADBMobile trackingClearCurrentBeacon];
//
//		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Current beacon cleared."];
//		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//	}];
//}
//
//- (void)trackLifetimeValueIncrease:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		if(!checkArgsWithTypes(command.arguments, @[@[STRING, NUMBER], @[DICTIONARY]])) {
//			[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//			return;
//		}
//
//		id amount = getArg(command.arguments[0]);
//		NSDictionary *cData = getArg(command.arguments[1]);
//
//		if ([amount isKindOfClass:[NSString class]]) {
//			amount = [NSDecimalNumber decimalNumberWithString:amount];
//		} else {
//			amount = [NSDecimalNumber decimalNumberWithDecimal:[amount decimalValue]];
//		}
//
//		[ADBMobile trackLifetimeValueIncrease:amount data:cData];
//
//		[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//	}];
//}
//
//- (void)trackTimedActionStart:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		if(!checkArgsWithTypes(command.arguments, @[@[STRING], @[DICTIONARY]])) {
//			[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//			return;
//		}
//
//		NSString* action = getArg(command.arguments[0]);
//		NSDictionary *cData = getArg(command.arguments[1]);
//
//		[ADBMobile trackTimedActionStart:action data:cData];
//
//		[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//	}];
//}
//
//- (void)trackTimedActionUpdate:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		if(!checkArgsWithTypes(command.arguments, @[@[STRING], @[DICTIONARY]])) {
//			[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//			return;
//		}
//
//		NSString* action = getArg(command.arguments[0]);
//		NSDictionary *cData = getArg(command.arguments[1]);
//
//		[ADBMobile trackTimedActionUpdate:action data:cData];
//
//		[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//	}];
//}
//
//- (void)trackingTimedActionExists:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		if(!checkArgsWithTypes(command.arguments, @[@[STRING]])) {
//			[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//			return;
//		}
//
//		NSString* action = getArg(command.arguments[0]);
//		BOOL exists = [ADBMobile trackingTimedActionExists:action];
//
//		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:exists];
//		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//	}];
//}
//
//- (void)trackTimedActionEnd:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		if(!checkArgsWithTypes(command.arguments, @[@[STRING]])) {
//			[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//			return;
//		}
//
//		NSString* action = getArg(command.arguments[0]);
//		[ADBMobile trackTimedActionEnd:action logic:nil];
//
//		[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//	}];
//}
//
//- (void)trackingIdentifier:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		NSString *trackingIdentifier = [ADBMobile trackingIdentifier];
//
//		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:trackingIdentifier];
//		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//	}];
//}
//
//- (void)trackingSendQueuedHits:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		[ADBMobile trackingSendQueuedHits];
//
//		[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//	}];
//}
//
//- (void)trackingClearQueue:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		[ADBMobile trackingClearQueue];
//
//		[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//	}];
//}
//
//- (void)trackingGetQueueSize:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		int size = (int)[ADBMobile trackingGetQueueSize];
//
//		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:size];
//		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//	}];
//}
//
//- (void)targetLoadRequestWithName:(CDVInvokedUrlCommand*)command {
//
//    [self.commandDelegate runInBackground:^{
//
//        if(!checkArgsWithTypes(command.arguments, @[@[STRING], @[STRING], @[DICTIONARY],  @[DICTIONARY],  @[DICTIONARY]])){
//            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//            return;
//        }
//
//        NSString* name = getArg(command.arguments[0]);
//        NSString* defaultContent = getArg(command.arguments[1]);
//        NSDictionary *profileParameters = getArg(command.arguments[2]);
//        NSDictionary *orderParameters = getArg(command.arguments[3]);
//        NSDictionary *mboxParameters = getArg(command.arguments[4]);
//
//        void (^callbackBlock)(NSString *content) = ^(NSString *content){
//            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:content];
//            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//        };
//
//        [ADBMobile targetLoadRequestWithName:name defaultContent:defaultContent profileParameters:profileParameters orderParameters:orderParameters mboxParameters:mboxParameters callback:callbackBlock];
//    }];
//}
//
//- (void)targetLoadRequestWithNameWithLocationParameters:(CDVInvokedUrlCommand*)command {
//
//    [self.commandDelegate runInBackground:^{
//
//        if(!checkArgsWithTypes(command.arguments, @[@[STRING], @[STRING], @[DICTIONARY],  @[DICTIONARY],  @[DICTIONARY], @[DICTIONARY]])){
//
//            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//            return;
//        }
//
//        NSString* name = getArg(command.arguments[0]);
//        NSString* defaultContent = getArg(command.arguments[1]);
//        NSDictionary *profileParameters = getArg(command.arguments[2]);
//        NSDictionary *orderParameters = getArg(command.arguments[3]);
//        NSDictionary *mboxParameters = getArg(command.arguments[4]);
//        NSDictionary *requestLocationParameters = getArg(command.arguments[5]);
//
//        void (^callbackBlock)(NSString *content) = ^(NSString *content){
//            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:content];
//            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//        };
//
//        [ADBMobile targetLoadRequestWithName:name defaultContent:defaultContent profileParameters:profileParameters orderParameters:orderParameters mboxParameters:mboxParameters requestLocationParameters:requestLocationParameters callback:callbackBlock];
//
//    }];
//}
//
//- (void)targetLoadRequest:(CDVInvokedUrlCommand*)command {
//
//    [self.commandDelegate runInBackground:^{
//
//        if(!checkArgsWithTypes(command.arguments, @[@[STRING], @[STRING], @[DICTIONARY]]) )
//        {
//            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//            return;
//        }
//
//        NSString* name = getArg(command.arguments[0]);
//        NSString* defaultContent = getArg(command.arguments[1]);
//        NSDictionary *parameters = getArg(command.arguments[2]);
//
//        void (^callbackBlock)(NSString *content) = ^(NSString *content){
//            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:content];
//            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//        };
//
//        ADBTargetLocationRequest *request = [ADBMobile targetCreateRequestWithName:name defaultContent:defaultContent parameters:parameters];
//        [ADBMobile targetLoadRequest:request callback:callbackBlock];
//	}];
//}
//
//- (void)targetLoadOrderConfirmRequest:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		if(!checkArgsWithTypes(command.arguments, @[@[STRING], @[STRING], @[STRING, NUMBER], @[STRING], @[DICTIONARY]])) {
//			[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//			return;
//		}
//
//		NSString* name = getArg(command.arguments[0]);
//		NSString* orderId = getArg(command.arguments[1]);
//		NSString* orderTotal = getArg(command.arguments[2]);
//		NSString* productPurchaseId = getArg(command.arguments[3]);
//		NSDictionary *parameters = getArg(command.arguments[4]);
//
//		ADBTargetLocationRequest *request = [ADBMobile targetCreateOrderConfirmRequestWithName:name orderId:orderId orderTotal:orderTotal productPurchasedId:productPurchaseId parameters:parameters];
//
//		[ADBMobile targetLoadRequest:request callback:^(NSString *content) {
//			CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:content];
//			[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//		}];
//	}];
//}
//
//- (void)targetClearCookies:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		[ADBMobile targetClearCookies];
//
//		[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//	}];
//}
//
//- (void)targetSessionID:(CDVInvokedUrlCommand*)command{
//
//    [self.commandDelegate runInBackground:^{
//        NSString *targetSessionId = [ADBMobile targetSessionID];
//        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:targetSessionId] callbackId:command.callbackId];
//    }];
//}
//
//- (void)targetPcID:(CDVInvokedUrlCommand*)command{
//
//    [self.commandDelegate runInBackground:^{
//        NSString *targetPcID = [ADBMobile targetPcID];
//        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:targetPcID] callbackId:command.callbackId];
//    }];
//}
//
//- (void)targetSetThirdPartyID:(CDVInvokedUrlCommand*)command{
//    [self.commandDelegate runInBackground:^{
//
//        if(!checkArgsWithTypes(command.arguments, @[@[STRING]])) {
//            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//            return;
//        }
//
//        NSString *thirdPartyID = command.arguments[0];
//        [ADBMobile targetSetThirdPartyID:thirdPartyID];
//        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//    }];
//}
//
//- (void)targetThirdPartyID:(CDVInvokedUrlCommand*)command{
//    [self.commandDelegate runInBackground:^{
//
//        NSString *thirdPartyID = [ADBMobile targetThirdPartyID];
//        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:thirdPartyID] callbackId:command.callbackId];
//    }];
//
//}
//
//- (void)acquisitionCampaignStartForApp:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		if(!checkArgsWithTypes(command.arguments, @[@[STRING], @[DICTIONARY]])) {
//			[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//			return;
//		}
//
//		NSString* appId = getArg(command.arguments[0]);
//		NSDictionary *data = getArg(command.arguments[1]);
//
//		[ADBMobile acquisitionCampaignStartForApp:appId data:data];
//
//		[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//	}];
//}
//
//- (void)audienceGetVisitorProfile:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		NSDictionary* visitorProfile = [ADBMobile audienceVisitorProfile];
//
//		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:visitorProfile];
//		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//	}];
//}
//
//- (void)audienceGetDpuuid:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		NSString* dpuuid = [ADBMobile audienceDpuuid];
//
//		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:dpuuid];
//		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//	}];
//}
//
//- (void)audienceGetDpid:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		NSString* dpid = [ADBMobile audienceDpid];
//
//		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:dpid];
//		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//	}];
//}
//
//- (void)audienceSetDpidAndDpuuid:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		if(!checkArgsWithTypes(command.arguments, @[@[STRING], @[STRING]])) {
//			[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//			return;
//		}
//
//		NSString* dpid = getArg(command.arguments[0]);
//		NSString* dpuuid = getArg(command.arguments[1]);
//
//		[ADBMobile audienceSetDpid:dpid dpuuid:dpuuid];
//
//		[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//	}];
//
//}
//
//- (void)audienceSignalWithData:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		if(!checkArgsWithTypes(command.arguments, @[@[DICTIONARY]])) {
//			[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//			return;
//		}
//
//		NSDictionary *data = getArg(command.arguments[0]);
//
//		[ADBMobile audienceSignalWithData:data callback:^(NSDictionary *response) {
//			CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:response];
//			[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//		}];
//	}];
//}
//
//- (void)audienceReset:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		[ADBMobile audienceReset];
//
//		[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
//	}];
//}
//
//- (void)visitorGetMarketingCloudId:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//		NSString* visitorMCID = [ADBMobile visitorMarketingCloudID];
//
//		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:visitorMCID];
//		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//	}];
//}
//
//- (void)visitorSyncIdentifierWithType:(CDVInvokedUrlCommand*)command {
//    [self.commandDelegate runInBackground:^{
//
//        if(!checkArgsWithTypes(command.arguments, @[@[STRING], @[STRING],@[NUMBER]]))
//        {
//            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//            return;
//        }
//
//        CDVPluginResult* pluginResult = nil;
//        NSString *identifierType = getArg(command.arguments[0]);
//        NSString *identifier = getArg(command.arguments[1]);
//        NSString *authStateString = getArg(command.arguments[2]);
//        int authState = [authStateString intValue];
//
//        if (authState >= 0 && authState <= 2)
//        {
//            [ADBMobile visitorSyncIdentifierWithType:identifierType identifier:identifier authenticationState:authState];
//            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"visitorSyncIdentifierWithType"];
//        }
//        else
//        {
//            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"AuthenticationState was an unknown value"];
//        }
//
//        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//
//    }];
//}
//
//
//- (void)visitorSyncIdentifiersWithAuthenticationState:(CDVInvokedUrlCommand*)command {
//
//    [self.commandDelegate runInBackground:^{
//
//        if(!checkArgsWithTypes(command.arguments, @[@[DICTIONARY], @[NUMBER]]))
//        {
//            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//            return;
//        }
//
//        CDVPluginResult* pluginResult = nil;
//
//        NSDictionary *firstArg = getArg(command.arguments[0]);
//        int authState = [getArg(command.arguments[1]) integerValue];
//
//        if (authState >= 0 && authState <= 2)
//        {
//            [ADBMobile visitorSyncIdentifiers:firstArg authenticationState:authState];
//            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"visitorSyncIdentifiers"];
//        }
//        else
//        {
//            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"AuthenticationState was an unknown value"];
//        }
//
//        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//    }];
//}
//
//- (void)visitorSyncIdentifiers:(CDVInvokedUrlCommand*)command {
//	[self.commandDelegate runInBackground:^{
//
//        if(!checkArgsWithTypes(command.arguments, @[@[DICTIONARY]]))
//        {
//            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//            return;
//        }
//
//        [ADBMobile visitorSyncIdentifiers:getArg(command.arguments[0])];
//        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"visitorSyncIdentifiers"] callbackId:command.callbackId];
//    }];
//}
//
//
//- (void)visitorAppendToURL: (CDVInvokedUrlCommand*)command{
//
//    [self.commandDelegate runInBackground:^{
//        if(!checkArgsWithTypes(command.arguments, @[@[STRING]])) {
//            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
//            return;
//        }
//
//        NSString *visitorUrlString = getArg(command.arguments[0]);
//        NSURL *visitorUrl = [NSURL URLWithString:visitorUrlString];
//        NSString *finalURLString = [[ADBMobile visitorAppendToURL:visitorUrl] absoluteString];
//        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:finalURLString] callbackId:command.callbackId];
//    }];
//}
//
//- (void)visitorGetIDs:(CDVInvokedUrlCommand*)command{
//    [self.commandDelegate runInBackground:^{
//        NSArray *visitorIdJSONArray = [self visitorGetIDsJs];
//        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:visitorIdJSONArray];
//        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//    }];
//}
//
///*
// * Helper functions
// */
//

//
//- (nullable NSArray *) visitorGetIDsJs{
//    NSArray* visitorIDs = [ADBMobile visitorGetIDs];
//    NSMutableArray* visitorIDsJSArray = [NSMutableArray array];
//    for(ADBVisitorID* visitorID in visitorIDs){
//        NSDictionary* dict = @{VisitorId_IdType: visitorID.idType?:@"", VisitorId_Id: visitorID.identifier?:@"", VisitorId_AuthenticationState: [NSNumber numberWithInt:visitorID.authenticationState]};
//        [visitorIDsJSArray addObject:dict];
//    }
//    return visitorIDsJSArray;
//}

static id getArg(id argument) { return argument == (id)[NSNull null] ? nil : argument; }

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
