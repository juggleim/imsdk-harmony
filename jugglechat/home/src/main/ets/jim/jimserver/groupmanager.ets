import { doHttp } from "./httputil";
import http from "@ohos.net.http";
import { JimServerConfig } from "./jimserver";

export interface GroupBean {
  group_id: string;
  group_name: string;
  group_portrait: string;
  member_count?: number;
}

export interface GroupMemberBean {
  member_id: string;
  group_id: string;
  display_name?: string;
}

export class GroupManager {
  private config: JimServerConfig;

  constructor(config: JimServerConfig) {
    this.config = config;
  }

  public GetMyGroups(callback: (groups: GroupBean[]) => void): void {
    let url = this.config.getServerUrl() + '/jim/groups/mygroups?start_id=0&count=100';
    doHttp(url, http.RequestMethod.GET, this.config.getCommonHeaders(), '', (code, data) => {
      if (code == 0 && data) {
        let result = data as Record<string, Object>;
        let items = result["items"] as Array<Record<string, Object>>;
        let groups: GroupBean[] = [];
        if (items) {
          for (let item of items) {
            groups.push({
              group_id: (item["group_id"] || '') as string,
              group_name: (item["group_name"] || '') as string,
              group_portrait: (item["group_portrait"] || '') as string,
              member_count: (item["member_count"] || 0) as number,
            });
          }
        }
        callback(groups);
      } else {
        callback([]);
      }
    });
  }

  public CreateGroup(name: string, portrait: string, memberIds: string[], callback: (success: boolean, groupId?: string) => void): void {
    let members: Array<Record<string, string>> = [];
    for (let id of memberIds) {
      let memberItem: Record<string, string> = { 'user_id': id };
      members.push(memberItem);
    }
    let data = JSON.stringify({ 'group_name': name, 'group_portrait': portrait, 'members': members });
    doHttp(this.config.getServerUrl() + '/jim/groups/add', http.RequestMethod.POST, this.config.getCommonHeaders(), data, (code, data) => {
      if (code == 0 && data) {
        let result = data as Record<string, Object>;
        callback(true, (result["group_id"] || '') as string);
      } else {
        callback(false);
      }
    });
  }

  public InviteMembers(groupId: string, memberIds: string[], callback: (success: boolean) => void): void {
    let data = JSON.stringify({ group_id: groupId, member_ids: memberIds });
    doHttp(this.config.getServerUrl() + '/jim/groups/invite', http.RequestMethod.POST, this.config.getCommonHeaders(), data, (code) => {
      callback(code == 0);
    });
  }

  public RemoveMembers(groupId: string, memberIds: string[], callback: (success: boolean) => void): void {
    let data = JSON.stringify({ group_id: groupId, member_ids: memberIds });
    doHttp(this.config.getServerUrl() + '/jim/groups/members/del', http.RequestMethod.POST, this.config.getCommonHeaders(), data, (code) => {
      callback(code == 0);
    });
  }

  public GetGroupMembers(groupId: string, callback: (members: GroupMemberBean[]) => void): void {
    let url = this.config.getServerUrl() + `/jim/groups/members/list?group_id=${groupId}`;
    doHttp(url, http.RequestMethod.GET, this.config.getCommonHeaders(), '', (code, data) => {
      if (code == 0 && data) {
        let result = data as Record<string, Object>;
        let items = result["items"] as Array<Record<string, Object>>;
        let members: GroupMemberBean[] = [];
        if (items) {
          for (let item of items) {
            members.push({
              member_id: (item["member_id"] || '') as string,
              group_id: groupId,
              display_name: (item["display_name"] || '') as string,
            });
          }
        }
        callback(members);
      } else {
        callback([]);
      }
    });
  }

  public ApplyJoinGroup(groupId: string, callback: (success: boolean) => void): void {
    let data = JSON.stringify({ group_id: groupId });
    doHttp(this.config.getServerUrl() + '/jim/groups/apply', http.RequestMethod.POST, this.config.getCommonHeaders(), data, (code) => {
      callback(code == 0);
    });
  }

  public UpdateGroup(groupId: string, name: string, portrait: string, callback: (success: boolean) => void): void {
    let data = JSON.stringify({ group_id: groupId, group_name: name, group_portrait: portrait });
    doHttp(this.config.getServerUrl() + '/jim/groups/update', http.RequestMethod.POST, this.config.getCommonHeaders(), data, (code) => {
      callback(code == 0);
    });
  }
}
