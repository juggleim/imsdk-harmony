import { Moment, MomentComment, MomentReaction } from '../entries/moment'

/**
 * Defines the Moment Callback alias.
 *
 * Example:
 * ```ts
 * const callback: MomentCallback = (...args: unknown[]) => {}
 * ```
 */
export type MomentCallback = (code: number, moment: Moment | null) => void
/**
 * Defines the Moments Callback alias.
 *
 * Example:
 * ```ts
 * const callback: MomentsCallback = (...args: unknown[]) => {}
 * ```
 */
export type MomentsCallback = (code: number, moments: Moment[], isFinished: boolean) => void
/**
 * Defines the Moment Comment Callback alias.
 *
 * Example:
 * ```ts
 * const callback: MomentCommentCallback = (...args: unknown[]) => {}
 * ```
 */
export type MomentCommentCallback = (code: number, comment: MomentComment | null) => void
/**
 * Defines the Moment Comments Callback alias.
 *
 * Example:
 * ```ts
 * const callback: MomentCommentsCallback = (...args: unknown[]) => {}
 * ```
 */
export type MomentCommentsCallback = (code: number, comments: MomentComment[], isFinished: boolean) => void
/**
 * Defines the Moment Reactions Callback alias.
 *
 * Example:
 * ```ts
 * const callback: MomentReactionsCallback = (...args: unknown[]) => {}
 * ```
 */
export type MomentReactionsCallback = (code: number, reactions: MomentReaction[], isFinished: boolean) => void
