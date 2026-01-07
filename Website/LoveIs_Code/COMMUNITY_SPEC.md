# Community & Chat Spec (Detailed)

## Goals
- A shared community space for buyers and sellers.
- Features: newsfeed, comments/likes, 1-1 chat, group chat, notifications, search.

## Access & Identity
- Both buyer and seller can access community.
- Identity source:
  - cf_customer is primary identity.
  - If account is seller, cf_customer.IsSeller = 1 and SellerId is set.
  - Display name priority: DisplayName -> Username.
  - Avatar fallback: first letter of display name.

## Posting (Newsfeed)
### Data model
- cf_community_post
  - CustomerId (author)
  - Content (text)
  - VideoUrl (YouTube link)
  - CreatedAt
- cf_community_post_image
  - PostId
  - ImageUrl
- cf_community_like
  - PostId
  - CustomerId
- cf_community_comment
  - PostId
  - CustomerId
  - Content

### UI/UX
- Composer bar shows avatar + prompt.
- Clicking opens modal:
  - Text area
  - Image upload + preview
  - Emoji picker (library)
  - YouTube link input -> iframe preview
  - Publish button
- Modal closes only by close button.

### Validation
- Rate limit: 5 posts / 5 minutes.
- Link whitelist in content (block other domains).
- Content length limits (configure later).

## Comments
- Inline comment input per post.
- Rate limit: 20 comments / 5 minutes.
- Stored in cf_community_comment.

## Likes
- Toggle like per post.
- Stored in cf_community_like.

## Chat (SignalR)
### Rooms
- cf_community_room (room metadata)
- cf_community_room_member (members)
- 1-1 room: exactly two members.
- Group room: multiple members.

### Messages
- cf_community_message
  - RoomId
  - SenderId
  - Content
  - CreatedAt
  - Status

### Realtime flow
1) Client connects to SignalR hub.
2) Client joins room group.
3) On send:
   - Save to DB.
   - Broadcast message to room group.
4) Receiver appends message without reload.

### Unread counters
- Count unread per room on load.
- Reset when user opens room.

## Notifications
### Types
- New message
- Post liked
- Comment added

### Storage
- cf_community_notification
  - CustomerId
  - Type
  - ReferenceId (post/comment/message)
  - IsRead

### UI
- Header dropdown showing unread items.
- Clicking notification sets IsRead.

## Search
- Search posts by content + author name.
- Future: hashtag indexing.

## Security & Anti-spam
- Rate limit (posts/comments).
- Whitelist URLs in post/comment content.
- Optional: manual moderation or report system.

## Open items
- Media storage limits for /upload.
- Dedicated admin moderation console.
- Content policy & banned words list.
