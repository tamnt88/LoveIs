using System;
using System.ComponentModel.DataAnnotations.Schema;

[Table("cf_community_post")]
public class CfCommunityPost
{
    public int Id { get; set; }
    public int CustomerId { get; set; }
    public string Content { get; set; }
    public int LikeCount { get; set; }
    public int CommentCount { get; set; }
    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}

[Table("cf_community_post_image")]
public class CfCommunityPostImage
{
    public int Id { get; set; }
    public int PostId { get; set; }
    public string ImageUrl { get; set; }
    public int SortOrder { get; set; }
    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
}

[Table("cf_community_comment")]
public class CfCommunityComment
{
    public int Id { get; set; }
    public int PostId { get; set; }
    public int CustomerId { get; set; }
    public string Content { get; set; }
    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
}

[Table("cf_community_like")]
public class CfCommunityLike
{
    public int Id { get; set; }
    public int PostId { get; set; }
    public int CustomerId { get; set; }
    public DateTime CreatedAt { get; set; }
}

[Table("cf_community_room")]
public class CfCommunityRoom
{
    public int Id { get; set; }
    public string RoomName { get; set; }
    public bool IsGroup { get; set; }
    public int CreatedBy { get; set; }
    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
}

[Table("cf_community_room_member")]
public class CfCommunityRoomMember
{
    public int Id { get; set; }
    public int RoomId { get; set; }
    public int CustomerId { get; set; }
    public string Role { get; set; }
    public bool Status { get; set; }
    public DateTime JoinedAt { get; set; }
}

[Table("cf_community_message")]
public class CfCommunityMessage
{
    public int Id { get; set; }
    public int RoomId { get; set; }
    public int SenderId { get; set; }
    public string Content { get; set; }
    public bool Status { get; set; }
    public DateTime CreatedAt { get; set; }
}

[Table("cf_community_notification")]
public class CfCommunityNotification
{
    public int Id { get; set; }
    public int CustomerId { get; set; }
    public string Type { get; set; }
    public int? ReferenceId { get; set; }
    public string Message { get; set; }
    public bool IsRead { get; set; }
    public DateTime CreatedAt { get; set; }
}

[Table("cf_community_action_log")]
public class CfCommunityActionLog
{
    public int Id { get; set; }
    public int CustomerId { get; set; }
    public string ActionType { get; set; }
    public string Meta { get; set; }
    public DateTime CreatedAt { get; set; }
}
