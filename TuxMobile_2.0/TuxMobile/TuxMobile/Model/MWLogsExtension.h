//
//  MWLogsExtension.h
//  Tailoring
//
//  Created by Dmitry Zhurov on 04.03.13.
//  Copyright (c) 2013 Dmitry Zhurov. All rights reserved.
//

#ifndef Tailoring_MWLogsExtension_h
#define Tailoring_MWLogsExtension_h

#define LOG_FLAG_REQUEST        (1 << 4)
#define LOG_FLAG_RESPONSE_OK    (1 << 5)
#define LOG_FLAG_RESPONSE_ERROR (1 << 6)
#define LOG_FLAG_SLED_INFO      (1 << 7)
#define LOG_FLAG_CRASH          (1 << 8)

#define DDLogRequest(frmt, ...)         LOG_OBJC_MAYBE(LOG_ASYNC_INFO,   ddLogLevel, LOG_FLAG_REQUEST,   0, frmt, ##__VA_ARGS__)
#define DDLogResponseOk(frmt, ...)      LOG_OBJC_MAYBE(LOG_ASYNC_INFO,   ddLogLevel, LOG_FLAG_RESPONSE_OK,   0, frmt, ##__VA_ARGS__)
#define DDLogResponseError(frmt, ...)   LOG_OBJC_MAYBE(LOG_ASYNC_ERROR,   ddLogLevel, LOG_FLAG_RESPONSE_ERROR,   0, frmt, ##__VA_ARGS__)

#define DDLogSledInfo(frmt, ...)        LOG_OBJC_MAYBE(LOG_ASYNC_INFO,   ddLogLevel, LOG_FLAG_SLED_INFO,   0, frmt, ##__VA_ARGS__)

#define DDLogCrash(frmt, ...)           LOG_OBJC_MAYBE(LOG_ASYNC_ERROR,   ddLogLevel, LOG_FLAG_CRASH,   0, frmt, ##__VA_ARGS__)

#endif