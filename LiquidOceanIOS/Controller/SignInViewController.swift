//
//  SignInViewController.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/23/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInDelegate {

    @IBOutlet weak var backAction: ActionButtonView!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var backActionLeading: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xFF333333"))

        // init
        GIDSignIn.sharedInstance()?.clientID = "454898966293-tac43n0h50as6i07qbt3mc1let090390.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        
        // vc specific
        GIDSignIn.sharedInstance()?.presentingViewController = self

        // Automatically sign in the user.
        // GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        backAction.type = .backSolid
        
        backAction.setOnClickListener {
            self.performSegue(withIdentifier: "UnwindToOptions", sender: nil)
        }
        
        if SessionSettings.instance.googleAuth {
            signInButton.isEnabled = false
            statusLabel.text = "Signed in"
        }
    }
    
    override func viewDidLayoutSubviews() {
        let backX = self.backAction.frame.origin.x
        if backX < 0 {
            backActionLeading.constant += 30
        }
    }
    
    // google sign-in delegate
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
      
        if idToken != nil {
            URLSessionHandler.instance.sendGoogleToken(token: String(idToken!.prefix(16))) { (success) -> (Void) in
                if !success {
                    self.statusLabel.text = "Could not sign in"
                }
                else {
                    self.statusLabel.text = "Signed in"
                }
                self.signInButton.isEnabled = false
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // ...
    }
}
