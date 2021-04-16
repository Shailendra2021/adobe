package com.aep;

import android.location.Location;
import org.apache.cordova.LOG;
import com.adobe.marketing.mobile.AdobeCallback;
import com.adobe.marketing.mobile.Analytics;
import com.adobe.marketing.mobile.Campaign;
import com.adobe.marketing.mobile.Identity;
import com.adobe.marketing.mobile.InvalidInitException;
import com.adobe.marketing.mobile.Lifecycle;
import com.adobe.marketing.mobile.LoggingMode;
import com.adobe.marketing.mobile.MobileCore;
import com.adobe.marketing.mobile.Places;
import com.adobe.marketing.mobile.PlacesMonitor;
import com.adobe.marketing.mobile.PlacesPOI;
import com.adobe.marketing.mobile.Signal;
import com.adobe.marketing.mobile.Target;
import com.adobe.marketing.mobile.TargetParameters;
import com.adobe.marketing.mobile.TargetRequest;
import com.adobe.marketing.mobile.PlacesAuthorizationStatus;
import com.adobe.marketing.mobile.PlacesRequestError;
import com.adobe.marketing.mobile.VisitorID;
import java.util.List;
import java.util.Iterator;
import java.util.HashMap;
import com.google.android.gms.location.Geofence;
import com.adobe.marketing.mobile.UserProfile;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

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

public class AEPMobile_PhoneGap extends CordovaPlugin {

    // =====================
    // public Method - all calls filter through this
    // =====================

    String applicationCode = "0b11157d649c/a5066337cdf1/launch-50f50af43544-development";
    final static String METHOD_PLACESMONITOR_EXTENSION_VERSION_PLACESMONITOR = "extensionVersionMonitor";
    final static String METHOD_PLACESMONITOR_START = "start";
    final static String METHOD_PLACESMONITOR_STOP = "stop";
    final static String METHOD_PLACESMONITOR_UPDATE_LOCATION = "updateLocation";
    final static String METHOD_PLACESMONITOR_SET_PLACES_MONITOR_MODE = "setPlacesMonitorMode";
    final static String METHOD_PLACES_CLEAR = "clear";
    final static String METHOD_PLACES_EXTENSION_VERSION_PLACES = "extensionVersionPlaces";
    final static String METHOD_PLACES_GET_CURRENT_POINTS_OF_INTEREST = "getCurrentPointsOfInterest";
    final static String METHOD_PLACES_GET_LAST_KNOWN_LOCATION = "getLastKnownLocation";
    final static String METHOD_PLACES_GET_NEARBY_POINTS_OF_INTEREST = "getNearbyPointsOfInterest";
    final static String METHOD_PLACES_PROCESS_GEOFENCE = "processGeofence";
    final static String METHOD_PLACES_SET_AUTHORIZATION_STATUS = "setAuthorizationStatus";

    final static String LOG_TAG = "ACPPlaces_Cordova";

    final static String POI = "POI";
    final static String LATITUDE = "Latitude";
    final static String LONGITUDE = "Longitude";
    final static String LOWERCASE_LATITUDE = "latitude";
    final static String LOWERCASE_LONGITUDE = "longitude";
    final static String IDENTIFIER = "Identifier";
    final static String RADIUS = "radius";
    final static String REQUEST_ID = "requestId";
    final static String CIRCULAR_REGION = "circularRegion";
    final static String EXPIRATION_DURATION = "expirationDuration";
    final static String PROVIDER = "cordova-plugin-geolocation";
    final static String METHOD_CORE_GET_SDK_IDENTITIES = "getSdkIdentities";
    final static String METHOD_CORE_EXTENSION_VERSION_CORE = "extensionVersion";
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        //Config.setContext(cordova.getActivity());
        if (action.equals("getVersion")) {
          //  this.getVersion(callbackContext);
            return true;
        } else if (action.equals("getPrivacyStatus")) {
         //   this.getPrivacyStatus(callbackContext);
            return true;
        } else if (action.equals("setPrivacyStatus")) {
          //  this.setPrivacyStatus(args, callbackContext);
            return true;
        } else if (action.equals("getLifetimeValue")) {
         //   this.getLifetimeValue(callbackContext);
            return true;
        } else if (action.equals("getUserIdentifier")) {
           // this.getUserIdentifier(callbackContext);
            return true;
        } else if (action.equals("setUserIdentifier")) {
          //  this.setUserIdentifier(args, callbackContext);
            return true;
        } else if (action.equals("setPushIdentifier")) {
            this.setPushIdentifier(args, callbackContext);
            return true;
        } else if (action.equals("getDebugLogging")) {
           // this.getDebugLogging(callbackContext);
            return true;
        } else if (action.equals("setDebugLogging")) {
         //   this.setDebugLogging(args, callbackContext);
            return true;
        } else if (action.equals("trackState")) {
            this.trackState(args, callbackContext);
            return true;
        } else if (action.equals("trackAction")) {
            this.trackAction(args, callbackContext);
            return true;
        } else if (action.equals("trackLocation")) {
           // this.trackLocation(args, callbackContext);
            return true;
        } else if (action.equals("trackBeacon")) {
         //   this.trackBeacon(args, callbackContext);
            return true;
        } else if (action.equals("trackingClearCurrentBeacon")) {
          //  this.trackingClearCurrentBeacon(callbackContext);
            return true;
        } else if (action.equals("trackLifetimeValueIncrease")) {
         //   this.trackLifetimeValueIncrease(args, callbackContext);
            return true;
        } else if (action.equals("trackTimedActionStart")) {
        //    this.trackTimedActionStart(args, callbackContext);
            return true;
        } else if (action.equals("trackTimedActionUpdate")) {
        //    this.trackTimedActionUpdate(args, callbackContext);
            return true;
        } else if (action.equals("trackTimedActionEnd")) {
         //   this.trackTimedActionEnd(args, callbackContext);
            return true;
        } else if (action.equals("trackingTimedActionExists")) {
        //    this.trackingTimedActionExists(args, callbackContext);
            return true;
        } else if (action.equals("trackingIdentifier")) {
        //    this.trackingIdentifier(callbackContext);
            return true;
        } else if (action.equals("trackingClearQueue")) {
         //   this.trackingClearQueue(callbackContext);
            return true;
        } else if (action.equals("trackingGetQueueSize")) {
          //  this.trackingGetQueueSize(callbackContext);
            return true;
        } else if (action.equals("trackingSendQueuedHits")) {
          //  this.trackingSendQueuedHits(callbackContext);
            return true;
        } else if (action.equals("targetLoadRequest")) {
            this.targetLoadRequest(args, callbackContext);
            return true;
        } else if (action.equals("targetLoadRequestWithName")){
          //  this.targetLoadRequestWithName(args, callbackContext);
            return true;
        } else if (action.equals("targetLoadRequestWithNameWithLocationParameters")){
          //  this.targetLoadRequestWithNameWithLocationParameters(args, callbackContext);
            return true;
        } else if (action.equals("targetLoadOrderConfirmRequest")) {
          //  this.targetLoadOrderConfirmRequest(args, callbackContext);
            return true;
        } else if (action.equals("targetClearCookies")) {
          //  this.targetClearCookies(callbackContext);
            return true;
        } else if (action.equals("targetSessionID")) {
          //  this.targetSessionID(args, callbackContext);
            return true;
        } else if (action.equals("targetPcID")) {
          //  this.targetPcID(args, callbackContext);
            return true;
        } else if (action.equals("targetSetThirdPartyID")) {
          //  this.targetSetThirdPartyID(args, callbackContext);
            return true;
        } else if (action.equals("targetThirdPartyID")) {
         //   this.targetGetThirdPartyID(args, callbackContext);
            return true;
        } else if (action.equals("acquisitionCampaignStartForApp")) {
          //  this.acquisitionCampaignStartForApp(args, callbackContext);
            return true;
        } else if (action.equals("audienceGetVisitorProfile")) {
          //  this.audienceGetVisitorProfile(callbackContext);
            return true;
        } else if (action.equals("audienceGetDpuuid")) {
          //  this.audienceGetDpuuid(callbackContext);
            return true;
        } else if (action.equals("audienceGetDpid")) {
          //  this.audienceGetDpid(callbackContext);
            return true;
        } else if (action.equals("audienceSetDpidAndDpuuid")) {
         //   this.audienceSetDpidAndDpuuid(args, callbackContext);
            return true;
        } else if (action.equals("audienceSignalWithData")) {
         //   this.audienceSignalWithData(args, callbackContext);
            return true;
        } else if (action.equals("audienceReset")) {
         //   this.audienceReset(callbackContext);
            return true;
        } else if (action.equals("visitorGetMarketingCloudId")) {
          //  this.visitorGetMarketingCloudId(callbackContext);
            return true;
        } else if (action.equals("visitorSyncIdentifierWithType")) {
         //   this.visitorSyncIdentifierWithType(args, callbackContext);
            return true;
        } else if (action.equals("visitorSyncIdentifiers")) {
         //   this.visitorSyncIdentifiers(args, callbackContext);
            return true;
        } else if (action.equals("visitorSyncIdentifiersWithAuthenticationState")){
         //   this.visitorSyncIdentifiersWithAuthenticationState(args, callbackContext);
            return true;
        } else if (action.equals("visitorGetIDs")) {
        //    this.visitorGetIDs(args, callbackContext);
            return true;
        } else if (action.equals("visitorAppendToURL")) {
         //   this.visitorAppendToURL(args, callbackContext);
            return true;
        } else if (action.equals("collectPII")) {
            this.collectPII(args,callbackContext);
            return true;
        }else if (action.equals("initializeAppAdobe")) {
          //     this.initializeAppAdobe(args,callbackContext);
            return true;
        }else if (METHOD_PLACESMONITOR_SET_PLACES_MONITOR_MODE.equals(action)) {
            setPlacesMonitorMode(callbackContext);
            return true;
        }else if (METHOD_PLACESMONITOR_EXTENSION_VERSION_PLACESMONITOR.equals(action)) {
            extensionVersionMonitor(callbackContext);
            return true;
        } else if (METHOD_PLACESMONITOR_START.equals(action)) {
            start(callbackContext);
            return true;
        } else if (METHOD_PLACESMONITOR_STOP.equals(action)) {
            stop(args, callbackContext);
            return true;
        }else if (METHOD_PLACESMONITOR_UPDATE_LOCATION.equals(action)) {
            updateLocation(callbackContext);
            return true;
        }else if (METHOD_PLACES_CLEAR.equals(action)) {
            clear(callbackContext);
            return true;
        } else if (METHOD_PLACES_EXTENSION_VERSION_PLACES.equals((action))) {
            extensionVersionPlaces(callbackContext);
            return true;
        } else if (METHOD_PLACES_GET_CURRENT_POINTS_OF_INTEREST.equals((action))) {
            getCurrentPointsOfInterest(callbackContext);
            return true;
        }else if (METHOD_PLACES_GET_LAST_KNOWN_LOCATION.equals((action))) {
            getLastKnownLocation(callbackContext);
            return true;
        } else if (METHOD_PLACES_GET_NEARBY_POINTS_OF_INTEREST.equals((action))) {
            getNearbyPointsOfInterest(args, callbackContext);
            return true;
        } else if (METHOD_PLACES_PROCESS_GEOFENCE.equals((action))) {
            processGeofence(args, callbackContext);
            return true;
        }else if (METHOD_PLACES_SET_AUTHORIZATION_STATUS.equals((action))) {
            setAuthorizationStatus(args, callbackContext);
            return true;
        }else if (METHOD_CORE_GET_SDK_IDENTITIES.equals((action))) {
            getSdkIdentities(callbackContext);
            return true;
        }else if (METHOD_CORE_EXTENSION_VERSION_CORE.equals((action))) {
            extensionVersion(callbackContext);
            return true;
        }else if (action.equals("getUrlVariables")) {
            getUrlVariables(callbackContext);
            return true;
        }else if (action.equals("handleTracking")) {
            handleTracking(args,callbackContext);
            return true;
        } else if (action.equals("getIdentifiers")) {
            getIdentifiers(callbackContext);
            return true;
        } else if (action.equals("trackAdobeDeepLink")){
        //    this.trackAdobeDeepLink(args,callbackContext);
            return true;
        }

        return false;
    }

   


    private void trackState(final JSONArray args, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                String state = null;
                HashMap<String, String> cData = null;

                try {
                    if (!args.get(0).equals(null) && args.get(0).getClass() == String.class) {
                        state = args.getString(0);
                    } else if (!args.get(0).equals(null)) {
                        
                    }
                    if (!args.get(1).equals(null)) {
                        JSONObject cDataJSON = args.getJSONObject(1);
                        if (!cDataJSON.equals(null) && cDataJSON.length() > 0) {
                            cData = GetHashMapFromJSON(cDataJSON);
                        }
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                    callbackContext.error(e.getMessage());
                    return;
                }
                if (state != null && cData != null) {
                    MobileCore.trackState(state, cData);
                    callbackContext.success();
                } else {
                    callbackContext.error("Parameter not sent in correct format");
                }
               
            }
        });
    }


        private void trackAction(final JSONArray args, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                String action = null;
                HashMap<String, String> cData = null;

                try {
                    // set appState if passed in
                    if (!args.get(0).equals(null) && args.get(0).getClass() == String.class) {
                        action = args.getString(0);
                    } else if (!args.get(0).equals(null)) {
                        // else set cData if it is passed in alone
                        JSONObject cDataJSON = args.getJSONObject(0);
                        if (!cDataJSON.equals(null) && cDataJSON.length() > 0) {
                            cData = GetHashMapFromJSON(cDataJSON);
                        }
                    }
                    // set cData if it is passed in along with action
                    if (!args.get(1).equals(null)) {
                        JSONObject cDataJSON = args.getJSONObject(1);
                        if (!cDataJSON.equals(null) && cDataJSON.length() > 0) {
                            cData = GetHashMapFromJSON(cDataJSON);
                        }
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                    callbackContext.error(e.getMessage());
                    return;
                }

                MobileCore.trackAction(action, cData);
                callbackContext.success();
            }
        });
    }


        private void setPushIdentifier(JSONArray args, final CallbackContext callbackContext) throws JSONException {
        final String pushIdentifier = args.getString(0);

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                MobileCore.setPushIdentifier(pushIdentifier);
                callbackContext.success();
            }
        });
    }



        private void collectPII(final JSONArray args, final CallbackContext callbackContext) throws JSONException {

        cordova.getThreadPool().execute((new Runnable() {
            @Override
            public void run() {
                HashMap<String, String> piiData = null;

                try {
                    if (!args.get(0).equals(null)) {
                        JSONObject piiDataJSON = args.getJSONObject(0);
                        if (!piiDataJSON.equals(null) && piiDataJSON.length() > 0) {
                            piiData = GetHashMapFromJSON(piiDataJSON);
                        }
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                    callbackContext.error(e.getMessage());
                    return;
                }

                MobileCore.collectPii(piiData);
                callbackContext.success();
            }
        }));

    }
    
    
    


      private void targetLoadRequest(final JSONArray args, final CallbackContext callbackContext) throws JSONException {

            String Mbox = args.getString(0);
            cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                
                Map<String, String> mboxParameters1 = new HashMap<>();

                TargetParameters parameters1 = new TargetParameters.Builder().parameters(mboxParameters1).build();
                TargetRequest request1 = new TargetRequest(Mbox, parameters1, "defaultContent1",

                        new AdobeCallback<String>() {

                            @Override

                            public void call(String value) {

                                // do something with target content.

                                callbackContext.success(value);

                            }

                        });

                List<TargetRequest> locationRequests = new ArrayList<>();

                locationRequests.add(request1);

                Target.retrieveLocationContent(locationRequests, parameters1);

            }
        });

    }

    private void extensionVersionMonitor(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                String extensionVersion = PlacesMonitor.extensionVersion();
                if (extensionVersion.length() > 0) {
                    callbackContext.success(extensionVersion);
                } else {
                    callbackContext.error("Extension version is null or empty");
                }
            }
        });
    }

    private void start(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                PlacesMonitor.start();
                callbackContext.success();
            }
        });
    }

    private void stop(final JSONArray args, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                PlacesMonitor.stop(true);
                callbackContext.success();
            }
        });
    }

    private void getUrlVariables(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                Identity.getUrlVariables(new AdobeCallback<String>() {
                    @Override
                    public void call(String urlVariables) {
                        callbackContext.success(urlVariables);
                    }
                });
            }
        });
    }

    private void getIdentifiers(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                Identity.getIdentifiers(new AdobeCallback<List<VisitorID>>() {
                    @Override
                    public void call(List<VisitorID> ids) {
                        String visitorIdsString = "";
                        if (ids.isEmpty()) {
                            visitorIdsString = "[]";
                        } else {
                            for (VisitorID id: ids) {
                                visitorIdsString = visitorIdsString.concat(String.format("[Id: %s, Type: %s, Origin: %s, Authentication: %s] ", id.getId(), id.getIdType(), id.getIdOrigin(), id.getAuthenticationState().toString()));
                            }
                        }
                        callbackContext.success(visitorIdsString);
                    }
                });
            }
        });
    }


    private void extensionVersion(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                final String version = MobileCore.extensionVersion();
                callbackContext.success(version);
            }
        });
    }


    private void getSdkIdentities(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                MobileCore.getSdkIdentities(new AdobeCallback<String>() {
                    @Override
                    public void call(String s) {
                        callbackContext.success(s);
                    }
                });
            }
        });
    }



    private void updateLocation(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                PlacesMonitor.updateLocation();
                callbackContext.success();
            }
        });
    }







    private void clear(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                Places.clear();
                callbackContext.success();
            }
        });
    }

    private void extensionVersionPlaces(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                String extensionVersion = Places.extensionVersion();
                if (extensionVersion.length() > 0) {
                    callbackContext.success(extensionVersion);
                } else {
                    callbackContext.error("Extension version is null or empty");
                }
            }
        });
    }

    private void getCurrentPointsOfInterest(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                Places.getCurrentPointsOfInterest(new AdobeCallback<List<PlacesPOI>>() {
                    @Override
                    public void call(List<PlacesPOI> pois) {
                        callbackContext.success(generatePOIString(pois));
                    }
                });
            }
        });
    }

    private void getLastKnownLocation(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                Places.getLastKnownLocation(new AdobeCallback<Location>() {
                    @Override
                    public void call(Location location) {
                        if(location != null) {
                            JSONObject json = new JSONObject();;
                            try {
                                json.put(LATITUDE, location.getLatitude());
                                json.put(LONGITUDE, location.getLongitude());
                            } catch (JSONException e){
                                LOG.d(LOG_TAG, "Error putting data into JSON: " + e.getLocalizedMessage());
                            }
                            callbackContext.success(json.toString());
                        } else {
                            callbackContext.error("Error retrieving last known location.");
                        }
                    }
                });
            }
        });
    }

    private void getNearbyPointsOfInterest(final JSONArray args, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                if (args == null || args.length() != 2) {
                    callbackContext.error("Invalid argument count, expected 2 (location and limit).");
                    return;
                }
                Location location = new Location(PROVIDER);
                HashMap<String, String> locationMap;
                int limit;
                try {
                    locationMap = getStringMapFromJSON(args.getJSONObject(0));
                    limit = args.getInt(1);
                } catch (JSONException e) {
                    callbackContext.error("Error while parsing arguments, Error " + e.getLocalizedMessage());
                    return;
                }

                location.setLatitude(Double.parseDouble(locationMap.get(LOWERCASE_LATITUDE)));
                location.setLongitude(Double.parseDouble(locationMap.get(LOWERCASE_LONGITUDE)));
                Places.getNearbyPointsOfInterest(location, limit, new AdobeCallback<List<PlacesPOI>>() {
                    @Override
                    public void call(List<PlacesPOI> pois) {
                        callbackContext.success(generatePOIString(pois));
                    }
                }, new AdobeCallback<PlacesRequestError>() {
                    @Override
                    public void call(PlacesRequestError placesRequestError) {
                        callbackContext.error(placesRequestError.toString());
                    }
                });
            }
        });
    }

    private void processGeofence(final JSONArray args, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                if (args == null || args.length() != 2) {
                    callbackContext.error("Invalid argument count, expected 2 (geofence, transition type).");
                    return;
                }
                int transitionType;
                HashMap<String, Object> geofenceMap;
                try {
                    geofenceMap = getObjectMapFromJSON(args.getJSONObject(0));
                    transitionType = args.getInt(1);
                } catch (JSONException e) {
                    callbackContext.error("Error while parsing argument, Error " + e.getLocalizedMessage());
                    return;
                }
                String requestId = (String)geofenceMap.get(REQUEST_ID);
                HashMap<String, String> circularRegion = getCircularRegionData((String)geofenceMap.get(CIRCULAR_REGION));
                if(circularRegion == null) {
                    callbackContext.error("Unable to get circular region data");
                    return;
                }
                double latitude = Double.parseDouble(circularRegion.get(LOWERCASE_LATITUDE));
                double longitude = Double.parseDouble(circularRegion.get(LOWERCASE_LONGITUDE));
                float radius = Float.parseFloat(circularRegion.get(RADIUS));
                long expirationDuration = Long.parseLong((String)geofenceMap.get(EXPIRATION_DURATION));
                final Geofence geofence = new Geofence.Builder()
                        .setCircularRegion(latitude, longitude, radius)
                        .setExpirationDuration(expirationDuration)
                        .setTransitionTypes(transitionType)
                        .setRequestId(requestId)
                        .build();
                Places.processGeofence(geofence, transitionType);
                callbackContext.success();
            }
        });
    }

    private void setAuthorizationStatus(final JSONArray args, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                if (args == null || args.length() != 1) {
                    callbackContext.error("Invalid argument count, expected 1 (status).");
                    return;
                }
                PlacesAuthorizationStatus status;
                try {
                    status = getAuthorizationStatus(args.getInt(0));
                } catch (JSONException e) {
                    callbackContext.error("Error while parsing argument, Error " + e.getLocalizedMessage());
                    return;
                }

                Places.setAuthorizationStatus(status);
                callbackContext.success();
            }
        });
    }



    private void setPlacesMonitorMode(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                // TODO: this method is not implemented in Android
                callbackContext.success();
            }
        });
    }


    // =====================
    // Helpers
    // =====================
    private HashMap<String, String> GetHashMapFromJSON(JSONObject data) {
        HashMap<String, String> map = new HashMap<String, String>();
        @SuppressWarnings("rawtypes")
        Iterator it = data.keys();
        while (it.hasNext()) {
            String n = (String) it.next();
            try {
                map.put(n, data.getString(n));
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        HashMap<String, String> table = new HashMap<String, String>();
        table.putAll(map);
        return table;
    }


    private HashMap<String, String> getStringMapFromJSON(JSONObject data) {
        HashMap<String, String> map = new HashMap<String, String>();
        @SuppressWarnings("rawtypes")
        Iterator it = data.keys();
        while (it.hasNext()) {
            String n = (String) it.next();
            try {
                map.put(n, data.getString(n));
            } catch (JSONException e) {
                LOG.e(LOG_TAG, "JSON error: " + e.getLocalizedMessage());
            }
        }

        return map;
    }

    private HashMap<String, Object> getObjectMapFromJSON(JSONObject data) {
        HashMap<String, Object> map = new HashMap<String, Object>();
        @SuppressWarnings("rawtypes")
        Iterator it = data.keys();
        while (it.hasNext()) {
            String n = (String) it.next();
            try {
                map.put(n, data.getString(n));
            } catch (JSONException e) {
                LOG.d(LOG_TAG, "JSON error: " + e.getLocalizedMessage());
            }
        }

        return map;
    }

    private PlacesAuthorizationStatus getAuthorizationStatus(final int status){
        if(status == 0) {
            return  PlacesAuthorizationStatus.DENIED;
        } else if(status == 1) {
            return PlacesAuthorizationStatus.ALWAYS;
        } else if(status == 2) {
            return PlacesAuthorizationStatus.UNKNOWN;
        } else if(status == 3) {
            return PlacesAuthorizationStatus.RESTRICTED;
        } else if(status == 4) {
            return PlacesAuthorizationStatus.WHEN_IN_USE;
        } else {
            return null;
        }
    }

    private HashMap<String, String> getCircularRegionData(final String regionData) {
        JSONObject json = null;

        try {
            json = new JSONObject(regionData);
            HashMap<String, String> regionDataMap = new HashMap<>();
            @SuppressWarnings("unchecked")
            Iterator<String> it = json.keys();
            while(it.hasNext()) {
                String name = it.next();
                regionDataMap.put(name, json.getString(name));
            }
            return regionDataMap;
        } catch (JSONException e) {
            LOG.e(LOG_TAG, "Error converting regionData string to Map: " + e.getLocalizedMessage());
            return null;
        }

    }

    private String generatePOIString(final List<PlacesPOI> pois) {
        JSONArray jsonArray = new JSONArray();
        JSONObject json;
        if (!pois.isEmpty()) {
            for (int index = 0; index < pois.size(); index++) {
                try {
                    PlacesPOI poi = pois.get(index);
                    json = new JSONObject();
                    json.put(POI, poi.getName());
                    json.put(LATITUDE, poi.getLatitude());
                    json.put(LONGITUDE, poi.getLongitude());
                    json.put(IDENTIFIER, poi.getIdentifier());
                    jsonArray.put(index, json);
                } catch (JSONException e) {
                    LOG.d(LOG_TAG, "Error putting data into JSON: " + e.getLocalizedMessage());
                }
            }
        }
        return jsonArray.toString();
    }



    private void handleTracking(final JSONArray args, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                String deliveryId = null;
                String broadlogId = null;

                try {
                    if (!args.get(0).equals(null) && args.get(0).getClass() == String.class) {
                        deliveryId = args.getString(0);
                        broadlogId = args.getString(1);
                    } else if (!args.get(0).equals(null)) {

                    }

                } catch (JSONException e) {
                    e.printStackTrace();
                    callbackContext.error(e.getMessage());
                    return;
                }

                HashMap<String, Object> contextData = new HashMap<>();

                if (deliveryId != null && broadlogId != null) {
                
                    contextData.put("deliveryId", deliveryId);
                    contextData.put("broadlogId", broadlogId);

                    // Send Click Tracking since the user did click on the notification
                    contextData.put("action", "2");
                    MobileCore.collectMessageInfo(contextData);

                    // Send Open Tracking since the user opened the app
                    contextData.put("action", "1");
                    MobileCore.collectMessageInfo(contextData);
                }

            }
        });
    }


//
//    private JSONArray visitorGetIDsJSONArray() {
//        ArrayList<Object> visitoIDsJson = new ArrayList<Object>();
//        JSONArray visitorIDSJSONArray = null;
//
//        try {
//            ArrayList<VisitorID> visitorIDs = (ArrayList<VisitorID>) Visitor.getIdentifiers();
//            if (visitorIDs != null && visitorIDs.size() > 0){
//                for (VisitorID vID:visitorIDs){
//                    HashMap<Object,Object> vIDMap = new HashMap<Object, Object>();
//                    vIDMap.put("idType", (vID.idType != null) ? vID.idType : "");
//                    vIDMap.put("id", (vID.id != null) ? vID.id : "");
//                    vIDMap.put("authenticationState", vID.authenticationState.toString());
//                    visitoIDsJson.add(vIDMap);
//                }
//
//                visitorIDSJSONArray = new JSONArray(visitoIDsJson);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return visitorIDSJSONArray;
//    }
//
    // =====================
    // Plugin life cycle events
    // =====================
    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);

        MobileCore.setApplication(cordova.getActivity().getApplication());
        MobileCore.setLogLevel(LoggingMode.DEBUG);

        try {
            UserProfile.registerExtension();
            Identity.registerExtension();
            Lifecycle.registerExtension();
            Signal.registerExtension();
            Campaign.registerExtension();
            Analytics.registerExtension();
            Target.registerExtension();
            PlacesMonitor.registerExtension(); //Register PlacesMonitor with Mobile Core
            Places.registerExtension(); //Register Places with Mobile Core
            if (applicationCode != null) {
//                MobileCore.start(o -> MobileCore.configureWithAppID(applicationCode));
                MobileCore.start(new AdobeCallback() {
                    @Override
                    public void call(Object o) {
                        // switch to your App ID from Launch
                        MobileCore.configureWithAppID(applicationCode);

                        final Map<String, Object> config = new HashMap<>();
                        config.put("places.membershipttl", 30);
                        MobileCore.updateConfiguration(config);

                        MobileCore.lifecycleStart(null);
                    }
                });


            }
        } catch (InvalidInitException e) {

        }


    }

    @Override
    public void onPause(boolean multitasking) {
        super.onPause(multitasking);
        MobileCore.lifecyclePause();
    }

    @Override
    public void onResume(boolean multitasking) {
        super.onResume(multitasking);
        MobileCore.setApplication(cordova.getActivity().getApplication());
        MobileCore.lifecycleStart(null);
    }

}
