# Redis Schema

| Key                                     | Type           | Description                                                                                                                    |
| --------------------------------------- | -------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| users:{userId}                          | Hash Object    | <u>Fields:</u><ul><li>email;</li><li>password (hashed);</li><li>firstName;</li><li>lastName;</li></ul>                         |
| users:count                             | String         | This will be used as an user ID each time a new user is created, then it will be incremented.                                  |
| users:emails:{email}                    | Hash Object    | Useful for looking up users by email in authentication.<br><br><u>Fields:</u><ul><li>id;</li><li>password (hashed);</li></ul>  |
| users:{userId}:conversations            | Sorted Set     | Contains the IDs of all conversations a user belongs to, sorted by their newest message from oldest to most recent             |
| admins:{adminId}                        | Hash Object    | <u>Fields:</u><ul><li>email;</li><li>password (hashed);</li><li>firstName;</li><li>lastName;</li></ul>                         |
| admins:count                            | String         | This will be used as an admin ID each time a new admin is created, then it will be incremented.                                |
| admins:emails:{email}                   | Hash Object    | Useful for looking up admins by email in authentication.<br><br><u>Fields:</u><ul><li>id;</li><li>password (hashed);</li></ul> |
| conversations:count                     | String         | This will be used as a conversation ID each time a new conversation is created, then it will be incremented.                   |
| conversations:{conversationId}:messages | Sorted Set     | This will contain the IDs of all the messages from this conversation sorted from oldest to newest.                             |
| conversations:{conversationId}:members  | Set            | This will contain the user IDs of all the users in the conversation.                                                           |
| messages:{messageId}                    | Hash Object    | <u>Fields:</u><ul><li>conversation;</li><li>sender;</li><li>text;</li></ul>                                                    |
| messages:count                          | String         | This will be used as a message ID each time a new message is created, then it will be incremented.                             |
| gyms                                    | Geospatial Set | This will contain the IDs of all the gyms sorted by their geohash. This allows efficient geospatial queries.                   |
| gyms:{gymId}                            | Hash Object    | <u>Fields:</u><ul><li>name;</li><li>streetAddress;</li><li>city;</li><li>state;</li><li>zipCode;</li></ul>                     |
| gyms:count                              | String         | This will be used as a gym ID each time a new gym is created, then it will be incremented.                                     |
