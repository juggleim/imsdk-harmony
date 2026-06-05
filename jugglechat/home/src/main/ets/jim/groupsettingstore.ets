import preferences from '@ohos.data.preferences'

let prefName = 'jchat_pref'
let groupSettingKey = 'jchat_group_settings'

export class GroupSettingRecord {
  groupId: string
  announcement: string
  myNickname: string
  updatedAt: number

  constructor(groupId: string = '', announcement: string = '', myNickname: string = '', updatedAt: number = 0) {
    this.groupId = groupId
    this.announcement = announcement
    this.myNickname = myNickname
    this.updatedAt = updatedAt
  }
}

export interface GroupSettingPatch {
  announcement?: string
  myNickname?: string
}

export class GroupSettingStore {
  private static getPref() {
    let ctx = getContext()
    let option: preferences.Options = { name: prefName }
    return preferences.getPreferencesSync(ctx, option)
  }

  private static readList(): GroupSettingRecord[] {
    let pref = GroupSettingStore.getPref()
    let raw = pref.getSync(groupSettingKey, '')
    if (raw == '') {
      return []
    }
    try {
      let parsed = JSON.parse(raw.toString()) as GroupSettingRecord[]
      return Array.isArray(parsed) ? parsed : []
    } catch (e) {
      console.error(`group_setting_store_parse_fail: ${e.message}`)
      return []
    }
  }

  private static writeList(list: GroupSettingRecord[]): void {
    let pref = GroupSettingStore.getPref()
    pref.putSync(groupSettingKey, JSON.stringify(list))
    pref.flush()
  }

  private static findRecordIndex(list: GroupSettingRecord[], groupId: string): number {
    for (let i = 0; i < list.length; i++) {
      if (list[i].groupId == groupId) {
        return i
      }
    }
    return -1
  }

  static getGroupSetting(groupId: string): GroupSettingRecord | null {
    let normalizedGroupId = groupId.trim()
    if (normalizedGroupId == '') {
      return null
    }
    let list = GroupSettingStore.readList()
    let foundIndex = GroupSettingStore.findRecordIndex(list, normalizedGroupId)
    if (foundIndex < 0) {
      return null
    }
    return list[foundIndex]
  }

  static upsertGroupSetting(groupId: string, patch: GroupSettingPatch): GroupSettingRecord | null {
    let normalizedGroupId = groupId.trim()
    if (normalizedGroupId == '') {
      return null
    }
    let list = GroupSettingStore.readList()
    let foundIndex = GroupSettingStore.findRecordIndex(list, normalizedGroupId)
    let current = foundIndex >= 0 ? list[foundIndex] : new GroupSettingRecord(normalizedGroupId)
    if (patch.announcement != undefined) {
      current.announcement = patch.announcement
    }
    if (patch.myNickname != undefined) {
      current.myNickname = patch.myNickname
    }
    current.updatedAt = Date.now()
    if (foundIndex >= 0) {
      list[foundIndex] = current
    } else {
      list.push(current)
    }
    GroupSettingStore.writeList(list)
    return current
  }
}
