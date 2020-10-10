//
//  JoinRequestService.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import Foundation
import Alamofire
import SainiUtils

class JoinRequestService: NSObject {
    static let logger = ConsoleLogger(name: "JoiningRequestService")

    private static func urlRewriter(url: String) -> String {
        // changing url
        // return url.replacingOccurrences(of: "example.com", with: "my.example.com")
        return url
    }

static func getVideoCallData(request : VideoCallDataRequest,completion: @escaping (MeetingModel?) -> Void) {
     GCD.CALL.join.async {
         APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.CALL.join, Loader: true, isMultipart: false) { (response) in
             if response != nil{                             //if response is not empty
                 
                 do {
                     let success = try JSONDecoder().decode(VideoCallResponse.self, from: response!) // decode the response into model
                     switch success.code{
                     case 100:
                         guard let meetingSessionConfiguration = processJson2(response: success) else {
                             displayToast("Error parsing meetingSessionConfiguration")
                             log.error("Error parsing meetingSessionConfiguration")/
                             return
                         }
                         
                         let meetingModel = MeetingModel(meetingSessionConfig: meetingSessionConfiguration, meetingId: success.data?.payload?.meeting?.meetingID ?? "", selfName: AppModel.shared.currentUser.user?.firstName ?? "", callKitOption: .outgoing)
                         
                         completion(meetingModel)
                         break
                     default:
                         log.error("\(Log.stats()) \(success.message)")/
                     }
                 }
                 catch let err {
                     log.error("ERROR OCCURED WHILE DECODING: \(Log.stats()) \(err)")/
                 }
             }
         }
     }
 }
    
    static func postJoinRequest(meetingId: String, name: String, completion: @escaping (MeetingSessionConfiguration?) -> Void) {
        let encodedURL = HttpUtils.encodeStrForURL(
            str: "\(AppConfiguration.url)join?title=\(meetingId)&name=\(name)&region=\(AppConfiguration.region)"
        )
        HttpUtils.postRequest(url: encodedURL, jsonData: nil, logger: logger) { data, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            guard let meetingSessionConfiguration = self.processJson(data: data) else {
                completion(nil)
                return
            }
            completion(meetingSessionConfiguration)
        }
    }

    private static func processJson(data: Data) -> MeetingSessionConfiguration? {
        let jsonDecoder = JSONDecoder()
        do {
            let joinMeetingResponse = try jsonDecoder.decode(JoinMeetingResponse.self, from: data)
            let meetingResp = getCreateMeetingResponse(from: joinMeetingResponse)
            let attendeeResp = getCreateAttendeeResponse(from: joinMeetingResponse)
            return MeetingSessionConfiguration(createMeetingResponse: meetingResp, createAttendeeResponse: attendeeResp, urlRewriter: urlRewriter)
        } catch {
            logger.error(msg: error.localizedDescription)
            return nil
        }
    }

    private static func getCreateMeetingResponse(from joinMeetingResponse: JoinMeetingResponse) -> CreateMeetingResponse {
        let meeting = joinMeetingResponse.joinInfo.meeting.meeting
        let meetingResp = CreateMeetingResponse(meeting:
            Meeting(
                externalMeetingId: meeting.externalMeetingId,
                mediaPlacement: MediaPlacement(
                    audioFallbackUrl: meeting.mediaPlacement.audioFallbackUrl,
                    audioHostUrl: meeting.mediaPlacement.audioHostUrl,
                    signalingUrl: meeting.mediaPlacement.signalingUrl,
                    turnControlUrl: meeting.mediaPlacement.turnControlUrl
                    
                ),
                mediaRegion: meeting.mediaRegion,
                meetingId: meeting.meetingId
            )
        )
        return meetingResp
    }

    private static func getCreateAttendeeResponse(from joinMeetingResponse: JoinMeetingResponse) -> CreateAttendeeResponse {
        let attendee = joinMeetingResponse.joinInfo.attendee.attendee
        let attendeeResp = CreateAttendeeResponse(attendee:
            Attendee(attendeeId: attendee.attendeeId,
                     externalUserId: attendee.externalUserId,
                     joinToken: attendee.joinToken)
        )
        return attendeeResp
    }
    
    //UPDATED
    
    private static func processJson2(response: VideoCallResponse) -> MeetingSessionConfiguration? {
        guard let meeting = response.data?.payload?.meeting else{
            return nil
        }
        guard let attendee = response.data?.menteePayload?.attendee else{
            return nil
        }
        
        let meetingResp = getCreateMeetingResponse2(from: meeting)
        let attendeeResp = getCreateAttendeeResponse2(from: attendee)
        return MeetingSessionConfiguration(createMeetingResponse: meetingResp,
                                           createAttendeeResponse: attendeeResp,
                                           urlRewriter: urlRewriter)
    }
    
    private static func getCreateMeetingResponse2(from joinMeetingResponse: MeetingData) -> CreateMeetingResponse {
        let meetingResp = CreateMeetingResponse(meeting:
                                                    Meeting(
                                                        externalMeetingId: joinMeetingResponse.externalMeetingID,
                                                        mediaPlacement: MediaPlacement(
                                                            audioFallbackUrl: joinMeetingResponse.mediaPlacement?.audioFallbackURL ?? "",
                                                            audioHostUrl: joinMeetingResponse.mediaPlacement?.audioHostURL ?? "",
                                                            signalingUrl: joinMeetingResponse.mediaPlacement?.signalingURL ?? "",
                                                            turnControlUrl: joinMeetingResponse.mediaPlacement?.turnControlURL ?? ""
                                                        ),
                                                        mediaRegion: joinMeetingResponse.mediaRegion,
                                                        meetingId: joinMeetingResponse.meetingID
                                                    )
        )
        return meetingResp
    }
    
    private static func getCreateAttendeeResponse2(from joinMeetingResponse: AttendeeModel) -> CreateAttendeeResponse {
        let attendeeResp = CreateAttendeeResponse(attendee:
                                                    Attendee(attendeeId: joinMeetingResponse.attendeeID,
                                                             externalUserId: joinMeetingResponse.externalUserID,
                                                             joinToken: joinMeetingResponse.joinToken)
        )
        return attendeeResp
    }
}
