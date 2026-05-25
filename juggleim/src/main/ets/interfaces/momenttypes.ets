import { Moment, MomentComment, MomentReaction } from '../entries/moment'

export type MomentCallback = (code: number, moment: Moment | null) => void
export type MomentsCallback = (code: number, moments: Moment[], isFinished: boolean) => void
export type MomentCommentCallback = (code: number, comment: MomentComment | null) => void
export type MomentCommentsCallback = (code: number, comments: MomentComment[], isFinished: boolean) => void
export type MomentReactionsCallback = (code: number, reactions: MomentReaction[], isFinished: boolean) => void
