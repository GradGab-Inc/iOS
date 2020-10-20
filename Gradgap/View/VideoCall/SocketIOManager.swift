//
//  SocketIOManager.swift
//  ChatWihSockets
//
//  Created by MACBOOK on 28/09/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation
import SocketIO


class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    var socket: SocketIOClient!
    
    // defaultNamespaceSocket and swiftSocket both share a single connection to the server
    var manager = SocketManager(socketURL: URL(string: API.SOCKET_URL)!, config: [.log(true), .compress])
    
    override init() {
        super.init()
        socket = manager.defaultSocket
    }
    
    func reloadSocket()
    {
        manager = SocketManager(socketURL: URL(string: API.SOCKET_URL)!, config: [.log(true), .compress])
        socket = manager.defaultSocket
    }
    
    //Custom Connect with userID
    func connectSocket() {
        if socket != nil {
            socket.disconnect()
        }
        if AppModel.shared.currentUser == nil {
            return
        }
        let userId = AppModel.shared.currentUser.accessToken
        self.manager.config = SocketIOClientConfiguration(
            arrayLiteral:.connectParams(["access_token": userId]),.extraHeaders(["Authorization" : userId]),
            .secure(false) //, .forcePolling(true), .forceWebsockets(true)
        )
        self.socket.connect()
                        
        //To connect socket
        socket.on(clientEvent: .connect) { (data, ack) in
            print("socket connected",data,ack)
        }
        
        //To connect socket
        socket.on(clientEvent: .disconnect) { (data, ack) in
            print("socket disconnected",data,ack)
        }
        
        socket.on(clientEvent: SocketClientEvent.reconnect) { (data, eck) in
            print(data)
                print("socket reconnect")
        }
        
        socket.on("extend_call") { (dataArray, ack) in
            print(dataArray)
            if dataArray.count == 0 {
                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.SETUP_EXTEND_DATA), object: nil)
            }
            else {
                let messageData = dataArray.first as! [String: Any]
                if let data = messageData["status"], data as! Int == 2 {
                    NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.SETUP_EXTEND_VERIFICATION_DATA), object: ["status" : 2])
                }
                else if let data = messageData["status"], data as! Int == 3 {
                    NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.SETUP_EXTEND_VERIFICATION_DATA), object: ["status" : 3])
                }
                
//                let jsonData = try? JSONSerialization.data(withJSONObject: dataArray, options: [])
//                let jsonString = String(data: jsonData!, encoding: .utf8)!
//                if let dict = convertToDictionary(text: jsonString) {
//                    NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.SETUP_EXTEND_VERIFICATION_DATA), object: dataArray)
//                }
            }
        }
        
        socket.on(clientEvent: .error) {data, ack in
            print(data)
        }
        
    }
    
    func establishConnection() {
        reloadSocket()
        delay(1.0) {
            SocketIOManager.sharedInstance.connectSocket()
        }
    }
    
    func closeConnection() {
        socket.disconnect()
        socket.removeAllHandlers()
    }
    
    func subscribeChannel(_ dict : [String : String]) {
        socket.emit("subscribe_channel", dict) {
            
        }
    }
    
//    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
//    }
//
//    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
//        if let err = error {
//            print("Error: \(err.localizedDescription)")
//        } else {
//            print("Error. Giving up")
//        }
//    }

    
    
//    func acknowledgementMessage(completionHandler: @escaping (_ messageStatus: Int) -> Void) {
//        socket.on("extend_call") { (dataArray, ack) in
//            print(dataArray)
//            if dataArray.count == 0 {
//                displayToast("For extend call")
//                completionHandler(3)
//            }
//            else {
//                let messageJsonData = dataArray.first as! [String: Any]
//                let jsonData = try? JSONSerialization.data(withJSONObject: messageJsonData["data"]!, options: [])
//                let jsonString = String(data: jsonData!, encoding: .utf8)!
//                if let dict = convertToDictionary(text: jsonString) {
//                    completionHandler(dict["status"] as! Int)
//                }
//            }
//        }
        
        
//        socket.on("subscribe_channel") { ( dataArray, ack) -> Void in
//            let messageJsonData = dataArray.first as! [String: Any]
//            let jsonData = try? JSONSerialization.data(withJSONObject: messageJsonData["data"]!, options: [])
//            let jsonString = String(data: jsonData!, encoding: .utf8)!
//            if let dict = convertToDictionary(text: jsonString) {
//                completionHandler(dict)
//            }
//        }
    }


//    func connectToServerWithNickname(message: String, completionHandler: (userList: [[String: AnyObject]]!) -> Void) {
//        socket.emit("message", message)
//
//        socket.on("userList") { ( dataArray, ack) -> Void in
//            completionHandler(userList: dataArray[0] as! [[String: AnyObject]])
//        }
//
//        listenForOtherMessages()
//    }
////
//
//    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
//        socket.emit("exitUser", nickname)
//        completionHandler()
//    }
//
//
//    func sendMessage(message: String) {
//        socket.emit("message",message)
//    }
    
    
   


//    func getChatMessage(completionHandler: @escaping (_ messageInfo: ChatMessage) -> Void) {
//        socket.on("message") { (dataArray, socketAck) -> Void in
//            let messageJsonData = dataArray.first as! [String: Any]
//            let jsonData = try? JSONSerialization.data(withJSONObject: messageJsonData["data"]!, options: [])
//            let jsonString = String(data: jsonData!, encoding: .utf8)!
//            print(jsonString)
//            //Decoding data into chat message model
//            do {
//                let message = try JSONDecoder().decode(ChatMessage.self, from: jsonData!) // decode the response into chat message
//                completionHandler(message)
//            }
//            catch let err {
//                print("Err", err)
//            }
//
//        }
//    }

//
//    private func listenForOtherMessages() {
//        socket.on("userConnectUpdate") { (dataArray, socketAck) -> Void in
//            NSNotificationCenter.defaultCenter().postNotificationName("userWasConnectedNotification", object: dataArray[0] as! [String: AnyObject])
//        }
//
//        socket.on("userExitUpdate") { (dataArray, socketAck) -> Void in
//            NSNotificationCenter.defaultCenter().postNotificationName("userWasDisconnectedNotification", object: dataArray[0] as! String)
//        }
//
//        socket.on("userTypingUpdate") { (dataArray, socketAck) -> Void in
//            NSNotificationCenter.defaultCenter().postNotificationName("userTypingNotification", object: dataArray[0] as? [String: AnyObject])
//        }
//    }
//
//
//    func sendStartTypingMessage(nickname: String) {
//        socket.emit("startType", nickname)
//    }
//
//
//    func sendStopTypingMessage(nickname: String) {
//        socket.emit("stopType", nickname)
//    }
//}


//func delay(_ delay:Double, closure:@escaping ()->()) {
//    DispatchQueue.main.asyncAfter(
//        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
//}


//func convertToDictionary(text: String) -> [String: Any]? {
//    if let data = text.data(using: .utf8) {
//        do {
//            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    return nil
//}
