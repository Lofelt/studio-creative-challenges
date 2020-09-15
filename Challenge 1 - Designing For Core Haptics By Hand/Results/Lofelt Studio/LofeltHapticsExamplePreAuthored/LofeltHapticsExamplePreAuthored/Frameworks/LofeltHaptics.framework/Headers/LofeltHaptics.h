#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

//! Project version number for LofeltHaptics.
FOUNDATION_EXPORT double LofeltHapticsVersionNumber;

//! Project version string for LofeltHaptics.
FOUNDATION_EXPORT const unsigned char LofeltHapticsVersionString[];

//! Custom error domain
extern NSString *_Nonnull const LofeltErrorDomain;

/*!
    @class      LofeltHaptics
    @brief      The LofeltHaptics class
    @discussion Defines the API of Lofelt SDK for iOS.
    @author     Joao Freire, James Kneafsey, Thomas McGuire
    @copyright  © 2020 Lofelt. All rights reserved.
*/
@interface LofeltHaptics : NSObject
{
    void *_controller;
}

- (instancetype)init NS_UNAVAILABLE;

/*! @method         initAndReturnError:error
    @abstract       Creates an instance of LofeltHaptics.
    @param error    If the initAndReturnError operation fails, this will be set to a valid NSError describing the error.
*/
- (nullable instancetype)initAndReturnError:(NSError **)error NS_DESIGNATED_INITIALIZER;

/*! @method         load:data:error
    @abstract       Loads a haptic clip from string data.
    @discussion     The data must be in a valid Lofelt JSON format.
    @param data     The Lofelt JSON format string.
    @param error    If the load operation fails, this will be set to a valid NSError describing the error.
    @return         Whether the operation succeeded
*/
- (BOOL)load:(NSString *_Nonnull)data error:(NSError *_Nullable *_Nullable)error;

/*! @method         play:error
    @abstract       Plays a loaded haptic clip.
    @discussion     The data must be preloaded using @c- (void)load;
                    Only one haptic clip can play at a time.
                    If one clip is playing it must be stopped before a new one is played using @c- (void) stop;
    @param error    If the play operation fails, this will be set to a valid NSError describing the error.
    @return         Whether the operation succeeded
*/
- (BOOL)play:(NSError *_Nullable *_Nullable)error;

/*! @method         stop:error
    @abstract       Stops the haptic clip that is currently playing.
    @param error    If the stop operation fails, this will be set to a valid NSError describing the error.
    @return         Whether the operation succeeded
 */
- (BOOL)stop:(NSError *_Nullable *_Nullable)error;

/*! @method             attachAudioSource:audioNode:error
    @abstract           Attaches an AVAudioNode as a source for real-time audio to haptics.
    @discussion         Haptic output will begin as soon as audio starts playing.
    @param audioNode    Any audio source with base type AVAudioNode.
    @param error        If the attachAudioSource operation fails, this will be set to a valid NSError describing the error.
    @return             Whether the operation succeeded
 */
- (BOOL)attachAudioSource:(AVAudioNode *)audioNode error:(NSError *_Nullable *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
