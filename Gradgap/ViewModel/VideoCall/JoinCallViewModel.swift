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
    func didRecieveJoinCallResponse(response: MeetingModel)
//    func didRecieveJoinCallResponse(response: VideoCallResponse)
}

struct JoinCallViewModel {
    var delegate: JoinCallDelegate?
    
    
    func getVideoCallData(request : VideoCallDataRequest) {
        GCD.CALL.join.async {
            APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.CALL.join, Loader: true, isMultipart: false) { (response) in
                if response != nil{                             //if response is not empty
                    
                    do {
                        let success = try JSONDecoder().decode(VideoCallResponse.self, from: response!) // decode the response into model
                        switch success.code{
                        case 100:
                        guard let meetingSessionConfiguration = self.processJson2(response: success) else {
                            displayToast("Error parsing meetingSessionConfiguration")
                            log.error("Error parsing meetingSessionConfiguration")/
                            return
                        }
                        
                        let meetingModel = MeetingModel(meetingSessionConfig: meetingSessionConfiguration, meetingId: success.data?.payload?.meeting?.meetingID ?? "", selfName: AppModel.shared.currentUser.user?.firstName ?? "", callKitOption: .outgoing)
                        self.delegate?.didRecieveJoinCallResponse(response: meetingModel)
                        
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
      
    
    public static func urlRewriter(url: String) -> String {
        // changing url
        // return url.replacingOccurrences(of: "example.com", with: "my.example.com")
        return url
    }
        
    func processJson2(response: VideoCallResponse) -> MeetingSessionConfiguration? {
        guard let meeting = response.data?.payload?.meeting else{
            return nil
        }
        guard let attendee = response.data?.menteePayload?.attendee else{
            return nil
        }
        
        let meetingResp = getCreateMeetingResponse2(from: meeting)
        let attendeeResp = getCreateAttendeeResponse2(from: attendee)
        return MeetingSessionConfiguration(createMeetingResponse: meetingResp, createAttendeeResponse: attendeeResp, urlRewriter: JoinCallViewModel.urlRewriter)
    }

    func getCreateMeetingResponse2(from joinMeetingResponse: MeetingData) -> CreateMeetingResponse {
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

    func getCreateAttendeeResponse2(from joinMeetingResponse: AttendeeModel) -> CreateAttendeeResponse {
        let attendeeResp = CreateAttendeeResponse(attendee:
            Attendee(attendeeId: joinMeetingResponse.attendeeID,
                     externalUserId: joinMeetingResponse.externalUserID,
                     joinToken: joinMeetingResponse.joinToken)
        )
        return attendeeResp
    }
}
