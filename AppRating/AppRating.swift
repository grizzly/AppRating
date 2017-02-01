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



open class AppRating {
    
    private static var appID : String = "";
    
    // Getters and Setters
    
    open static func appID(_ appID: String) {
        AppRating.appID = appID
        AppRating.manager.appID = appID
    }
    
    open static let manager : AppRatingManager = {
        assert(AppRating.appID != "", "AppRating.appID(appID: String) has to be the first AppRating call made.")
        struct Singleton {
            static let instance: AppRatingManager = AppRatingManager(appID: AppRating.appID)
        }
        return Singleton.instance;
    }()
    
    open static func rate() {
        AppRating.manager.rateApp();
    }
    
    open static func showRatingAlert() {
        DispatchQueue.main.async {
            AppRating.manager.showRatingAlert()
        }
    }
    
    /*
     * Users will need to have the same version of your app installed for this many
     * days before they will be prompted to rate it.
     * Default => 3
     */
    
    open static func daysUntilPrompt() -> Int {
        return AppRating.manager.daysUntilPrompt
    }
    
    open static func daysUntilPrompt(_ daysUntilPrompt: Int) {
        AppRating.manager.daysUntilPrompt = daysUntilPrompt
    }
    
    /*
     * An example of a 'use' would be if the user launched the app. Bringing the app
     * into the foreground (on devices that support it) would also be considered
     * a 'use'.
     *
     * Users need to 'use' the same version of the app this many times before
     * before they will be prompted to rate it.
     * Default => 3
     */
    
    open static func usesUntilPrompt() -> Int {
        return AppRating.manager.usesUntilPrompt
    }
    
    open static func usesUntilPrompt(_ usesUntilPrompt: Int) {
        AppRating.manager.usesUntilPrompt = usesUntilPrompt
    }
    
    /*
     * Once the rating alert is presented to the user, they might select
     * 'Remind me later'. This value specifies how many days Armchair
     * will wait before reminding them. A value of 0 disables reminders and
     * removes the 'Remind me later' button.
     * Default => 1
     */
    
    open static func daysBeforeReminding() -> Int {
        return AppRating.manager.daysBeforeReminding;
    }
    
    open static func daysBeforeReminding(_ daysBeforeReminding: Int) {
        AppRating.manager.daysBeforeReminding = daysBeforeReminding
    }
    
    /*
     * By default, Armchair tracks all new bundle versions.
     * When it detects a new version, it resets the values saved for usage,
     * significant events, popup shown, user action etc...
     * By setting this to false, Armchair will ONLY track the version it
     * was initialized with. If this setting is set to true, Armchair
     * will reset after each new version detection.
     * Default => true
     */
    
    open static func tracksNewVersions() -> Bool {
        return AppRating.manager.tracksNewVersions
    }
    
    open static func tracksNewVersions(_ tracksNewVersions: Bool) {
        AppRating.manager.tracksNewVersions = tracksNewVersions
    }
    
    /*
     * If set to true, the main bundle will always be used to load localized strings.
     * Set this to true if you have provided your own custom localizations in
     * ArmchairLocalizable.strings in your main bundle
     * Default => false.
     */
    
    open static func useMainAppBundleForLocalizations() -> Bool {
        return AppRating.manager.useMainAppBundleForLocalizations
    }
    
    open static func useMainAppBundleForLocalizations(_ useMainAppBundleForLocalizations: Bool) {
        AppRating.manager.useMainAppBundleForLocalizations = useMainAppBundleForLocalizations
    }
 
    
    /*
     * Enables the debug mode, so a lot of information is printed out to 
     * the console
     * Default => false.
     */
    
    open static func debugEnabled() -> Bool {
        return self.manager.debugEnabled;
    }
    
    open static func debugEnabled(_ newstatus: Bool) {
        self.manager.debugEnabled = newstatus;
    }
    
    /*
     * Disables the conditions check when set to true
     * Useful if you want to test if the correct iTunes Link is opened
     * Default => false.
     */
    
    open static func ratingConditionsAlwaysTrue() -> Bool {
        return self.manager.ratingConditionsAlwaysTrue;
    }
    
    open static func ratingConditionsAlwaysTrue(_ newstatus: Bool) {
        self.manager.ratingConditionsAlwaysTrue = newstatus;
    }
    
    /*
     * Resets all counters. Perfect for testing.
     */
    
    open static func resetAllCounters() {
        return self.manager.resetAllCounters();
    }
    
    /*
     * Availabe for iOS 10.3+ 
     * Will use the new Apple App Rating Feature if 
     * set to true. Apple decides wheter it is the right
     * time to present the review screen, so it may not be
     * displayed also when the conditions will be met.
     */
    
    open static func useSKStorereViewController() -> Bool {
        return self.manager.useSKStorereViewController;
    }
    
    open static func useSKStorereViewController(_ newstatus: Bool) {
        self.manager.useSKStorereViewController = newstatus;
    }

    
}

open class AppRatingManager : NSObject {
    
    public var appID : String = "";
    public var appName : String = "";
    public var daysUntilPrompt : Int = 3;
    public var usesUntilPrompt : Int = 3;
    public var daysBeforeReminding : Int = 1;
    public var tracksNewVersions : Bool = true;
    public var shouldPromptIfRated : Bool = true;
    public var useMainAppBundleForLocalizations : Bool = false;
    public var usesAnimation : Bool = true;
    public var tintColor : UIColor?;
    public var useSKStorereViewController : Bool = false;
    public var ratingConditionsAlwaysTrue: Bool = false;
    public var debugEnabled : Bool = false;

    
    fileprivate var userDefaultsObject = UserDefaults.standard;
    fileprivate var operatingSystemVersion = NSString(string: UIDevice.current.systemVersion).doubleValue;
    fileprivate var currentVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    fileprivate var ratingAlert: UIAlertController? = nil
    fileprivate let reviewURLTemplate  = "https://itunes.apple.com/us/app/x/idAPP_ID?at=AFFILIATE_CODE&ct=AFFILIATE_CAMPAIGN_CODE&action=write-review"
    
    // MARK: Optional Closures
    public typealias AppRatingClosure = () -> ()
    var didDisplayAlertClosure: AppRatingClosure?
    var didDeclineToRateClosure: AppRatingClosure?
    var didOptToRateClosure: AppRatingClosure?
    var didOptToRemindLaterClosure: AppRatingClosure?
    
    
    init(appID: String) {
        super.init();
        self.appID = appID;
        setupNotifications();
        setDefaults();
    }
    
    public func rateApp() {
        
        userDefaultsObject.set(true, forKey: keyForAppRatingKeyString(appratingRatedCurrentVersion));
        userDefaultsObject.set(true, forKey: keyForAppRatingKeyString(appratingRatedAnyVersion));
        userDefaultsObject.synchronize()
        
        if (defaultOpensInStoreKit()) {
            UIApplication.shared.openURL(URL(string: reviewURLString())!)
        } else {
            UIApplication.shared.openURL(URL(string: reviewURLString())!)
        }
    }
    
    // MARK: Singleton Instance Setup
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(AppRatingManager.appWillResignActive(_:)),            name: NSNotification.Name.UIApplicationWillResignActive,    object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AppRatingManager.applicationDidFinishLaunching(_:)),  name: NSNotification.Name.UIApplicationDidFinishLaunching,  object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AppRatingManager.applicationWillEnterForeground(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    // MARK: -
    // MARK: PRIVATE Functions
    
    fileprivate func showRatingAlert() {
        
        if (useSKStorereViewController && self.defaultOpensInSKStoreReviewController()) {
            if #available(iOS 10.3, *) {
                //SKStoreReviewController.requestReview()
            }
        } else {
            
            let alertView : UIAlertController = UIAlertController(title: defaultReviewTitle(), message: defaultReviewMessage(), preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: defaultCancelButtonTitle(), style:UIAlertActionStyle.cancel, handler: {
                (alert: UIAlertAction!) in
                self.dontRate()
            }))
            if (showsRemindButton()) {
                if let defaultremindtitle = defaultRemindButtonTitle() {
                    alertView.addAction(UIAlertAction(title: defaultremindtitle, style:UIAlertActionStyle.default, handler: {
                        (alert: UIAlertAction!) in
                        self.remindMeLater()
                    }))
                }
            }
            alertView.addAction(UIAlertAction(title: defaultRateButtonTitle(), style:UIAlertActionStyle.default, handler: {
                (alert: UIAlertAction!) in
                self._rateApp()
            }))
            
            // get the top most controller (= the StoreKit Controller) and dismiss it
            if let presentingController = UIApplication.shared.keyWindow?.rootViewController {
                if let topController = topMostViewController(presentingController) {
                    topController.present(alertView, animated: usesAnimation) {
                        self.debugLog("presentViewController() completed")
                    }
                }
                // note that tint color has to be set after the controller is presented in order to take effect (last checked in iOS 9.3)
                alertView.view.tintColor = tintColor
            }
            self.ratingAlert = alertView;
        }
        
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
    }
    
    fileprivate func defaultKeyPrefix() -> String {
        if !self.appID.isEmpty {
            return self.appID + "_"
        } else {
            return "_"
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
    
    fileprivate func incrementUseCount() {
        _incrementCountForKeyType(appratingUseCount)
    }
    
    fileprivate func _incrementCountForKeyType(_ keyString: String) {
       
        let incrementKey = keyForAppRatingKeyString(keyString);
        
        let bundleVersionKey = kCFBundleVersionKey as String
        // App's version. Not settable as the other ivars because that would be crazy.
        let currentVersion = Bundle.main.object(forInfoDictionaryKey: bundleVersionKey) as? String
        if currentVersion == nil {
            assertionFailure("Could not read kCFBundleVersionKey from InfoDictionary")
            return
        }
        
        // Get the version number that we've been tracking thus far
        let currentVersionKey = keyForAppRatingKeyString(appratingCurrentVersion)
        var trackingVersion: String? = userDefaultsObject.string(forKey: currentVersionKey)
        // New install, or changed keys
        if trackingVersion == nil {
            trackingVersion = currentVersion
            userDefaultsObject.set(currentVersion as AnyObject?, forKey: currentVersionKey)
        }
        
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
            debugLog("Reset Tracking Version to: \(trackingVersion!)")
        }
        
        userDefaultsObject.synchronize()
        if (ratingConditionsHaveBeenMet()) {
            showRatingAlert();
        }
    }
    
    public func resetAllCounters() {
        debugLog("Reseting all Counters!")
        resetUsageCounters();
        
        let currentVersionKey = keyForAppRatingKeyString(appratingCurrentVersion);
        let trackingVersion: String? = userDefaultsObject.string(forKey: currentVersionKey)
        let bundleVersionKey = kCFBundleVersionKey as String
        let currentVersion = Bundle.main.object(forInfoDictionaryKey: bundleVersionKey) as? String
        
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
        self.debugLog("appWillResignActive:")
        hideRatingAlert()
    }
    
    @objc public func applicationDidFinishLaunching(_ notification: Notification) {
        DispatchQueue.global(qos: .background).async {
            self.debugLog("applicationDidFinishLaunching:")
            self.incrementUseCount();
        }
    }
    
    @objc public func applicationWillEnterForeground(_ notification: Notification) {
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
        switch UIDevice.current.systemVersion.compare("10.3.0", options: NSString.CompareOptions.numeric) {
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
            
            if window.windowLevel != UIWindowLevelNormal {
                let windows: NSArray = UIApplication.shared.windows as NSArray
                for candidateWindow in windows {
                    if let candidateWindow = candidateWindow as? UIWindow {
                        if candidateWindow.windowLevel == UIWindowLevelNormal {
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

