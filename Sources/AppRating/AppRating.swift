// AppRating.swift
//
// Copyright (c) 2017 GrizzlyNT (https://github.com/grizzly/AppRating)
//
// Based on: Armchair, Copyright (c) 2014 Armchair (http://github.com/UrbanApps/Armchair)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import StoreKit
import SystemConfiguration


@objc open class AppRating: NSObject {
    
    private static var appID : String = "";
    
    // MARK: -
    // MARK: Public Functions
    
    /**
     * Explicit call to start the rating process.
     * Should only be called directly on a user interaction like
     * pressing a "Please rate this app" button
     */
    @objc public static func rate() {
        AppRating.manager.rateApp();
    }

    /**
     * Explicit call to show the AlertView, asking
     * the user if she/he wants to rate the app.
     */
    @objc public static func showRatingAlert() {
        AppRating.manager.showRatingAlert();
    }
    
    // MARK: -
    // MARK: Getters & Setters
    
    /**
     * Used to set the Apple App Store AppID.
     * Has to be set as the very first call to AppRating
     *
     * - Parameter appID: Apple App ID
     */
    @objc public static func appID(_ appID: String) {
        AppRating.appID = appID
        AppRating.manager.appID = appID
    }

    /**
     * Singleton instance of the underlaying rating manager.
     */
    @objc public static let manager : AppRatingManager = {
        assert(AppRating.appID != "", "AppRating.appID(appID: String) has to be the first AppRating call made.")
        struct Singleton {
            static let instance: AppRatingManager = AppRatingManager(appID: AppRating.appID)
        }
        return Singleton.instance;
    }()
    
    
    /**
     * Users will need to have the same version of your app installed for this many
     * days before they will be prompted to rate it.
     * Default => 3
     */
    @objc public static func daysUntilPrompt() -> Int {
        return AppRating.manager.daysUntilPrompt
    }

    /**
     * Used to set the number of days before the app should 
     * ask the user for a rating. If you ask people after some
     * days only, the chance for getting better ratings is higher.
     * People who don't like your app will delete it mostly within
     * 1 day.
     *
     * - Parameter daysUntilPrompt: Number of days until Prompt
     */
    @objc public static func daysUntilPrompt(_ daysUntilPrompt: Int) {
        AppRating.manager.daysUntilPrompt = daysUntilPrompt
    }
    
    /**
     * An example of a 'use' would be if the user launched the app. Bringing the app
     * into the foreground (on devices that support it) would also be considered
     * a 'use'.
     *
     * Users need to 'use' the same version of the app this many times before
     * before they will be prompted to rate it.
     * Default => 3
     */
    
    @objc public static func usesUntilPrompt() -> Int {
        return AppRating.manager.usesUntilPrompt
    }


    /**
     * Sets the number of uses needed before the app asks the user
     * to rate the app
     *
     * - Parameter usesUntilPrompt: Number of days until Prompt
     */
    @objc public static func usesUntilPrompt(_ usesUntilPrompt: Int) {
        AppRating.manager.usesUntilPrompt = usesUntilPrompt
    }
    
    /**
     * Once the rating alert is presented to the user, they might select
     * 'Remind me later'. This value specifies how many days AppRating
     * will wait before reminding them. A value of 0 disables reminders and
     * removes the 'Remind me later' button.
     * Default => 1
     */
    
    @objc public static func daysBeforeReminding() -> Int {
        return AppRating.manager.daysBeforeReminding;
    }
    
    /**
     * Sets the number of days needed before the app asks the user
     * to rate the app again (after the user has pressed 'remind me
     * later'
     *
     * - Parameter daysBeforeReminding: Number of days before asking again
     */
    @objc public static func daysBeforeReminding(_ daysBeforeReminding: Int) {
        AppRating.manager.daysBeforeReminding = daysBeforeReminding
    }
    
    /**
     * A significant event can be anything you want to be in your app. In a
     * telephone app, a significant event might be placing or receiving a call.
     * In a game, it might be beating a level or a boss. This is just another
     * layer of filtering that can be used to make sure that only the most
     * loyal of your users are being prompted to rate you on the app store.
     * If you leave this at a value of 0 (default), then this won't be a criterion
     * used for rating.
     *
     * To tell AppRating that the user has performed
     * a significant event, call the method AppRating.userDidSignificantEvent()
     * Default => 0
     */
    @objc public static func significantEventsUntilPrompt() -> Int {
        return AppRating.manager.significantEventsUntilPrompt
    }
    
    /**
     * Sets the number of significant events needed before the app asks the user
     * to rate the app
     *
     * - Parameter significantEventsUntilPrompt: Number of significant events needed
     */
    @objc public static func significantEventsUntilPrompt(_ significantEventsUntilPrompt: Int) {
        AppRating.manager.significantEventsUntilPrompt = significantEventsUntilPrompt
    }
    
    /**
     * By default, AppRating tracks all new bundle versions.
     * When it detects a new version, it resets the values saved for usage,
     * significant events, popup shown, user action etc...
     * By setting this to false, AppRating will ONLY track the version it
     * was initialized with. If this setting is set to true, AppRating
     * will reset after each new version detection.
     * Default => true
     */
    
    @objc public static func tracksNewVersions() -> Bool {
        return AppRating.manager.tracksNewVersions
    }
    
    @objc public static func tracksNewVersions(_ tracksNewVersions: Bool) {
        AppRating.manager.tracksNewVersions = tracksNewVersions
    }
    
    /**
     * If set to true, the main bundle will always be used to load localized strings.
     * Set this to true if you have provided your own custom localizations in
     * AppRatingLocalizable.strings in your main bundle
     * Default => false.
     */
    
    @objc public static func useMainAppBundleForLocalizations() -> Bool {
        return AppRating.manager.useMainAppBundleForLocalizations
    }
    
    @objc public static func useMainAppBundleForLocalizations(_ useMainAppBundleForLocalizations: Bool) {
        AppRating.manager.useMainAppBundleForLocalizations = useMainAppBundleForLocalizations
    }
    

    /**
     * Enables the debug mode, so a lot of information is printed out to
     * the console
     * Default => false.
     */
    
    @objc public static func debugEnabled() -> Bool {
        return self.manager.debugEnabled;
    }
    
    @objc public static func debugEnabled(_ newstatus: Bool) {
        self.manager.debugEnabled = newstatus;
    }
    
    /**
     * Disables the conditions check when set to true
     * Useful if you want to test if the correct iTunes Link is opened
     * Default => false.
     */
    
    @objc public static func ratingConditionsAlwaysTrue() -> Bool {
        return self.manager.ratingConditionsAlwaysTrue;
    }
    
    @objc public static func ratingConditionsAlwaysTrue(_ newstatus: Bool) {
        self.manager.ratingConditionsAlwaysTrue = newstatus;
    }
    
    /**
     * Resets all counters. Perfect for testing.
     */
    
    @objc public static func resetAllCounters() {
        return self.manager.resetAllCounters();
    }
    
    /**
     * Availabe for iOS 10.3+ 
     * Will use the new Apple App Rating Feature if
     * set to true. Apple decides wheter it is the right
     * time to present the review screen, so it may not be
     * displayed also when the conditions will be met.
     * Default => true (for iOS 10.3+)
     */
    
    @objc public static func useSKStoreReviewController() -> Bool {
        return self.manager.useSKStoreReviewController;
    }
    
    /**
     * If you don't want to user SKStoreViewController at all
     * simply set this to false
     * - Parameter newstatus: the value
     */
    
    @objc public static func useSKStoreReviewController(_ newstatus: Bool) {
        self.manager.useSKStoreReviewController = newstatus;
    }
    
    /**
     * If the conditions have met to show up the rating alert, a number
     * of seconds is waited before the alert is shown. Use this to avoid
     * showing the alert to early (for example if the app is still loading
     * data)
     * Default => 2 seconds
     * - Parameter seconds: number of seconds to wait until prompt is shown
     */
    
    @objc public static func secondsBeforePromptIsShown(_ seconds: Double) {
        self.manager.secondsBeforePromptIsShown = seconds;
    }
    
    // MARK: Events
    
    /**
     * Tells AppRating that the user performed a significant event.
     * A significant event is whatever you want it to be. If you're app is used
     * to make VoIP calls, then you might want to call this method whenever the
     * user places a call. If it's a game, you might want to call this whenever
     * the user beats a level boss.
     *
     * If the user has performed enough significant events and used the app enough,
     * you can suppress the rating alert by passing false for canPromptForRating. The
     * rating alert will simply be postponed until it is called again with true for
     * canPromptForRating.
     */
    @objc public static func userDidSignificantEvent(canPromptForRating: Bool) {
        self.manager.userDidSignificantEvent(canPromptForRating: canPromptForRating)
    }
    
    
}

open class AppRatingManager : NSObject {
    
    // MARK: -
    // MARK: Public Members
    
    @objc public var appID : String = "";
    @objc public var appName : String = "";
    @objc public var daysUntilPrompt : Int = 3;
    @objc public var usesUntilPrompt : Int = 3;
    @objc public var daysBeforeReminding : Int = 7;
    @objc public var significantEventsUntilPrompt : Int = 0;
    @objc public var secondsBeforePromptIsShown : Double = 2;
    @objc public var tracksNewVersions : Bool = true;
    @objc public var shouldPromptIfRated : Bool = true;
    @objc public var useMainAppBundleForLocalizations : Bool = false;
    @objc public var usesAnimation : Bool = true;
    @objc public var tintColor : UIColor?;
    @objc public var useSKStoreReviewController : Bool = true;
    @objc public var ratingConditionsAlwaysTrue: Bool = false;
    @objc public var debugEnabled : Bool = false;
    
    // MARK: -
    // MARK: Optional Closures
    
    public typealias AppRatingClosure = () -> ()
    @objc public var didDisplayAlertClosure: AppRatingClosure?
    @objc public var didDeclineToRateClosure: AppRatingClosure?
    @objc public var didOptToRateClosure: AppRatingClosure?
    @objc public var didOptToRemindLaterClosure: AppRatingClosure?
    
    fileprivate var userDefaultsObject = UserDefaults.standard;
    fileprivate var operatingSystemVersion = NSString(string: UIDevice.current.systemVersion).doubleValue;
    fileprivate var currentVersion = "0.0.0";
    fileprivate var ratingAlert: UIAlertController? = nil
    fileprivate let reviewURLTemplate  = "https://itunes.apple.com/app/idAPP_ID?at=AFFILIATE_CODE&ct=AFFILIATE_CAMPAIGN_CODE&action=write-review"
    
    // MARK: -
    // MARK: Initialization
    
    init(appID: String) {
        super.init();
        self.appID = appID;
        setupNotifications();
        setDefaults();
    }
    
    // MARK: -
    // MARK: Singleton Instance Setup
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(AppRatingManager.appWillResignActive(_:)),            name: UIApplication.willResignActiveNotification,    object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AppRatingManager.applicationDidFinishLaunching(_:)),  name: UIApplication.didFinishLaunchingNotification,  object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AppRatingManager.applicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // MARK: -
    // MARK: PRIVATE Functions
    
    fileprivate func rateApp() {
        self.setUserHasRatedApp();
        if (defaultOpensInStoreKit()) {
            if #available(iOS 10.3, *) {
                UIApplication.shared.open(URL(string: reviewURLString())!, options: [:], completionHandler: nil);
            } else {
               UIApplication.shared.openURL(URL(string: reviewURLString())!)
            }
        } else {
            if #available(iOS 10.3, *) {
                UIApplication.shared.open(URL(string: reviewURLString())!, options: [:], completionHandler: nil);
            } else {
                UIApplication.shared.openURL(URL(string: reviewURLString())!)
            }
        }
    }
    
    fileprivate func showRatingAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + self.secondsBeforePromptIsShown) {
            if (self.useSKStoreReviewController && self.defaultOpensInSKStoreReviewController()) {
                if #available(iOS 10.3, *) {
                    SKStoreReviewController.requestReview();
                    self.remindMeLater();
                }
            } else {
                if (self.ratingAlert == nil) {
                    let alertView : UIAlertController = UIAlertController(title: self.defaultReviewTitle(), message: self.defaultReviewMessage(), preferredStyle: UIAlertController.Style.alert)
                    alertView.addAction(UIAlertAction(title: self.defaultCancelButtonTitle(), style:UIAlertAction.Style.cancel, handler: {
                        (alert: UIAlertAction!) in
                        self.dontRate();
                        self.hideRatingAlert();
                    }))
                    if (self.showsRemindButton()) {
                        if let defaultremindtitle = self.defaultRemindButtonTitle() {
                            alertView.addAction(UIAlertAction(title: defaultremindtitle, style:UIAlertAction.Style.default, handler: {
                                (alert: UIAlertAction!) in
                                self.remindMeLater();
                                self.hideRatingAlert();
                            }))
                        }
                    }
                    alertView.addAction(UIAlertAction(title: self.defaultRateButtonTitle(), style:UIAlertAction.Style.default, handler: {
                        (alert: UIAlertAction!) in
                        self._rateApp();
                        self.hideRatingAlert();
                    }))
                    
                    // get the top most controller (= the StoreKit Controller) and dismiss it
                    if let presentingController = UIApplication.shared.keyWindow?.rootViewController {
                        if let topController = self.topMostViewController(presentingController) {
                            topController.present(alertView, animated: self.usesAnimation) {
                                self.debugLog("presentViewController() completed")
                            }
                        }
                        // note that tint color has to be set after the controller is presented in order to take effect (last checked in iOS 9.3)
                        alertView.view.tintColor = self.tintColor
                    }
                    self.ratingAlert = alertView;
                }
            }
        }
        
    }
    
    fileprivate func setUserHasRatedApp() {
        userDefaultsObject.set(true, forKey: keyForAppRatingKeyString(appratingRatedCurrentVersion));
        userDefaultsObject.set(true, forKey: keyForAppRatingKeyString(appratingRatedAnyVersion));
        userDefaultsObject.synchronize()
    }
    
    private func hideRatingAlert() {
        if let alert = ratingAlert {
            alert.dismiss(animated: false, completion: nil);
            ratingAlert = nil
        }
    }
    
    private func dontRate() {
        userDefaultsObject.set(true, forKey: keyForAppRatingKeyString(self.appratingKeyDeclinedToRate));
        userDefaultsObject.synchronize();
        if let closure = didDeclineToRateClosure {
            closure()
        }
    }
    
    private func remindMeLater() {
        userDefaultsObject.set(Date().timeIntervalSince1970, forKey: keyForAppRatingKeyString(self.appratingReminderRequestDate));
        userDefaultsObject.synchronize()
        if let closure = didOptToRemindLaterClosure {
            closure()
        }
    }
    
    private func _rateApp() {
        rateApp()
        if let closure = didOptToRateClosure {
            closure()
        }
    }
    
    fileprivate func showsRemindButton() -> Bool {
        return true;
    }
    
    fileprivate func setDefaults() {
        self.appName = self.defaultAppName();
        self.currentVersion = getAppVersion();
    }
    
    fileprivate func defaultKeyPrefix() -> String {
        if !self.appID.isEmpty {
            return self.appID + "_"
        } else {
            return "_"
        }
    }
    
    fileprivate func getAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version;
        } else {
            return "0.0.0";
        }
    }
    
    fileprivate func defaultAppName() -> String {
        let mainBundle = Bundle.main
        let displayName = mainBundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        let bundleNameKey = kCFBundleNameKey as String
        let name = mainBundle.object(forInfoDictionaryKey: bundleNameKey) as? String
        return displayName ?? name ?? "This App"
    }
    
    fileprivate func defaultReviewTitle() -> String {
        var template = "Rate %@"
        // Check for a localized version of the default title
        if let bundle = self.bundle() {
            template = bundle.localizedString(forKey: template,
                                              value: bundle.localizedString(forKey: template, value:"", table: nil),
                                              table: "AppRatingLocalizable")
        }
        
        return template.replacingOccurrences(of: "%@", with: "\(self.appName)", options: NSString.CompareOptions(rawValue: 0), range: nil)
    }
    
    fileprivate func defaultReviewMessage() -> String {
        var template = "If you enjoy using %@, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!"
        // Check for a localized version of the default title
        if let bundle = self.bundle() {
            template = bundle.localizedString(forKey: template,
                                              value: bundle.localizedString(forKey: template, value:"", table: nil),
                                              table: "AppRatingLocalizable")
        }
        
        return template.replacingOccurrences(of: "%@", with: "\(self.appName)", options: NSString.CompareOptions(rawValue: 0), range: nil)
    }
    
    fileprivate func defaultCancelButtonTitle() -> String {
        var title = "No, Thanks"
        // Check for a localized version of the default title
        if let bundle = self.bundle() {
            title = bundle.localizedString(forKey: title,
                                           value: bundle.localizedString(forKey: title, value:"", table: nil),
                                           table: "AppRatingLocalizable")
        }
        
        return title
    }
    
    fileprivate func defaultRateButtonTitle() -> String {
        var template = "Rate %@"
        // Check for a localized version of the default title
        if let bundle = self.bundle() {
            template = bundle.localizedString(forKey: template,
                                              value: bundle.localizedString(forKey: template, value:"", table: nil),
                                              table: "AppRatingLocalizable")
        }
        
        return template.replacingOccurrences(of: "%@", with: "\(self.appName)", options: NSString.CompareOptions(rawValue: 0), range: nil)
    }
    
    fileprivate func defaultRemindButtonTitle() -> String? {
        //if reminders are disabled, return a nil title to supress the button
        if self.daysBeforeReminding == 0 {
            return nil
        }
        var title = "Remind me later"
        // Check for a localized version of the default title
        if let bundle = self.bundle() {
            title = bundle.localizedString(forKey: title,
                                           value: bundle.localizedString(forKey: title, value:"", table: nil),
                                           table: "AppRatingLocalizable")
        }
        
        return title
    }
    
    fileprivate func ratingConditionsHaveBeenMet() -> Bool {
        
        if self.ratingConditionsAlwaysTrue {
            return true
        }
        
        if self.appID.isEmpty {
            debugLog("ratingConditionsHaveBeenMet: appID empty!")
            return false
        }
        
        // check if the app has been used long enough
        let timeIntervalOfFirstLaunch = userDefaultsObject.double(forKey: keyForAppRatingKeyString(appratingFirstUseDate))
        let dateOfFirstLaunch = Date(timeIntervalSince1970: timeIntervalOfFirstLaunch)
        let timeSinceFirstLaunch = Date().timeIntervalSince(dateOfFirstLaunch)
        let timeUntilRate: TimeInterval = 60 * 60 * 24 * Double(daysUntilPrompt)
        if timeSinceFirstLaunch < timeUntilRate {
            debugLog("ratingConditionsHaveBeenMet: app has not been used long enough!")
            return false
        }
        
        // check if the app has been used enough times
        let useCount = userDefaultsObject.integer(forKey: keyForAppRatingKeyString(appratingUseCount))
        if useCount <= usesUntilPrompt {
            debugLog("ratingConditionsHaveBeenMet: app has not been used enough times!")
            return false
        }
        
        // check if the user has done enough significant events
        let significantEventCount = userDefaultsObject.integer(forKey: keyForAppRatingKeyString(appratingSignificantEventCount))
        if significantEventCount < significantEventsUntilPrompt {
            self.debugLog("ratingConditionsHaveBeenMet: not enough sigificant events!")
            return false
        }
        
        // Check if the user previously has declined to rate this version of the app
        if userHasDeclinedToRate() {
            debugLog("ratingConditionsHaveBeenMet: user has declined to rate app!")
            return false
        }
        
        // Check if the user has already rated the app?
        if userHasRatedCurrentVersion() {
            debugLog("ratingConditionsHaveBeenMet: user has rated current app!")
            return false
        }
        
        // If the user wanted to be reminded later, has enough time passed?
        let timeIntervalOfReminder = userDefaultsObject.double(forKey: keyForAppRatingKeyString(appratingReminderRequestDate))
        let reminderRequestDate = Date(timeIntervalSince1970: timeIntervalOfReminder)
        let timeSinceReminderRequest = Date().timeIntervalSince(reminderRequestDate)
        let timeUntilReminder: TimeInterval = 60 * 60 * 24 * Double(daysBeforeReminding)
        if timeSinceReminderRequest < timeUntilReminder {
            debugLog("ratingConditionsHaveBeenMet: user wants to be reminded later, but not enough time passed since last try!")
            return false
        }
        
        // if we have a global set to not show if the end-user has already rated once, and the developer has not opted out of displaying on minor updates
        let ratedAnyVersion = userDefaultsObject.bool(forKey: keyForAppRatingKeyString(appratingRatedAnyVersion));
        if (!shouldPromptIfRated && ratedAnyVersion) {
            debugLog("ratingConditionsHaveBeenMet: allready voted!")
            return false
        }
        
        return true
    }
    
    fileprivate func userHasDeclinedToRate() -> Bool {
        return userDefaultsObject.bool(forKey: keyForAppRatingKeyString(appratingKeyDeclinedToRate));
    }
    
    fileprivate func userHasRatedCurrentVersion() -> Bool {
        return userDefaultsObject.bool(forKey: keyForAppRatingKeyString(appratingRatedCurrentVersion));
    }
    
    fileprivate func userDidSignificantEvent(canPromptForRating: Bool) {
        DispatchQueue.global(qos: .background).async {
            self.incrementSignificantEventCount(canPromptForRating: canPromptForRating)
        }
    }
    
    fileprivate func incrementSignificantEventCount(canPromptForRating: Bool) {
        _incrementCountForKeyType(appratingSignificantEventCount, canPromptForRating: canPromptForRating);
    }
    
    fileprivate func incrementUseCount() {
        _incrementCountForKeyType(appratingUseCount, canPromptForRating: true);
    }
    
    fileprivate func _incrementCountForKeyType(_ keyString: String, canPromptForRating: Bool) {

        let incrementKey = keyForAppRatingKeyString(keyString);
        
        // App's version. Not settable as the other ivars because that would be crazy.
        let currentVersion = getAppVersion();
        
        // Get the version number that we've been tracking thus far
        let currentVersionKey = keyForAppRatingKeyString(appratingCurrentVersion)
        var trackingVersion: String? = userDefaultsObject.string(forKey: currentVersionKey)
        // New install, or changed keys
        if trackingVersion == nil {
            trackingVersion = currentVersion
            userDefaultsObject.set(currentVersion as AnyObject?, forKey: currentVersionKey)
        }
        
        debugLog("Current version : \(currentVersion)")
        debugLog("Tracking version: \(trackingVersion!)")
        
        if trackingVersion == currentVersion {
            // Check if the first use date has been set. if not, set it.
            let firstUseDateKey = keyForAppRatingKeyString(appratingFirstUseDate)
            var timeInterval: Double? = userDefaultsObject.double(forKey: firstUseDateKey)
            if 0 == timeInterval {
                timeInterval = Date().timeIntervalSince1970
                userDefaultsObject.set(NSNumber(value: timeInterval!), forKey: firstUseDateKey)
            }
            
            // Increment the key's count
            var incrementKeyCount = userDefaultsObject.integer(forKey: incrementKey)
            incrementKeyCount += 1
            
            userDefaultsObject.set(incrementKeyCount, forKey:incrementKey)
            
            debugLog("Incremented \(incrementKey): \(incrementKeyCount)")
            
        } else if tracksNewVersions {
            // it's a new version of the app, so restart tracking
            resetAllCounters()
            debugLog("Reset Tracking Version to: \(currentVersion)")
        }
        
        userDefaultsObject.synchronize()
        if (canPromptForRating && ratingConditionsHaveBeenMet()) {
            showRatingAlert();
        }
    }
    
    public func resetAllCounters() {
        debugLog("Reseting all Counters!")
        resetUsageCounters();
        
        let currentVersionKey = keyForAppRatingKeyString(appratingCurrentVersion);
        let trackingVersion: String? = userDefaultsObject.string(forKey: currentVersionKey)
        let currentVersion = getAppVersion();
        
        userDefaultsObject.set(trackingVersion as AnyObject?, forKey: keyForAppRatingKeyString(appratingPreviousVersion))
        userDefaultsObject.set(userDefaultsObject.object(forKey: keyForAppRatingKeyString(appratingRatedCurrentVersion)), forKey: keyForAppRatingKeyString(appratingRatedPreviousVersion))
        userDefaultsObject.set(userDefaultsObject.object(forKey: keyForAppRatingKeyString(appratingKeyDeclinedToRate)), forKey: keyForAppRatingKeyString(appratingKeyPreviousDeclinedToRate))
        userDefaultsObject.set(currentVersion as AnyObject?, forKey: currentVersionKey)
        
        userDefaultsObject.set(NSNumber(value: false), forKey: keyForAppRatingKeyString(appratingRatedCurrentVersion))
        userDefaultsObject.set(NSNumber(value: false), forKey: keyForAppRatingKeyString(appratingKeyDeclinedToRate))
        userDefaultsObject.set(NSNumber(value: 0), forKey: keyForAppRatingKeyString(appratingReminderRequestDate))
        userDefaultsObject.synchronize()
    }
    
    public func resetUsageCounters() {
        userDefaultsObject.set(NSNumber(value: NSDate().timeIntervalSince1970), forKey: keyForAppRatingKeyString(appratingFirstUseDate))
        userDefaultsObject.set(NSNumber(value: 1), forKey: keyForAppRatingKeyString(appratingUseCount))
        userDefaultsObject.synchronize()
    }
    
    // MARK: -
    // MARK: Notification Handlers
    
    @objc public func appWillResignActive(_ notification: Notification) {
        hideRatingAlert()
        DispatchQueue.global(qos: .background).async {
            self.debugLog("appWillResignActive:")
        };
    }
    
    @objc public func applicationDidFinishLaunching(_ notification: Notification) {
        hideRatingAlert()
        DispatchQueue.global(qos: .background).async {
            self.debugLog("applicationDidFinishLaunching:")
            self.incrementUseCount();
        }
    }
    
    @objc public func applicationWillEnterForeground(_ notification: Notification) {
        hideRatingAlert()
        DispatchQueue.global(qos: .background).async {
            self.debugLog("applicationWillEnterForeground:")
            self.incrementUseCount();
        }
    }
    
    // MARK: -
    // MARK: PRIVATE Misc Settings
    
    // If you aren't going to set an affiliate code yourself, please leave this as is.
    // It is my affiliate code. It is better that somebody's code is used rather than nobody's.
    
    fileprivate var affiliateCode: String                   = "1000ldjv"
    fileprivate var affiliateCampaignCode: String           = "AppRating"
    
    fileprivate func reviewURLString() -> String {
        let template = reviewURLTemplate
        var reviewURL = template.replacingOccurrences(of: "APP_ID", with: "\(appID)")
        reviewURL = reviewURL.replacingOccurrences(of: "AFFILIATE_CODE", with: "\(affiliateCode)")
        reviewURL = reviewURL.replacingOccurrences(of: "AFFILIATE_CAMPAIGN_CODE", with: "\(affiliateCampaignCode)")
        debugLog(reviewURL)
        return reviewURL
    }
    
    // MARK: -
    // MARK: Internet Connectivity
    
    private func connectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    // MARK: -
    // MARK: PRIVATE Misc Helpers
    
    private func bundle() -> Bundle? {
        var bundle: Bundle? = nil
        if useMainAppBundleForLocalizations {
            bundle = Bundle.main
        } else {
            let podBundle = Bundle(for: AppRatingManager.classForCoder())
            if let bundleURL = podBundle.url(forResource: "AppRating", withExtension: "bundle") {
                if let resourceBundle = Bundle(url: bundleURL) {
                    bundle = resourceBundle;
                }
            }
        }
        if bundle != nil {
            return bundle;
        } else {
            return Bundle.main;
        }
    }
    
    
    fileprivate func defaultOpensInSKStoreReviewController() -> Bool {
        let version = UIDevice.current.systemVersion.compare("10.3", options: NSString.CompareOptions.numeric);
        switch version {
        case .orderedSame, .orderedDescending:
            return true;
        case .orderedAscending:
            return false;
        }
    }
    
    fileprivate func defaultOpensInStoreKit() -> Bool {
        switch UIDevice.current.systemVersion.compare("10.3.0", options: NSString.CompareOptions.numeric) {
        case .orderedSame, .orderedDescending:
            return true;
        case .orderedAscending:
            return false;
        }
    }
    
    private func topMostViewController(_ controller: UIViewController?) -> UIViewController? {
        var isPresenting: Bool = false
        var topController: UIViewController? = controller
        repeat {
            // this path is called only on iOS 6+, so -presentedViewController is fine here.
            if let controller = topController {
                if let presented = controller.presentedViewController {
                    isPresenting = true
                    topController = presented
                } else {
                    isPresenting = false
                }
            }
        } while isPresenting
        
        return topController
    }
    
    private func getRootViewController() -> UIViewController? {
        if var window = UIApplication.shared.keyWindow {
            
            if window.windowLevel != UIWindow.Level.normal {
                let windows: NSArray = UIApplication.shared.windows as NSArray
                for candidateWindow in windows {
                    if let candidateWindow = candidateWindow as? UIWindow {
                        if candidateWindow.windowLevel == UIWindow.Level.normal {
                            window = candidateWindow
                            break
                        }
                    }
                }
            }
            
            for subView in window.subviews {
                if let responder = subView.next {
                    if responder.isKind(of: UIViewController.self) {
                        return topMostViewController(responder as? UIViewController)
                    }
                    
                }
            }
        }
        
        return nil
    }
    
    // MARK: Tracking Keys with sensible defaults
    
    fileprivate lazy var appratingCurrentVersion: String = "AppRatingCurrentVersion";
    fileprivate lazy var appratingPreviousVersion: String = "AppRatingPreviousVersion";
    fileprivate lazy var appratingRatedCurrentVersion: String = "AppRatingRatedCurrentVersion";
    fileprivate lazy var appratingRatedPreviousVersion: String = "AppRatingRatedPreviousVersion";
    fileprivate lazy var appratingKeyDeclinedToRate: String = "AppRatingKeyDeclinedToRate";
    fileprivate lazy var appratingKeyPreviousDeclinedToRate: String = "AppRatingPreviousKeyDeclinedToRate";
    fileprivate lazy var appratingReminderRequestDate: String = "AppRatingReminderRequestDate";
    fileprivate lazy var appratingFirstUseDate: String = "AppRatingFirstUseDate";
    fileprivate lazy var appratingRatedAnyVersion: String = "AppRatingRatedAnyVersion";
    fileprivate lazy var appratingUseCount: String = "AppRatingUseCount";
    fileprivate lazy var appratingSignificantEventCount : String = "AppRatingSignificantEventCount";
    
    fileprivate func keyForAppRatingKeyString(_ keyString: String) -> String {
        return defaultKeyPrefix() + keyString;
    }
    
    // MARK: -
    // MARK: Debug
    
    static let lockQueue = DispatchQueue(label: "com.grizzlynt.apprating.lockqueue")
    
    fileprivate func debugLog(_ log: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        if self.debugEnabled {
            AppRatingManager.lockQueue.sync(execute: {
                print("[AppRating] \(log)")
            })
        }
    }
    
}

