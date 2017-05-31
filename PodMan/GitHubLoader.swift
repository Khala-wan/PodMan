//
//  GitHubLoader.swift
//  OAuth2App
//
//  Created by Pascal Pfiffner on 11/12/14.
//  CC0, Public Domain
//

import Cocoa
import OAuth2


/**
	Simple class handling authorization and data requests with GitHub.
 */
class GitHubLoader: OAuth2DataLoader ,DataLoader{
	
	let baseURL = URL(string: "https://api.github.com")!
	
	public init() {
		let oauth = OAuth2CodeGrant(settings: [
			"client_id": "c62dae614e4852b2a4c6",                         // yes, this client-id and secret will work!
            "client_secret": "15f4450ef9b8c98113e4504ad6e0790794afdf58",
            "authorize_uri": "https://github.com/login/oauth/authorize",
            "token_uri": "https://github.com/login/oauth/access_token",
            "scope": "user repo",
            "redirect_uris": ["podman://oauth/callback"],            // app has registered this scheme
            "secret_in_body": true,                                      // GitHub does not accept client secret in the Authorization header
			"verbose": true,
		])
        oauth.clientConfig.accessTokenAssumeUnexpired = true
		super.init(oauth2: oauth)
	}
	
	
	/** Perform a request against the GitHub API and return decoded JSON or an NSError. */
	func request(path: String, callback: @escaping ((OAuth2JSON?, Error?) -> Void)) {
		oauth2.logger = OAuth2DebugLogger(.trace)
		let url = baseURL.appendingPathComponent(path)
		var req = oauth2.request(forURL: url)
		req.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
		
		perform(request: req) { response in
			do {
				let dict = try response.responseJSON()
				DispatchQueue.main.async() {
					callback(dict, nil)
				}
			}
			catch let error {
				DispatchQueue.main.async() {
					callback(nil, error)
				}
			}
		}
	}
	
	func requestUserdata(callback: @escaping ((_ dict: OAuth2JSON?, _ error: Error?) -> Void)) {
		request(path: "user", callback: callback)
	}
}

