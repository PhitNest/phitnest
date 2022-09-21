# Redis Schema

| Key                                     | Type           | Description                                                                                                                                                |
| --------------------------------------- | -------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| users:{userId}                          | Hash Object    | <u>Fields:</u><code><ul><li>String email;</li><li>String password (hashed);</li><li>String firstName;</li><li>String lastName;</li></ul></code>            |
| users:count                             | String         | This will be used as an user ID each time a new user is created, then it will be incremented.                                                              |
| users:emails:{email}                    | Hash Object    | Useful for looking up users by email in authentication.<br><br><u>Fields:</u><code><ul><li>String id;</li><li>String password (hashed);</li></ul></code>   |
| users:{userId}:conversations            | Sorted Set     | Contains the IDs of all conversations a user belongs to, sorted by their newest message from oldest to most recent                                         |
| admins:{adminId}                        | Hash Object    | <u>Fields:</u><code><ul><li>String email;</li><li>String password (hashed);</li><li>String firstName;</li><li>String lastName;</li></ul></code>            |
| admins:count                            | String         | This will be used as an admin ID each time a new admin is created, then it will be incremented.                                                            |
| admins:emails:{email}                   | Hash Object    | Useful for looking up admins by email in authentication.<br><br><u>Fields:</u><code><ul><li>String id;</li><li>String password (hashed);</li></ul></code>  |
| conversations:count                     | String         | This will be used as a conversation ID each time a new conversation is created, then it will be incremented.                                               |
| conversations:{conversationId}:messages | Sorted Set     | This will contain the IDs of all the messages from this conversation sorted from oldest to newest.                                                         |
| conversations:{conversationId}:members  | Set            | This will contain the user IDs of all the users in the conversation.                                                                                       |
| messages:{messageId}                    | Hash Object    | <u>Fields:</u><code><ul><li>String conversation;</li><li>String sender;</li><li>String text;</li></ul></code>                                              |
| messages:count                          | String         | This will be used as a message ID each time a new message is created, then it will be incremented.                                                         |
| gyms                                    | Geospatial Set | This will contain the IDs of all the gyms sorted by their geohash. This allows efficient geospatial queries.                                               |
| gyms:{gymId}                            | Hash Object    | <u>Fields:</u><code><ul><li>String name;</li><li>String streetAddress;</li><li>String city;</li><li>String state;</li><li>String zipCode;</li></ul></code> |
| gyms:count                              | String         | This will be used as a gym ID each time a new gym is created, then it will be incremented.                                                                 |
