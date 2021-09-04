//
//  StorageContentType.swift
//  FireFast
//
//  Created by Mojtaba Soleimani on 2021-09-03.
//

import Foundation

public enum StorageContentType: String {
  // IMAGE
  case jpg = "image/jpeg"
  case bmp = "image/bmp"
  case gif = "image/gif"
  case svg = "image/svg+xml"
  
  // VIDEO
  case mpeg = "video/mpeg"
  case mp4 = "video/mp4"
  case mov = "video/quicktime"
  case avi = "video/x-msvideo"
  
  // AUDIO
  case mp3 = "audio/mpeg"
  case wav = "audio/x-wav"
  case m3u = "audio/x-mpegurl"
  case midi = "audio/mid"
}
