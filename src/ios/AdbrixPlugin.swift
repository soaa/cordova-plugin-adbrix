@objc(AdbrixPlugin) class AdbrixPlugin: CDVPlugin {
    override func pluginInitialize() {
        NotificationCenter.default.addObserver(self, selector: #selector(AdbrixPlugin.applicationDidFinishLaunching), name: Notification.Name.UIApplicationDidFinishLaunching, object: nil)
        
        AppDelegate.adbrixPluginClassInit
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let bundle = Bundle.main
        let appKey = bundle.object(forInfoDictionaryKey: ADBRIX_APP_KEY) as? String
        let appHash = bundle.object(forInfoDictionaryKey: ADBRIX_APP_HASH) as? String
        
        let ifa = ASIdentifierManager.shared().advertisingIdentifier
        let isAppleAdvertisingTrackingEnabled = ASIdentifierManager.shared().isAdvertisingTrackingEnabled
        
        IgaworksCore.setAppleAdvertisingIdentifier(ifa?.uuidString, isAppleAdvertisingTrackingEnabled: isAppleAdvertisingTrackingEnabled)
        
        NSLog("ifa UUIDString -> %@", ifa?.uuidString ?? "")
        
        IgaworksCore.igaworksCore(withAppKey: appKey, andHashKey: appHash)
        
        NSLog("Igaworks initialized %@", appKey ?? "")
    }
    
    @objc(firstTimeExperience:) func firstTimeExperience(command: CDVInvokedUrlCommand) {
        if let options = command.arguments.first as? Dictionary<String, String> {
            if let activity = options["activity"] {
                if let param = options["param"] {
                    AdBrix.firstTimeExperience(activity, param: param)
                } else {
                    AdBrix.firstTimeExperience(activity)
                }
            }
        }
        
        self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_OK), callbackId: command.callbackId)
    }
    
    @objc(retention:) func retention(command: CDVInvokedUrlCommand) {
        if let options = command.arguments.first as? Dictionary<String, String> {
            if let activity = options["activity"] {
                if let param = options["param"] {
                    AdBrix.retention(activity, param: param)
                } else {
                    AdBrix.retention(activity)
                }
            }
        }
        
        self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_OK), callbackId: command.callbackId)
    }

    @objc(setAge:) func setAge(command: CDVInvokedUrlCommand) {
        if let age = command.arguments.first as? Int32 {
            IgaworksCore.setAge(age)
        }
        
        self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_OK), callbackId: command.callbackId)
    }
    
    @objc(setGender:) func setGender(command: CDVInvokedUrlCommand) {
        if let gender = command.arguments.first as? String {
            if ("M".caseInsensitiveCompare(gender) == ComparisonResult.orderedSame) {
                IgaworksCore.setGender(IgaworksCoreGenderMale)
            } else if("F".caseInsensitiveCompare(gender) == ComparisonResult.orderedSame) {
                IgaworksCore.setGender(IgaworksCoreGenderFemale)
            }
        }
        
        self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_OK), callbackId: command.callbackId)
    }
}

//MARK: extension NaverPlugin
extension AppDelegate {
    
    static let adbrixPluginClassInit : () = {
        let swizzle = { (cls: AnyClass, originalSelector: Selector, swizzledSelector: Selector) in
            let originalMethod = class_getInstanceMethod(cls, originalSelector)
            let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)
            
            let didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
        swizzle(AppDelegate.self, #selector(UIApplicationDelegate.application(_:open:sourceApplication:annotation:)), #selector(AppDelegate.adbrixSwizzledApplication(_:open:sourceApplication:annotation:)))
        
        if #available(iOS 9.0, *) {
            swizzle(AppDelegate.self, #selector(UIApplicationDelegate.application(_:open:options:)), #selector(AppDelegate.adbrixSwizzledApplication_options(_:open:options:)))
        }
    }()
    
    open func adbrixSwizzledApplication(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) {
        IgaworksCore.passOpen(url)
        self.adbrixSwizzledApplication(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    open func adbrixSwizzledApplication_options(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any]) {
        IgaworksCore.passOpen(url)
        self.adbrixSwizzledApplication_options(application, open: url, options: options)
    }
}
