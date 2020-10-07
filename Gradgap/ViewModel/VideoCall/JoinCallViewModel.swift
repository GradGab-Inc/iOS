//
//  JoinCallViewModel.swift
//  Gradgap
//
//  Created by iMac on 10/3/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import SainiUtils
import AmazonChimeSDK

protocol JoinCallDelegate {
//    func didRecieveJoinCallResponse(response: MeetingSessionConfiguration)
    func didRecieveJoinCallResponse(response: VideoCallResponse)
}

struct JoinCallViewModel {
    var delegate: JoinCallDelegate?
    
//    func getVideoCallData1(request : VideoCallDataRequest, completion: @escaping (MeetingSessionConfiguration?) -> Void) {
//        GCD.CALL.join.async {
//            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.CALL.join, Loader: true, isMultipart: false) { (response) in
//                if response != nil {
//
//                }
//            }
//        }
//    }
    
    func getVideoCallData(request : VideoCallDataRequest) {
        GCD.CALL.join.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.CALL.join, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    do {
                        let success = try JSONDecoder().decode(VideoCallResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                            self.delegate?.didRecieveJoinCallResponse(response: success.self)
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
        
        
        
        
//    func processJson(data: Data) -> MeetingSessionConfiguration? {
//        let jsonDecoder = JSONDecoder()
//        do {
//            let joinMeetingResponse = try jsonDecoder.decode(JoinMeetingResponse.self, from: data)
//            let meetingResp = getCreateMeetingResponse(from: joinMeetingResponse)
//            let attendeeResp = getCreateAttendeeResponse(from: joinMeetingResponse)
//            return MeetingSessionConfiguration(createMeetingResponse: meetingResp,
//                                               createAttendeeResponse: attendeeResp,
//                                               urlRewriter: urlRewriter)
//        } catch {
//            logger.error(msg: error.localizedDescription)
//            return nil
//        }
//    }
//
//    func getCreateMeetingResponse(from joinMeetingResponse: JoinMeetingResponse) -> CreateMeetingResponse {
//        let meeting = joinMeetingResponse.joinInfo.meeting.meeting
//        let meetingResp = CreateMeetingResponse(meeting:
//            Meeting(
//                externalMeetingId: meeting.externalMeetingId,
//                mediaPlacement: MediaPlacement(
//                    audioFallbackUrl: meeting.mediaPlacement.audioFallbackUrl,
//                    audioHostUrl: meeting.mediaPlacement.audioHostUrl,
//                    signalingUrl: meeting.mediaPlacement.signalingUrl,
//                    turnControlUrl: meeting.mediaPlacement.turnControlUrl
//                ),
//                mediaRegion: meeting.mediaRegion,
//                meetingId: meeting.meetingId
//            )
//        )
//        return meetingResp
//    }
//
//    private static func getCreateAttendeeResponse(from joinMeetingResponse: JoinMeetingResponse) -> CreateAttendeeResponse {
//        let attendee = joinMeetingResponse.joinInfo.attendee.attendee
//        let attendeeResp = CreateAttendeeResponse(attendee:
//            Attendee(attendeeId: attendee.attendeeId,
//                     externalUserId: attendee.externalUserId,
//                     joinToken: attendee.joinToken)
//        )
//        return attendeeResp
//    }
}
