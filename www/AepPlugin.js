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
var AEP = (function () {
	var AEP = (typeof exports !== 'undefined') && exports || {};

	AEP.doNothing = function () {};

	var PLUGIN_NAME = "AEPMobile_PhoneGap";

	AEP.optedIn		= 1;
	AEP.optedOut	= 2;
	AEP.optUnknown	= 3;

	AEP.beaconUnknown	= 0;
	AEP.beaconImmediate	= 1;
	AEP.beaconNear		= 2;
	AEP.beaconFar		= 3;

	AEP.mobileVisitorAuthenticationStateUnknown			= 0;
	AEP.mobileVisitorAuthenticationStateAuthenticated	= 1;
	AEP.mobileVisitorAuthenticationStateLoggedOut		= 2;
           
	AEP.visitorID_idType = "idType";
	AEP.visitorID_id = "id";
	AEP.visitorID_authenticationState = "authenticationState";

	AEP.initializeAppAdobe = function(action, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "initializeAppAdobe", [action]);
	};

	AEP.getVersion = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "getVersion", []);
	};

	AEP.getPrivacyStatus = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "getPrivacyStatus", []);
	};

	AEP.setPrivacyStatus = function (privacyStatus, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "setPrivacyStatus", [privacyStatus]);
	};

	AEP.getLifetimeValue = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "getLifetimeValue", []);
	};

	AEP.getUserIdentifier = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "getUserIdentifier", []);
	};

	AEP.setUserIdentifier = function (userIdentifier, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "setUserIdentifier", [userIdentifier]);
	};

	AEP.setPushIdentifier = function (pushIdentifier, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "setPushIdentifier", [pushIdentifier]);
	};

	AEP.getDebugLogging = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "getDebugLogging", []);
	};

	AEP.setDebugLogging = function(debugLogging, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "setDebugLogging", [debugLogging]);
	};

	AEP.keepLifecycleSessionAlive = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "keepLifecycleSessionAlive", []);
	};

	AEP.collectLifecycleData = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "collectLifecycleData", []);
	};

	AEP.collectPII = function(piiData, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "collectPII", [piiData]);
	}

	AEP.trackState = function(stateName, cData, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "trackState", [stateName, cData]);
	};

	AEP.trackAction = function(action, cData, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "trackAction", [action, cData]);
	};

	AEP.trackActionFromBackground = function(action, cData, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "trackActionFromBackground", [action, cData]);
	};

	AEP.trackLocation = function(lat, long, cData, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "trackLocation", [lat, long, cData]);
	};

	AEP.trackBeacon = function(uuid, major, minor, proximity, cData, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "trackBeacon", [uuid, major, minor, proximity, cData]);
	};

	AEP.clearCurrentBeacon = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "trackingClearCurrentBeacon", []);
	};

	AEP.trackAdobeDeepLink = function(deeplinkURL, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "trackAdobeDeepLink", [deeplinkURL]);
	}
	
	AEP.trackLifetimeValueIncrease = function(amount, cData, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "trackLifetimeValueIncrease", [amount, cData]);
	};

	AEP.trackTimedActionStart = function(action, cData, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "trackTimedActionStart", [action, cData]);
	};

	AEP.trackTimedActionUpdate = function(action, cData, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "trackTimedActionUpdate", [action, cData]);
	};

	AEP.trackTimedActionEnd = function(action, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "trackTimedActionEnd", [action]);
	};

	AEP.trackingTimedActionExists = function(success, fail, action) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "trackingTimedActionExists", [action]);
	};

	AEP.trackingIdentifier = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "trackingIdentifier", []);
	};

	AEP.trackingSendQueuedHits = function() {
		return cordova.exec(AEP.doNothing, AEP.doNothing, "AEPMobile_PhoneGap", "trackingSendQueuedHits", []);
	};

	AEP.trackingClearQueue = function() {
		return cordova.exec(AEP.doNothing, AEP.doNothing, "AEPMobile_PhoneGap", "trackingClearQueue", []);
	};

	AEP.trackingGetQueueSize = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "trackingGetQueueSize", []);
	};

	AEP.targetLoadRequest = function(success, fail, name, defaultContent, parameters) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "targetLoadRequest", [name, defaultContent, parameters]);
	};

	AEP.targetLoadRequestWithName = function(success, fail, name, defaultContent, profileParameters, orderParameters, mboxParameters) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "targetLoadRequestWithName", [name, defaultContent, profileParameters, orderParameters, mboxParameters]);
	}

	AEP.targetLoadRequestWithNameWithLocationParameters = function(success, fail, name, defaultContent, profileParameters, orderParameters, mboxParameters, requestLocationParameters) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "targetLoadRequestWithNameWithLocationParameters", [name, defaultContent, profileParameters, orderParameters, mboxParameters, requestLocationParameters]);
	}

	AEP.targetSessionID = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "targetSessionID", []);
	}

	AEP.targetPcID = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "targetPcID", []);
	}

	AEP.targetSetThirdPartyID = function(thirdPartyID, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "targetSetThirdPartyID", [thirdPartyID]);
	}

	AEP.targetThirdPartyID = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "targetThirdPartyID", []);
	}

	AEP.targetLoadOrderConfirmRequest = function(success, fail, name, orderId, orderTotal, productPurchaseId, parameters) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "targetLoadOrderConfirmRequest", [name, orderId, orderTotal, productPurchaseId, parameters]);
	};

	AEP.targetClearCookies = function() {	
		return cordova.exec(AEP.doNothing, AEP.doNothing, "AEPMobile_PhoneGap", "targetClearCookies", []);
	};

	AEP.acquisitionCampaignStartForApp = function(appId, data, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "acquisitionCampaignStartForApp", [appId, data]);
	};

	AEP.audienceGetVisitorProfile = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "audienceGetVisitorProfile", []);
	};

	AEP.audienceGetDpuuid = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "audienceGetDpuuid", []);
	};

	AEP.audienceGetDpid = function(success, fail) {	
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "audienceGetDpid", []);
	};

	AEP.audienceSetDpidAndDpuuid = function(dpid, dpuuid, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "audienceSetDpidAndDpuuid", [dpid, dpuuid]);
	};	

	AEP.audienceSignalWithData = function(success, fail, data) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "audienceSignalWithData", [data]);
	};	

	AEP.audienceReset = function() {	
		return cordova.exec(AEP.doNothing, AEP.doNothing, "AEPMobile_PhoneGap", "audienceReset", []);
	};

	AEP.visitorAppendToURL = function(urlToAppend, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "visitorAppendToURL", [urlToAppend]);
	}

	AEP.visitorGetMarketingCloudId = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "visitorGetMarketingCloudId", []);
	};	

	AEP.visitorSyncIdentifiers = function(identifiers, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "visitorSyncIdentifiers", [identifiers]);
	};

	AEP.visitorSyncIdentifierWithType = function(identifierType, identifier, authenticationState, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "visitorSyncIdentifierWithType", [identifierType, identifier, authenticationState]);
	}

	AEP.visitorSyncIdentifiersWithAuthenticationState = function(identifiers, authenticationState, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "visitorSyncIdentifiersWithAuthenticationState", [identifiers, authenticationState]);
	}
          
	AEP.visitorGetIDs = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "visitorGetIDs", []);
	}

	/*
	*	iOS methods
	*/
	AEP.trackPushMessageClickthrough = function(userInfo, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "trackPushMessageClickthrough", [userInfo]);
	};
	
	AEP.setAppGroup = function(appGroup, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "setAppGroup", [appGroup]);
	};

	AEP.syncSettings = function(settings, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "syncSettings", [settings]);
	};

	AEP.initializeWatch = function() {
		return cordova.exec(AEP.doNothing, AEP.doNothing, "AEPMobile_PhoneGap", "initializeWatch", []);
	};

	AEP.trackLocalNotificationClickThrough = function(userInfo, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "trackLocalNotificationClickThrough", [userInfo]);
	}

	AEP.extensionVersionPlaces = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "extensionVersionPlaces", []);
	}

	AEP.getCurrentPointsOfInterest = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "getCurrentPointsOfInterest", []);
	}

	AEP.getLastKnownLocation = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "getLastKnownLocation", []);
	}

	AEP.getNearbyPointsOfInterest = function(location, limit, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "getNearbyPointsOfInterest", [location, limit]);
	}

	AEP.processGeofence = function(geofence, transitionType, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "getNearbyPointsOfInterest", [geofence, transitionType]);
	}

	AEP.setAuthorizationStatus = function(status, success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "getNearbyPointsOfInterest", [status]);
	}

	AEP.extensionVersionMonitor = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "extensionVersionMonitor", []);
	}

	AEP.start = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "start", []);
	}
	AEP.stop = function(shouldClearData,success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "stop", [shouldClearData]);
	}

	AEP.updateLocation = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "updateLocation", []);
	}
	AEP.extensionVersion = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "extensionVersion", []);
	}
	AEP.extensionVersion = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "extensionVersion", []);
	}
	AEP.getSdkIdentities = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "getSdkIdentities", []);
	}
	AEP.getIdentifiers = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "getIdentifiers", []);
	}
	AEP.getUrlVariables = function(success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "getUrlVariables", []);
	}
	AEP.handleTracking = function(action,action1,success, fail) {
		return cordova.exec(success, fail, "AEPMobile_PhoneGap", "handleTracking", [action,action1]);
	}


	return AEP;
}());

module.exports = AEP;
