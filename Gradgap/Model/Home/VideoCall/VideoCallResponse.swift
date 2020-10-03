//
//  VideoCallResponse.swift
//  Gradgap
//
//  Created by iMac on 10/3/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation



// MARK: - Welcome
struct VideoCallResponse: Codable {
    let code: Int
    let message: String
    let data: VideoDataModel?
    let format, timestamp: String
    
    enum CodingKeys: String, CodingKey {
           case code
           case message, data, format, timestamp
       }
       
       init(from decoder: Decoder) throws {
           let values = try decoder.container(keyedBy: CodingKeys.self)
           
           code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
           message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
           data = try values.decodeIfPresent(VideoDataModel.self, forKey: .data) ?? nil
           format = try values.decodeIfPresent(String.self, forKey: .format) ?? ""
           timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? ""
       }
       
       init() {
           code = 0
           message = ""
           data = VideoDataModel.init()
           format = ""
           timestamp = ""
       }
    
}

// MARK: - DataClass
struct VideoDataModel: Codable {
    let updatedOn: String
    let payload: VideoPayloadModel?
    let createdOn: String
    let menteePayload: MenteePayload?
    let setOnInsert: SetOnInsert?

    enum CodingKeys: String, CodingKey {
        case updatedOn, payload, createdOn, menteePayload
        case setOnInsert = "$setOnInsert"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        menteePayload = try values.decodeIfPresent(MenteePayload.self, forKey: .menteePayload) ?? nil
        updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? ""
        payload = try values.decodeIfPresent(VideoPayloadModel.self, forKey: .payload) ?? nil
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? ""
        setOnInsert = try values.decodeIfPresent(SetOnInsert.self, forKey: .setOnInsert) ?? nil
    }
    
    init() {
        menteePayload = MenteePayload.init()
        updatedOn = ""
        payload = VideoPayloadModel.init()
        createdOn = ""
        setOnInsert = SetOnInsert.init()
    }
    
}

// MARK: - MenteePayload
struct MenteePayload: Codable {
    let attendee: AttendeeModel?

    enum CodingKeys: String, CodingKey {
        case attendee = "Attendee"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        attendee = try values.decodeIfPresent(AttendeeModel.self, forKey: .attendee) ?? nil
    }
    
    init() {
        attendee = AttendeeModel.init()
    }
    
}

// MARK: - Attendee
struct AttendeeModel: Codable {
    let externalUserID, attendeeID, joinToken: String

    enum CodingKeys: String, CodingKey {
        case externalUserID = "ExternalUserId"
        case attendeeID = "AttendeeId"
        case joinToken = "JoinToken"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        externalUserID = try values.decodeIfPresent(String.self, forKey: .externalUserID) ?? ""
        attendeeID = try values.decodeIfPresent(String.self, forKey: .attendeeID) ?? ""
        joinToken = try values.decodeIfPresent(String.self, forKey: .joinToken) ?? ""
    }
    init() {
        externalUserID = ""
        attendeeID = ""
        joinToken = ""
    }
    
}

// MARK: - Payload
struct VideoPayloadModel: Codable {
    let meeting: Meeting?

    enum CodingKeys: String, CodingKey {
        case meeting = "Meeting"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        meeting = try values.decodeIfPresent(Meeting.self, forKey: .meeting) ?? nil
    }
    
    init() {
        meeting = Meeting.init()
    }
    
}

// MARK: - Meeting
struct Meeting: Codable {
    let meetingID, externalMeetingID: String
    let mediaPlacement: MediaPlacement?
    let mediaRegion: String

    enum CodingKeys: String, CodingKey {
        case meetingID = "MeetingId"
        case externalMeetingID = "ExternalMeetingId"
        case mediaPlacement = "MediaPlacement"
        case mediaRegion = "MediaRegion"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        mediaPlacement = try values.decodeIfPresent(MediaPlacement.self, forKey: .mediaPlacement) ?? nil
        meetingID = try values.decodeIfPresent(String.self, forKey: .meetingID) ?? ""
        externalMeetingID = try values.decodeIfPresent(String.self, forKey: .externalMeetingID) ?? ""
        mediaRegion = try values.decodeIfPresent(String.self, forKey: .mediaRegion) ?? ""
    }
    
    init() {
        mediaPlacement = MediaPlacement.init()
        meetingID = ""
        externalMeetingID = ""
        mediaRegion = ""
    }
    
}

// MARK: - MediaPlacement
struct MediaPlacement: Codable {
    let audioHostURL, audioFallbackURL, screenDataURL, screenSharingURL: String
    let screenViewingURL, signalingURL: String
    let turnControlURL: String

    enum CodingKeys: String, CodingKey {
        case audioHostURL = "AudioHostUrl"
        case audioFallbackURL = "AudioFallbackUrl"
        case screenDataURL = "ScreenDataUrl"
        case screenSharingURL = "ScreenSharingUrl"
        case screenViewingURL = "ScreenViewingUrl"
        case signalingURL = "SignalingUrl"
        case turnControlURL = "TurnControlUrl"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        audioHostURL = try values.decodeIfPresent(String.self, forKey: .audioHostURL) ?? ""
        audioFallbackURL = try values.decodeIfPresent(String.self, forKey: .audioFallbackURL) ?? ""
        screenDataURL = try values.decodeIfPresent(String.self, forKey: .screenDataURL) ?? ""
        screenSharingURL = try values.decodeIfPresent(String.self, forKey: .screenSharingURL) ?? ""
        screenViewingURL = try values.decodeIfPresent(String.self, forKey: .screenViewingURL) ?? ""
        signalingURL = try values.decodeIfPresent(String.self, forKey: .signalingURL) ?? ""
        turnControlURL = try values.decodeIfPresent(String.self, forKey: .turnControlURL) ?? ""
    }
    
    init() {
        audioHostURL = ""
        audioFallbackURL = ""
        screenDataURL =  ""
        screenSharingURL = ""
        screenViewingURL = ""
        signalingURL = ""
        turnControlURL = ""
    }
    
}

// MARK: - SetOnInsert
struct SetOnInsert: Codable {
    let v: Int

    enum CodingKeys: String, CodingKey {
        case v = "__v"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? 0
    }
    
    init() {
        v = 0
    }
    
}
