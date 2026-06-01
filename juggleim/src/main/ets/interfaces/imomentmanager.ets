import { CommonCallback } from './commoncallback'
import {
  GetMomentCommentOption,
  GetMomentOption,
  Moment,
  MomentMedia
} from '../entries/moment'
import {
  MomentCallback,
  MomentCommentCallback,
  MomentCommentsCallback,
  MomentReactionsCallback,
  MomentsCallback
} from './momenttypes'

/**
 * Declares the contract for I Moment Manager.
 *
 * Example:
 * ```ts
 * const manager = JuggleIm.instance.getMomentManager()
 * ```
 */
export interface IMomentManager {
  addMoment(content: string, mediaList: MomentMedia[], callback: MomentCallback): void
  removeMoment(momentId: string, callback: CommonCallback): void
  getCachedMomentList(option: GetMomentOption): Moment[]
  getMomentList(option: GetMomentOption, callback: MomentsCallback): void
  getMoment(momentId: string, callback: MomentCallback): void
  addComment(momentId: string, parentCommentId: string, content: string, callback: MomentCommentCallback): void
  removeComment(momentId: string, commentId: string, callback: CommonCallback): void
  getCommentList(option: GetMomentCommentOption, callback: MomentCommentsCallback): void
  addReaction(momentId: string, key: string, callback: CommonCallback): void
  removeReaction(momentId: string, key: string, callback: CommonCallback): void
  getReactionList(momentId: string, callback: MomentReactionsCallback): void
}
