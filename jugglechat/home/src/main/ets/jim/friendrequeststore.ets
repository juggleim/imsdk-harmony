import preferences from '@ohos.data.preferences'

let prefName = 'jchat_pref'
let friendRequestKey = 'jchat_friend_requests'

export interface FriendRequestRecord {
  requestId: string
  userId: string
  nickname: string
  avatar: string
  message: string
  status: string
  createdAt: number
  updatedAt: number
}

export class FriendRequestStore {
  private static getPref() {
    let ctx = getContext()
    let option: preferences.Options = { name: prefName }
    return preferences.getPreferencesSync(ctx, option)
  }

  static getRequests(): FriendRequestRecord[] {
    let pref = FriendRequestStore.getPref()
    let raw = pref.getSync(friendRequestKey, '')
    if (raw == '') {
      return []
    }
    try {
      let requests = JSON.parse(raw.toString()) as FriendRequestRecord[]
      return Array.isArray(requests) ? requests : []
    } catch (e) {
      console.error(`friend_request_store_parse_fail: ${e.message}`)
      return []
    }
  }

  static saveRequests(requests: FriendRequestRecord[]): void {
    let pref = FriendRequestStore.getPref()
    pref.putSync(friendRequestKey, JSON.stringify(requests))
    pref.flush()
  }

  static getRequestByUserId(userId: string): FriendRequestRecord | null {
    if (userId == '') {
      return null
    }
    let requestList = FriendRequestStore.getRequests()
    for (let i = 0; i < requestList.length; i++) {
      if (requestList[i].userId == userId) {
        return requestList[i]
      }
    }
    return null
  }

  static submitRequest(userId: string, nickname: string, avatar: string, message: string): FriendRequestRecord | null {
    let normalizedUserId = userId.trim()
    if (normalizedUserId == '') {
      return null
    }
    let requestList = FriendRequestStore.getRequests()
    let now = Date.now()
    let nextStatus = 'pending'
    let nextRecord: FriendRequestRecord = {
      requestId: `${normalizedUserId}_${now}`,
      userId: normalizedUserId,
      nickname: nickname,
      avatar: avatar,
      message: message,
      status: nextStatus,
      createdAt: now,
      updatedAt: now
    }
    let replaced = false
    for (let i = 0; i < requestList.length; i++) {
      if (requestList[i].userId == normalizedUserId) {
        nextRecord.requestId = requestList[i].requestId
        nextRecord.createdAt = requestList[i].createdAt
        requestList[i] = nextRecord
        replaced = true
        break
      }
    }
    if (!replaced) {
      requestList.unshift(nextRecord)
    }
    FriendRequestStore.saveRequests(requestList)
    return nextRecord
  }

  static markAccepted(requestId: string): FriendRequestRecord | null {
    return FriendRequestStore.markStatus(requestId, 'accepted')
  }

  static markRejected(requestId: string): FriendRequestRecord | null {
    return FriendRequestStore.markStatus(requestId, 'rejected')
  }

  static markPending(requestId: string): FriendRequestRecord | null {
    return FriendRequestStore.markStatus(requestId, 'pending')
  }

  private static markStatus(requestId: string, status: string): FriendRequestRecord | null {
    if (requestId == '') {
      return null
    }
    let requestList = FriendRequestStore.getRequests()
    for (let i = 0; i < requestList.length; i++) {
      if (requestList[i].requestId == requestId) {
        requestList[i].status = status
        requestList[i].updatedAt = Date.now()
        FriendRequestStore.saveRequests(requestList)
        return requestList[i]
      }
    }
    return null
  }
}
